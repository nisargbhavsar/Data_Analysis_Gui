function [ varargout ] = filter_resampled_data( sys, sample_rate, cuttoff_freq, varargin )
%filters given position data
%   filter (matrix) gives back filtered position data in form of a matrix
%   INPUT:  [Inf 13] matrix with order of x values, y values, z values and time
%           Resampled data only.
%   OUTPUT: [Inf 13] mtrix with filtered data with x values, y values, z
%           values and time
%   Uses a 2nd order butterworth filter
%   

if (sys ==1) %Leap data
a = cuttoff_freq/(sample_rate/2);
[b,a] = butter(3,a);
varargin = cell2mat(varargin);

filtered_x_index = filtfilt(b,a,varargin(:,1));
filtered_y_index = filtfilt(b,a,varargin(:,2));
filtered_z_index = filtfilt(b,a,varargin(:,3));

filtered_x_palm = filtfilt(b,a,varargin(:,4));
filtered_y_palm = filtfilt(b,a,varargin(:,5));
filtered_z_palm = filtfilt(b,a,varargin(:,6));

filtered_x_thumb = filtfilt(b,a,varargin(:,7));
filtered_y_thumb = filtfilt(b,a,varargin(:,8));
filtered_z_thumb = filtfilt(b,a,varargin(:,9));

filtered_x_wrist = filtfilt(b,a,varargin(:,10));
filtered_y_wrist = filtfilt(b,a,varargin(:,11));
filtered_z_wrist = filtfilt(b,a,varargin(:,12));


%for debugging
% figure()
% subplot(3,1,1)
% plot(filtered_x)
% 
% subplot(3,1,2)
% plot(filtered_y)
% 
% subplot(3,1,3)
% plot(filtered_z)
% 
% 
filtered_data = [filtered_x_index filtered_y_index filtered_z_index filtered_x_palm filtered_y_palm filtered_z_palm filtered_x_thumb filtered_y_thumb filtered_z_thumb filtered_x_wrist filtered_y_wrist filtered_z_wrist varargin(:,13)];
varargout = num2cell(filtered_data, [1 2]);
end
if(sys ==2)
    a = cuttoff_freq/(sample_rate/2);
    [b,a] = butter(3,a);
    varargin = cell2mat(varargin);

    filtered_x_index = filtfilt(b,a,varargin(:,2));
    filtered_y_index = filtfilt(b,a,varargin(:,3));
    filtered_z_index = filtfilt(b,a,varargin(:,4));

    filtered_x_palm = filtfilt(b,a,varargin(:,5));
    filtered_y_palm = filtfilt(b,a,varargin(:,6));
    filtered_z_palm = filtfilt(b,a,varargin(:,7));
    
    filtered_data = [varargin(:,1) filtered_x_index filtered_y_index filtered_z_index filtered_x_palm filtered_y_palm filtered_z_palm];
    varargout = num2cell(filtered_data, [1 2]);
end


end

