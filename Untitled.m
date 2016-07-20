function [ output_args ] = Untitled( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%output_array = zeros(1,32);
    % Index finger max vector velocity
    if_max_v_vel_index = max(vector_vel(:,1)); %Peak Index Vector Vel
    if_max_v_vel_index = find(vector_vel(:,1) == if_max_v_vel_index);
    
    %Thumb max vector velocity
    th_max_v_vel = max(vector_vel(:,2)); %Peak Thumb Vector Vel
    th_max_v_vel_index = find(vector_vel(:,2) == th_max_v_vel);
    
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
%         disp(if_x_50n);
%         disp(if_y_50n);
%         disp(if_z_50n);

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
    ifs_move_x = ifs_move_z; %All start and end times based on velocity in z
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
    ife_move_x = ife_move_z; %All end times are based on velocity in z
    ife_move_y = ife_move_z;
    the_move_x = the_move_z;
    the_move_y = the_move_z;
    % Peak XYZ velocities
    %index finger max velocity (X)
    if(side>3) %Subject pointing in positive x direction
        if_max_vel = max((velocity(ifs_move_x:ife_move_x,1)));
    end
    if(side <4)  %Subject pointing in negative x direction
        if_max_vel = min((velocity(ifs_move_x:ife_move_x,1)));
    end
    if_max_vel_index_x = find((velocity(:,1)) == if_max_vel);
    
    %index finger max velocity (Y)
    if_max_vel = max(velocity(ifs_move_x:ife_move_x,2));
    if_max_vel_index_y = find(velocity(:,2)==if_max_vel);
    
        
    %thumb max velocity (X)
    if(side>3) %Subject pointing in positive x direction
        th_max_vel = max((velocity(ths_move_x:the_move_x,4)));
    end
    if(side <4) %Subject pointing in negative x direction
        th_max_vel = min((velocity(ths_move_x:the_move_x,4)));
    end
    th_max_vel_index_x = find((velocity(:,4)) == th_max_vel);
    
    %thumb max velocity (Y)
    th_max_vel = max(velocity(ths_move_x:the_move_x,5));
    th_max_vel_index_y = find(velocity(:,5) == th_max_vel);

    
    %Peak acceleration index
    temp_array = accel(ifs_move_x:if_max_vel_index_x, 1); %copy index acceleration in x direction from movement start to peak velocity
    if(isempty(temp_array))
        temp_array = accel(if_max_vel_index_x:ifs_move_x,1); %necessary for catching an error
    end
    if(side>3)
        peakAccel = max(temp_array);
    else % if(side<4)%Subject pointing in negative x direction
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
    if(side >3) %Subject pointing to the right
        peakAccel = max(temp_array);
    else % if(side<4)
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
    if(side >3) %Subject pointing to the right
        peakDeccel = min(temp_array);
    else %if(side<4)
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
    if(side >3)
        peakDeccel = min(temp_array);
    else %if(side<4)
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
    
    output_array = [ifs_move_x   ifs_move_y   ifs_move_z   ths_move_x   ths_move_y   ths_move_z   ife_move_x   ife_move_y   ife_move_z   the_move_x   the_move_y   the_move_z   if_max_vel_index_x   if_max_vel_index_y   if_max_vel_index_z   th_max_vel_index_x   th_max_vel_index_y   th_max_vel_index_z   if_peakAccel_index_x   if_peakAccel_index_y   if_peakAccel_index_z   th_peakAccel_index_x   th_peakAccel_index_y   th_peakAccel_index_z   if_peakDeccel_index_x   if_peakDeccel_index_y   if_peakDeccel_index_z   th_peakDeccel_index_x   th_peakDeccel_index_y   th_peakDeccel_index_z   if_max_v_vel_index   th_max_v_vel_index   if_x_50n   if_y_50n   if_z_50n   if_x_50p   if_y_50p   if_z_50p   if_x_100n   if_y_100n   if_z_100n   if_x_100p   if_y_100p   if_z_100p   th_x_50n   th_y_50n   th_z_50n   th_x_50p   th_y_50p   th_z_50p   th_x_100n   th_y_100n   th_z_100n   th_x_100p   th_y_100p   th_z_100p];

end

