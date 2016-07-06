function [ varargout ] = KinVal_Extract(resample_rate, type, VelEnd_tolerance, vel_tolerance, pos, velocity, accel, vector_sagpos, vector_vel, vector_accel,if_vector_vel_tol,th_vector_vel_tol, varargin )
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

if type ==0

%    output_array = zeros(1,32);
    % Index finger max vector velocity
    if_max_v_vel_index = max(vector_vel(:,1)); %Peak Index Vector Vel
    if_max_v_vel_index = find(vector_vel(:,1) == if_max_v_vel_index);
    
    
    %Thumb max vector velocity
    th_max_v_vel_index = max(vector_vel(:,2));
    th_max_v_vel_index = find(vector_vel(:,2) == th_max_v_vel_index);
    
 

    
    %index finger max velocity (Z)
    [~, indices] = findpeaks(velocity(:,3),'MinPeakHeight',if_vector_vel_tol);
    if_max_vel_index_z = indices(1,1);

    %thumb max velocity (Z)
    [~, indices] = findpeaks(velocity(:,6),'MinPeakHeight',th_vector_vel_tol);
    th_max_vel_index_z= indices (1,1);
    
%     if_max_vel_index_x = if_max_v_vel_index;
%     if_max_vel_index_y = if_max_v_vel_index;
%     if_max_vel_index_z = if_max_v_vel_index;
%     th_max_vel_index_x = th_max_v_vel_index;
%     th_max_vel_index_y = th_max_v_vel_index;
%     th_max_vel_index_z = th_max_v_vel_index;
%

    % Index Finger 100, 50 msec before and after
    if(resample_rate == 50)
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
    end
    
    
    
    

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
    
    ths_move_x = th_max_vel_index_z;
    while (abs(velocity(ths_move_x,1))>vel_tolerance && ths_move_x>0)      %Movement Start for outgoing arc (x) thumb
        ths_move_x = ths_move_x-1;
    end
    
   	ths_move_y = th_max_vel_index_z;
    while (velocity(ths_move_y,2)>vel_tolerance && ths_move_y >0)     %Movement Start for outgoing arc (y) thumb
        ths_move_y = ths_move_y-1;
    end
    
    ths_move_z = th_max_vel_index_z;
    while (velocity(ths_move_z,3)>vel_tolerance && ths_move_z >0)      %Movement Start for outgoing arc (z) thumb
        ths_move_z = ths_move_z-1;
    end
    ifs_move_x = ifs_move_z;
    ifs_move_y = ifs_move_z;
    ths_move_x = ths_move_z;
    ths_move_y = ths_move_z;
    
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
    
    the_move_x = th_max_vel_index_z;
    while (velocity(the_move_x,1)>VelEnd_tolerance && the_move_x<max_index)      %Movement End for outgoing arc (x) thumb
        the_move_x = the_move_x+1;
    end
    
   	the_move_y = th_max_vel_index_z;
    while (velocity(the_move_y,2)>VelEnd_tolerance && the_move_y <max_index)     %Movement End for outgoing arc (y) thumb
        the_move_y = the_move_y+1;
    end
    
    the_move_z = th_max_vel_index_z;
    while (velocity(the_move_z,3)>VelEnd_tolerance && the_move_z<max_index)      %Movement End for outgoing arc (z) thumb
        the_move_z = the_move_z+1;
    end
    ife_move_x = ife_move_z;
    ife_move_y = ife_move_z;
    the_move_x = the_move_z;
    the_move_y = the_move_z;
    % Peak XYZ velocities
    %index finger max velocity (X)
    if_max_vel = max(abs(velocity(ifs_move_x:ife_move_x,1)));
    if_max_vel_index_x = find(abs(velocity(:,1)) == if_max_vel);
    
    
    %index finger max velocity (Y)
    if_max_vel = max(velocity(ifs_move_x:ife_move_x,2));
    if_max_vel_index_y = find(velocity(:,2)==if_max_vel);
    
        
    %thumb max velocity (X)
    th_max_vel = max(abs(velocity(ths_move_x:the_move_x,4)));
    th_max_vel_index_x = find(abs(velocity(:,4)) == th_max_vel);
    
    %thumb max velocity (Y)
    th_max_vel = max(velocity(ths_move_x:the_move_x,5));
    th_max_vel_index_y = find(velocity(:,5) == th_max_vel);

    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 1); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x,1);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_x = find(accel(:,1) == peakAccel);
    
    temp_array = accel(ifs_move_y:if_max_vel_index_y, 2); %copy index acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_y:ifs_move_y,2);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_y = find(accel(:,2) == peakAccel);
    
    temp_array = accel(ifs_move_z:if_max_vel_index_z, 3); %copy index acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_z:ifs_move_z, 3);
    end
    peakAccel = max(temp_array);
    if_peakAccel_index_z = find(accel(:,3) == peakAccel);
    
    %Peak acceleration thumb  
    temp_array = accel(ths_move_x:th_max_vel_index_x, 4); %copy thumb acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_x:ths_move_x, 4);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_x = find(accel(:,4) == peakAccel);
    
    temp_array = accel(ths_move_y:th_max_vel_index_y, 5); %copy thumb acceleration in y direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_y:ths_move_y, 5);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_y = find(accel(:,5) == peakAccel);
    
    temp_array = accel(ths_move_z:th_max_vel_index_z, 6); %copy thumb acceleration in z direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(th_max_vel_index_z:ths_move_z, 6);
    end
    peakAccel = max(temp_array);
    th_peakAccel_index_z = find(accel(:,6) == peakAccel);
    
    
    %Peak decceleration index
    
    temp_array = accel(if_max_vel_index_x:ife_move_x, 1); %copy index acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_x:if_max_vel_index_x, 1);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_x = find(accel(:,1) == peakDeccel);
    
    temp_array = accel(if_max_vel_index_y:ife_move_y, 2); %copy index acceleration in y direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_y:if_max_vel_index_y, 2);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_y = find(accel(:,2) == peakDeccel);
    
    temp_array = accel(if_max_vel_index_z:ife_move_z, 3); %copy index acceleration in z direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(ife_move_z:if_max_vel_index_z, 3);
    end
    peakDeccel = min(temp_array);
    if_peakDeccel_index_z = find(accel(:,3) == peakDeccel);
    
    %Peak decceleration thumb
    
    temp_array = accel(th_max_vel_index_x:the_move_x, 4); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_x:th_max_vel_index_x, 4);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_x = find(accel(:,4) == peakAccel);
    
    temp_array = accel(th_max_vel_index_y:the_move_y, 5); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_y:th_max_vel_index_y, 5);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_y = find(accel(:,5) == peakAccel);
    
    temp_array = accel(th_max_vel_index_z:the_move_z, 6); %copy thumb acceleration in x direction from peak velocity to movement end
    if(isempty(temp_array))
        temp_array = accel(the_move_z:th_max_vel_index_z, 6);
    end
    peakAccel = min(temp_array);
    th_peakDeccel_index_z = find(accel(:,6) == peakAccel);
    
   
    
    output_array = [ifs_move_x ifs_move_y ifs_move_z ths_move_x ths_move_y ths_move_z ife_move_x ife_move_y ife_move_z the_move_x the_move_y the_move_z if_max_vel_index_x if_max_vel_index_y if_max_vel_index_z th_max_vel_index_x th_max_vel_index_y th_max_vel_index_z if_peakAccel_index_x if_peakAccel_index_y if_peakAccel_index_z th_peakAccel_index_x th_peakAccel_index_y th_peakAccel_index_z if_peakDeccel_index_x if_peakDeccel_index_y if_peakDeccel_index_z th_peakDeccel_index_x th_peakDeccel_index_y th_peakDeccel_index_z if_max_v_vel_index th_max_v_vel_index if_x_50n if_y_50n if_z_50n if_x_50p if_y_50p if_z_50p if_x_100n if_y_100n if_z_100n if_x_100p if_y_100p if_z_100p th_x_50n th_y_50n th_z_50n th_x_50p th_y_50p th_z_50p th_x_100n th_y_100n th_z_100n th_x_100p th_y_100p th_z_100p]; 
   
    %    disp((output_array));
%     index_max_vel = max(velocity(:,1));
%     
%     index_min_vel = min(velocity(:,1));
%     
%     index_max_vel_index = find(velocity(:,1)==index_max_vel);
%     index_min_vel_index = find(velocity(:,1) == index_min_vel);
% 
%     index= zeros(1,4);
%     
%     for x = index_max_vel_index:-1:1 %Movement Start for outgoing arc
%         index(1,1) = x;
%         if velocity(x,1) < vel_tolerance
%             break
%         end 
%     end
%     index(1,2) = index_max_vel_index; %Movement end for outgoing arc
%     while velocity(index(1,2),1)> vel_tolerance
%         index(1,2) = index(1,2) + 1;
%     end
%     
%     index(1,3) = index_min_vel_index; %Movement Start for incoming arc
%     while velocity(index(1,3),1) < (-1*vel_tolerance)
%         index(1,3) = index(1,3) - 1;
%     end
%     
%     
%     index(1,4) = index_min_vel_index; %Movement end for incoming arc
%     while velocity(index(1,4),1) < (-1*vel_tolerance)
%         index(1,4) = index(1,4) + 1;
%     end
    
%     thumb_max_vel = max(velocity(:,2));
%     index_max_vel_thumb = find(velocity(:,2)==thumb_max_vel);
%     wrist_max_vel = max(velocity(:,3));
%     index_max_vel_wrist = find(velocity(:,3)==wrist_max_vel);
%     palm_max_vel = max(velocity(:,4));
%     index_max_vel_palm = find(velocity(:,4)==palm_max_vel);
%     
%     temp_array = accel(index(1,1):index_max_vel_index,1);
%     
%     index_max_accel = max(temp_array);
%     index_max_accel_index = find(accel(:,1)==index_max_accel); % max accel on outgoing arc
%     
%     max_deccel = accel(index_max_accel:index(1,2),1);
%     index_min_accel= min(max_deccel);
%     index_min_accel_index = find(accel(:,1)==index_min_accel); %max deccel on outgoing arc
%     
%     max_accel_incoming = accel(index(1,3):index_min_vel_index,1);
%     index_incoming_min= min(max_accel_incoming);
%     index_incoming_min_index = find(accel(:,1)==index_incoming_min); %max accel on incoming arc
%     
%     max_deccel = accel(index_min_vel_index:index(1,4),1);
%     index_outgoing_min= max(max_deccel);
%     index_outgoing_min_index = find(accel(:,1)==index_outgoing_min); %max deccel on outgoing arc
%     
%     
% 
%     
%     
%     thumb_max_accel = max(accel(:,2));
%     index_max_accel_thumb = find(accel(:,2)==thumb_max_accel);
%     wrist_max_accel = max(accel(:,3));
%     index_max_accel_wrist = find(accel(:,3)==wrist_max_accel);
%     palm_max_accel = max(accel(:,4));
%     index_max_accel_palm = find(accel(:,4)==palm_max_accel);
%     
%     output = [index(1,1) index(1,2) index(1,3) index(1,4) index_max_vel_index index_min_vel_index index_max_vel_wrist index_max_vel_palm index_max_accel_index index_min_accel_index index_incoming_min_index index_outgoing_min_index];
    
    varargout = num2cell( output_array, [1 2]);
end

if type ==1 %Grasping motion
    varargin=(cell2mat(varargin));
    %Movement End
    %Grip aperture should be greater than half of the object diameter
    objective_f_ga = zeros(length(pos(:,1)),1);
    obj_dia = varargin(1,3)/2;
    for i=1: length(pos(:,1))
        if(pos(i,6)>obj_dia)
            objective_f_ga(i,1) = 1;
        end
    end
    
    objective_f_gav = zeros (length(velocity), 1); %Grip Aperture should be decreasing, therefore grip velocity should be negative
    for i =1:length (velocity)
        if velocity(i,6) >0
            objective_f_gav(i,1)= 1;
        else
            objective_f_gav (i,1) = 0;
        end
    end
    
    objective_f_gaa = zeros(length(accel),1); %Grip aperture should be decelerating, not accelerating, therefore postive acceleration
    for i =1:length (accel)
        if accel(i,6) <0
            objective_f_gaa(i,1)= 1;
        else
            objective_f_gaa (i,1) = 0;
        end
    end
    %speed of wrist low upon movement ending
    max_wrist_velocity = max(velocity(:,3));
    objective_f_ws = abs(velocity(:,3));
    %assign more importance to lower wrist speeds
    objective_f_ws = 1-(objective_f_ws(:,1)/max_wrist_velocity);
    
    %Average height of the thumb and index finger must be bigger than 3/4 of the
    %height of the object from the Leap Detector
    objective_f_h = zeros(length(vel_tolerance(:,1)),1);
    
    obj_height = varargin(1,5)*3/4;
    for i=1: length(vel_tolerance(:,1))
        if (vel_tolerance (i,2) > obj_height)
            objective_f_h (i,1) = 1;
        end
    end
    
    %Sagittal position of the index must be more than half of the object
    %distance from the needle
    objective_f_d = zeros(length(pos(:,6)),1);
    obj_dist = varargin(1,4)/2;
    for i=1: length(pos(:,6))
        if(pos(i,6) > obj_dist)
            objective_f_d (i,1) = 1;
        end
    end
    master_obj_function = zeros(length(objective_f_gaa(:,1)),1);
    for i=1: length(objective_f_gaa(:,1))
        master_obj_function(i,1) = objective_f_gaa(i,1)*objective_f_d(i,1)* objective_f_h(i,1)*objective_f_ws(i,1)*objective_f_ga(i,1)*objective_f_gav(i,1);
    end
    
    max_i = max(master_obj_function);
    index = find(master_obj_function(:,1)==max_i);
    
    varargout = num2cell(index, [1 2]);
end


end

