function [trial_num,varargout ] = load_LEAP_data_gui( varargin )
%LOAD_LEAP_DATA_GUI Select multiple files to load and assemble info into an array for gui
% INPUT: 0 (Load Calibration Data) or 1 (Load Trial Data)
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


        
    if (varargin{1} ==1)
        [filename, ~] = uigetfile('*.txt', 'Select a Trial');
        if isequal(filename,0)
            master_array = zeros (5,13);
            varargout = num2cell(master_array, [1 2]);
            trial_num = 0;
            return;
        else
                    currFile =fopen(filename, 'r');
                    formatSpec = '%f';
                    size_ = [13 Inf]; 
                    array = fscanf(currFile,formatSpec ,size_);

                    array = array';
        end
                %[rows coloumns] = size(master_array);

                str = regexprep(filename,'Trial_','');
                str = regexprep(str,'.txt','');

                trial_num = str2double(str);
            varargout = num2cell(array, [1 2]);
   end
    if (varargin{1} == 0)
        [calfile, ~] = uigetfile('*.txt', 'Select a Calibration File');
        formatSpec = '%f';
        size_ = [4 Inf];
        calFile = fopen(calfile,'r');
        
        cal_array = fscanf(calFile, formatSpec, size_);
        
        cal_array = cal_array';
        count =0;
        i=1;
        while (count <2)
            if(cal_array(i,4) == 0)
            count = count +1;
            end
            i = i+1;
        end
        
        cal_array = cal_array(1:i-3,:);
        max_time = cal_array(end,4)/1e3;
       
        time = (0:1/50:max_time)*1e3;
        predicted_x_index = (pchip( cal_array(:,4),cal_array(:,1), time))';
        predicted_y_index = (pchip( cal_array(:,4),cal_array(:,2), time))';
        predicted_z_index = (pchip( cal_array(:,4),cal_array(:,3), time))'; 
        
        new_cal_array = zeros (length (predicted_x_index), 4);
        
        new_cal_array(:,1) = predicted_x_index;
        new_cal_array(:,2) = predicted_y_index;
        new_cal_array(:,3) = predicted_z_index;
        new_cal_array(:,4) = time'; 
        
        [b,a] = butter(3,0.4);

        filt_cal_array(:,1)= filtfilt(b,a,new_cal_array(:,1));
        filt_cal_array(:,2) = filtfilt(b,a,new_cal_array(:,2));
        filt_cal_array(:,3) = filtfilt(b,a,new_cal_array(:,3));
        output_array = zeros (length(filt_cal_array),4);
        output_array(:,1) = filt_cal_array(:,1);
        output_array(:,2) = filt_cal_array(:,2);
        output_array(:,3) = filt_cal_array(:,3);
        output_array(:,4) = time';
        trial_num =0;
        varargout = num2cell( output_array, [1 2]);
    end
    
    if (varargin{1} == 3)
        [calfile, ~] = uigetfile('*.xls', 'Select an Optotrak Trial');

        if isequal(calname,0)
            master_array = zeros (5,13);
            varargout = num2cell(master_array, [1 2]);
            trial_num = 0;
            return;
        else
        [num, txt, ~] = xlsread(calfile, 1);
        
        frequency = txt{2,1};
        frequency = regexprep(frequency,'Frequency: ','');
        frequency = str2double(frequency);
        
        
        trial_num = frequency;
        
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
end

