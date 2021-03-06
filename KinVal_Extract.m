function [ varargout ] = KinVal_Extract(marker, system, side, resample_rate, type, VelEnd_tolerance, vel_tolerance, pos, velocity, accel, vector_sagpos, vector_vel, vector_accel, if_vector_vel_tol, th_vector_vel_tol, varargin)
%Kinematic_Var_Extract Analyses given filtered data and returns data points
%of needed kinematic variables
%   INPUT:(type, tolerance, handles.Filtered_SagPos, handles.Filtered_Velocity, handles.Filtered_Accel)
%   If type ==0: Pointing motion
%       Peak Velocity 
%       Peak Acceleration
%       Peak Deceleration
%
%       Movement start time
%       Movement end time
%   If type ==1: Grasping motion
%       Peak Velocity
%       Peak Acceleration
%       Movement start time
%       Movement end time
%       Peak grip aperture

if (type ==0 && system ==1) %Pointing Leap
    varargin=(cell2mat(varargin)); 
    if(marker == 2 || marker == 1) %index Only / index part for index + thumb
        
        % Index finger max vector velocity
        if_max_v_vel_index = max(vector_vel(:,1)); %Peak Index Vector Vel
        if_max_v_vel_index = find(vector_vel(:,1) == if_max_v_vel_index);
        if(varargin(1, 1) ~= 0) %Respecify
            %index finger max velocity (Z)
            [~, if_max_vel_index_z] = max(velocity(varargin(1, 1): varargin(1, 2), 3));
            if_max_vel_index_z = if_max_vel_index_z+ varargin(1, 1) -1;
        else
            %index finger max velocity (Z)
            [~, indices] = findpeaks(velocity(:,3),'MinPeakHeight',if_vector_vel_tol);
            if_max_vel_index_z = indices(1,1);
        end

        %%assuming resample rate is 50 Hz
        %100 msec before/after
        if_100n_index = if_max_vel_index_z - 5;
        if_100p_index = if_max_vel_index_z + 5;

        %40 msec before/after
        if_40n_index = if_max_vel_index_z - 2;
        if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
        if_60n_index = if_max_vel_index_z -3;
        if_60p_index = if_max_vel_index_z +3;

        %50 msec before/after (x)
        x = [pos(if_60n_index,1), pos(if_40n_index,1)];
        y = [pos(if_60n_index,2), pos(if_40n_index,2)];
        z = [pos(if_60n_index,3), pos(if_40n_index,3)];

        if_x_50n = interp1(x,1.5); %Values
        if_y_50n = interp1(y,1.5);
        if_z_50n = interp1(z,1.5);

        x = [pos(if_40p_index,1), pos(if_60p_index,1)];
        y = [pos(if_40p_index,2),pos(if_60p_index,2)];
        z = [pos(if_40p_index,3),pos(if_60p_index,3)];

        if_x_50p = interp1(x,1.5); %Values
        if_y_50p = interp1(y,1.5);
        if_z_50p = interp1(z,1.5);

        if_x_100n = pos(if_100n_index,1); %Values
        if_y_100n = pos(if_100n_index,2);
        if_z_100n = pos(if_100n_index,3);

        if_x_100p = pos(if_100p_index,1); %Values
        if_y_100p = pos(if_100p_index,2);
        if_z_100p = pos(if_100p_index,3);

        %movement start time -time when velocity is less than the given tolerance
        ifs_move_x = if_max_vel_index_z;
        while (abs(velocity(ifs_move_x,1))>vel_tolerance && ifs_move_x>0)      %Movement Start for outgoing arc (x) index
            ifs_move_x = ifs_move_x-1;
        end

        ifs_move_y = if_max_vel_index_z;
        while (velocity(ifs_move_y,2)>vel_tolerance && ifs_move_y >0)     %Movement Start for outgoing arc (y) index
            ifs_move_y = ifs_move_y-1;
        end

        ifs_move_z = if_max_vel_index_z;
        while (velocity(ifs_move_z,3)>vel_tolerance && ifs_move_z >0)      %Movement Start for outgoing arc (z) index
            ifs_move_z = ifs_move_z-1;
        end

        ifs_move_x = ifs_move_z; %All start and end times based on velocity in z
        ifs_move_y = ifs_move_z;
        
        %movement end time - time when velocity lower than given velocity
        %tolerance
        size_ = size(velocity());
        max_index = size_(1,1);

        ife_move_x = if_max_vel_index_z;
        while (velocity(ife_move_x,1)>VelEnd_tolerance && ife_move_x<max_index)      %Movement End for outgoing arc (x) index
            ife_move_x = ife_move_x+1;
        end

        ife_move_y = if_max_vel_index_z;
        while (velocity(ife_move_y,2)>VelEnd_tolerance && ife_move_y <max_index)     %Movement End for outgoing arc (y) index
            ife_move_y = ife_move_y+1;
        end

        ife_move_z = if_max_vel_index_z;
        while (velocity(ife_move_z,3)>VelEnd_tolerance && ife_move_z <max_index)      %Movement End for outgoing arc (z) index
            ife_move_z = ife_move_z+1;
        end
    
        ife_move_x = ife_move_z; %All end times are based on velocity in z
        ife_move_y = ife_move_z;
        
        % Peak XYZ velocities
        %index finger max velocity (X)
    %     if(side>0) %Subject pointing to the right (1)
    %         if_max_vel = max((velocity(ifs_move_x:ife_move_x,1)));
    %     end
    %     if(side <0)  %Subject pointing to the left (-1)
            if_max_vel = min((velocity(ifs_move_x:ife_move_x,1)));
    %     end
        if_max_vel_index_x = find((velocity(:,1)) == if_max_vel);


        %index finger max velocity (Y)
        if_max_vel = max(velocity(ifs_move_x:ife_move_x,2));
        if_max_vel_index_y = find(velocity(:,2)==if_max_vel);
        
        %Peak acceleration index
        temp_array = accel(ifs_move_x:if_max_vel_index_x, 1); %copy index acceleration in x direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_x:ifs_move_x,1); %necessary for catching an error
        end
        if(side>0) %Subject pointing to the right (1)
            peakAccel = max(temp_array);
        else % if(side<0)%Subject pointing to the left (-1)
            peakAccel = min(temp_array);
        end    
        if_peakAccel_index_x = find(accel(:,1) == peakAccel);
        if(isempty(if_peakAccel_index_x)) 
            if_peakAccel_index_x = if_max_vel_index_z;
        end

        temp_array = accel(ifs_move_y:if_max_vel_index_y, 2); %copy index acceleration in y direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_y:ifs_move_y,2);
        end
        peakAccel = max(temp_array);
        if_peakAccel_index_y = find(accel(:,2) == peakAccel);
        if(isempty(if_peakAccel_index_y)) 
            if_peakAccel_index_y = if_max_vel_index_z;
        end

        temp_array = accel(ifs_move_z:if_max_vel_index_z, 3); %copy index acceleration in z direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_z:ifs_move_z, 3);
        end
        peakAccel = max(temp_array);
        if_peakAccel_index_z = find(accel(:,3) == peakAccel);
        if(isempty(if_peakAccel_index_z)) 
            if_peakAccel_index_z = if_max_vel_index_z;
        end

         %Peak decceleration index
        temp_array = accel(if_max_vel_index_x:ife_move_x,1);
        if(isempty(temp_array))
            temp_array = accel(ife_move_x:if_max_vel_index_x, 1);
        end
        if(side >0) %Subject pointing to the right (1)
            peakDeccel = min(temp_array);
        else %if(side<0) %Subject pointing to the left (-1)
            peakDeccel = max(temp_array);
        end    
        if_peakDeccel_index_x = find(accel(:,1) == peakDeccel);
        if(isempty(if_peakDeccel_index_x)) 
            if_peakDeccel_index_x = if_max_vel_index_z;
        end

        temp_array = accel(if_max_vel_index_y:ife_move_y, 2); %copy index acceleration in y direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ife_move_y:if_max_vel_index_y, 2);
        end
        peakDeccel = min(temp_array);
        if_peakDeccel_index_y = find(accel(:,2) == peakDeccel);
        if(isempty(if_peakDeccel_index_y))
            if_peakDeccel_index_y = if_max_vel_index_z;
        end

        temp_array = accel(if_max_vel_index_z:ife_move_z, 3); %copy index acceleration in z direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ife_move_z:if_max_vel_index_z, 3);
        end
        peakDeccel = min(temp_array);
        if_peakDeccel_index_z = find(accel(:,3) == peakDeccel);
        if(isempty(if_peakDeccel_index_z)) 
            if_peakDeccel_index_z = if_max_vel_index_z;
        end
    end
    
    %output_array = zeros(1,32);
    if(marker == 3 || marker == 1) %thumb Only / thumb for index + thumb
        
        %Thumb max vector velocity
        th_max_v_vel = max(vector_vel(:,2)); %Peak Thumb Vector Vel
        th_max_v_vel_index = find(vector_vel(:,2) == th_max_v_vel);
        
        if(varargin(1, 1) ~= 0)
            %thumb max velocity (Z)
            [~, th_max_vel_index_z] = max(velocity(varargin(1, 1): varargin(1, 2), 6));
            th_max_vel_index_z = th_max_vel_index_z + varargin(1, 1) -1;
        else
            %thumb max velocity (Z)
            [~, indices] = findpeaks(velocity(:,6),'MinPeakHeight',th_vector_vel_tol);
            th_max_vel_index_z= indices (1,1);
        end

        %%Assuming resample rate is 50 Hz
        % Thumb 100, 50 msec before and after 
        %100 msec before/after
        th_100n_index = th_max_vel_index_z - 5;
        th_100p_index = th_max_vel_index_z + 5;
        
        %40 msec before/after
        th_40n_index = th_max_vel_index_z - 2;
        th_40p_index = th_max_vel_index_z + 2;

        %60 msec before/after
        th_60n_index = th_max_vel_index_z -3;
        th_60p_index = th_max_vel_index_z +3;

        %50 msec before/after (x)
        x = [pos(th_60n_index,4), pos(th_40n_index,4)];
        y = [pos(th_60n_index,5), pos(th_40n_index,5)];
        z = [pos(th_60n_index,6), pos(th_40n_index,6)];

        th_x_50n = interp1(x,1.5); %Values
        th_y_50n = interp1(y,1.5);
        th_z_50n = interp1(z,1.5);

        x = [pos(th_40p_index,4), pos(th_60p_index,4)];
        y = [pos(th_40p_index,5), pos(th_60p_index,5)];
        z = [pos(th_40p_index,6), pos(th_60p_index,6)];

        th_x_50p = interp1(x,1.5); %Values
        th_y_50p = interp1(y,1.5);
        th_z_50p = interp1(z,1.5);
        
        th_x_100n = pos(th_100n_index,4); %Values
        th_y_100n = pos(th_100n_index,5);
        th_z_100n = pos(th_100n_index,6);
        
        th_x_100p = pos(th_100p_index,4); %Values
        th_y_100p = pos(th_100p_index,5);
        th_z_100p = pos(th_100p_index,6);
        
%         ths_move_x = th_max_vel_index_z;
%         while (abs(velocity(ths_move_x,4))>vel_tolerance && ths_move_x>0)      %Movement Start for outgoing arc (x) thumb
%             ths_move_x = ths_move_x-1;
%         end
% 
%         ths_move_y = th_max_vel_index_z;
%         while (velocity(ths_move_y,5)>vel_tolerance && ths_move_y >0)     %Movement Start for outgoing arc (y) thumb
%             ths_move_y = ths_move_y-1;
%         end
% 
%         ths_move_z = th_max_vel_index_z;
%         while (velocity(ths_move_z,6)>vel_tolerance && ths_move_z >0)      %Movement Start for outgoing arc (z) thumb
%             ths_move_z = ths_move_z-1;
%         end
% 
%         ths_move_x = ths_move_z;
%         ths_move_y = ths_move_z;
        
        ths_move_x = th_max_vel_index_z;
        while (abs(velocity(ths_move_x,4))>vel_tolerance && ths_move_x>0)      %Movement Start for outgoing arc (x) thumb
            ths_move_x = ths_move_x-1;
        end

        ths_move_y = th_max_vel_index_z;
        while (velocity(ths_move_y,5)>vel_tolerance && ths_move_y >0)     %Movement Start for outgoing arc (y) thumb
            ths_move_y = ths_move_y-1;
        end

        ths_move_z = th_max_vel_index_z;
        while (velocity(ths_move_z,6)>vel_tolerance && ths_move_z >0)      %Movement Start for outgoing arc (z) thumb
            ths_move_z = ths_move_z-1;
        end

        ths_move_x = ths_move_z;
        ths_move_y = ths_move_z;
        
        %movement end time - time when velocity lower than given velocity
        %tolerance
        size_ = size(velocity());
        max_index = size_(1,1);
        
        the_move_x = th_max_vel_index_z;
        while (velocity(the_move_x,4)>VelEnd_tolerance && the_move_x<max_index)      %Movement End for outgoing arc (x) thumb
            the_move_x = the_move_x+1;
        end

        the_move_y = th_max_vel_index_z;
        while (velocity(the_move_y,5)>VelEnd_tolerance && the_move_y <max_index)     %Movement End for outgoing arc (y) thumb
            the_move_y = the_move_y+1;
        end

        the_move_z = th_max_vel_index_z;
        while (velocity(the_move_z,6)>VelEnd_tolerance && the_move_z<max_index)      %Movement End for outgoing arc (z) thumb
            the_move_z = the_move_z+1;
        end
        the_move_x = the_move_z;
        the_move_y = the_move_z;
        
        %thumb max velocity (X)
    %     if(side>0) %Subject pointing to the right (1)
    %         th_max_vel = max((velocity(ths_move_x:the_move_x,4)));
    %     end
    %     if(side <0) %Subject pointing to the left (-1)
            th_max_vel = min((velocity(ths_move_x:the_move_x,4)));
    %     end
        th_max_vel_index_x = find((velocity(:,4)) == th_max_vel);

        %thumb max velocity (Y)
        th_max_vel = max(velocity(ths_move_x:the_move_x,5));
        th_max_vel_index_y = find(velocity(:,5) == th_max_vel);

        %Peak acceleration thumb  
        temp_array = accel(ths_move_x:th_max_vel_index_x, 4); %copy thumb acceleration in x direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(th_max_vel_index_x:ths_move_x, 4);
        end
        if(side >0) %Subject pointing to the right (1)
            peakAccel = max(temp_array);
        else % if(side<0) %Subject pointing to the left (-1)
            peakAccel = min(temp_array);
        end
        th_peakAccel_index_x = find(accel(:,4) == peakAccel);
        if(isempty(th_peakAccel_index_x)) 
            th_peakAccel_index_x = th_max_vel_index_z;
        end

        temp_array = accel(ths_move_y:th_max_vel_index_y, 5); %copy thumb acceleration in y direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(th_max_vel_index_y:ths_move_y, 5);
        end
        peakAccel = max(temp_array);
        th_peakAccel_index_y = find(accel(:,5) == peakAccel);
        if(isempty(th_peakAccel_index_y)) 
            th_peakAccel_index_y = th_max_vel_index_z;
        end

        temp_array = accel(ths_move_z:th_max_vel_index_z, 6); %copy thumb acceleration in z direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(th_max_vel_index_z:ths_move_z, 6);
        end
        peakAccel = max(temp_array);
        th_peakAccel_index_z = find(accel(:,6) == peakAccel);
        if(isempty(th_peakAccel_index_z)) 
            th_peakAccel_index_z = th_max_vel_index_z;
        end
        
        %Peak decceleration thumb
    
        temp_array = accel(th_max_vel_index_x:the_move_x, 4); %copy thumb acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(the_move_x:th_max_vel_index_x, 4);
        end
        if(side >0) %Subject pointing to the right (1)
            peakDeccel = min(temp_array);
        else %if(side<0) %Subject pointign to the left (-1)
            peakDeccel = max(temp_array);
        end   
        th_peakDeccel_index_x = find(accel(:,4) == peakDeccel);
        if(isempty(th_peakDeccel_index_x))
            th_peakDeccel_index_x = th_peak_vel_index_z;
        end

        temp_array = accel(th_max_vel_index_y:the_move_y, 5); %copy thumb acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(the_move_y:th_max_vel_index_y, 5);
        end
        peakAccel = min(temp_array);
        th_peakDeccel_index_y = find(accel(:,5) == peakAccel);
        if(isempty(th_peakDeccel_index_y))
            th_peakDeccel_index_y = th_peak_vel_index_z;
        end

        temp_array = accel(th_max_vel_index_z:the_move_z, 6); %copy thumb acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(the_move_z:th_max_vel_index_z, 6);
        end
        peakAccel = min(temp_array);
        th_peakDeccel_index_z = find(accel(:,6) == peakAccel);
        if(isempty(th_peakDeccel_index_z))
            th_peakDeccel_index_z = th_peak_vel_index_z;
        end
    
    end
    
    if(marker==1)
        output_array = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p]; 
    end
    if(marker ==2) %index only
        output_array = [ifs_move_x   ifs_move_y   ifs_move_z   1   1  1   ife_move_x   ife_move_y   ife_move_z   1   1   1   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   1   1   1   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   1   1   1   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   1   1   1   if_max_v_vel_index   1   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   1   1   1   1   1   1   1   1   1   1   1   1]; 
    end
    if(marker == 3) %thumb only
        output_array = [1   1   1   ths_move_x   ths_move_y   ths_move_z   1   1   1   the_move_x   the_move_y   the_move_z   1   1   1   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   1   1   1   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   1   1   1   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   1   th_max_v_vel_index   1   1   1   1   1   1   1   1   1   1   1   1   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p]; 
    end  
    varargout = num2cell( output_array, [1 2]);
end

if (type ==1 && system ==1) %Grasping Leap
    varargin=(cell2mat(varargin)); 
    %%%Target approach phase
   
    %index finger max velocity (Z)
    [~, indices] = findpeaks(velocity(:, 3), 'MinPeakHeight', if_vector_vel_tol);
    if_max_vel_index_z = indices (1, 1);

    %thumb max velocity (Z)
    [~, indices] = findpeaks(velocity(:,6), 'MinPeakHeight', th_vector_vel_tol);
    th_max_vel_index_z = indices (1,1);

    % Index Finger 100, 50 msec before and after peak velocity
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index = if_max_vel_index_z - 5;
    if_100p_index = if_max_vel_index_z + 5;
        
        %40 msec before/after
    if_40n_index = if_max_vel_index_z - 2;
    if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
    if_60n_index = if_max_vel_index_z - 3;
    if_60p_index = if_max_vel_index_z + 3;
    
%     if(if_100n_index <1)
%         if_100n_index = 1;
%     end
%     if(if_100p_index > length(pos(:,1)))
%         if_100p_index = 1;
%     end
    
        %50 msec before/after (x)
    x = [pos(if_60n_index, 1), pos(if_40n_index, 1)];
    y = [pos(if_60n_index, 2), pos(if_40n_index, 2)];
    z = [pos(if_60n_index, 3), pos(if_40n_index, 3)];

    if_x_50n = interp1(x, 1.5); %Values
    if_y_50n = interp1(y, 1.5);
    if_z_50n = interp1(z, 1.5);

    x = [pos(if_40p_index, 1), pos(if_60p_index, 1)];
    y = [pos(if_40p_index, 2), pos(if_60p_index, 2)];
    z = [pos(if_40p_index, 3), pos(if_60p_index, 3)];

    if_x_50p = interp1(x, 1.5); %Values
    if_y_50p = interp1(y, 1.5);
    if_z_50p = interp1(z, 1.5);
        
    if_x_100n = pos(if_100n_index, 1); %Values
    if_y_100n = pos(if_100n_index, 2);
    if_z_100n = pos(if_100n_index, 3);
        
    if_x_100p = pos(if_100p_index, 1); %Values
    if_y_100p = pos(if_100p_index, 2);
    if_z_100p = pos(if_100p_index, 3);
        
        % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index = th_max_vel_index_z - 5;
    th_100p_index = th_max_vel_index_z + 5;
        
        %40 msec before/after
    th_40n_index = th_max_vel_index_z - 2;
    th_40p_index = th_max_vel_index_z + 2;

        %60 msec before/after
    th_60n_index = th_max_vel_index_z - 3;
    th_60p_index = th_max_vel_index_z + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index, 4), pos(th_40n_index, 4)];
    y = [pos(th_60n_index, 5), pos(th_40n_index, 5)];
    z = [pos(th_60n_index, 6), pos(th_40n_index, 6)];

    th_x_50n = interp1(x, 1.5); %Values
    th_y_50n = interp1(y, 1.5);
    th_z_50n = interp1(z, 1.5);

    x = [pos(th_40p_index, 4), pos(th_60p_index, 4)];
    y = [pos(th_40p_index, 5), pos(th_60p_index, 5)];
    z = [pos(th_40p_index, 6), pos(th_60p_index, 6)];

    th_x_50p = interp1(x, 1.5); %Values
    th_y_50p = interp1(y, 1.5);
    th_z_50p = interp1(z, 1.5);
        
    th_x_100n = pos(th_100n_index, 4); %Values
    th_y_100n = pos(th_100n_index, 5);
    th_z_100n = pos(th_100n_index, 6);
        
    th_x_100p = pos(th_100p_index, 4); %Values
    th_y_100p = pos(th_100p_index, 5);
    th_z_100p = pos(th_100p_index, 6);
    
    %movement start time -time when velocity is less than the given tolerance
    
    ifs_move_z = if_max_vel_index_z;
    while (velocity(ifs_move_z, 3) > vel_tolerance && ifs_move_z > 0) %Movement Start for outgoing arc (z) index
        ifs_move_z = ifs_move_z - 1;
    end

    ths_move_z = th_max_vel_index_z;
    while (velocity(ths_move_z,6)>vel_tolerance && ths_move_z >0) %Movement Start for outgoing arc (z) thumb
        ths_move_z = ths_move_z-1;
    end
    ifs_move_x = ifs_move_z; %All start and end times based on velocity in z
    ifs_move_y = ifs_move_z;
    ths_move_x = ths_move_z;
    ths_move_y = ths_move_z;
    
    %movement end time - time when velocity lower than given velocity
    %tolerance
    size_ = size(velocity());
    max_index = size_(1,1);
    
    ife_move_z = if_max_vel_index_z;
    while (velocity(ife_move_z,3)>VelEnd_tolerance && ife_move_z <max_index)      %Movement End for outgoing arc (z) index
        ife_move_z = ife_move_z+1;
    end

    the_move_z = th_max_vel_index_z;
    while (velocity(the_move_z,6)>VelEnd_tolerance && the_move_z<max_index)      %Movement End for outgoing arc (z) thumb
        the_move_z = the_move_z+1;
    end
    ife_move_x = ife_move_z; %All end times are based on velocity in z
    ife_move_y = ife_move_z;
    the_move_x = the_move_z;
    the_move_y = the_move_z;
    
    % Index finger max vector velocity
    [~, if_max_v_vel_index] = max(vector_vel(ifs_move_x:ife_move_x, 1)); %Peak Index Vector Vel look for the max
    if_max_v_vel_index = if_max_v_vel_index + ifs_move_x -1; %find(vector_vel(:, 1) == if_max_v_vel_index);
    
    %Thumb max vector velocity
    [~, th_max_v_vel_index] = max(vector_vel(ths_move_x:the_move_x, 2)); %Peak Thumb Vector Vel look for the max
    th_max_v_vel_index = th_max_v_vel_index + ths_move_z -1; %find(vector_vel(:, 2) == th_max_v_vel);
    
    % Peak XYZ velocities
    %index finger max velocity (X)
    %if(side>0) %Subject pointing to the right (1)
        if_max_vel = max((velocity(ifs_move_x:ife_move_x,1)));
    %end
    %if(side <0)  %Subject pointing to the left (-1)
        %if_max_vel = min((velocity(ifs_move_x:ife_move_x,2)));
    %end
    if_max_vel_index_x = find((velocity(:,1)) == if_max_vel);
    
    %index finger max velocity (Y)
    if_max_vel = max(velocity(ifs_move_x:ife_move_x,2));
    if_max_vel_index_y = find(velocity(:,2)==if_max_vel);
    
    %thumb max velocity (X)
%     if(side>0) %Subject pointing to the right (1)
         th_max_vel = max((velocity(ths_move_x:the_move_x,4)));
%     end
%     if(side <0) %Subject pointing to the left (-1)
%         th_max_vel = min((velocity(ths_move_x:the_move_x,4)));
%     end
    th_max_vel_index_x = find((velocity(:,4)) == th_max_vel);
    
    %thumb max velocity (Y)
    th_max_vel = max(velocity(ths_move_x:the_move_x,5));
    th_max_vel_index_y = find(velocity(:,5) == th_max_vel);
    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 1); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x,1); %necessary for catching an error
    end
    if(side>0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0)%Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end    
    if_peakAccel_index_x = find(accel(:,1) == peakAccel);
    if(isempty(if_peakAccel_index_x)) 
        if_peakAccel_index_x = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_y:if_max_vel_index_y, 2); %copy index acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_y:ifs_move_y,2);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_y = find(accel(:,2) == peakAccel);
    if(isempty(if_peakAccel_index_y)) 
        if_peakAccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_z:if_max_vel_index_z, 3); %copy index acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_z:ifs_move_z, 3);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_z = find(accel(:,3) == peakAccel);
    if(isempty(if_peakAccel_index_z)) 
        if_peakAccel_index_z = if_max_vel_index_z;
    end
    
    %Peak acceleration thumb  
    temp_array = accel(ths_move_x:th_max_vel_index_x, 4); %copy thumb acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_x:ths_move_x, 4);
    end
    if(side >0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0) %Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end
    th_peakAccel_index_x = find(accel(:,4) == peakAccel);
    if(isempty(th_peakAccel_index_x)) 
        th_peakAccel_index_x = th_max_vel_index_z;
    end
   
    temp_array = accel(ths_move_y:th_max_vel_index_y, 5); %copy thumb acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_y:ths_move_y, 5);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_y = find(accel(:,5) == peakAccel);
    if(isempty(th_peakAccel_index_y)) 
        th_peakAccel_index_y = th_max_vel_index_z;
    end
    
    temp_array = accel(ths_move_z:th_max_vel_index_z, 6); %copy thumb acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_z:ths_move_z, 6);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_z = find(accel(:,6) == peakAccel);
    if(isempty(th_peakAccel_index_z)) 
        th_peakAccel_index_z = th_max_vel_index_z;
    end
        
    %Peak decceleration index
    temp_array = accel(if_max_vel_index_x:ife_move_x,1);
    if(isempty(temp_array))
        temp_array = accel(ife_move_x:if_max_vel_index_x, 1);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subejct pointing to the left (-1)
        peakDeccel = max(temp_array);
    end    
    if_peakDeccel_index_x = find(accel(:,1) == peakDeccel);
    if(isempty(if_peakDeccel_index_x)) 
        if_peakDeccel_index_x = if_max_vel_index_z;
    end

    temp_array = accel(if_max_vel_index_y:ife_move_y, 2); %copy index acceleration in y direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_y:if_max_vel_index_y, 2);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_y = find(accel(:,2) == peakDeccel);
    if(isempty(if_peakDeccel_index_y))
        if_peakDeccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(if_max_vel_index_z:ife_move_z, 3); %copy index acceleration in z direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_z:if_max_vel_index_z, 3);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_z = find(accel(:,3) == peakDeccel);
    if(isempty(if_peakDeccel_index_z)) 
        if_peakDeccel_index_z = if_max_vel_index_z;
    end
    
    %Peak decceleration thumb
    temp_array = accel(th_max_vel_index_x:the_move_x, 4); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_x:th_max_vel_index_x, 4);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subject pointing to the left (-1)
        peakDeccel = max(temp_array);
    end   
    th_peakDeccel_index_x = find(accel(:,4) == peakDeccel);
    if(isempty(th_peakDeccel_index_x))
        th_peakDeccel_index_x = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_y:the_move_y, 5); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_y:th_max_vel_index_y, 5);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_y = find(accel(:,5) == peakAccel);
    if(isempty(th_peakDeccel_index_y))
        th_peakDeccel_index_y = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_z:the_move_z, 6); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_z:th_max_vel_index_z, 6);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_z = find(accel(:,6) == peakAccel);
    if(isempty(th_peakDeccel_index_z))
        th_peakDeccel_index_z = th_peak_vel_index_z;
    end
    
    approach_output = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p];
    approach_phase_end = ife_move_z;
    approach_phase_begin = ifs_move_z;
    
    %%Return Phase
    % Index finger max vector velocity
    [~, if_max_v_vel_index] = max(vector_vel(ife_move_z:end, 1)); %Peak Index Vector Vel look for the max
    if_max_v_vel_index = if_max_v_vel_index + ife_move_z -1;
    
    %Thumb max vector velocity
    [~, th_max_v_vel_index] = max(vector_vel(ife_move_z:end, 2)); %Peak Thumb Vector Vel look for the max
    th_max_v_vel_index = th_max_v_vel_index + ife_move_z -1;
        
    %Index finger velocity peak (z)
    [~, if_min_vel_index_z] = min(velocity(ife_move_z:end,3)); 
    if_min_vel_index_z = if_min_vel_index_z + ife_move_z -1;
    %Thumb velocity peak (z)
    [~, th_min_vel_index_z] = min(velocity(the_move_z:end,6)); 
    th_min_vel_index_z = th_min_vel_index_z + the_move_z -1;

    %Return phase start
    ifs_move_rp = if_min_vel_index_z;
    while(abs(velocity(ifs_move_rp, 3)) > vel_tolerance && ifs_move_rp >ife_move_z)
        ifs_move_rp = ifs_move_rp -1;
    end
    
    ths_move_rp = th_min_vel_index_z;
    while(abs(velocity(ths_move_rp, 6)) > vel_tolerance && ths_move_rp >the_move_z)
        ths_move_rp = ths_move_rp -1;
    end
    
    %Return phase end
    ife_move_rp = if_min_vel_index_z;
    while(abs(velocity(ife_move_rp, 3)) > VelEnd_tolerance && ife_move_rp < max_index)
        ife_move_rp = ife_move_rp +1;
    end

    the_move_rp = th_min_vel_index_z;
    while(abs(velocity(the_move_rp, 6)) > VelEnd_tolerance && the_move_rp < max_index)
        the_move_rp = the_move_rp +1;
    end
    
    [rows, ~] = size (velocity(:,3));
% % % % % % % %     %Begining of object placement
% % % % % % % %     %objp_begin = ifs_move_rp;
% % % % % % % %     objp_begin = if_max_vel_index_z;
% % % % % % % %     while(velocity(objp_begin,3) > 0.1 && objp_begin > 1)
% % % % % % % %         objp_begin = objp_begin -1;
% % % % % % % %     end
% % % % % % % %     
% % % % % % % %     %End of object placement
% % % % % % % % %     objp_end = ifs_move_rp;
% % % % % % % %     objp_end = if_max_vel_index_z
% % % % % % % %     while(velocity(objp_end,3)< 0.02 && objp_end < rows)
% % % % % % % %         objp_end = objp_end +1;
% % % % % % % %     end
    
    %movement start time -time when velocity is less than the given tolerance
    ifs_move_x = ifs_move_rp; %All start and end times based on velocity in z
    ifs_move_y = ifs_move_rp;
    ifs_move_z = ifs_move_rp;
    ths_move_x = ths_move_rp;
    ths_move_y = ths_move_rp;
    ths_move_z = ths_move_rp;
    
    %movement end time - time when velocity lower than given velocity tolerance
    ife_move_x = ife_move_rp;
    ife_move_y = ife_move_rp;
    ife_move_z = ife_move_rp;
    the_move_x = the_move_rp;
    the_move_y = the_move_rp;
    the_move_z = the_move_rp;
    
    % Peak XYZ velocities
    %index finger max velocity (X)
    %if(side>0) %Subject pointing to the right (1)
        [if_max_vel, if_max_vel_index_x] = max(abs(velocity(ifs_move_x:ife_move_x,1)));
        if_max_vel_index_x = if_max_vel_index_x + ifs_move_x -1;
        
    %end
    %if(side <0)  %Subject pointing to the left (-1)
        %if_max_vel = min((velocity(ifs_move_x:ife_move_x,2)));
    %end
    %if_max_vel_index_x = find(abs(velocity(:,1)) == if_max_vel);
    
    %index finger max velocity (Y)
    [if_max_vel, if_max_vel_index_y] = max(abs(velocity(ifs_move_x:ife_move_x,2)));
    if_max_vel_index_y = if_max_vel_index_y + ifs_move_x -1;
    %if_max_vel_index_y = find(velocity(:,2)==if_max_vel);
    
    %index finger max velocity (z)
    if_max_vel_index_z = if_min_vel_index_z;
    
    %thumb max velocity (X)
%     if(side>0) %Subject pointing to the right (1)
%         th_max_vel = max((velocity(ths_move_x:the_move_x,4)));
%     end
%     if(side <0) %Subject pointing to the left (-1)
        [th_max_vel, th_max_vel_index_x] = max(abs(velocity(ths_move_x:the_move_x,4)));
        th_max_vel_index_x = th_max_vel_index_x + ths_move_x -1;
%     end
    %th_max_vel_index_x = find((velocity(:,4)) == th_max_vel);
    
    %thumb max velocity (Y)
    [th_max_vel, th_max_vel_index_y] = max(abs(velocity(ths_move_x:the_move_x,5)));
    th_max_vel_index_y = th_max_vel_index_y + ths_move_x -1;
    
    %thumb max velocity (Z)
    th_max_vel_index_z = th_min_vel_index_z;
    
    % Index Finger 100, 50 msec before and after peak velocity
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index = if_max_vel_index_z - 5;
    if_100p_index = if_max_vel_index_z + 5;
        
        %40 msec before/after
    if_40n_index = if_max_vel_index_z - 2;
    if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
    if_60n_index = if_max_vel_index_z -3;
    if_60p_index = if_max_vel_index_z +3;

        %50 msec before/after (x)
    x = [pos(if_60n_index, 1), pos(if_40n_index, 1)];
    y = [pos(if_60n_index, 2), pos(if_40n_index, 2)];
    z = [pos(if_60n_index, 3), pos(if_40n_index, 3)];

    if_x_50n = interp1(x, 1.5); %Values
    if_y_50n = interp1(y, 1.5);
    if_z_50n = interp1(z, 1.5);

    x = [pos(if_40p_index, 1), pos(if_60p_index, 1)];
    y = [pos(if_40p_index, 2), pos(if_60p_index, 2)];
    z = [pos(if_40p_index, 3), pos(if_60p_index, 3)];

    if_x_50p = interp1(x, 1.5); %Values
    if_y_50p = interp1(y, 1.5);
    if_z_50p = interp1(z, 1.5);
        
    if_x_100n = pos(if_100n_index, 1); %Values
    if_y_100n = pos(if_100n_index, 2);
    if_z_100n = pos(if_100n_index, 3);
        
    if_x_100p = pos(if_100p_index, 1); %Values
    if_y_100p = pos(if_100p_index, 2);
    if_z_100p = pos(if_100p_index, 3);
        
    % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index = th_max_vel_index_z - 5;
    th_100p_index = th_max_vel_index_z + 5;
        
        %40 msec before/after
    th_40n_index = th_max_vel_index_z - 2;
    th_40p_index = th_max_vel_index_z + 2;

        %60 msec before/after
    th_60n_index = th_max_vel_index_z - 3;
    th_60p_index = th_max_vel_index_z + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index, 4), pos(th_40n_index, 4)];
    y = [pos(th_60n_index, 5), pos(th_40n_index, 5)];
    z = [pos(th_60n_index, 6), pos(th_40n_index, 6)];

    th_x_50n = interp1(x, 1.5); %Values
    th_y_50n = interp1(y, 1.5);
    th_z_50n = interp1(z, 1.5);

    x = [pos(th_40p_index, 4), pos(th_60p_index, 4)];
    y = [pos(th_40p_index, 5), pos(th_60p_index, 5)];
    z = [pos(th_40p_index, 6), pos(th_60p_index, 6)];

    th_x_50p = interp1(x, 1.5); %Values
    th_y_50p = interp1(y, 1.5);
    th_z_50p = interp1(z, 1.5);
        
    th_x_100n = pos(th_100n_index, 4); %Values
    th_y_100n = pos(th_100n_index, 5);
    th_z_100n = pos(th_100n_index, 6);
        
    th_x_100p = pos(th_100p_index, 4); %Values
    th_y_100p = pos(th_100p_index, 5);
    th_z_100p = pos(th_100p_index, 6);
    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 1); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x, 1); %necessary for catching an error 
    end
    if(side>0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0)%Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end    
    if_peakAccel_index_x = find(accel(:,1) == peakAccel);
    if(isempty(if_peakAccel_index_x)) 
        if_peakAccel_index_x = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_y:if_max_vel_index_y, 2); %copy index acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_y:ifs_move_y,2);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_y = find(accel(:,2) == peakAccel);
    if(isempty(if_peakAccel_index_y)) 
        if_peakAccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_z:if_max_vel_index_z, 3); %copy index acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_z:ifs_move_z, 3);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_z = find(accel(:,3) == peakAccel);
    if(isempty(if_peakAccel_index_z)) 
        if_peakAccel_index_z = if_max_vel_index_z;
    end
    
    %Peak acceleration thumb  
    temp_array = accel(ths_move_x:th_max_vel_index_x, 4); %copy thumb acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_x:ths_move_x, 4);
    end
    if(side >0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0) %Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end
    th_peakAccel_index_x = find(accel(:,4) == peakAccel);
    if(isempty(th_peakAccel_index_x)) 
        th_peakAccel_index_x = th_max_vel_index_z;
    end
   
    temp_array = accel(ths_move_y:th_max_vel_index_y, 5); %copy thumb acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_y:ths_move_y, 5);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_y = find(accel(:,5) == peakAccel);
    if(isempty(th_peakAccel_index_y)) 
        th_peakAccel_index_y = th_max_vel_index_z;
    end
    
    temp_array = accel(ths_move_z:th_max_vel_index_z, 6); %copy thumb acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_z:ths_move_z, 6);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_z = find(accel(:,6) == peakAccel);
    if(isempty(th_peakAccel_index_z)) 
        th_peakAccel_index_z = th_max_vel_index_z;
    end
        
    %Peak decceleration index
    temp_array = accel(if_max_vel_index_x:ife_move_x,1);
    if(isempty(temp_array))
        temp_array = accel(ife_move_x:if_max_vel_index_x, 1);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subejct pointing to the left (-1)
        peakDeccel = max(temp_array);
    end    
    if_peakDeccel_index_x = find(accel(:,1) == peakDeccel);
    if(isempty(if_peakDeccel_index_x)) 
        if_peakDeccel_index_x = if_max_vel_index_z;
    end

    temp_array = accel(if_max_vel_index_y:ife_move_y, 2); %copy index acceleration in y direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_y:if_max_vel_index_y, 2);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_y = find(accel(:,2) == peakDeccel);
    if(isempty(if_peakDeccel_index_y))
        if_peakDeccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(if_max_vel_index_z:ife_move_z, 3); %copy index acceleration in z direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_z:if_max_vel_index_z, 3);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_z = find(accel(:,3) == peakDeccel);
    if(isempty(if_peakDeccel_index_z)) 
        if_peakDeccel_index_z = if_max_vel_index_z;
    end
    
    %Peak decceleration thumb
    
    temp_array = accel(th_max_vel_index_x:the_move_x, 4); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_x:th_max_vel_index_x, 4);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subject pointing to the left (-1)
        peakDeccel = max(temp_array);
    end   
    th_peakDeccel_index_x = find(accel(:,4) == peakDeccel);
    if(isempty(th_peakDeccel_index_x))
        th_peakDeccel_index_x = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_y:the_move_y, 5); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_y:th_max_vel_index_y, 5);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_y = find(accel(:,5) == peakAccel);
    if(isempty(th_peakDeccel_index_y))
        th_peakDeccel_index_y = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_z:the_move_z, 6); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_z:th_max_vel_index_z, 6);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_z = find(accel(:,6) == peakAccel);
    if(isempty(th_peakDeccel_index_z))
        th_peakDeccel_index_z = th_peak_vel_index_z;
    end
    
    return_output = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p];
    return_phase_begin = ifs_move_z;
    return_phase_end = ife_move_z;
    
    %%Grasping start
    %Grip aperture should be between 4/3 * object diameter and the object
    %diameter (from 'Robust movement segmentation by combining multiple
    %sources of information' by Schot, Benner and Smeets)
    objective_f_ga = zeros(length(pos(:, 1)), 1);
    obj_dia = varargin(1,3);
    for i= 1: length(pos(:, 1))
        if(pos(i, 11) < obj_dia) 
            objective_f_ga(i, 1) = pos(i, 11)/obj_dia;
        end
        if(pos(i, 11) >= obj_dia && pos(i, 11) <= 4/3* obj_dia)
            objective_f_ga(i, 1) = (4*obj_dia - 3*pos(i, 11)) / obj_dia;
        end
        %Else the grip aperture is greater than 4/3*obj_dia
    end
    
    %Debuging
    figure()
    subplot(6,1,1);
    plot(pos(:,7),objective_f_ga(:,1));
    %
    
    objective_f_gav = zeros (length(pos(:,1)),1); %Grip Aperture should be decreasing, therefore grip velocity should be negative (added a buffer of 0.05 m/s)
    for i =1:length (velocity)
        if velocity(i,11) < 0.05
            objective_f_gav(i,1)= 1;
        end
    end
    
    %Debuging
    subplot(6,1,2);
    plot(pos(:,7),objective_f_gav);
    %
    
    objective_f_gaa = zeros(length(pos(:,1)),1); %Grip aperture should be decelerating, not accelerating, therefore postive acceleration (added a buffer of 0.01 m/s^2)
    for i =1:length (accel)
        if accel(i,6) > -0.01
            objective_f_gaa(i,1)= 1;
        end
    end
    
    %Debuging
    subplot(6,1,3);
    plot(pos(:,7),objective_f_gaa);
    %
    
    %speed of wrist low upon movement ending
    max_wrist_velocity = max(velocity(:,3));
    objective_f_ws = zeros(length(pos(:,1)),1);
    %assign more importance to lower wrist speeds
    for( i=1: length(velocity(:,3)))
        objective_f_ws(i,1) = 1-(abs(velocity(i,3))/ max_wrist_velocity);
    end
        
    %Average height of the thumb and index finger must be bigger than 3/4 of the height of the object from the Leap Detector
    objective_f_h = zeros(length(pos(:, 1)), 1);
    obj_height = varargin(1,5) * 3/4;
    for i=1: length(pos(:,1))
        if ((pos (i, 2) + pos(i, 5))/2 > obj_height)
            objective_f_h (i, 1) = 1;
        end
    end
    %Debuging
    subplot(6,1,4);
    plot(pos(:,7), objective_f_ws); 
    subplot(6,1,5);
    plot(pos(:, 7), objective_f_h);
    %
    
    %Sagittal position of the index must be more than half of the azimuthal object
    %distance  from the needle
    objective_f_d = zeros(length(vector_sagpos(:, 1)), 1);
    obj_dist = varargin(1, 4) * 1/2;
    for(i = 1: length(vector_sagpos(:, 1)))
        if(vector_sagpos(i, 1) > obj_dist)
                objective_f_d (i, 1) = 1;
        end
    end

    %Debuging
    subplot(6,1,6);
    plot(pos(:, 7), objective_f_d);
    %

    master_obj_function (:,1) = objective_f_gaa(:,1) .* objective_f_gav(:,1) .* objective_f_ga(:,1) .* objective_f_h(:,1) .* objective_f_ws(:,1) .* objective_f_d;
    %Replace all zeros with Nan
    master_obj_function(master_obj_function == 0) = NaN;
    [~, index] = max(master_obj_function(approach_phase_end:return_phase_begin, 1));
    index = approach_phase_end + index -1;
    
    %Debuging
    figure()
    plot(pos(:, 7), master_obj_function);
    hold on
    plot(pos(index, 7), master_obj_function(index, 1), 'xr');
    %
    
    %Max Grip
    [~, max_g_index] = max(pos(1:index, 11));
    
       
    % Index Finger 100, 50 msec before and after peak grip aperture
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index_g = max_g_index - 5;
    if_100p_index_g = max_g_index + 5;
        
        %40 msec before/after
    if_40n_index_g = max_g_index - 2;
    if_40p_index_g = max_g_index + 2;

        %60 msec before/after
    if_60n_index_g = max_g_index - 3;
    if_60p_index_g = max_g_index + 3;
    
        %50 msec before/after (x)
    x = [pos(if_60n_index_g, 1), pos(if_40n_index_g, 1)];
    y = [pos(if_60n_index_g, 2), pos(if_40n_index_g, 2)];
    z = [pos(if_60n_index_g, 3), pos(if_40n_index_g, 3)];

    if_x_50n_g = interp1(x, 1.5); %Values
    if_y_50n_g = interp1(y, 1.5);
    if_z_50n_g = interp1(z, 1.5);

    x = [pos(if_40p_index_g, 1), pos(if_60p_index_g, 1)];
    y = [pos(if_40p_index_g, 2), pos(if_60p_index_g, 2)];
    z = [pos(if_40p_index_g, 3), pos(if_60p_index_g, 3)];

    if_x_50p_g = interp1(x, 1.5); %Values
    if_y_50p_g = interp1(y, 1.5);
    if_z_50p_g = interp1(z, 1.5);
        
    if_x_100n_g = pos(if_100n_index_g, 1); %Values
    if_y_100n_g = pos(if_100n_index_g, 2);
    if_z_100n_g = pos(if_100n_index_g, 3);
        
    if_x_100p_g = pos(if_100p_index_g, 1); %Values
    if_y_100p_g = pos(if_100p_index_g, 2);
    if_z_100p_g = pos(if_100p_index_g, 3);
        
        % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index_g = max_g_index - 5;
    th_100p_index_g = max_g_index + 5;
        
        %40 msec before/after
    th_40n_index_g = max_g_index - 2;
    th_40p_index_g = max_g_index + 2;

        %60 msec before/after
    th_60n_index_g = max_g_index - 3;
    th_60p_index_g = max_g_index + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index_g, 4), pos(th_40n_index_g, 4)];
    y = [pos(th_60n_index_g, 5), pos(th_40n_index_g, 5)];
    z = [pos(th_60n_index_g, 6), pos(th_40n_index_g, 6)];

    th_x_50n_g = interp1(x, 1.5); %Values
    th_y_50n_g = interp1(y, 1.5);
    th_z_50n_g = interp1(z, 1.5);

    x = [pos(th_40p_index_g, 4), pos(th_60p_index_g, 4)];
    y = [pos(th_40p_index_g, 5), pos(th_60p_index_g, 5)];
    z = [pos(th_40p_index_g, 6), pos(th_60p_index_g, 6)];

    th_x_50p_g = interp1(x, 1.5); %Values
    th_y_50p_g = interp1(y, 1.5);
    th_z_50p_g = interp1(z, 1.5);
        
    th_x_100n_g= pos(th_100n_index_g, 4); %Values
    th_y_100n_g = pos(th_100n_index_g, 5);
    th_z_100n_g = pos(th_100n_index_g, 6);
        
    th_x_100p_g = pos(th_100p_index_g, 4); %Values
    th_y_100p_g = pos(th_100p_index_g, 5);
    th_z_100p_g = pos(th_100p_index_g, 6);
    
    
    max_grip_positions = [if_x_50n_g if_y_50n_g if_z_50n_g if_x_50p_g if_y_50p_g if_z_50p_g if_x_100n_g if_y_100n_g if_z_100n_g if_x_100p_g if_y_100p_g if_z_100p_g th_x_50n_g th_y_50n_g th_z_50n_g th_x_50p_g th_y_50p_g th_z_50p_g th_x_100n_g th_y_100n_g th_z_100n_g th_x_100p_g th_y_100p_g th_z_100p_g max_g_index];

    %Placement start
    placement_start = index;
    while(velocity(placement_start, 2) > -0.1) %Using velocity in y direction
        placement_start = placement_start+ 1;
    end
    %Placement end
    %placement_end = ifs_move_z;
    placement_end = placement_start;
    %while(vector_vel(placement_end, 1) < 0.02)
    while(velocity(placement_end, 2) > -0.01)
        placement_end = placement_end + 1;
    end
    final_output = [approach_output return_output index placement_start placement_end max_grip_positions];
    
    varargout = num2cell(final_output, [1 2]);
end

if(type ==0 && system == 2) %Optotrak pointing th_vector_vel_tol is the vel tolerance of the palm, not the thumb
    varargin=(cell2mat(varargin)); 
    if(marker == 1 || marker == 2) %index kin vars
         %Index finger max vector velocity
        if_max_v_vel_index = max(vector_vel(:,2)); %Peak Index Vector Vel
        if_max_v_vel_index = find(vector_vel(:,2) == if_max_v_vel_index);
        
        if(varargin(1, 1) ~=0)
            [~, if_max_vel_index_z] = max(velocity(varargin(1, 1): varargin(1, 2), 4));
            if_max_vel_index_z = if_max_vel_index_z + varargin(1, 1) -1;
        else
             %index finger max velocity (Z)
            [~, indices] = findpeaks(velocity(:,4),'MinPeakHeight',if_vector_vel_tol);
            try
                if_max_vel_index_z = indices(1,1);
            catch
                if_max_vel_index_z = if_max_v_vel_index;
            end
        end
        
        %Assuming collection frequency of 50 Hz
        %Index finger position 100 msec before/after
        if_100n_index = if_max_vel_index_z - 5;
        if_100p_index = if_max_vel_index_z + 5;
        
        %40 msec before/after
        if_40n_index = if_max_vel_index_z - 2;
        if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
        if_60n_index = if_max_vel_index_z -3;
        if_60p_index = if_max_vel_index_z +3;

        %50 msec before/after (x)
        x = [pos(if_60n_index,2), pos(if_40n_index,2)];
        y = [pos(if_60n_index,3), pos(if_40n_index,3)];
        z = [pos(if_60n_index,4), pos(if_40n_index,4)];

        if_x_50n = interp1(x,1.5); %Values
        if_y_50n = interp1(y,1.5);
        if_z_50n = interp1(z,1.5);

        x = [pos(if_40p_index,2), pos(if_60p_index,2)];
        y = [pos(if_40p_index,3),pos(if_60p_index,3)];
        z = [pos(if_40p_index,4),pos(if_60p_index,4)];

        if_x_50p = interp1(x,1.5); %Values
        if_y_50p = interp1(y,1.5);
        if_z_50p = interp1(z,1.5);
        
        if_x_100n = pos(if_100n_index,2); %Values
        if_y_100n = pos(if_100n_index,3);
        if_z_100n = pos(if_100n_index,4);
        
        if_x_100p = pos(if_100p_index,2); %Values
        if_y_100p = pos(if_100p_index,3);
        if_z_100p = pos(if_100p_index,4);
        
        %movement start time -time when velocity is less than the given tolerance
        ifs_move_z = if_max_vel_index_z;
        while (velocity(ifs_move_z,4)>vel_tolerance && ifs_move_z >0)      %Movement Start for outgoing arc (z) index
            ifs_move_z = ifs_move_z-1;
        end
        
        ifs_move_x = ifs_move_z;
        ifs_move_y = ifs_move_z;
        
        %movement end time - time when velocity lower than given velocity
        %tolerance
        size_ = size(velocity());
        max_index = size_(1,1);

        ife_move_z = if_max_vel_index_z;
        while (velocity(ife_move_z,4)>VelEnd_tolerance && ife_move_z <max_index)      %Movement End for outgoing arc (z) index
            ife_move_z = ife_move_z+1;
        end
        
        ife_move_x = ife_move_z;
        ife_move_y = ife_move_z;
        
        % Peak XYZ velocities
        %index finger max velocity (X)
        if(side>0) %Subject pointing to the right (1)
            if_max_vel = max((velocity(ifs_move_x:ife_move_x,2)));
        end
        if(side <0) %Subject pointing to the left (-1)
            if_max_vel = min((velocity(ifs_move_x:ife_move_x,2)));
        end
        if_max_vel_index_x = find((velocity(:,2)) == if_max_vel);


        %index finger max velocity (Y)
        if_max_vel = max(velocity(ifs_move_y:ife_move_y,3));
        if_max_vel_index_y = find(velocity(:,3)==if_max_vel);
        
        %Some Optotrak trials are not collected properly, so the movement
        %end occurs as the last data point of velocity (which is out of
        %bounds for the acceleration matrix)
        if(length(accel) < ife_move_x)
            ife_move_x = length(accel);
            ife_move_y = length(accel);
            ife_move_z = length(accel);
        end
        
        %Peak acceleration index
        temp_array = accel(ifs_move_x:if_max_vel_index_x, 2); %copy index acceleration in x direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_x:ifs_move_x,2);
        end
        if(side >0) %Subject pointing to the right (1)
            peakAccel = max(temp_array);
        else %if(side<0) %Subject pointing to the left (-1)
            peakAccel = min(temp_array);
        end    
        if_peakAccel_index_x = find(accel(:,2) == peakAccel);
        if(isempty(if_peakAccel_index_x)) 
            if_peakAccel_index_x = if_max_vel_index_z;
        end

        temp_array = accel(ifs_move_y:if_max_vel_index_y, 3); %copy index acceleration in y direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_y:ifs_move_y,3);
        end
        peakAccel = max(temp_array);
        if_peakAccel_index_y = find(accel(:,3) == peakAccel);
        if(isempty(if_peakAccel_index_y)) 
            if_peakAccel_index_y = if_max_vel_index_z;
        end

        temp_array = accel(ifs_move_z:if_max_vel_index_z, 4); %copy index acceleration in z direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(if_max_vel_index_z:ifs_move_z, 4);
        end
        peakAccel = max(temp_array);
        if_peakAccel_index_z = find(accel(:,4) == peakAccel);
        if(isempty(if_peakAccel_index_z)) 
            if_peakAccel_index_z = if_max_vel_index_z;
        end
    
         %Peak decceleration index
        temp_array = accel(if_max_vel_index_x:ife_move_x, 2); %copy index acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ife_move_x:if_max_vel_index_x, 2);
        end
        if(side >0) %Subject pointing to the right (1)
            peakDeccel = min(temp_array);
        else %if(side<0) %Subject pointing to the left (-1)
            peakDeccel = max(temp_array);
        end    
        if_peakDeccel_index_x = find(accel(:,2) == peakDeccel);
        if(isempty(if_peakDeccel_index_x)) 
            if_peakDeccel_index_x = if_max_vel_index_z;
        end

        temp_array = accel(if_max_vel_index_y:ife_move_y, 3); %copy index acceleration in y direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ife_move_y:if_max_vel_index_y, 3);
        end
        peakDeccel = min(temp_array);
        if_peakDeccel_index_y = find(accel(:,3) == peakDeccel);

        temp_array = accel(if_max_vel_index_z:ife_move_z, 4); %copy index acceleration in z direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ife_move_z:if_max_vel_index_z, 4);
        end
        peakDeccel = min(temp_array);
        if_peakDeccel_index_z = find(accel(:,4) == peakDeccel);
        
    end
   
    if(marker == 1 || marker == 3) %palm kin vars
        %Palm max vector velocity
        pl_max_v_vel_index = max(vector_vel(:,3));
        pl_max_v_vel_index = find(vector_vel(:,3) == pl_max_v_vel_index);
        
        if(varargin(1, 1) ~= 0)
            %Palm max Velocity (z)
            [~, pl_max_vel_index_z] = max(velocity(varargin(1, 1):varargin(1, 2), 7));
            pl_max_vel_index_z = pl_max_vel_index_z + varargin(1, 1) -1;
            
        else
            %Palm max velocity (Z)
            [~, indices] = findpeaks(velocity(:,7),'MinPeakHeight',th_vector_vel_tol);
            try
                pl_max_vel_index_z= indices (1,1);
            catch
                pl_max_vel_index_z = pl_max_v_vel_index;
            end
        end
        
        % % Assuming collection frequency of 50 Hz
        % Palm 100, 50 msec before and after
        %100 msec before/after
        pl_100n_index = pl_max_vel_index_z - 5;
        pl_100p_index = pl_max_vel_index_z + 5;
        
        %40 msec before/after
        pl_40n_index = pl_max_vel_index_z - 2;
        pl_40p_index = pl_max_vel_index_z + 2;

        %60 msec before/after
        pl_60n_index = pl_max_vel_index_z -3;
        pl_60p_index = pl_max_vel_index_z +3;

        %50 msec before/after (x)
        x = [pos(pl_60n_index,5), pos(pl_40n_index,5)];
        y = [pos(pl_60n_index,6), pos(pl_40n_index,6)];
        z = [pos(pl_60n_index,7), pos(pl_40n_index,7)];

        pl_x_50n = interp1(x,1.5); %Values
        pl_y_50n = interp1(y,1.5);
        pl_z_50n = interp1(z,1.5);

        x = [pos(pl_40p_index,5), pos(pl_60p_index,5)];
        y = [pos(pl_40p_index,6), pos(pl_60p_index,6)];
        z = [pos(pl_40p_index,7), pos(pl_60p_index,7)];

        pl_x_50p = interp1(x,1.5); %Values
        pl_y_50p = interp1(y,1.5);
        pl_z_50p = interp1(z,1.5);
        
        pl_x_100n = pos(pl_100n_index,5); %Values
        pl_y_100n = pos(pl_100n_index,6);
        pl_z_100n = pos(pl_100n_index,7);
        
        pl_x_100p = pos(pl_100p_index,5); %Values
        pl_y_100p = pos(pl_100p_index,6);
        pl_z_100p = pos(pl_100p_index,7);
        
%         pls_move_x = pl_max_vel_index_z;
%         while (abs(velocity(pls_move_x,5))>vel_tolerance && pls_move_x>0)      %Movement Start for outgoing arc (x) palm
%             pls_move_x = pls_move_x-1;
%         end
% 
%         pls_move_y = pl_max_vel_index_z;
%         while (velocity(pls_move_y,6)>vel_tolerance && pls_move_y >0)     %Movement Start for outgoing arc (y) palm
%             pls_move_y = pls_move_y-1;
%         end

        pls_move_z = pl_max_vel_index_z;
        while (velocity(pls_move_z,7)>vel_tolerance && pls_move_z >0)      %Movement Start for outgoing arc (z) palm
            pls_move_z = pls_move_z-1;
        end
        
        pls_move_x = pls_move_z;
        pls_move_y = pls_move_z;
        
        %movement end time - time when velocity lower than given velocity
        %tolerance
        size_ = size(velocity());
        max_index = size_(1,1);
        
%         ple_move_x = pl_max_vel_index_z;
%         while (velocity(ple_move_x,5)>VelEnd_tolerance && ple_move_x<max_index)      %Movement End for outgoing arc (x) palm
%             ple_move_x = ple_move_x+1;
%         end
% 
%         ple_move_y = pl_max_vel_index_z;
%         while (velocity(ple_move_y,6)>VelEnd_tolerance && ple_move_y <max_index)     %Movement End for outgoing arc (y) thumb
%             ple_move_y = ple_move_y+1;
%         end

        ple_move_z = pl_max_vel_index_z;
        while (velocity(ple_move_z,7)>VelEnd_tolerance && ple_move_z<max_index)      %Movement End for outgoing arc (z) thumb
            ple_move_z = ple_move_z+1;
        end
        
        ple_move_x = ple_move_z;
        ple_move_y = ple_move_z;
        
        %palm max velocity (X)
        if(side>0) %Sbject pointing to the right (1)
            pl_max_vel = max((velocity(pls_move_x:ple_move_x,5)));
        end
        if(side <0) %Subject pointing to the left (-1)
            pl_max_vel = min((velocity(pls_move_x:ple_move_x,5)));
        end
        pl_max_vel_index_x = find((velocity(:,5)) == pl_max_vel);

        %palm max velocity (Y)
        pl_max_vel = max(velocity(pls_move_y:ple_move_y,6));
        pl_max_vel_index_y = find(velocity(:,6) == pl_max_vel);
        
        %Peak acceleration palm  
        temp_array = accel(pls_move_x:pl_max_vel_index_x, 5); %copy thumb acceleration in x direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(pl_max_vel_index_x:pls_move_x, 5);
        end
        if(side >0) %Subject pointing to the right (1)
            peakAccel = max(temp_array);
        else %if(side<0) %Subejct pointing to the left (-1)
         peakAccel = min(temp_array);
        end
        pl_peakAccel_index_x = find(accel(:,5) == peakAccel);
        if(isempty(pl_peakAccel_index_x)) 
            pl_peakAccel_index_x = pl_max_vel_index_z;
        end

        temp_array = accel(pls_move_y:pl_max_vel_index_y, 6); %copy palm acceleration in y direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(pl_max_vel_index_y:pls_move_y, 6);
        end
        peakAccel = max(temp_array);
        pl_peakAccel_index_y = find(accel(:,6) == peakAccel);
        if(isempty(pl_peakAccel_index_y)) 
            pl_peakAccel_index_y = pl_max_vel_index_z;
        end

        temp_array = accel(pls_move_z:pl_max_vel_index_z, 7); %copy thumb acceleration in z direction from movement start to peak velocity
        if(isempty(temp_array))
            temp_array = accel(pl_max_vel_index_z:pls_move_z, 7);
        end
        peakAccel = max(temp_array);
        pl_peakAccel_index_z = find(accel(:,7) == peakAccel);
        if(isempty(pl_peakAccel_index_z)) 
            pl_peakAccel_index_z = pl_max_vel_index_z;
        end    
    
        %Peak decceleration palm
        temp_array = accel(pl_max_vel_index_x:ple_move_x, 5); %copy thumb acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ple_move_x:pl_max_vel_index_x, 5);
        end
        peakDeccel = min(temp_array);
        if(side<0)
%          temp = accel(pl_max_vel_index_x:ple_move_x, 5);
%              if(isempty(temp))
%                 temp = accel(ple_move_x:pl_max_vel_index_x, 5);
%              end
            peakDeccel = max(temp_array);
        end   
        pl_peakDeccel_index_x = find(accel(:,5) == peakDeccel);

        temp_array = accel(pl_max_vel_index_y:ple_move_y, 6); %copy palm acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ple_move_y:pl_max_vel_index_y, 6);
        end
        peakAccel = min(temp_array);
        pl_peakDeccel_index_y = find(accel(:,6) == peakAccel);

        temp_array = accel(pl_max_vel_index_z:ple_move_z, 7); %copy thumb acceleration in x direction from peak velocity to movement end
        if(isempty(temp_array))
            temp_array = accel(ple_move_z:pl_max_vel_index_z, 7);
        end
        peakAccel = min(temp_array);
        pl_peakDeccel_index_z = find(accel(:,7) == peakAccel);
        
    end
   
    if(marker == 1)
        output_array = [ifs_move_x ifs_move_y ifs_move_z pls_move_x pls_move_y pls_move_z ife_move_x ife_move_y ife_move_z ple_move_x ple_move_y ple_move_z if_max_vel_index_x if_max_vel_index_y if_max_vel_index_z pl_max_vel_index_x pl_max_vel_index_y pl_max_vel_index_z if_peakAccel_index_x if_peakAccel_index_y if_peakAccel_index_z pl_peakAccel_index_x pl_peakAccel_index_y pl_peakAccel_index_z if_peakDeccel_index_x if_peakDeccel_index_y if_peakDeccel_index_z pl_peakDeccel_index_x pl_peakDeccel_index_y pl_peakDeccel_index_z if_max_v_vel_index pl_max_v_vel_index if_x_50n if_y_50n if_z_50n if_x_50p if_y_50p if_z_50p if_x_100n if_y_100n if_z_100n if_x_100p if_y_100p if_z_100p pl_x_50n pl_y_50n pl_z_50n pl_x_50p pl_y_50p pl_z_50p pl_x_100n pl_y_100n pl_z_100n pl_x_100p pl_y_100p pl_z_100p]; 
    end
    if(marker == 2) %index only
        output_array = [ifs_move_x ifs_move_y ifs_move_z 1 1 1 ife_move_x ife_move_y ife_move_z 1 1 1 if_max_vel_index_x if_max_vel_index_y if_max_vel_index_z 1 1 1 if_peakAccel_index_x if_peakAccel_index_y if_peakAccel_index_z 1 1 1 if_peakDeccel_index_x if_peakDeccel_index_y if_peakDeccel_index_z 1 1 1 if_max_v_vel_index 1 if_x_50n if_y_50n if_z_50n if_x_50p if_y_50p if_z_50p if_x_100n if_y_100n if_z_100n if_x_100p if_y_100p if_z_100p 1 1 1 1 1 1 1 1 1 1 1 1];   
    end
    if(marker == 3) %Palm only
        output_array = [1 1 1 pls_move_x pls_move_y pls_move_z 1 1 1 ple_move_x ple_move_y ple_move_z 1 1 1 pl_max_vel_index_x pl_max_vel_index_y pl_max_vel_index_z 1 1 1 pl_peakAccel_index_x pl_peakAccel_index_y pl_peakAccel_index_z 1 1 1 pl_peakDeccel_index_x pl_peakDeccel_index_y pl_peakDeccel_index_z 1 pl_max_v_vel_index 1 1 1 1 1 1 1 1 1 1 1 1 pl_x_50n pl_y_50n pl_z_50n pl_x_50p pl_y_50p pl_z_50p pl_x_100n pl_y_100n pl_z_100n pl_x_100p pl_y_100p pl_z_100p]; 
    end
    varargout = num2cell( output_array, [1 2]);
end

if(type == 1 && system ==2) %Optotrak grasping
    varargin=(cell2mat(varargin)); 
    
    %%%Target approach phase 
    %index finger max velocity (Z)
    [~, indices] = findpeaks(velocity(:, 4), 'MinPeakHeight', if_vector_vel_tol);
    if_max_vel_index_z= indices (1, 1);

    %thumb max velocity (Z)
    [~, indices] = findpeaks(velocity(:,7), 'MinPeakHeight', th_vector_vel_tol);
    th_max_vel_index_z = indices (1,1);

    % Index Finger 100, 50 msec before and after peak velocity
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index = if_max_vel_index_z - 5;
    if_100p_index = if_max_vel_index_z + 5;
        
        %40 msec before/after
    if_40n_index = if_max_vel_index_z - 2;
    if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
    if_60n_index = if_max_vel_index_z -3;
    if_60p_index = if_max_vel_index_z +3;

        %50 msec before/after (x)
    x = [pos(if_60n_index,2), pos(if_40n_index,2)];
    y = [pos(if_60n_index,3), pos(if_40n_index,3)];
    z = [pos(if_60n_index,4), pos(if_40n_index,4)];

    if_x_50n = interp1(x, 1.5); %Values
    if_y_50n = interp1(y, 1.5);
    if_z_50n = interp1(z, 1.5);

    x = [pos(if_40p_index,2), pos(if_60p_index,2)];
    y = [pos(if_40p_index,3), pos(if_60p_index,3)];
    z = [pos(if_40p_index,4), pos(if_60p_index,4)];

    if_x_50p = interp1(x, 1.5); %Values
    if_y_50p = interp1(y, 1.5);
    if_z_50p = interp1(z, 1.5);
        
    if_x_100n = pos(if_100n_index, 2); %Values
    if_y_100n = pos(if_100n_index, 3);
    if_z_100n = pos(if_100n_index, 4);
        
    if_x_100p = pos(if_100p_index, 2); %Values
    if_y_100p = pos(if_100p_index, 3);
    if_z_100p = pos(if_100p_index, 4);
        
        % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index = th_max_vel_index_z - 5;
    th_100p_index = th_max_vel_index_z + 5;
        
        %40 msec before/after
    th_40n_index = th_max_vel_index_z - 2;
    th_40p_index = th_max_vel_index_z + 2;

        %60 msec before/after
    th_60n_index = th_max_vel_index_z - 3;
    th_60p_index = th_max_vel_index_z + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index, 5), pos(th_40n_index, 5)];
    y = [pos(th_60n_index, 6), pos(th_40n_index, 6)];
    z = [pos(th_60n_index, 7), pos(th_40n_index, 7)];

    th_x_50n = interp1(x, 1.5); %Values
    th_y_50n = interp1(y, 1.5);
    th_z_50n = interp1(z, 1.5);

    x = [pos(th_40p_index, 5), pos(th_60p_index, 5)];
    y = [pos(th_40p_index, 6), pos(th_60p_index, 6)];
    z = [pos(th_40p_index, 7), pos(th_60p_index, 7)];

    th_x_50p = interp1(x, 1.5); %Values
    th_y_50p = interp1(y, 1.5);
    th_z_50p = interp1(z, 1.5);
        
    th_x_100n = pos(th_100n_index, 5); %Values
    th_y_100n = pos(th_100n_index, 6);
    th_z_100n = pos(th_100n_index, 7);
        
    th_x_100p = pos(th_100p_index, 5); %Values
    th_y_100p = pos(th_100p_index, 6);
    th_z_100p = pos(th_100p_index, 7);
    
    %movement start time -time when velocity is less than the given tolerance
    ifs_move_x = if_max_vel_index_z;
    while (abs(velocity(ifs_move_x, 2)) > vel_tolerance && ifs_move_x > 0)      %Movement Start for outgoing arc (x) index
        ifs_move_x = ifs_move_x - 1;
    end
    
    ifs_move_y = if_max_vel_index_z;
    while (velocity(ifs_move_y, 3) > vel_tolerance && ifs_move_y > 0)       %Movement Start for outgoing arc (y) index
        ifs_move_y = ifs_move_y - 1;
    end
    
    ifs_move_z = if_max_vel_index_z;
    while (velocity(ifs_move_z, 4) > vel_tolerance && ifs_move_z > 0)       %Movement Start for outgoing arc (z) index
        ifs_move_z = ifs_move_z - 1;
    end
    
    ths_move_x = th_max_vel_index_z;
    while (abs(velocity(ths_move_x, 5)) >vel_tolerance && ths_move_x>0)      %Movement Start for outgoing arc (x) thumb
        ths_move_x = ths_move_x-1;
    end
    
   	ths_move_y = th_max_vel_index_z;
    while (velocity(ths_move_y, 6)>vel_tolerance && ths_move_y >0)     %Movement Start for outgoing arc (y) thumb
        ths_move_y = ths_move_y-1;
    end
    
    ths_move_z = th_max_vel_index_z;
    while (velocity(ths_move_z, 7)>vel_tolerance && ths_move_z >0)      %Movement Start for outgoing arc (z) thumb
        ths_move_z = ths_move_z-1;
    end
    ifs_move_x = ifs_move_z; %All start and end times based on velocity in z
    ifs_move_y = ifs_move_z;
    ths_move_x = ths_move_z;
    ths_move_y = ths_move_z;
    
    %movement end time - time when velocity lower than given velocity
    %tolerance
    size_ = size(velocity());
    max_index = size_(1,1);
    
    ife_move_x = if_max_vel_index_z;
    while (velocity(ife_move_x, 2)>VelEnd_tolerance && ife_move_x<max_index)      %Movement End for outgoing arc (x) index
        ife_move_x = ife_move_x+1;
    end
    
    ife_move_y = if_max_vel_index_z;
    while (velocity(ife_move_y, 3)>VelEnd_tolerance && ife_move_y <max_index)     %Movement End for outgoing arc (y) index
        ife_move_y = ife_move_y+1;
    end
    
    ife_move_z = if_max_vel_index_z;
    while (velocity(ife_move_z, 4)>VelEnd_tolerance && ife_move_z <max_index)      %Movement End for outgoing arc (z) index
        ife_move_z = ife_move_z+1;
    end
    
    the_move_x = th_max_vel_index_z;
    while (velocity(the_move_x, 5)>VelEnd_tolerance && the_move_x<max_index)      %Movement End for outgoing arc (x) thumb
        the_move_x = the_move_x+1;
    end
    
   	the_move_y = th_max_vel_index_z;
    while (velocity(the_move_y, 6)>VelEnd_tolerance && the_move_y <max_index)     %Movement End for outgoing arc (y) thumb
        the_move_y = the_move_y+1;
    end
    
    the_move_z = th_max_vel_index_z;
    while (velocity(the_move_z, 7)>VelEnd_tolerance && the_move_z<max_index)      %Movement End for outgoing arc (z) thumb
        the_move_z = the_move_z+1;
    end
    ife_move_x = ife_move_z; %All end times are based on velocity in z
    ife_move_y = ife_move_z;
    the_move_x = the_move_z;
    the_move_y = the_move_z;
    
    % Index finger max vector velocity
    [~, if_max_v_vel_index] = max(vector_vel(ifs_move_x:ife_move_x, 2)); %Peak Index Vector Vel look for the max
    if_max_v_vel_index = if_max_v_vel_index + ifs_move_x -1;
    %Thumb max vector velocity
    [~, th_max_v_vel_index] = max(vector_vel(ths_move_x:the_move_x,3)); %Peak Thumb Vector Vel look for the max
    th_max_v_vel_index = th_max_v_vel_index + ths_move_x -1;
    
    % Peak XYZ velocities
    %index finger max velocity (X)
    %if(side>0) %Subject pointing to the right (1)
        [~, if_max_vel_index_x] = max((velocity(ifs_move_x:ife_move_x, 2)));
    %end
    %if(side <0)  %Subject pointing to the left (-1)
        %if_max_vel = min((velocity(ifs_move_x:ife_move_x,2)));
    %end
    if_max_vel_index_x = if_max_vel_index_x + ifs_move_x -1;
    
    
    %index finger max velocity (Y)
    [~, if_max_vel_index_y] = max(velocity(ifs_move_x:ife_move_x, 3));
    if_max_vel_index_y = if_max_vel_index_y + ifs_move_x -1;
    
        
    %thumb max velocity (X)
%     if(side>0) %Subject pointing to the right (1)
         [~, th_max_vel_index_x] = max((velocity(ths_move_x:the_move_x, 5)));
%     end
%     if(side <0) %Subject pointing to the left (-1)
%         th_max_vel = min((velocity(ths_move_x:the_move_x,4)));
%     end
    th_max_vel_index_x = th_max_vel_index_x + ths_move_x -1;
    
    %thumb max velocity (Y)
    [~, th_max_vel_index_y] = max(velocity(ths_move_x:the_move_x,6));
    %th_max_vel_index_y = find(velocity(:,6) == th_max_vel);
    th_max_vel_index_y = th_max_vel_index_y + ths_move_x -1;

    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 2); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x,2); %necessary for catching an error
    end
    if(side>0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0)%Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end    
    if_peakAccel_index_x = find(accel(:,2) == peakAccel);
    if(isempty(if_peakAccel_index_x)) 
        if_peakAccel_index_x = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_y:if_max_vel_index_y, 3); %copy index acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_y:ifs_move_y, 3);
    end
    [~, if_peakAccel_index_y] = max(temp_array);
    if_peakAccel_index_y = if_peakAccel_index_y + ifs_move_y -1;
    if(isempty(if_peakAccel_index_y)) 
        if_peakAccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_z:if_max_vel_index_z, 4); %copy index acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_z:ifs_move_z, 4);
    end
    [~, if_peakAccel_index_z] = max(temp_array);
    if_peakAccel_index_z = if_peakAccel_index_z + ifs_move_z -1;
    if(isempty(if_peakAccel_index_z)) 
        if_peakAccel_index_z = if_max_vel_index_z;
    end
    
    %Peak acceleration thumb  
    temp_array = accel(ths_move_x:th_max_vel_index_x, 5); %copy thumb acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_x:ths_move_x, 5);
    end
    if(side >0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0) %Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end
    th_peakAccel_index_x = find(accel(:, 5) == peakAccel);
    if(isempty(th_peakAccel_index_x)) 
        th_peakAccel_index_x = th_max_vel_index_z;
    end
   
    temp_array = accel(ths_move_y:th_max_vel_index_y, 6); %copy thumb acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_y:ths_move_y, 6);
    end
    [~, th_peakAccel_index_y] = max(temp_array);
    th_peakAccel_index_y = th_peakAccel_index_y + ths_move_y -1;
    if(isempty(th_peakAccel_index_y)) 
        th_peakAccel_index_y = th_max_vel_index_z;
    end
    
    temp_array = accel(ths_move_z:th_max_vel_index_z, 7); %copy thumb acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_z:ths_move_z, 7);
    end
    [~, th_peakAccel_index_z] = max(temp_array);
    th_peakAccel_index_z = th_peakAccel_index_z + ths_move_z -1;
    if(isempty(th_peakAccel_index_z)) 
        th_peakAccel_index_z = th_max_vel_index_z;
    end
        
    %Peak decceleration index
    temp_array = accel(if_max_vel_index_x:ife_move_x, 2);
    if(isempty(temp_array))
        temp_array = accel(ife_move_x:if_max_vel_index_x, 2);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subject pointing to the left (-1)
        peakDeccel = max(temp_array);
    end    
    if_peakDeccel_index_x = find(accel(:, 2) == peakDeccel);
    if(isempty(if_peakDeccel_index_x)) 
        if_peakDeccel_index_x = if_max_vel_index_z;
    end

    temp_array = accel(if_max_vel_index_y:ife_move_y,  3); %copy index acceleration in y direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_y:if_max_vel_index_y,  3);
    end
    [~, if_peakDeccel_index_y] = min(temp_array);
    if_peakDeccel_index_y = if_max_vel_index_y + if_peakDeccel_index_y -1;
    if(isempty(if_peakDeccel_index_y))
        if_peakDeccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(if_max_vel_index_z:ife_move_z, 4); %copy index acceleration in z direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_z:if_max_vel_index_z, 4);
    end
    [~, if_peakDeccel_index_z] = min(temp_array);
    if_peakDeccel_index_z = if_max_vel_index_z + if_peakDeccel_index_z -1;
    if(isempty(if_peakDeccel_index_z)) 
        if_peakDeccel_index_z = if_max_vel_index_z;
    end
    
    %Peak decceleration thumb
    temp_array = accel(th_max_vel_index_x:the_move_x, 5); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_x:th_max_vel_index_x, 5);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subject pointing to the left (-1)
        peakDeccel = max(temp_array);
    end   
    th_peakDeccel_index_x = find(accel(:, 5) == peakDeccel);
    if(isempty(th_peakDeccel_index_x))
        th_peakDeccel_index_x = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_y:the_move_y, 6); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_y:th_max_vel_index_y, 6);
    end
    [~, th_peakDeccel_index_y] = min(temp_array);
    th_peakDeccel_index_y = th_max_vel_index_y + th_peakDeccel_index_y -1;
    if(isempty(th_peakDeccel_index_y))
        th_peakDeccel_index_y = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_z:the_move_z, 7); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_z:th_max_vel_index_z, 7);
    end
    [~, th_peakDeccel_index_z] = min(temp_array);
    th_peakDeccel_index_z = th_max_vel_index_z + th_peakDeccel_index_z -1;
    if(isempty(th_peakDeccel_index_z))
        th_peakDeccel_index_z = th_peak_vel_index_z;
    end
    
    approach_output = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p];
    approach_phase_end = ife_move_z;
    approach_phase_begin = ifs_move_z;
    %%Return Phase
    
    % Index finger max vector velocity
    [~, if_max_v_vel_index] = max(vector_vel(ife_move_z:end, 2)); %Peak Index Vector Vel look for the max
    if_max_v_vel_index = if_max_v_vel_index + ife_move_z -1;
    
    %Thumb max vector velocity
    [~, th_max_v_vel_index] = max(vector_vel(ife_move_z:end, 3)); %Peak Thumb Vector Vel look for the max
    th_max_v_vel_index = th_max_v_vel_index + ife_move_z -1;
        
    %Index finger velocity peak (z)
    [~, if_min_vel_index_z] = min(velocity(ife_move_z:end,4)); 
    if_min_vel_index_z = if_min_vel_index_z + ife_move_z -1;
    %Thumb velocity peak (z)
    [~, th_min_vel_index_z] = min(velocity(the_move_z:end,7)); 
    th_min_vel_index_z = th_min_vel_index_z + the_move_z -1;

    %Return phase start
    ifs_move_rp = if_min_vel_index_z;
    while(abs(velocity(ifs_move_rp, 4)) > vel_tolerance && ifs_move_rp >ife_move_z)
        ifs_move_rp = ifs_move_rp -1;
    end
    
    ths_move_rp = th_min_vel_index_z;
    while(abs(velocity(ths_move_rp, 7)) > vel_tolerance && ths_move_rp >the_move_z)
        ths_move_rp = ths_move_rp -1;
    end
    
    %Return phase end
    ife_move_rp = if_min_vel_index_z;
    while(abs(velocity(ife_move_rp, 4)) > VelEnd_tolerance && ife_move_rp < max_index)
        ife_move_rp = ife_move_rp +1;
    end

    the_move_rp = th_min_vel_index_z;
    while(abs(velocity(the_move_rp, 7)) > VelEnd_tolerance && the_move_rp < max_index)
        the_move_rp = the_move_rp +1;
    end
    
    [rows, ~] = size (velocity(:,3));
    
    %movement start time -time when velocity is less than the given tolerance
    ifs_move_x = ifs_move_rp; %All start and end times based on velocity in z
    ifs_move_y = ifs_move_rp;
    ifs_move_z = ifs_move_rp;
    ths_move_x = ths_move_rp;
    ths_move_y = ths_move_rp;
    ths_move_z = ths_move_rp;
    
    %movement end time - time when velocity lower than given velocity tolerance
    ife_move_x = ife_move_rp;
    ife_move_y = ife_move_rp;
    ife_move_z = ife_move_rp;
    the_move_x = the_move_rp;
    the_move_y = the_move_rp;
    the_move_z = the_move_rp;
    
    % Peak XYZ velocities
    %index finger max velocity (X)
    %if(side>0) %Subject pointing to the right (1)
        [~, if_max_vel_index_x] = max(abs(velocity(ifs_move_x:ife_move_x, 2)));
        if_max_vel_index_x = if_max_vel_index_x + ifs_move_x -1;
        
    %end
    %if(side <0)  %Subject pointing to the left (-1)
        %if_max_vel = min((velocity(ifs_move_x:ife_move_x,2)));
    %end
    %if_max_vel_index_x = find(abs(velocity(:,1)) == if_max_vel);
    
    %index finger max velocity (Y)
    [~, if_max_vel_index_y] = max(abs(velocity(ifs_move_x:ife_move_x, 3)));
    if_max_vel_index_y = if_max_vel_index_y + ifs_move_x -1;
    
    %index finger max velocity (z)
    if_max_vel_index_z = if_min_vel_index_z;
    
    %thumb max velocity (X)
%     if(side>0) %Subject pointing to the right (1)
%         th_max_vel = max((velocity(ths_move_x:the_move_x,4)));
%     end
%     if(side <0) %Subject pointing to the left (-1)
        [~, th_max_vel_index_x] = max(abs(velocity(ths_move_x:the_move_x, 5)));
        th_max_vel_index_x = th_max_vel_index_x + ths_move_x -1;
%     end
    %th_max_vel_index_x = find((velocity(:,4)) == th_max_vel);
    
    %thumb max velocity (Y)
    [~, th_max_vel_index_y] = max(abs(velocity(ths_move_x:the_move_x, 6)));
    th_max_vel_index_y = th_max_vel_index_y + ths_move_x -1;
    
    %thumb max velocity (Z)
    th_max_vel_index_z = th_min_vel_index_z;
    
    % Index Finger 100, 50 msec before and after peak velocity
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index = if_max_vel_index_z - 5;
    if_100p_index = if_max_vel_index_z + 5;
        
        %40 msec before/after
    if_40n_index = if_max_vel_index_z - 2;
    if_40p_index = if_max_vel_index_z + 2;

        %60 msec before/after
    if_60n_index = if_max_vel_index_z -3;
    if_60p_index = if_max_vel_index_z +3;

        %50 msec before/after (x)
    x = [pos(if_60n_index, 1), pos(if_40n_index, 1)];
    y = [pos(if_60n_index, 2), pos(if_40n_index, 2)];
    z = [pos(if_60n_index, 3), pos(if_40n_index, 3)];

    if_x_50n = interp1(x, 1.5); %Values
    if_y_50n = interp1(y, 1.5);
    if_z_50n = interp1(z, 1.5);

    x = [pos(if_40p_index, 1), pos(if_60p_index, 1)];
    y = [pos(if_40p_index, 2), pos(if_60p_index, 2)];
    z = [pos(if_40p_index, 3), pos(if_60p_index, 3)];

    if_x_50p = interp1(x, 1.5); %Values
    if_y_50p = interp1(y, 1.5);
    if_z_50p = interp1(z, 1.5);
        
    if_x_100n = pos(if_100n_index, 1); %Values
    if_y_100n = pos(if_100n_index, 2);
    if_z_100n = pos(if_100n_index, 3);
        
    if_x_100p = pos(if_100p_index, 1); %Values
    if_y_100p = pos(if_100p_index, 2);
    if_z_100p = pos(if_100p_index, 3);
        
    % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index = th_max_vel_index_z - 5;
    th_100p_index = th_max_vel_index_z + 5;
        
        %40 msec before/after
    th_40n_index = th_max_vel_index_z - 2;
    th_40p_index = th_max_vel_index_z + 2;

        %60 msec before/after
    th_60n_index = th_max_vel_index_z - 3;
    th_60p_index = th_max_vel_index_z + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index, 4), pos(th_40n_index, 4)];
    y = [pos(th_60n_index, 5), pos(th_40n_index, 5)];
    z = [pos(th_60n_index, 6), pos(th_40n_index, 6)];

    th_x_50n = interp1(x, 1.5); %Values
    th_y_50n = interp1(y, 1.5);
    th_z_50n = interp1(z, 1.5);

    x = [pos(th_40p_index, 4), pos(th_60p_index, 4)];
    y = [pos(th_40p_index, 5), pos(th_60p_index, 5)];
    z = [pos(th_40p_index, 6), pos(th_60p_index, 6)];

    th_x_50p = interp1(x, 1.5); %Values
    th_y_50p = interp1(y, 1.5);
    th_z_50p = interp1(z, 1.5);
        
    th_x_100n = pos(th_100n_index, 4); %Values
    th_y_100n = pos(th_100n_index, 5);
    th_z_100n = pos(th_100n_index, 6);
        
    th_x_100p = pos(th_100p_index, 4); %Values
    th_y_100p = pos(th_100p_index, 5);
    th_z_100p = pos(th_100p_index, 6);
    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 2); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x, 2); %necessary for catching an error 
    end
    if(side>0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0)%Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end    
    if_peakAccel_index_x = find(accel(:, 2) == peakAccel);
    if(isempty(if_peakAccel_index_x)) 
        if_peakAccel_index_x = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_y:if_max_vel_index_y, 3); %copy index acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_y:ifs_move_y, 3);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_y = find(accel(:, 3) == peakAccel);
    if(isempty(if_peakAccel_index_y)) 
        if_peakAccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(ifs_move_z:if_max_vel_index_z, 4); %copy index acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_z:ifs_move_z, 4);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_z = find(accel(:, 4) == peakAccel);
    if(isempty(if_peakAccel_index_z)) 
        if_peakAccel_index_z = if_max_vel_index_z;
    end
    
    %Peak acceleration thumb  
    temp_array = accel(ths_move_x:th_max_vel_index_x, 5); %copy thumb acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_x:ths_move_x, 5);
    end
    if(side >0) %Subject pointing to the right (1)
        peakAccel = max(temp_array);
    else % if(side<0) %Subject pointing to the left (-1)
        peakAccel = min(temp_array);
    end
    th_peakAccel_index_x = find(accel(:, 5) == peakAccel);
    if(isempty(th_peakAccel_index_x)) 
        th_peakAccel_index_x = th_max_vel_index_z;
    end
   
    temp_array = accel(ths_move_y:th_max_vel_index_y, 6); %copy thumb acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_y:ths_move_y, 6);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_y = find(accel(:, 6) == peakAccel);
    if(isempty(th_peakAccel_index_y)) 
        th_peakAccel_index_y = th_max_vel_index_z;
    end
    
    temp_array = accel(ths_move_z:th_max_vel_index_z, 7); %copy thumb acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_z:ths_move_z, 7);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_z = find(accel(:, 7) == peakAccel);
    if(isempty(th_peakAccel_index_z)) 
        th_peakAccel_index_z = th_max_vel_index_z;
    end
        
    %Peak decceleration index
    temp_array = accel(if_max_vel_index_x:ife_move_x, 2);
    if(isempty(temp_array))
        temp_array = accel(ife_move_x:if_max_vel_index_x, 2);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subejct pointing to the left (-1)
        peakDeccel = max(temp_array);
    end    
    if_peakDeccel_index_x = find(accel(:, 2) == peakDeccel);
    if(isempty(if_peakDeccel_index_x)) 
        if_peakDeccel_index_x = if_max_vel_index_z;
    end

    temp_array = accel(if_max_vel_index_y:ife_move_y, 3); %copy index acceleration in y direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_y:if_max_vel_index_y, 3);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_y = find(accel(:, 3) == peakDeccel);
    if(isempty(if_peakDeccel_index_y))
        if_peakDeccel_index_y = if_max_vel_index_z;
    end
    
    temp_array = accel(if_max_vel_index_z:ife_move_z, 4); %copy index acceleration in z direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_z:if_max_vel_index_z, 4);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_z = find(accel(:, 4) == peakDeccel);
    if(isempty(if_peakDeccel_index_z)) 
        if_peakDeccel_index_z = if_max_vel_index_z;
    end
    
    %Peak decceleration thumb
    
    temp_array = accel(th_max_vel_index_x:the_move_x, 5); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_x:th_max_vel_index_x, 5);
    end
    if(side >0) %Subject pointing to the right (1)
        peakDeccel = min(temp_array);
    else %if(side<0) %Subject pointing to the left (-1)
        peakDeccel = max(temp_array);
    end   
    th_peakDeccel_index_x = find(accel(:, 5) == peakDeccel);
    if(isempty(th_peakDeccel_index_x))
        th_peakDeccel_index_x = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_y:the_move_y, 6); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_y:th_max_vel_index_y, 6);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_y = find(accel(:, 6) == peakAccel);
    if(isempty(th_peakDeccel_index_y))
        th_peakDeccel_index_y = th_peak_vel_index_z;
    end
    
    temp_array = accel(th_max_vel_index_z:the_move_z, 7); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_z:th_max_vel_index_z, 7);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_z = find(accel(:, 7) == peakAccel);
    if(isempty(th_peakDeccel_index_z))
        th_peakDeccel_index_z = th_peak_vel_index_z;
    end
    
    return_output = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p];
    return_phase_begin = ifs_move_z;
    return_phase_end = ife_move_z;
%     % Index finger max vector velocity
%     [~, if_max_v_vel_index] = max(vector_vel(ife_move_z:end, 2)); %Peak Index Vector Vel look for the max
%     if_max_v_vel_index = if_max_v_vel_index + ife_move_z -1;
%     
%     %Thumb max vector velocity
%     [~, th_max_v_vel_index] = max(vector_vel(ife_move_z:end, 3)); %Peak Thumb Vector Vel look for the max
%     th_max_v_vel_index = th_max_v_vel_index + ife_move_z -1;
%     
%     % Index finger velocity peak (z)
%     %[~, indices] = findpeaks(-velocity(ife_move_z:end, 4), 'MinPeakHeight', if_vector_vel_tol); %Negative peak of index velocity (z)
%     [~, if_max_vel_index_z] = min (velocity(ife_move_z:end, 4));
%     if_max_vel_index_z = ife_move_z + if_max_vel_index_z -1;
%     %if_max_vel_index_z= indices (1, 1);
% %     if_max_v_vel_index = min(vector_vel(varargin(1,8):varargin(1,9),2)); 
% %     if_max_v_vel_index = find(vector_vel(:,1) == if_max_v_vel_index);
%     
%     %Thumb velocity peak (z)
% %     [~, indices] = findpeaks(-velocity(the_move_z:end, 7),'MinPeakHeight', th_vector_vel_tol); %Negative peak of thumb velocity (z)
% %     th_max_vel_index_z = indices (1, 1);
%     [~, th_max_vel_index_z] = min(velocity(the_move_z:end, 7));
%     th_max_vel_index_z = th_max_vel_index_z + the_move_z -1;
% %     th_max_v_vel = min(vector_vel(varargin(1,8):varargin(1,9),3)); 
% %     th_max_v_vel_index = find(vector_vel(:,2) == th_max_v_vel);

%     %Return phase start
%     ifs_move_rp = if_max_vel_index_z;
%     while(abs(velocity(ifs_move_rp, 4)) > vel_tolerance && ifs_move_rp >ife_move_z)
%         ifs_move_rp = ifs_move_rp -1;
%     end
%     
%     
%     ths_move_rp = th_max_vel_index_z;
%     while(abs(velocity(ths_move_rp, 7)) > vel_tolerance && ths_move_rp > the_move_z)
%         ths_move_rp = ths_move_rp -1;
%     end
%     
%     %Return phase end
%     ife_move_rp = if_max_vel_index_z;
%     while(abs(velocity(ife_move_rp, 4)) > VelEnd_tolerance && ife_move_rp <max_index)
%         ife_move_rp = ife_move_rp +1;
%     end
%     
%     the_move_rp = th_max_vel_index_z;
%     while(abs(velocity(the_move_rp, 7)) > VelEnd_tolerance && the_move_rp <max_index)
%         the_move_rp = the_move_rp +1;
%     end

    
%    return_output = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z if_max_v_vel_index   th_max_v_vel_index  objp_begin  objp_end];
    %return_output = [ifs_move_rp ths_move_rp ife_move_rp the_move_rp objp_begin objp_end];
    
    %Grasping start
    %Grip aperture should be between 4/3 * object diameter and the object
    %diameter (from 'Robust movement segmentation by combining multiple
    %sources of information' by Schot, Benner and Smeets)
    objective_f_ga = zeros(length(vector_sagpos(:,1)),1);
    obj_dia = varargin(1, 3);
    for i=1: length(vector_sagpos(:, 1))
        if(vector_sagpos(i, 4) < obj_dia) 
            objective_f_ga(i, 1) = vector_sagpos(i, 4)/obj_dia;
        end
        if(vector_sagpos(i, 4) >= obj_dia && vector_sagpos(i, 4) <= 4/3*obj_dia)
            objective_f_ga(i, 1) = (4*obj_dia - 3*pos(i, 4)) / obj_dia;
        end
        %Else the grip aperture is greater than 4/3*obj_dia
    end
    
    %Debuging
    figure()
    subplot(5,1,1);
    plot(vector_sagpos(:,1),objective_f_ga(:,1));
    %
    
    objective_f_gav = zeros (length(vector_vel(:, 1)), 1); %Grip Aperture should be decreasing, therefore grip velocity should be negative
    for i =1:length (vector_vel(:, 1))
        if vector_vel(i, 4) < 0
            objective_f_gav(i,1)= 1;
        end
    end
    
    %Debuging
    subplot(5,1,2);
    plot(vector_vel(:, 1),objective_f_gav(:, 1));
    %
    
    objective_f_gaa = zeros(length(vector_accel(:, 1)),1); %Grip aperture should be decelerating, not accelerating, therefore postive acceleration
    for i =1:length (vector_accel(:, 1))
        if vector_accel(i, 4) > 0
            objective_f_gaa(i,1)= 1;
        end
    end
    
    %Debugging
    subplot(5,1,3);
    plot(vector_accel(:, 1), objective_f_gaa(:, 1));
    %
    
    
    %Average height of the thumb and index finger must be bigger than 3/4 of the
    %height of the object
    objective_f_h = zeros(length(pos(:,1)),1);
    
    obj_height = varargin(1,5)*3/4;
    for i=1: length(pos(:,1))
        if ((pos (i,3) + pos(i, 6))/2 > obj_height)
            objective_f_h (i,1) = 1;
        end
    end
    
    %Debugging
    subplot(5,1,4);
    plot(pos(:, 1), objective_f_h(:, 1));
    %
    
    %Sagittal position of the index must be more than half of the azimuthal object
    %distance from the needle
    objective_f_d = zeros(length(vector_sagpos(:,1)),1);
    obj_dist = varargin(1,4)/2;
    for i=1: length(vector_sagpos(:,1))
        if(vector_sagpos(i, 2) > obj_dist)
            objective_f_d (i,1) = 1;
        end
    end
    
    %Debugging
    subplot(5,1,5);
    plot(vector_sagpos(:, 1), objective_f_d(:,1));
    
%    master_obj_function = zeros(length(objective_f_gaa(:,1)),1);
%    master_obj_function(:,1) = objective_f_gaa(:,1) * objective_f_h(:,1) * objective_f_ws(:,1) * objective_f_ga(:,1) * objective_f_gav(:,1) * objective_f_d(:,1);
    master_obj_function(:,1) = objective_f_gaa(:,1) .* objective_f_h(:,1) .* objective_f_ga(:,1) .* objective_f_gav(:,1) .* objective_f_d(:, 1); 
    master_obj_function(master_obj_function == 0) = NaN; %Replace all 0s with NaNs
    [~, index] = max(master_obj_function(approach_phase_end:return_phase_begin, 1));
    index = approach_phase_end + index -1;
    
    %Debugging
    figure()
    plot(pos(:, 1), master_obj_function);
    hold on;
    plot(pos(index, 1), master_obj_function(index, 1), 'xr');
    %
    
    %Max Grip
    [~, max_g_index] = max(vector_sagpos(1:index, 4));
    
    %Index Finger 100, 50 msec before and after peak grip aperture
    % Assuming sample rate is 50 frames per second
        %100 msec before/after
    if_100n_index = max_g_index - 5;
    if_100p_index = max_g_index + 5;
        
        %40 msec before/after
    if_40n_index = max_g_index - 2;
    if_40p_index = max_g_index + 2;

        %60 msec before/after
    if_60n_index = max_g_index -3;
    if_60p_index = max_g_index +3;

        %50 msec before/after (x)
    x = [pos(if_60n_index, 2), pos(if_40n_index, 2)];
    y = [pos(if_60n_index, 3), pos(if_40n_index, 3)];
    z = [pos(if_60n_index, 4), pos(if_40n_index, 4)];

    if_x_50n_g = interp1(x, 1.5); %Values
    if_y_50n_g = interp1(y, 1.5);
    if_z_50n_g = interp1(z, 1.5);

    x = [pos(if_40p_index, 2), pos(if_60p_index, 2)];
    y = [pos(if_40p_index, 3), pos(if_60p_index, 3)];
    z = [pos(if_40p_index, 4), pos(if_60p_index, 4)];

    if_x_50p_g = interp1(x, 1.5); %Values
    if_y_50p_g = interp1(y, 1.5);
    if_z_50p_g = interp1(z, 1.5);
        
    if_x_100n_g = pos(if_100n_index, 2); %Values
    if_y_100n_g = pos(if_100n_index, 3);
    if_z_100n_g = pos(if_100n_index, 4);
        
    if_x_100p_g = pos(if_100p_index, 2); %Values
    if_y_100p_g = pos(if_100p_index, 3);
    if_z_100p_g = pos(if_100p_index, 4);
        
    % Thumb 100, 50 msec before and after
        %100 msec before/after
    th_100n_index = index - 5;
    th_100p_index = index + 5;
        
        %40 msec before/after
    th_40n_index = index - 2;
    th_40p_index = index + 2;

        %60 msec before/after
    th_60n_index = index - 3;
    th_60p_index = index + 3;

        %50 msec before/after (x)
    x = [pos(th_60n_index, 5), pos(th_40n_index, 5)];
    y = [pos(th_60n_index, 6), pos(th_40n_index, 6)];
    z = [pos(th_60n_index, 7), pos(th_40n_index, 7)];

    th_x_50n_g = interp1(x, 1.5); %Values
    th_y_50n_g = interp1(y, 1.5);
    th_z_50n_g = interp1(z, 1.5);

    x = [pos(th_40p_index, 5), pos(th_60p_index, 5)];
    y = [pos(th_40p_index, 6), pos(th_60p_index, 6)];
    z = [pos(th_40p_index, 7), pos(th_60p_index, 7)];

    th_x_50p_g = interp1(x, 1.5); %Values
    th_y_50p_g = interp1(y, 1.5);
    th_z_50p_g = interp1(z, 1.5);
        
    th_x_100n_g = pos(th_100n_index, 5); %Values
    th_y_100n_g = pos(th_100n_index, 6);
    th_z_100n_g = pos(th_100n_index, 7);
        
    th_x_100p_g = pos(th_100p_index, 5); %Values
    th_y_100p_g = pos(th_100p_index, 6);
    th_z_100p_g = pos(th_100p_index, 7);
   
    max_grip_positions = [if_x_50n_g if_y_50n_g if_z_50n_g if_x_50p_g if_y_50p_g if_z_50p_g if_x_100n_g if_y_100n_g if_z_100n_g if_x_100p_g if_y_100p_g if_z_100p_g th_x_50n_g th_y_50n_g th_z_50n_g th_x_50p_g th_y_50p_g th_z_50p_g th_x_100n_g th_y_100n_g th_z_100n_g th_x_100p_g th_y_100p_g th_z_100p_g];
    
    %Placement start
    placement_start = index;
    while(velocity(placement_start, 3) > -0.1) %Using velocity in y direction
        placement_start = placement_start+ 1;
    end
    %Placement end
    %placement_end = ifs_move_z;
    placement_end = placement_start;
    while(velocity(placement_end, 3) > -0.01)
        placement_end = placement_end + 1;
    end
    final_output = [approach_output return_output index objp_start objp_end max_grip_positions];
    
    varargout = num2cell(final_output, [1 2]);
end

end

