function [frequency, trial_num,varargout ] = load_LEAP_data_gui( varargin )
%LOAD_LEAP_DATA_GUI Select multiple files to load and assemble info into an array for gui
% INPUT: 0 (Load Calibration Data) or 1 (Load Trial Data) or 2 (Load Optotrak Calibration File) or 3 (Load Optotrak Trial)
% OUTPUT: Calibration points array (0)
        % master_array (1)
        %%
        % Calibration Points array returns x,y,z values of starting point,
        % and the target points (3)
        % Calibration Points array is a 4 by 3 array
        
        % master_array has x y and z position data of:
        % Index Finger
        % Palm
        % Thumb
        % Wrist
        % In that order followed with time data
        %% 


        
    if (varargin{1} ==1) %Leap Trial
        [filename, ~] = uigetfile('*.txt', 'Select a Trial');
        if isequal(filename,0)
            master_array = zeros (5,13);
            varargout = num2cell(master_array, [1 2]);
            trial_num = 0;
            frequency =0;
            return;
        else
            currFile =fopen(filename, 'r');
            formatSpec = '%f';
            size_ = [13 Inf]; 
            array = fscanf(currFile,formatSpec ,size_);
            array = array';
        end
        array(:,13) = array(:,13) - array(1,13); %ensure first time point is zero

        str = regexprep(filename,'Trial_','');
        str = regexprep(str,'.txt','');

        trial_num = str2double(str);
        frequency = trial_num;
        varargout = num2cell(array, [1 2]);
   end
    if (varargin{1} == 0) %Leap Calibration
        [calfile, ~] = uigetfile('*.txt', 'Select a Calibration File');
        formatSpec = '%f';
        size_ = [4 Inf];
        calFile = fopen(calfile,'r');
        
        cal_array = fscanf(calFile, formatSpec, size_);
        
        cal_array = cal_array';
        cal_array(:,4) = cal_array(:,4) - cal_array(1,4); %ensure first time point is zero
        count =0;
        i=1;
        while (count <2 && i < length(cal_array(:, 1)))
            if(cal_array(i,4) == 0)
                count = count +1;
            end
            i = i+1;
        end
        
        cal_array = cal_array(1:i-3,:);
        max_time = cal_array(end,4)/1e3;
       
        time = (0:1/50:max_time)*1e3;
        predicted_x_index = (pchip( cal_array(:, 4),cal_array(:, 1), time))';
        predicted_y_index = (pchip( cal_array(:, 4),cal_array(:, 2), time))';
        predicted_z_index = (pchip( cal_array(:, 4),cal_array(:, 3), time))'; 
        
        new_cal_array = zeros (length (predicted_x_index), 4);
        
        new_cal_array(:, 1) = predicted_x_index;
        new_cal_array(:, 2) = predicted_y_index;
        new_cal_array(:, 3) = predicted_z_index;
        new_cal_array(:, 4) = time'; 
        
        [b,a] = butter(3,0.4);

        filt_cal_array(:, 1)= filtfilt(b, a, new_cal_array(:, 1));
        filt_cal_array(:, 2) = filtfilt(b, a, new_cal_array(:, 2));
        filt_cal_array(:, 3) = filtfilt(b, a, new_cal_array(:, 3));
        output_array = zeros (length(filt_cal_array), 4);
        output_array(:, 1) = filt_cal_array(:, 1);
        output_array(:, 2) = filt_cal_array(:, 2);
        output_array(:, 3) = filt_cal_array(:, 3);
        output_array(:, 4) = time';
        trial_num= 0;
        frequency= 0;
        varargout = num2cell( output_array, [1 2]);
    end
    
    if (varargin{1} == 3) %Optotrak Trial
        [calfile, ~] = uigetfile('*.csv', 'Select an Optotrak Trial');
        remain = calfile;
        for(i =1:6)  
            [token, remain] = strtok(remain,'_');
        end
        %trial_num = double(token);
        trial_num = str2double(token);
        
        if isequal(calfile,0)
            master_array = zeros (5,7);
            varargout = num2cell(master_array, [1 2]);
            trial_num = 0;
            frequency =0;
            return;
        else
        [num, txt, ~] = xlsread(calfile, 1);
        
        frequency = txt{2,1};
        frequency = regexprep(frequency,'Frequency: ','');
        frequency = str2double(frequency);
        
        num(:,1) = (1/frequency)*1e3*num(:,1); %Turn from frames to time in ms 
       % trial_num = frequency;
        num(:,2)
        
        varargout = num2cell(num, [1 2]);
%         
%         max_time = num(end,1)/frequency;
%         time = (0:1/frequency:max_time)*1e3;
% 
%         predicted_x_index = (pchip( num(:,1),num(:,2), time))';
%         predicted_y_index = (pchip( num(:,1),num(:,3), time))';
%         predicted_z_index = (pchip( num(:,1),num(:,4), time))'; 
%         
%         new_array = zeros (length (predicted_x_index), 4);
%         
%         new_array(:,1) = predicted_x_index; 
%         new_array(:,2) = predicted_y_index;
%         new_array(:,3) = predicted_z_index;
%         new_array(:,4) = time'; 
%         
%         [b,a] = butter(3,0.4);
% 
%         filt_cal_array(:,1)= filtfilt(b,a,new_cal_array(:,1));
%         filt_cal_array(:,2) = filtfilt(b,a,new_cal_array(:,2));
%         filt_cal_array(:,3) = filtfilt(b,a,new_cal_array(:,3));
%         output_array = zeros (length(filt_cal_array),4);
%         output_array(:,1) = filt_cal_array(:,1);
%         output_array(:,2) = filt_cal_array(:,2);
%         output_array(:,3) = filt_cal_array(:,3);
%         output_array(:,4) = time';
%         trial_num =0;
%         varargout = num2cell( output_array, [1 2]);
        end
    end
    
    if(varargin {1} ==2) %Optotrak Calibration
        frequency =0; %Not needed
        trial_num =0; %Not needed
        
        [calfile, ~] = uigetfile('*.csv', 'Select Optotrak Calibration');

        if isequal(calfile,0)
            master_array = zeros (5,7);
            varargout = num2cell(master_array, [1 2]);
            return;
        else
        [num, txt, ~] = xlsread(calfile, 1);
        
        frequency = txt{2,1};
        frequency = regexprep(frequency,'Frequency: ','');
        frequency = str2double(frequency);
        
        num(:,1) = (1/frequency)*1e3*num(:,1); %Turn from frames to time in ms 
        trial_num = frequency;
        
        varargout = num2cell(num, [1 2]);
        end
    if(varargin{1} == 4) %Eyelink trial
        fid = fopen(filename,'r','ieee-le');

        %%% HEADER LOAD
        % PART1: (GENERAL) 
        hdr = char(fread(fid,256,'uchar')'); 
        header.ver=str2num(hdr(1:8));            % 8 ascii : version of this data format (0)
        header.patientID  = char(hdr(9:88));     % 80 ascii : local patient identification
        header.recordID  = char(hdr(89:168));    % 80 ascii : local recording identification
        header.startdate=char(hdr(169:176));     % 8 ascii : startdate of recording (dd.mm.yy)
        header.starttime  = char(hdr(177:184));  % 8 ascii : starttime of recording (hh.mm.ss)
        header.length = str2num (hdr(185:192));  % 8 ascii : number of bytes in header record
        reserved = hdr(193:236); % [EDF+C       ] % 44 ascii : reserved
        header.records = str2num (hdr(237:244)); % 8 ascii : number of data records (-1 if unknown)
        header.duration = str2num (hdr(245:252)); % 8 ascii : duration of a data record, in seconds
        header.channels = str2num (hdr(253:256));% 4 ascii : number of signals (ns) in data record

        %%%% PART2 (DEPENDS ON QUANTITY OF CHANNELS)

        header.labels=cellstr(char(fread(fid,[16,header.channels],'char')')); % ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp)
        header.transducer =cellstr(char(fread(fid,[80,header.channels],'char')')); % ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode)
        header.units = cellstr(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC)
        header.physmin = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical minimum (e.g. -500 or 34)
        header.physmax = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * physical maximum (e.g. 500 or 40)
        header.digmin = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * digital minimum (e.g. -2048)
        header.digmax = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * digital maximum (e.g. 2047)
        header.prefilt =cellstr(char(fread(fid,[80,header.channels],'char')')); % ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
        header.samplerate = str2num(char(fread(fid,[8,header.channels],'char')')); % ns * 8 ascii : ns * nr of samples in each data record
        reserved = char(fread(fid,[32,header.channels],'char')'); % ns * 32 ascii : ns * reserved


        f1=find(cellfun('isempty', regexp(header.labels, 'EDF Annotations', 'once'))==0); % Channels number with the EDF Annotations
        f2=find(cellfun('isempty', regexp(header.labels, 'Status', 'once'))==0); % Channels number with the EDF Annotations
        f=[f1(:); f2(:)];
        %%%%%% PART 3: Loading of signals

        %Structure of the data in format EDF:

        %[block1 block2 .. , block N], where N=header.records
        % Block structure:
        % [(d seconds of 1 channel) (d seconds of 2 channel) ... (d seconds of h channel)], Where h - quantity of channels, d - duration of the block
        % Ch = header.channels
        % d = header.duration

        Ch_data = fread(fid,'int16'); % Loading of signals


        fclose(fid); % close a file

        %%%%% PART 4: Transformation of the data
        if header.records<0, % If the quantity of blocks is not known
        R=sum(header.duration*header.samplerate); % Length of one block
        header.records=fix(length(Ch_data)./R); % Quantity of written down blocks
        end

        % Separating a read signal into blocks
        Ch_data=reshape(Ch_data, [], header.records);

        % establishing calibration parametres



        sf = (header.physmax - header.physmin)./(header.digmax - header.digmin);
        dc = header.physmax - sf.* header.digmax;

        data=cell(1, header.channels);
        Rs=cumsum([1; header.duration*header.samplerate]); %     Rs(k):Rs(k+1)-1


        % separating of signals of everyone the channel from blocks 
        % and recording of signals in structure of cells

        for k=1:header.channels

        data{k}=reshape(Ch_data(Rs(k):Rs(k+1)-1, :), [], 1);
        if sum(k==f)==0 % non nnotation
        % Calibration of the data
        data{k}=data{k}.*sf(k)+dc(k);
        end
        end

        % PART 5: ANNOTATION READ
            header.annotation.event={};
            header.annotation.starttime=[];
            header.annotation.duration=[];
            header.annotation.data={};

        if sum(f)>0

        try

        for p1=1:length(f)
        Annt=char(typecast(int16(data{f(p1)}), 'uint8'))';   

        % separate of annotation on blocks
        Annt=buffer(Annt, header.samplerate(f(p1)).*2, 0)';
        ANsize=size(Annt);
            for p2=1:ANsize(1)
           % search TALs starttime
            Annt1=Annt(p2, :); 
            Tstart=regexp(Annt1, '+');
            Tstart=[Tstart(2:end) ANsize(2)];

            for p3=1:length(Tstart)-1
           A=Annt1(Tstart(p3):Tstart(p3+1)-1); % TALs block 
           header.annotation.data={header.annotation.data{:} A}; 

              % duration and starttime TALs
               Tds=find(A==20 | A==21); 
                if length(Tds)>2
                    td=str2num(A(Tds(1)+1:Tds(2)-1)); 
                    if isempty(td), td=0; end
                   header.annotation.duration=[header.annotation.duration(:); td];
                   header.annotation.starttime=[header.annotation.starttime(:); str2num(A(2:Tds(1)-1))];
                   header.annotation.event={header.annotation.event{:} A(Tds(2)+1:Tds(end)-1)};
                  else
                   header.annotation.duration=[header.annotation.duration(:); 0];
                   header.annotation.starttime=[header.annotation.starttime(:); str2num(A(2:Tds(1)-1))];
                   header.annotation.event={header.annotation.event{:} A(Tds(1)+1:Tds(end)-1)};
                end
            end
            end
        end

        % delete annotation
        a=find(cell2mat(cellfun(@length, header.annotation.event, 'UniformOutput', false))==0);
        header.annotation.event(a)=[];
        header.annotation.starttime(a)=[];
        header.annotation.duration(a)=[];

        end

        end

        header.samplerate(f)=[];
        header.channels=header.channels-length(f);
        header.labels(f)=[];
        header.transducer(f)=[];
        header.units(f)=[];
        header.physmin(f)=[];
        header.physmax(f)=[];
        header.digmin(f)=[];
        header.digmax(f)=[];
        header.prefilt(f)=[];
        data(f)=[];
    end
end

