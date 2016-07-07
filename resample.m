function [status, downsampled_data] = resample(sys, resample_rate, varargin )
%resample Resamples given data at a user specified frequency using pchip
%   resample (matrix) returns a resampled data set
%   matrix must have time data in last coloumn with x y and z position data
%   in coloumns 1,2 and 3 respectively
%   Status corresponds to the amount of data missing
%   If more than 30% of data missing, status =1, else status =0

if(sys ==1)
            %missing_data_limit = 200; %in ms
            varargin = cell2mat(varargin);
            status =0;
            size_array = size(varargin);
            rows = size_array (1);
            coloumns = size_array (2);
            %index=0;
            

%             missing_index = find(varargin(:,1)==999.0000);
%             
%             %add the missing frame times
%             for d =1:length(missing_index)
%                   missing_data_ms = missing_data_ms + (varargin(missing_index(d),coloumns)-varargin(missing_index(d)-1,coloumns)); 
%             end
%             
%             %Disregard trial if more than 30% data lost 
%            
             total_time = varargin(rows,coloumns);
%             
%             percent_missing = missing_data_ms/total_time;
%             
%             if (percent_missing >=0.30)
%                 output('There is too much data missing from this trial')
%                 return             
%             end
            
            %Remove all data points where hand was lost to the camera
            index = find(varargin(:,1)==999.00);
            if(length(index(:,1))/length(varargin(:,1)) > 0.3)
                status =1;
            end
            for count =1: 12
                for j =1: length(index(:,1))
                    varargin(index(j,1),count) = nan;
                end
            end
            if(length(index(:,1)) == length(varargin(:,1)))
                a = [0;1;2;3];
                downsampled_data = [a a a a a a a a a a a a a];
                status = 2;
                return;
            end
           
%             for j =1: length(missing_index)
%                  y = varargin;
%                  curr_index = missing_index(j);
%                  y([curr_index], :) = [];
%                  clear('y');   % distract the JIT
%             end
          
            % Fill/resample data to output rate
            % output_rate = input('Please Enter The Desired Output Rate in Hz: ')
            %output_rate = 50; %desired output rate in Hz
            max_time = total_time/1e3;
            time = (0:1/resample_rate:max_time) * 1e3;
            %downsampled_data = [];
            predicted_x_index = (pchip( varargin(:,13),varargin(:,1), time))';
            predicted_y_index = (pchip( varargin(:,13),varargin(:,2), time))';
            predicted_z_index = (pchip( varargin(:,13),varargin(:,3), time))'; 
            
            predicted_x_palm = (pchip( varargin(:,13),varargin(:,4), time))';
            predicted_y_palm = (pchip( varargin(:,13),varargin(:,5), time))';
            predicted_z_palm = (pchip( varargin(:,13),varargin(:,6), time))'; 
            
            predicted_x_thumb = (pchip( varargin(:,13),varargin(:,7), time))';
            predicted_y_thumb = (pchip( varargin(:,13),varargin(:,8), time))';
            predicted_z_thumb = (pchip( varargin(:,13),varargin(:,9), time))'; 
            
            predicted_x_wrist = (pchip( varargin(:,13),varargin(:,10), time))';
            predicted_y_wrist = (pchip( varargin(:,13),varargin(:,11), time))';
            predicted_z_wrist = (pchip( varargin(:,13),varargin(:,12), time))'; 
            time = time';
            downsampled_data = [predicted_x_index predicted_y_index  predicted_z_index predicted_x_palm predicted_y_palm predicted_z_palm predicted_x_thumb predicted_y_thumb predicted_z_thumb predicted_x_wrist predicted_y_wrist predicted_z_wrist time];
end
if(sys == 2)
    
    
end

end

