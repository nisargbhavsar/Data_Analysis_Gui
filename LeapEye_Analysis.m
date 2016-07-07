function varargout = LeapEye_Analysis(varargin)
% LEAPEYE_ANALYSIS MATLAB code for LeapEye_Analysis.fig
%      LEAPEYE_ANALYSIS, by itself, creates a new LEAPEYE_ANALYSIS or raises the existing
%      singleton*.
%
%      H = LEAPEYE_ANALYSIS returns the handle to a new LEAPEYE_ANALYSIS or the handle to
%      the existing singleton*.
%
%      LEAPEYE_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEAPEYE_ANALYSIS.M with the given input arguments.
%
%      LEAPEYE_ANALYSIS('Property','Value',...) creates a new LEAPEYE_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LeapEye_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LeapEye_Analysfis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LeapEye_Analysis

% Last Modified by GUIDE v2.5 07-Jul-2016 15:11:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LeapEye_Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @LeapEye_Analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT


% --- Executes just before LeapEye_Analysis is made visible.
function LeapEye_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LeapEye_Analysis (see VARARGIN)

% Choose default command line output for LeapEye_Analysis
handles.output = hObject;
%% Format axes
% Ax = findall(0,'type','axes') ;
% axis(Ax,[0 1000 -250 500]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LeapEye_Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);
setappdata(0  , 'hMainGui'    , gcf);
setappdata(gcf,   'cal'    , 0);
setappdata(gcf, 'cal_update', @updateCal);
end

% --- Outputs from this function are returned to the command line.
function varargout = LeapEye_Analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in Data_Select.
function Data_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Data_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Data_Select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Data_Select
    Data_Type = get(handles.Data_Select,'Value');  
   if (Data_Type==1)
       handles.Data_Type = 1;
   else
       handles.Data_Type = 2;
   end
   
     guidata(hObject, handles); %Update GUI
end

% --- Executes on selection change in File_Listbox.
function File_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to File_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns File_Listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from File_Listbox
end

% --- Executes during object creation, after setting all properties.
function File_Listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in Index_XYZ_Check.
function Index_XYZ_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Index_XYZ_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Index_XYZ_Check

% h = findobj(0, 'tag', 'figure1');
if (handles.extract == 0)
    axes(handles.Top_Graph);
    cla;
    axes(handles.Middle_Graph);
    cla;
    axes(handles.Bottom_Graph);
    cla;
      if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
        if (size(handles.Master_array) ~= 0) %Data in the array

          if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
            axes(handles.Top_Graph);
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,1),'-r');
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,2),'-g');
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,3),'-b');


            axes(handles.Middle_Graph);
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,1),'-r');
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,2),'-g');
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,3),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,1),'-r');
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,2),'-g');
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,3),'-b');
         end

         if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
            axes(handles.Top_Graph);
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,1),'-r');
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,2),'-g');
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,3),'-b');


            axes(handles.Middle_Graph);
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,1),'-r');
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,2),'-g');
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,3),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,1),'-r');
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,2),'-g');
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,3),'-b');
         end

         if (handles.Raw_disp (1,3) ==1) %plot Filtered Values 
            axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,1),'-r');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,2),'-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,3),'-b');

            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,1),'-r');
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,2),'-g');
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,3),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,1),'-r');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,2),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,3),'-b');
         end


        end
        aCheckbox = findobj('Tag','Wrist_Accel_Check');
        bCheckbox = findobj('Tag','Thumb_Accel_Check');
        cCheckbox = findobj('Tag','Palm_Accel_Check');
        dCheckbox = findobj('Tag','Grip_Aperture_Check');
        hCheckbox = findobj('Tag','Index_Accel_Check');
        eCheckbox = findobj('Tag','Thumb_XYZ_Check');
        fCheckbox = findobj('Tag','Palm_XYZ_Check');
        gCheckbox = findobj('Tag','Wrist_XYZ_Check');
        set(dCheckbox,'value',0);
        set(aCheckbox,'value',0);
        set(bCheckbox,'value',0);
        set(cCheckbox,'value',0);
        set(hCheckbox,'value',0);
        set(eCheckbox,'value',0);
        set(fCheckbox,'value',0);
        set(gCheckbox,'value',0);

      end 
end
    
      if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla;
    axes(handles.Middle_Graph);
    cla;
    axes(handles.Bottom_Graph);
    cla;
          gCheckbox = findobj('Tag','Index_XYZ_Check');
      set(gCheckbox,'value',0);
      end 
end

% --- Executes on button press in Thumb_XYZ_Check.
function Thumb_XYZ_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Thumb_XYZ_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Thumb_XYZ_Check

if (handles.extract == 0)
axes(handles.Top_Graph);
cla;
axes(handles.Bottom_Graph);
cla;
axes(handles.Middle_Graph);
cla;

    if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
      %if (size(handles.Master_array) ~= 0) %Data in the array
       
          if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
            axes(handles.Top_Graph);
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,4),'-r');
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,5),'-g');
            plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,6),'-b');


            axes(handles.Middle_Graph);
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,4),'-r');
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,5),'-g');
            plot(handles.Raw_Velocity_XYZ(:,7), handles.Raw_Velocity_XYZ(:,6),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,4),'-r');
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,5),'-g');
            plot(handles.Raw_Accel_XYZ(:,7), handles.Raw_Accel_XYZ(:,6),'-b');
         end

         if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
            axes(handles.Top_Graph);
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,4),'-r');
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,5),'-g');
            plot(handles.Resampled_XYZ(:,7), handles.Resampled_XYZ(:,6),'-b');


            axes(handles.Middle_Graph);
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,4),'-r');
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,5),'-g');
            plot(handles.Resampled_Velocity_XYZ(:,7), handles.Resampled_Velocity_XYZ(:,6),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,4),'-r');
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,5),'-g');
            plot(handles.Resampled_Accel_XYZ(:,7), handles.Resampled_Accel_XYZ(:,6),'-b');
         end

         if (handles.Raw_disp (1,3) ==1) %plot Filtered Values 
            axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,4),'-r');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,5),'-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,6),'-b');

            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,4),'-r');
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,5),'-g');
            plot(handles.Filtered_Velocity_XYZ(:,7), handles.Filtered_Velocity_XYZ(:,6),'-b');

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,4),'-r');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,5),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ(:,6),'-b');
         end  
  end
    aCheckbox = findobj('Tag','Wrist_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_Accel_Check');
    eCheckbox = findobj('Tag','Index_XYZ_Check');
    fCheckbox = findobj('Tag','Palm_XYZ_Check');
    gCheckbox = findobj('Tag','Wrist_XYZ_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    set(gCheckbox,'value',0);
end
  
%end


  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla;
    axes(handles.Bottom_Graph);
    cla;
    axes(handles.Middle_Graph);
    cla;
      gCheckbox = findobj('Tag','Thumb_XYZ_Check');
      set(gCheckbox,'value',0);
  end  
end

% --- Executes on button press in Index_Accel_Check.
function Index_Accel_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Index_Accel_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Index_Accel_Check

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;        

 if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
     
     if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
        axes(handles.Top_Graph);
        plot(handles.Raw_SagPos(:,5), handles.Raw_SagPos(:,1), '-r');
       
        
        axes(handles.Middle_Graph);
        plot(handles.Raw_Velocity (:,5), handles.Raw_Velocity(:,1), '-r');
        
        axes(handles.Bottom_Graph);
        plot(handles.Raw_Accel (:,5), handles.Raw_Accel(:,1), '-r');
     end
     
     if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
        axes(handles.Top_Graph);
        plot(handles.Resampled_SagPos (:,5), handles.Resampled_SagPos(:,1), '-g');
        
        axes(handles.Middle_Graph);
        plot(handles.Resampled_Velocity (:,5), handles.Resampled_Velocity(:,1), '-g');
        
        axes(handles.Bottom_Graph);
        plot(handles.Resampled_Accel (:,5), handles.Resampled_Accel(:,1), '-g');
     end
     
     if (handles.Raw_disp (1,3) ==1) %plot Filtered Values 
        axes(handles.Top_Graph);
        plot(handles.Filtered_SagPos (:,5), handles.Filtered_SagPos(:,1), '-b');
        
        axes(handles.Middle_Graph);
        plot(handles.Filtered_Velocity (:,5), handles.Filtered_Velocity(:,1), '-b');
        
        axes(handles.Bottom_Graph);
        plot(handles.Filtered_Accel (:,5), handles.Filtered_Accel(:,1), '-b');
     end
   
    aCheckbox = findobj('Tag','Wrist_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Palm_XYZ_Check');
    gCheckbox = findobj('Tag','Wrist_XYZ_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    set(gCheckbox,'value',0);

 end
 
  guidata(hObject, handles); %Update GUI
  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla; 
     
    axes(handles.Middle_Graph);
    cla;
    
    axes(handles.Bottom_Graph);
    cla;
  end  
  
  

end

% --- Executes on button press in Thumb_Accel_Check.
function Thumb_Accel_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Thumb_Accel_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Thumb_Accel_Check


axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;        

 if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
     
     if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
        axes(handles.Top_Graph);
        plot(handles.Raw_SagPos(:,5), handles.Raw_SagPos(:,2), '-r');
        
        axes(handles.Middle_Graph);
        plot(handles.Raw_Velocity (:,5), handles.Raw_Velocity(:,2), '-r');
        
        axes(handles.Bottom_Graph);
        plot(handles.Raw_Accel (:,5), handles.Raw_Accel(:,2), '-r');
     end
     
     if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
        axes(handles.Top_Graph);
        plot(handles.Resampled_SagPos (:,5), handles.Resampled_SagPos(:,2), '-g');
        
        axes(handles.Middle_Graph);
        plot(handles.Resampled_Velocity (:,5), handles.Resampled_Velocity(:,2), '-g');
        
        axes(handles.Bottom_Graph);
        plot(handles.Resampled_Accel (:,5), handles.Resampled_Accel(:,2), '-g');
     end
     
     if (handles.Raw_disp (1,3) ==1) %plot Filtered Values 
        axes(handles.Top_Graph);
        plot(handles.Filtered_SagPos (:,5), handles.Filtered_SagPos(:,2), '-b');
        
        axes(handles.Middle_Graph);
        plot(handles.Filtered_Velocity (:,5), handles.Filtered_Velocity(:,2), '-b');
        
        axes(handles.Bottom_Graph);
        plot(handles.Filtered_Accel (:,5), handles.Filtered_Accel(:,2), '-b');
     end
     
    
    aCheckbox = findobj('Tag','Wrist_Accel_Check');
    bCheckbox = findobj('Tag','Index_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Palm_XYZ_Check');
    gCheckbox = findobj('Tag','Wrist_XYZ_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    set(gCheckbox,'value',0);
 end
 
  guidata(hObject, handles); %Update GUI
  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla; 
     
    axes(handles.Middle_Graph);
    cla;
    
    axes(handles.Bottom_Graph);
    cla;
  end  
 
end

% --- Executes on button press in Palm_Accel_Check.
function Palm_Accel_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Palm_Accel_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;        

 if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
     
     if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
        axes(handles.Top_Graph);
        plot(handles.Raw_SagPos(:,5), handles.Raw_SagPos(:,4), '-r');
        
        axes(handles.Middle_Graph);
        plot(handles.Raw_Velocity (:,5), handles.Raw_Velocity(:,4), '-r');
        
        axes(handles.Bottom_Graph);
        plot(handles.Raw_Accel (:,5), handles.Raw_Accel(:,4), '-r');
     end
     
     if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
        axes(handles.Top_Graph);
        plot(handles.Resampled_SagPos (:,5), handles.Resampled_SagPos(:,4), '-g');
        
        axes(handles.Middle_Graph);
        plot(handles.Resampled_Velocity (:,5), handles.Resampled_Velocity(:,4), '-g');
        
        axes(handles.Bottom_Graph);
        plot(handles.Resampled_Accel (:,5), handles.Resampled_Accel(:,4), '-g');
     end
     
     if (handles.Raw_disp (1,3) ==1) %plot Filtered Values 
        axes(handles.Top_Graph);
        plot(handles.Filtered_SagPos (:,5), handles.Filtered_SagPos(:,4), '-b');
        
        axes(handles.Middle_Graph);
        plot(handles.Filtered_Velocity (:,5), handles.Filtered_Velocity(:,4), '-b');
        
        axes(handles.Bottom_Graph);
        plot(handles.Filtered_Accel (:,5), handles.Filtered_Accel(:,4), '-b');
     end
    aCheckbox = findobj('Tag','Wrist_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Index_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Palm_XYZ_Check');
    gCheckbox = findobj('Tag','Wrist_XYZ_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    set(gCheckbox,'value',0); 

 end
 
  guidata(hObject, handles); %Update GUI
  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla; 
     
    axes(handles.Middle_Graph);
    cla;
    
    axes(handles.Bottom_Graph);
    cla;
  end  
end

% --- Executes on button press in Wrist_Accel_Check.
function Wrist_Accel_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Wrist_Accel_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Wrist_Accel_Check

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;        

 if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
     
     if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
        axes(handles.Top_Graph);
        plot(handles.Raw_SagPos(:,5), handles.Raw_SagPos(:,3), '-r');
        
        axes(handles.Middle_Graph);
        plot(handles.Raw_Velocity (:,5), handles.Raw_Velocity(:,3), '-r');
        
        axes(handles.Bottom_Graph);
        plot(handles.Raw_Accel (:,5), handles.Raw_Accel(:,3), '-r');
     end
     
     if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
        axes(handles.Top_Graph);
        plot(handles.Resampled_SagPos (:,5), handles.Resampled_SagPos(:,3), '-g');
        
        axes(handles.Middle_Graph);
        plot(handles.Resampled_Velocity (:,5), handles.Resampled_Velocity(:,3), '-g');
        
        axes(handles.Bottom_Graph);
        plot(handles.Resampled_Accel (:,5), handles.Resampled_Accel(:,3), '-g');
     end
     
     if (handles.Raw_disp(1,3) ==1) %plot Filtered Values
        axes(handles.Top_Graph);
        plot(handles.Filtered_SagPos (:,5), handles.Filtered_SagPos(:,3), '-b');
        
        axes(handles.Middle_Graph);
        plot(handles.Filtered_Velocity (:,5), handles.Filtered_Velocity(:,3), '-b');
        
        axes(handles.Bottom_Graph);
        plot(handles.Filtered_Accel (:,5), handles.Filtered_Accel(:,3), '-b');
     end
     aCheckbox = findobj('Tag','Index_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Palm_XYZ_Check');
    gCheckbox = findobj('Tag','Wrist_XYZ_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    set(gCheckbox,'value',0);

 end
 
  guidata(hObject, handles); %Update GUI
  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
    cla; 
     
    axes(handles.Middle_Graph);
    cla;
    
    axes(handles.Bottom_Graph);
    cla;
  end  
end

% --- Executes during object creation, after setting all properties.
function Bottom_Graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bottom_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Bottom_Graph
xlabel ('Time (ms)');
ylabel ('Acceleration (m/s^2)');
end


% --- Executes during object creation, after setting all properties.
function Middle_Graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Middle_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Middle_Graph
ylabel ('Velocity (m/s)');
end


% --- Executes during object creation, after setting all properties.
function Top_Graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Top_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Top_Graph
ylabel ('Position (mm)');
end

function Cutoff_Freq_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Cutoff_Freq_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cutoff_Freq_Edit as text
%        str2double(get(hObject,'String')) returns contents of Cutoff_Freq_Edit as a double
handles.Cutoff_Freq = (str2num(get(hObject,'String')));
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function Cutoff_Freq_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cutoff_Freq_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.Cutoff_Freq = 10; %Pre-Set Cutoff Frequency
guidata(hObject, handles);
end

% --- Executes on button press in Load_Data_Button.
function Load_Data_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.warning_text, 'String','Warning:');

set(handles.Resample_Radio,'Value',0);
set(handles.Raw_Radio,'Value',0);
set(handles.Filter_Radio,'Value',0);
if(handles.system ==1)
    [handles.Trial_Num ,handles.Master_array] = load_LEAP_data_gui(1); %Call load_LEAP_data_gui function to let user input required files
else
    [handles.frequency, handles.Master_array] = load_LEAP_data_gui(3); %Load Optotrak data
end

if(handles.system ==1)
    handles.Raw_SagPos = zeros(length(handles.Master_array), 6); % Index, Thumb, Wrist, Palm,Time, Grip Aperture
    handles.Raw_Velocity = zeros (length (handles.Master_array)-1,6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture
    handles.Raw_Accel = zeros (length(handles.Master_array)-2, 6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture

    handles.Resampled_SagPos = zeros(length(handles.Master_array), 6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture
    handles.Resampled_Velocity = zeros (length (handles.Master_array)-1,6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture
    handles.Resampled_Accel = zeros (length(handles.Master_array)-2, 6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture

    handles.Filtered_SagPos = zeros(length(handles.Master_array), 6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture
    handles.Filtered_Velocity = zeros (length (handles.Master_array)-1,6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture
    handles.Filtered_Accel = zeros (length(handles.Master_array)-2, 6); % Index, Thumb, Wrist, Palm, Time, Grip Aperture

    handles.Raw_XYZ = zeros(length(handles.Master_array), 11); % Index (XYZ), Thumb(XYZ), Time
    handles.Raw_Velocity_XYZ = zeros (length (handles.Master_array)-1,11); % Index, Thumb, Time
    handles.Raw_Accel_XYZ = zeros (length(handles.Master_array)-2, 11); % Index, Thumb,Time

    handles.Resampled_XYZ = zeros(length(handles.Master_array), 11); % Index (XYZ), Thumb(XYZ), Time
    handles.Resampled_Velocity_XYZ = zeros (length (handles.Master_array)-1,11); % Index, Thumb, Time
    handles.Resampled_Accel_XYZ = zeros (length(handles.Master_array)-2, 11); % Index, Thumb,Time

    handles.Filtered_XYZ = zeros(length(handles.Master_array), 11); % Index (XYZ), Thumb(XYZ), Time
    handles.Filtered_Velocity_XYZ = zeros (length (handles.Master_array)-1,11); % Index, Thumb, Time
    handles.Filtered_Accel_XYZ = zeros (length(handles.Master_array)-2, 11); % Index, Thumb,Time
else
    %Time, Index, Palm
    handles.Raw_SagPos = zeros(length(handles.Master_array), 3); 
    handles.Raw_Velocity = zeros (length (handles.Master_array)-1,3); 
    handles.Raw_Accel = zeros (length(handles.Master_array)-2, 3); 

    handles.Resampled_SagPos = zeros(length(handles.Master_array), 3); 
    handles.Resampled_Velocity = zeros (length (handles.Master_array)-1,3);
    handles.Resampled_Accel = zeros (length(handles.Master_array)-2, 3);

    handles.Filtered_SagPos = zeros(length(handles.Master_array), 3);
    handles.Filtered_Velocity = zeros (length (handles.Master_array)-1,3);
    handles.Filtered_Accel = zeros (length(handles.Master_array)-2, 3);
    
    %Time, Index (XYZ), Palm (XYZ)
    handles.Raw_XYZ = zeros(length(handles.Master_array), 7);
    handles.Raw_Velocity_XYZ = zeros (length (handles.Master_array)-1,7);
    handles.Raw_Accel_XYZ = zeros (length(handles.Master_array)-2, 7);

    handles.Resampled_XYZ = zeros(length(handles.Master_array), 7); 
    handles.Resampled_Velocity_XYZ = zeros (length (handles.Master_array)-1,7);
    handles.Resampled_Accel_XYZ = zeros (length(handles.Master_array)-2, 7);

    handles.Filtered_XYZ = zeros(length(handles.Master_array), 7);
    handles.Filtered_Velocity_XYZ = zeros (length (handles.Master_array)-1,7); 
    handles.Filtered_Accel_XYZ = zeros (length(handles.Master_array)-2, 7);
end
handles.Raw_disp = zeros(1,3);
handles.Vel_Tol = 0.02;
handles.VelEnd_Tol = 0.1;
handles.kin_array = zeros(1,13);
handles.variables = zeros (1,4);
h = findobj(0, 'tag', 'figure1');
handles.extract = 0;
handles.kin_var_select = 1;
handles.edited = 0;
handles.point= 0;
handles.curr_col = 1;

handles.Calibration_array = h(1).UserData;

index_x = 0;
index_y = 0;
index_z = 0;
if(size(handles.Calibration_array) ~= [0 0])
    %X, Y, Z coordinates of starting point
    index_x = handles.Calibration_array (1,1);
    index_y = handles.Calibration_array (1,2);
    index_z = handles.Calibration_array (1,3);
end
if(handles.system ==1)
        for i = 1: length(handles.Master_array(:,1))
            handles.Raw_SagPos(i,1) =  sqrt((handles.Master_array(i,1))^2 + (handles.Master_array(i,2)-index_y)^2 + (index_z-handles.Master_array(i,3))^2); %Index
            handles.Raw_SagPos(i,2) =  sqrt((handles.Master_array(i,7))^2 + (handles.Master_array(i,8)-index_y)^2 + (index_z-handles.Master_array(i,9))^2); %Thumb
            handles.Raw_SagPos(i,3) =  sqrt((handles.Master_array(i,10))^2 + (handles.Master_array(i,11)-index_y)^2 + (index_z-handles.Master_array(i,12))^2); %Wrist
            handles.Raw_SagPos(i,4) =  sqrt((handles.Master_array(i,4))^2 + (handles.Master_array(i,5)-index_y)^2 + (index_z-handles.Master_array(i,6))^2); %Palm
            handles.Raw_SagPos (i,5) = handles.Master_array(i,13);
            handles.Raw_SagPos (1,6) = sqrt((handles.Master_array(i,1)-handles.Master_array(i,7))^2 + (handles.Master_array(i,2)-handles.Master_array(i,8))^2 + (handles.Master_array(i,3)-handles.Master_array(1,9))^2);
            
            handles.Raw_XYZ (i,1) = handles.Master_array(i,1); %index position
            handles.Raw_XYZ (i,2) = handles.Master_array(i,2)-index_y;
            handles.Raw_XYZ (i,3) = index_z-handles.Master_array(i,3);
            handles.Raw_XYZ (i,4) = handles.Master_array(i,7); %Thumb position
            handles.Raw_XYZ (i,5) = handles.Master_array(i,8)-index_y;
            handles.Raw_XYZ (i,6) = index_z-handles.Master_array(i,9);
            handles.Raw_XYZ (i,7) = handles.Master_array(i,13); %time
            handles.Raw_XYZ (i,8) = sqrt((handles.Raw_XYZ(i,1)-handles.Raw_XYZ(i,4))^2); %Grip aperture (x)
            handles.Raw_XYZ (i,9) = sqrt((handles.Raw_XYZ(i,2)-handles.Raw_XYZ(1,5))^2); %Grip aperture (y)
            handles.Raw_XYZ (i,10) = sqrt((handles.Raw_XYZ(i,3)-handles.Raw_XYZ(i,6))^2);%Grip aperture (z)
            handles.Raw_XYZ (i,11) = sqrt((handles.Raw_XYZ(i,8))^2+(handles.Raw_XYZ(i,9))^2 + (handles.Raw_XYZ(i,10))^2);  
        end
      for i=1: (length(handles.Master_array)-1)
            indextemp_2 = sqrt(handles.Master_array(i+1,1)^2 + handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2); %index position
            indextemp_1 = sqrt(handles.Master_array(i,1)^2 + handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2);
            delta_time = handles.Master_array (i+1,13) - handles.Master_array(i,13);
            handles.Raw_Velocity (i,1) = (indextemp_2-indextemp_1)/delta_time;
            
            thumbtemp_2 = sqrt(handles.Master_array(i+1,7)^2 + handles.Master_array(i+1,8)^2 + handles.Master_array(i+1,9)^2); %Thumb position
            thumbtemp_1 = sqrt(handles.Master_array(i,7)^2 + handles.Master_array(i,8)^2 + handles.Master_array(i,9)^2);
            handles.Raw_Velocity (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time;
            
            wristtemp_2 = sqrt(handles.Master_array(i+1,10)^2 + handles.Master_array(i+1,11)^2 + handles.Master_array(i+1,12)^2); %Wrist position
            wristtemp_1 = sqrt(handles.Master_array(i,10)^2 + handles.Master_array(i,11)^2 + handles.Master_array(i,12)^2);
            handles.Raw_Velocity (i,3) = (wristtemp_2-wristtemp_1)/delta_time;
            
            palmtemp_2 = sqrt(handles.Master_array(i+1,4)^2 + handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2); %Palm position
            palmtemp_1 = sqrt(handles.Master_array(i,4)^2 + handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2);
            handles.Raw_Velocity (i,4) = (palmtemp_2-palmtemp_1)/delta_time;
         
            handles.Raw_Velocity(i,5) = (handles.Master_array (i,13)); %time
            handles.Raw_Velocity(i,6) = (handles.Raw_SagPos(i+1,6)-handles.Raw_SagPos(i,6))/delta_time;
            
            handles.Raw_Velocity_XYZ(i,1) = (handles.Raw_XYZ(i+1,1)-handles.Raw_XYZ(i,1))/delta_time; %index velocity X
            handles.Raw_Velocity_XYZ(i,2) = (handles.Raw_XYZ(i+1,2)-handles.Raw_XYZ(i,2))/delta_time; %index velocity Y
            handles.Raw_Velocity_XYZ(i,3) = (handles.Raw_XYZ(i+1,3)-handles.Raw_XYZ(i,3))/delta_time; %index velocity X
            handles.Raw_Velocity_XYZ(i,4) = (handles.Raw_XYZ(i+1,4)-handles.Raw_XYZ(i,4))/delta_time; %Thumb velocity X
            handles.Raw_Velocity_XYZ(i,5) = (handles.Raw_XYZ(i+1,5)-handles.Raw_XYZ(i,5))/delta_time; %Thumb velocity Y
            handles.Raw_Velocity_XYZ(i,6) = (handles.Raw_XYZ(i+1,6)-handles.Raw_XYZ(i,6))/delta_time; %Thumb velocity Z
            handles.Raw_Velocity_XYZ(i,7) = (handles.Master_array (i,13)); % time
            
            handles.Raw_Velocity_XYZ (i,8) = (handles.Raw_XYZ(i+1,8)-handles.Raw_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Raw_Velocity_XYZ (i,9) = (handles.Raw_XYZ(i+1,9)-handles.Raw_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Raw_Velocity_XYZ (i,10) = (handles.Raw_XYZ(i+1,10)-handles.Raw_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Raw_Velocity_XYZ (i,11) = (handles.Raw_XYZ(i+1,11)-handles.Raw_XYZ(i,11))/delta_time;
            
      end
        
        for i=1: (length(handles.Master_array)-2)
           
            indextemp_2 = handles.Raw_Velocity(i+1,1);
            indextemp_1 = handles.Raw_Velocity(i,1);
            delta_time = handles.Raw_Velocity (i+1,5) - handles.Raw_Velocity(i,5);
            handles.Raw_Accel (i,1) = (indextemp_2-indextemp_1)/delta_time *1000;
           
            thumbtemp_2 = handles.Raw_Velocity(i+1,2);
            thumbtemp_1 = handles.Raw_Velocity(i,2);
            handles.Raw_Accel (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time*1000;
            
            wristtemp_2 = handles.Raw_Velocity(i+1,3);
            wristtemp_1 = handles.Raw_Velocity(i,3);
            handles.Raw_Accel (i,3) = (wristtemp_2-wristtemp_1)/delta_time*1000;
            
            palmtemp_2 = handles.Raw_Velocity(i+1,4);
            palmtemp_1 = handles.Raw_Velocity(i,4);
            handles.Raw_Accel (i,4) = (palmtemp_2-palmtemp_1)/delta_time*1000;
            
            handles.Raw_Accel (i,5) = handles.Master_array (i,13);
            handles.Raw_Accel(i,6) = (handles.Raw_Velocity(i+1,6)-handles.Raw_Velocity(i))/delta_time*1000;
            
            handles.Raw_Accel_XYZ(i,1) = (handles.Raw_Velocity_XYZ(i+1,1)-handles.Raw_Velocity_XYZ(i,1))/delta_time *1000; %index accel X
            handles.Raw_Accel_XYZ(i,2) = (handles.Raw_Velocity_XYZ(i+1,2)-handles.Raw_Velocity_XYZ(i,2))/delta_time *1000;
            handles.Raw_Accel_XYZ(i,3) = (handles.Raw_Velocity_XYZ(i+1,3)-handles.Raw_Velocity_XYZ(i,3))/delta_time *1000;
            handles.Raw_Accel_XYZ(i,4) = (handles.Raw_Velocity_XYZ(i+1,4)-handles.Raw_Velocity_XYZ(i,4))/delta_time *1000;
            handles.Raw_Accel_XYZ(i,5) = (handles.Raw_Velocity_XYZ(i+1,5)-handles.Raw_Velocity_XYZ(i,5))/delta_time *1000;
            handles.Raw_Accel_XYZ(i,6) = (handles.Raw_Velocity_XYZ(i+1,6)-handles.Raw_Velocity_XYZ(i,6))/delta_time *1000;
            handles.Raw_Accel_XYZ (i,7) = handles.Master_array (i,13);
            
            handles.Raw_Accel_XYZ (i,8) = (handles.Raw_Velocity_XYZ(i+1,8)-handles.Raw_Velocity_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Raw_Accel_XYZ (i,9) = (handles.Raw_Velocity_XYZ(i+1,9)-handles.Raw_Velocity_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Raw_Accel_XYZ (i,10) = (handles.Raw_Velocity_XYZ(i+1,10)-handles.Raw_Velocity_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Raw_Accel_XYZ (i,11) = (handles.Raw_Velocity_XYZ(i+1,11)-handles.Raw_Velocity_XYZ(i,11))/delta_time;
        end
end
if(handles.system ==2)
    for (num =1: length(handles.Master_array(:,1)))
        handles.Raw_SagPos(i,2) = sqrt((handles.Master_array(i,2))^2 + (handles.Master_array(i,3)-index_y)^2 + (index_z-handles.Master_array(i,4))^2); %Index Sag Pos
        handles.Raw_SagPos(i,3) = sqrt((handles.Master_array(i,5))^2 + (handles.Master_array(i,6)-index_y)^2 + (index_z-handles.Master_array(i,7))^2); %Palm Sag Pos
        handles.Raw_SagPos(i,1) = (handles.Master_array(i,1)/handles.frequency)*1e3; %Time in ms
    
        handles.Raw_XYZ (i,1) = (handles.Master_array(i,1)/handles.frequency)*1e3;
        handles.Raw_XYZ (i,2) = handles.Master_array(i,2); %Index (x)
        handles.Raw_XYZ (i,3) = handles.Master_array(i,3); %(y)
        handles.Raw_XYZ (i,4) = handles.Master_array(i,4); %(z)
        handles.Raw_XYZ (i,5) = handles.Master_array(i,5); %Palm (x)
        handles.Raw_XYZ (i,6) = handles.Master_array(i,6); %(y)
        handles.Raw_XYZ (i,7) = handles.Master_array(i,7); %(z) 
    end
    for(num =1:length(handles.Master_array(:,1))-1)
        delta_time = handles.Raw_XYZ(i+1,1) - handles.Raw_XYZ(i,1);
        
        handles.Raw_Velocity(i,1) = handles.Raw_SagPos(i,1);
        indextemp_2 = sqrt(handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2 + handles.Master_array(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2 + handles.Master_array(i,4)^2);
        handles.Raw_Velocity (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2 + handles.Master_array(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2 + handles.Master_array(i,7)^2);
        handles.Raw_Velocity(i,3) = (palmtemp_2 - palmtemp_1) /delta_time;

        handles.Raw_Velocity_XYZ(i,1) = (handles.Raw_XYZ (i,1)); % time
        handles.Raw_Velocity_XYZ(i,2) = (handles.Raw_XYZ(i+1,2)-handles.Raw_XYZ(i,2))/delta_time; %index velocity X
        handles.Raw_Velocity_XYZ(i,3) = (handles.Raw_XYZ(i+1,3)-handles.Raw_XYZ(i,3))/delta_time; %index velocity Y
        handles.Raw_Velocity_XYZ(i,4) = (handles.Raw_XYZ(i+1,4)-handles.Raw_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Raw_Velocity_XYZ(i,5) = (handles.Raw_XYZ(i+1,5)-handles.Raw_XYZ(i,5))/delta_time; %palm velocity X
        handles.Raw_Velocity_XYZ(i,6) = (handles.Raw_XYZ(i+1,6)-handles.Raw_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Raw_Velocity_XYZ(i,7) = (handles.Raw_XYZ(i+1,7)-handles.Raw_XYZ(i,7))/delta_time; %palm velocity Z
    end
    for(num =1: length(handles.Master_array(:,1))-2)
        delta_time = handles.Raw_Velocity(i+1, 1) - handles.Raw_Velocity(i,1);
        
        handles.Raw_Accel(i,1) = handles.Raw_Velocity(i,1);
        indextemp_2 = sqrt(handles.Raw_Velocity(i+1,2)^2 + handles.Raw_Velocity(i+1,3)^2 + handles.Raw_Velocity(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Raw_Velocity(i,2)^2 + handles.Raw_Velocity(i,3)^2 + handles.Raw_Velocity(i,4)^2);
        handles.Raw_Accel (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Raw_Velocity(i+1,5)^2 + handles.Raw_Velocity(i+1,6)^2 + handles.Raw_Velocity(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Raw_Velocity(i,5)^2 + handles.Raw_Velocity(i,6)^2 + handles.Raw_Velocity(i,7)^2);
        handles.Raw_Accel (i,3) = (palmtemp_2 - palmtemp_1) /delta_time;
        
        handles.Raw_Accel_XYZ(i,1) = (handles.Raw_Velocity (i,1)); % time
        handles.Raw_Accel_XYZ(i,2) = (handles.Raw_Velocity_XYZ(i+1,2)-handles.Raw_Velocity_XYZ(i,2))/delta_time; %index velocity X
        handles.Raw_Accel_XYZ(i,3) = (handles.Raw_Velocity_XYZ(i+1,3)-handles.Raw_Velocity_XYZ(i,3))/delta_time; %index velocity Y
        handles.Raw_Accel_XYZ(i,4) = (handles.Raw_Velocity_XYZ(i+1,4)-handles.Raw_Velocity_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Raw_Accel_XYZ(i,5) = (handles.Raw_Velocity_XYZ(i+1,5)-handles.Raw_Velocity_XYZ(i,5))/delta_time; %palm velocity X
        handles.Raw_Accel_XYZ(i,6) = (handles.Raw_Velocity_XYZ(i+1,6)-handles.Raw_Velocity_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Raw_Accel_XYZ(i,7) = (handles.Raw_Velocity_XYZ(i+1,7)-handles.Raw_Velocity_XYZ(i,7))/delta_time; %palm velocity Z
    end
end
 
name = strcat('Trial # : ',num2str(handles.Trial_Num), ' Loaded');
set(handles.Trial_Num_Text, 'String',name);
handles.Raw_disp = zeros (1,3);

aCheckbox = findobj('Tag','Index_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Wrist_Accel_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
    
    axes(handles.Top_Graph);
        cla;
    axes(handles.Middle_Graph);
        cla;        
    axes(handles.Bottom_Graph);
        cla;   
        
        A = strcat('Trial #:', num2str(handles.Trial_Num));
set(handles.trial_num_edit,'String',A);

guidata(hObject,handles);
end

% --- Executes on button press in Resample_Button.
function Resample_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Resample_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[status, handles.Master_array] = resample(handles.system, handles.Resample_Rate, handles.Master_array);
if(status ==1)
    set(handles.warning_text, 'String','Warning: There is more than 30% of data missing from this trial.');
end
if(status ==2)
    set(handles.warning_text,'String','Warning: Please reject, there is no data in this trial.');
end
index_x = 0;
index_y = 0;
index_z = 0;

if(size(handles.Calibration_array) ~= [0 0])
    %X, Y, Z coordinates of starting point
    index_x = handles.Calibration_array (1,1);
    index_y = handles.Calibration_array (1,2);
    index_z = handles.Calibration_array (1,3);
end

if(handles.system==1)
        for i = 1: length(handles.Master_array(:,1))
            handles.Resampled_SagPos(i,1) =  sqrt((handles.Master_array(i,1))^2 + (handles.Master_array(i,2)-index_y)^2 + (index_z-handles.Master_array(i,3))^2); %Index
            handles.Resampled_SagPos(i,2) =  sqrt((handles.Master_array(i,7))^2 + (handles.Master_array(i,8)-index_y)^2 + (index_z-handles.Master_array(i,9))^2); %Thumb
            handles.Resampled_SagPos(i,3) =  sqrt((handles.Master_array(i,10))^2 + (handles.Master_array(i,11)-index_y)^2 + (index_z-handles.Master_array(i,12))^2); %Wrist
            handles.Resampled_SagPos(i,4) =  sqrt((handles.Master_array(i,4))^2 + (handles.Master_array(i,5)-index_y)^2 + (index_z-handles.Master_array(i,6))^2); %Palm
            handles.Resampled_SagPos(i,5) = handles.Master_array(i,13);
            handles.Resampled_SagPos(i,6) = sqrt((handles.Master_array(i,1)-handles.Master_array(i,7))^2 + (handles.Master_array(i,2)-handles.Master_array(i,8))^2 + (handles.Master_array(i,3)-handles.Master_array(1,9))^2);
            
            handles.Resampled_XYZ (i,1) = handles.Master_array(i,1); %index position
            handles.Resampled_XYZ (i,2) = handles.Master_array(i,2)-index_y;
            handles.Resampled_XYZ (i,3) = index_z-handles.Master_array(i,3);
            handles.Resampled_XYZ (i,4) = handles.Master_array(i,7); %Thumb position
            handles.Resampled_XYZ (i,5) = handles.Master_array(i,8)-index_y;
            handles.Resampled_XYZ (i,6) = index_z-handles.Master_array(i,9);
            handles.Resampled_XYZ (i,7) = handles.Master_array(i,13); %time

            handles.Resampled_XYZ (i,8) = sqrt((handles.Resampled_XYZ(i,1)-handles.Resampled_XYZ(i,4))^2); %Grip aperture (x)
            handles.Resampled_XYZ (i,9) = sqrt((handles.Resampled_XYZ(i,2)-handles.Resampled_XYZ(1,5))^2); %Grip aperture (y)
            handles.Resampled_XYZ (i,10) = sqrt((handles.Resampled_XYZ(i,3)-handles.Resampled_XYZ(i,6))^2);%Grip aperture (z)
            handles.Resampled_XYZ (i,11) = sqrt((handles.Resampled_XYZ(i,8))^2+(handles.Resampled_XYZ(i,9))^2 + (handles.Resampled_XYZ(i,10))^2);  
        end
        
        for i=1: (length(handles.Master_array)-1)
            indextemp_2 = sqrt(handles.Master_array(i+1,1)^2 + handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2); %index position
            indextemp_1 = sqrt(handles.Master_array(i,1)^2 + handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2);
            delta_time = handles.Master_array (i+1,13) - handles.Master_array(i,13);
            handles.Resampled_Velocity (i,1) = (indextemp_2-indextemp_1)/delta_time;
            
            thumbtemp_2 = sqrt(handles.Master_array(i+1,7)^2 + handles.Master_array(i+1,8)^2 + handles.Master_array(i+1,9)^2); %Thumb position
            thumbtemp_1 = sqrt(handles.Master_array(i,7)^2 + handles.Master_array(i,8)^2 + handles.Master_array(i,9)^2);
            handles.Resampled_Velocity (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time;
            
            wristtemp_2 = sqrt(handles.Master_array(i+1,10)^2 + handles.Master_array(i+1,11)^2 + handles.Master_array(i+1,12)^2); %Wrist position
            wristtemp_1 = sqrt(handles.Master_array(i,10)^2 + handles.Master_array(i,11)^2 + handles.Master_array(i,12)^2);
            handles.Resampled_Velocity (i,3) = (wristtemp_2-wristtemp_1)/delta_time;
            
            palmtemp_2 = sqrt(handles.Master_array(i+1,4)^2 + handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2); %Palm position
            palmtemp_1 = sqrt(handles.Master_array(i,4)^2 + handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2);
            handles.Resampled_Velocity (i,4) = (palmtemp_2-palmtemp_1)/delta_time;
         
            handles.Resampled_Velocity(i,5) = (handles.Master_array (i,13)); %time
            handles.Resampled_Velocity(i,6) = (handles.Resampled_SagPos(i+1,6)-handles.Resampled_SagPos(i,6))/delta_time;
            
             handles.Resampled_Velocity_XYZ(i,1) = (handles.Resampled_XYZ(i+1,1)-handles.Resampled_XYZ(i,1))/delta_time; %index velocity X
            handles.Resampled_Velocity_XYZ(i,2) = (handles.Resampled_XYZ(i+1,2)-handles.Resampled_XYZ(i,2))/delta_time; %index velocity Y
            handles.Resampled_Velocity_XYZ(i,3) = (handles.Resampled_XYZ(i+1,3)-handles.Resampled_XYZ(i,3))/delta_time; %index velocity X
            handles.Resampled_Velocity_XYZ(i,4) = (handles.Resampled_XYZ(i+1,4)-handles.Resampled_XYZ(i,4))/delta_time; %Thumb velocity X
            handles.Resampled_Velocity_XYZ(i,5) = (handles.Resampled_XYZ(i+1,5)-handles.Resampled_XYZ(i,5))/delta_time; %Thumb velocity Y
            handles.Resampled_Velocity_XYZ(i,6) = (handles.Resampled_XYZ(i+1,6)-handles.Resampled_XYZ(i,6))/delta_time; %Thumb velocity Z
            handles.Resampled_Velocity_XYZ(i,7) = (handles.Master_array (i,13)); % time
            
            handles.Resampled_Velocity_XYZ (i,8) = (handles.Resampled_XYZ(i+1,8)-handles.Resampled_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Resampled_Velocity_XYZ (i,9) = (handles.Resampled_XYZ(i+1,9)-handles.Resampled_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Resampled_Velocity_XYZ (i,10) = (handles.Resampled_XYZ(i+1,10)-handles.Resampled_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Resampled_Velocity_XYZ (i,11) = (handles.Resampled_XYZ(i+1,11)-handles.Resampled_XYZ(i,11))/delta_time;
        end
        
        for i=1: (length(handles.Master_array)-2)
           
            indextemp_2 = handles.Resampled_Velocity(i+1,1);
            indextemp_1 = handles.Resampled_Velocity(i,1);
            delta_time = handles.Resampled_Velocity (i+1,5) - handles.Resampled_Velocity(i,5);
            handles.Resampled_Accel (i,1) = (indextemp_2-indextemp_1)/delta_time*1000;
           
            thumbtemp_2 = handles.Resampled_Velocity(i+1,2);
            thumbtemp_1 = handles.Resampled_Velocity(i,2);
            handles.Resampled_Accel (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time*1000;
            
            wristtemp_2 = handles.Resampled_Velocity(i+1,3);
            wristtemp_1 = handles.Resampled_Velocity(i,3);
            handles.Resampled_Accel (i,3) = (wristtemp_2-wristtemp_1)/delta_time*1000;
            
            palmtemp_2 = handles.Resampled_Velocity(i+1,4);
            palmtemp_1 = handles.Resampled_Velocity(i,4);
            handles.Resampled_Accel (i,4) = (palmtemp_2-palmtemp_1)/delta_time*1000;
            
            handles.Resampled_Accel (i,5) = handles.Master_array (i,13);
            handles.Resampled_Accel(i,6) = (handles.Resampled_Velocity(i+1,6)-handles.Resampled_Velocity(i))/delta_time*1000;
            
            handles.Resampled_Accel_XYZ(i,1) = (handles.Resampled_Velocity_XYZ(i+1,1)-handles.Resampled_Velocity_XYZ(i,1))/delta_time *1000; %index accel X
            handles.Resampled_Accel_XYZ(i,2) = (handles.Resampled_Velocity_XYZ(i+1,2)-handles.Resampled_Velocity_XYZ(i,2))/delta_time *1000;
            handles.Resampled_Accel_XYZ(i,3) = (handles.Resampled_Velocity_XYZ(i+1,3)-handles.Resampled_Velocity_XYZ(i,3))/delta_time *1000;
            handles.Resampled_Accel_XYZ(i,4) = (handles.Resampled_Velocity_XYZ(i+1,4)-handles.Resampled_Velocity_XYZ(i,4))/delta_time *1000;
            handles.Resampled_Accel_XYZ(i,5) = (handles.Resampled_Velocity_XYZ(i+1,5)-handles.Resampled_Velocity_XYZ(i,5))/delta_time *1000;
            handles.Resampled_Accel_XYZ(i,6) = (handles.Resampled_Velocity_XYZ(i+1,6)-handles.Resampled_Velocity_XYZ(i,6))/delta_time *1000;
            handles.Resampled_Accel_XYZ (i,7) = handles.Master_array (i,13);
            
            handles.Resampled_Accel_XYZ (i,8) = (handles.Resampled_Velocity_XYZ(i+1,8)-handles.Resampled_Velocity_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Resampled_Accel_XYZ (i,9) = (handles.Resampled_Velocity_XYZ(i+1,9)-handles.Resampled_Velocity_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Resampled_Accel_XYZ (i,10) = (handles.Resampled_Velocity_XYZ(i+1,10)-handles.Resampled_Velocity_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Resampled_Accel_XYZ (i,11) = (handles.Resampled_Velocity_XYZ(i+1,11)-handles.Resampled_Velocity_XYZ(i,11))/delta_time;
            
        end
end
if(handles.system ==2)
    for (num =1: length(handles.Master_array(:,1)))
       
        handles.Resampled_SagPos(i,2) =  sqrt((handles.Master_array(i,2))^2 + (handles.Master_array(i,3)-index_y)^2 + (index_z-handles.Master_array(i,4))^2); %Index
        handles.Resampled_SagPos(i,3) =  sqrt((handles.Master_array(i,5))^2 + (handles.Master_array(i,6)-index_y)^2 + (index_z-handles.Master_array(i,7))^2); %Palm

        handles.Resampled_SagPos(i,1) = handles.Master_array(i,1); %Time
            
        handles.Resampled_XYZ (i,1) = (handles.Master_array(i,1)/handles.frequency)*1e3; %Time
        
        handles.Resampled_XYZ (i,2) = handles.Master_array(i,2); %Index (x)
        handles.Resampled_XYZ (i,3) = handles.Master_array(i,3); %(y)
        handles.Resampled_XYZ (i,4) = handles.Master_array(i,4); %(z)
        handles.Resampled_XYZ (i,5) = handles.Master_array(i,5); %Palm (x)
        handles.Resampled_XYZ (i,6) = handles.Master_array(i,6); %(y)
        handles.Resampled_XYZ (i,7) = handles.Master_array(i,7); %(z) 
    end
    for(num =1:length(handles.Master_array(:,1))-1)
        delta_time = handles.Resampled_XYZ(i+1,1) - handles.Resampled_XYZ(i,1);
        
        handles.Resampled_Velocity(i,1) = handles.Resampled_SagPos(i,1);
        indextemp_2 = sqrt(handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2 + handles.Master_array(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2 + handles.Master_array(i,4)^2);
        handles.Resampled_Velocity (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2 + handles.Master_array(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2 + handles.Master_array(i,7)^2);
        handles.Resampled_Velocity(i,3) = (palmtemp_2 - palmtemp_1) /delta_time;

        handles.Resampled_Velocity_XYZ(i,1) = (handles.Resampled_XYZ (i,1)); % time
        handles.Resampled_Velocity_XYZ(i,2) = (handles.Resampled_XYZ(i+1,2)-handles.Resampled_XYZ(i,2))/delta_time; %index velocity X
        handles.Resampled_Velocity_XYZ(i,3) = (handles.Resampled_XYZ(i+1,3)-handles.Resampled_XYZ(i,3))/delta_time; %index velocity Y
        handles.Resampled_Velocity_XYZ(i,4) = (handles.Resampled_XYZ(i+1,4)-handles.Resampled_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Resampled_Velocity_XYZ(i,5) = (handles.Resampled_XYZ(i+1,5)-handles.Resampled_XYZ(i,5))/delta_time; %palm velocity X
        handles.Resampled_Velocity_XYZ(i,6) = (handles.Resampled_XYZ(i+1,6)-handles.Resampled_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Resampled_Velocity_XYZ(i,7) = (handles.Resampled_XYZ(i+1,7)-handles.Resampled_XYZ(i,7))/delta_time; %palm velocity Z
    end
    for(num =1: length(handles.Master_array(:,1))-2)
        delta_time = handles.Resampled_Velocity(i+1, 1) - handles.Resampled_Velocity(i,1);
        
        handles.Resampled_Accel(i,1) = handles.Resampled_Velocity(i,1);
        indextemp_2 = sqrt(handles.Resampled_Velocity(i+1,2)^2 + handles.Resampled_Velocity(i+1,3)^2 + handles.Resampled_Velocity(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Resampled_Velocity(i,2)^2 + handles.Resampled_Velocity(i,3)^2 + handles.Resampled_Velocity(i,4)^2);
        handles.Resampled_Accel (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Resampled_Velocity(i+1,5)^2 + handles.Resampled_Velocity(i+1,6)^2 + handles.Resampled_Velocity(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Resampled_Velocity(i,5)^2 + handles.Resampled_Velocity(i,6)^2 + handles.Resampled_Velocity(i,7)^2);
        handles.Resampled_Accel (i,3) = (palmtemp_2 - palmtemp_1) /delta_time;
        
        handles.Resampled_Accel_XYZ(i,1) = (handles.Resampled_Velocity (i,1)); % time
        handles.Resampled_Accel_XYZ(i,2) = (handles.Resampled_Velocity_XYZ(i+1,2)-handles.Resampled_Velocity_XYZ(i,2))/delta_time; %index velocity X
        handles.Resampled_Accel_XYZ(i,3) = (handles.Resampled_Velocity_XYZ(i+1,3)-handles.Resampled_Velocity_XYZ(i,3))/delta_time; %index velocity Y
        handles.Resampled_Accel_XYZ(i,4) = (handles.Resampled_Velocity_XYZ(i+1,4)-handles.Resampled_Velocity_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Resampled_Accel_XYZ(i,5) = (handles.Resampled_Velocity_XYZ(i+1,5)-handles.Resampled_Velocity_XYZ(i,5))/delta_time; %palm velocity X
        handles.Resampled_Accel_XYZ(i,6) = (handles.Resampled_Velocity_XYZ(i+1,6)-handles.Resampled_Velocity_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Resampled_Accel_XYZ(i,7) = (handles.Resampled_Velocity_XYZ(i+1,7)-handles.Resampled_Velocity_XYZ(i,7))/delta_time; %palm velocity Z
    end

end

%Get rid of all unfilled data spaces in arrays
handles.Resampled_SagPos(all(handles.Resampled_SagPos==0,2),:)=[];
handles.Resampled_Velocity(all(handles.Resampled_Velocity==0,2),:)=[];
handles.Resampled_Accel(all(handles.Resampled_Accel==0,2),:)=[];
handles.Resampled_XYZ(all(handles.Resampled_XYZ==0,2),:)=[];
handles.Resampled_Velocity_XYZ(all(handles.Resampled_Velocity_XYZ==0,2),:)=[];
handles.Resampled_Accel_XYZ(all(handles.Resampled_Accel_XYZ == 0,2),:) =[];

name = strcat('Trial # : ',num2str(handles.Trial_Num), ' Resampled at: ', num2str(handles.Resample_Rate), ' Hz');
set(handles.Trial_Num_Text, 'String',name);
handles.extract =0;

guidata(hObject, handles);

end

% --- Executes on button press in Filter_Button.
function Filter_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Master_array = filter_resampled_data (handles.system, handles.Resample_Rate, handles.Cutoff_Freq, handles.Master_array);

index_x = 0;
index_y = 0;
index_z = 0;

if(size(handles.Calibration_array) ~= [0 0])
    %X, Y, Z coordinates of starting point
    index_x = handles.Calibration_array (1,1);
    index_y = handles.Calibration_array (1,2);
    index_z = handles.Calibration_array (1,3);
end

if (handles.system ==1)
        for i = 1: length(handles.Master_array(:,1))
            handles.Filtered_SagPos(i,1) =  sqrt((handles.Master_array(i,1))^2 + (handles.Master_array(i,2)-index_y)^2 + (index_z-handles.Master_array(i,3))^2); %Index
            handles.Filtered_SagPos(i,2) =  sqrt((handles.Master_array(i,7))^2 + (handles.Master_array(i,8)-index_y)^2 + (index_z-handles.Master_array(i,9))^2); %Thumb
            handles.Filtered_SagPos(i,3) =  sqrt((handles.Master_array(i,10))^2 + (handles.Master_array(i,11)-index_y)^2 + (index_z-handles.Master_array(i,12))^2); %Wrist
            handles.Filtered_SagPos(i,4) =  sqrt((handles.Master_array(i,4))^2 + (handles.Master_array(i,5)-index_y)^2 + (index_z-handles.Master_array(i,6))^2); %Palm
            handles.Filtered_SagPos(i,5) = handles.Master_array(i,13);
            handles.Filtered_SagPos (i,6) = sqrt((handles.Master_array(i,1)-handles.Master_array(i,7))^2 + (handles.Master_array(i,2)-handles.Master_array(i,8))^2 + (handles.Master_array(i,3)-handles.Master_array(1,9))^2);
        
            handles.Filtered_XYZ (i,1) = handles.Master_array(i,1); %index position
        handles.Filtered_XYZ (i,2) = handles.Master_array(i,2)-index_y;
        handles.Filtered_XYZ (i,3) = index_z-handles.Master_array(i,3);
        handles.Filtered_XYZ (i,4) = handles.Master_array(i,7); %Thumb position
        handles.Filtered_XYZ (i,5) = handles.Master_array(i,8)-index_y;
        handles.Filtered_XYZ (i,6) = index_z-handles.Master_array(i,9);
        handles.Filtered_XYZ (i,7) = handles.Master_array(i,13); %time
        
        handles.Filtered_XYZ (i,8) = sqrt((handles.Filtered_XYZ(i,1)-handles.Filtered_XYZ(i,4))^2); %Grip aperture (x)
        handles.Filtered_XYZ (i,9) = sqrt((handles.Filtered_XYZ(i,2)-handles.Filtered_XYZ(1,5))^2); %Grip aperture (y)
        handles.Filtered_XYZ (i,10) = sqrt((handles.Filtered_XYZ(i,3)-handles.Filtered_XYZ(i,6))^2);%Grip aperture (z)
        handles.Filtered_XYZ (i,11) = sqrt((handles.Filtered_XYZ(i,8))^2+(handles.Filtered_XYZ(i,9))^2 + (handles.Filtered_XYZ(i,10))^2);  
        end
        for i=1: (length(handles.Master_array(:,1))-1)
            indextemp_2 = sqrt(handles.Master_array(i+1,1)^2 + handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2); %index position
            indextemp_1 = sqrt(handles.Master_array(i,1)^2 + handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2);
            delta_time = handles.Master_array (i+1,13) - handles.Master_array(i,13);
            handles.Filtered_Velocity (i,1) = (indextemp_2-indextemp_1)/delta_time;
            
            thumbtemp_2 = sqrt(handles.Master_array(i+1,7)^2 + handles.Master_array(i+1,8)^2 + handles.Master_array(i+1,9)^2); %Thumb position
            thumbtemp_1 = sqrt(handles.Master_array(i,7)^2 + handles.Master_array(i,8)^2 + handles.Master_array(i,9)^2);
            handles.Filtered_Velocity (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time;
            
            wristtemp_2 = sqrt(handles.Master_array(i+1,10)^2 + handles.Master_array(i+1,11)^2 + handles.Master_array(i+1,12)^2); %Wrist position
            wristtemp_1 = sqrt(handles.Master_array(i,10)^2 + handles.Master_array(i,11)^2 + handles.Master_array(i,12)^2);
            handles.Filtered_Velocity (i,3) = (wristtemp_2-wristtemp_1)/delta_time;
            
            palmtemp_2 = sqrt(handles.Master_array(i+1,4)^2 + handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2); %Palm position
            palmtemp_1 = sqrt(handles.Master_array(i,4)^2 + handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2);
            handles.Filtered_Velocity (i,4) = (palmtemp_2-palmtemp_1)/delta_time;
         
            handles.Filtered_Velocity(i,5) = (handles.Master_array (i,13)); %time
            handles.Filtered_Velocity(i,6) = (handles.Filtered_SagPos(i+1,6)-handles.Filtered_SagPos(i,6))/delta_time; %Grip Aperture
            
            handles.Filtered_Velocity_XYZ(i,1) = (handles.Filtered_XYZ(i+1,1)-handles.Filtered_XYZ(i,1))/delta_time; %index velocity X
            handles.Filtered_Velocity_XYZ(i,2) = (handles.Filtered_XYZ(i+1,2)-handles.Filtered_XYZ(i,2))/delta_time; %index velocity Y
            handles.Filtered_Velocity_XYZ(i,3) = (handles.Filtered_XYZ(i+1,3)-handles.Filtered_XYZ(i,3))/delta_time; %index velocity X
            handles.Filtered_Velocity_XYZ(i,4) = (handles.Filtered_XYZ(i+1,4)-handles.Filtered_XYZ(i,4))/delta_time; %Thumb velocity X
            handles.Filtered_Velocity_XYZ(i,5) = (handles.Filtered_XYZ(i+1,5)-handles.Filtered_XYZ(i,5))/delta_time; %Thumb velocity Y
            handles.Filtered_Velocity_XYZ(i,6) = (handles.Filtered_XYZ(i+1,6)-handles.Filtered_XYZ(i,6))/delta_time; %Thumb velocity Z
            handles.Filtered_Velocity_XYZ(i,7) = (handles.Master_array (i,13)); % time
            
            handles.Filtered_Velocity_XYZ (i,8) = (handles.Filtered_XYZ(i+1,8)-handles.Filtered_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Filtered_Velocity_XYZ (i,9) = (handles.Filtered_XYZ(i+1,9)-handles.Filtered_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Filtered_Velocity_XYZ (i,10) = (handles.Filtered_XYZ(i+1,10)-handles.Filtered_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Filtered_Velocity_XYZ (i,11) =(handles.Filtered_XYZ(i+1,11)-handles.Filtered_XYZ(i,11))/delta_time;
        end
        
        for i=1: (length(handles.Master_array(:,1))-2)
           
            indextemp_2 = handles.Filtered_Velocity(i+1,1);
            indextemp_1 = handles.Filtered_Velocity(i,1);
            delta_time = handles.Filtered_Velocity (i+1,5) - handles.Filtered_Velocity(i,5);
            handles.Filtered_Accel (i,1) = (indextemp_2-indextemp_1)/delta_time*1000;
           
            thumbtemp_2 = handles.Filtered_Velocity(i+1,2);
            thumbtemp_1 = handles.Filtered_Velocity(i,2);
            handles.Filtered_Accel (i,2) = (thumbtemp_2-thumbtemp_1)/delta_time*1000;
            
            wristtemp_2 = handles.Filtered_Velocity(i+1,3);
            wristtemp_1 = handles.Filtered_Velocity(i,3);
            handles.Filtered_Accel (i,3) = (wristtemp_2-wristtemp_1)/delta_time*1000;
            
            palmtemp_2 = handles.Filtered_Velocity(i+1,4);
            palmtemp_1 = handles.Filtered_Velocity(i,4);
            handles.Filtered_Accel (i,4) = (palmtemp_2-palmtemp_1)/delta_time*1000;
            
            handles.Filtered_Accel (i,5) = handles.Master_array (i,13);
            handles.Filtered_Accel(i,6) = (handles.Filtered_Velocity(i+1,6)-handles.Filtered_Velocity(i))/delta_time*1000;
            
            handles.Filtered_Accel_XYZ(i,1) = (handles.Filtered_Velocity_XYZ(i+1,1)-handles.Filtered_Velocity_XYZ(i,1))/delta_time *1000; %index accel X
            handles.Filtered_Accel_XYZ(i,2) = (handles.Filtered_Velocity_XYZ(i+1,2)-handles.Filtered_Velocity_XYZ(i,2))/delta_time *1000;
            handles.Filtered_Accel_XYZ(i,3) = (handles.Filtered_Velocity_XYZ(i+1,3)-handles.Filtered_Velocity_XYZ(i,3))/delta_time *1000;
            handles.Filtered_Accel_XYZ(i,4) = (handles.Filtered_Velocity_XYZ(i+1,4)-handles.Filtered_Velocity_XYZ(i,4))/delta_time *1000;
            handles.Filtered_Accel_XYZ(i,5) = (handles.Filtered_Velocity_XYZ(i+1,5)-handles.Filtered_Velocity_XYZ(i,5))/delta_time *1000;
            handles.Filtered_Accel_XYZ(i,6) = (handles.Filtered_Velocity_XYZ(i+1,6)-handles.Filtered_Velocity_XYZ(i,6))/delta_time *1000;
            handles.Filtered_Accel_XYZ (i,7) = handles.Master_array (i,13);
            
            handles.Filtered_Accel_XYZ (i,8) = (handles.Filtered_Velocity_XYZ(i+1,8)-handles.Filtered_Velocity_XYZ(i,8))/delta_time; %Grip aperture velocity (x)
            handles.Filtered_Accel_XYZ (i,9) = (handles.Filtered_Velocity_XYZ(i+1,9)-handles.Filtered_Velocity_XYZ(i,9))/delta_time; %Grip aperture velocity(y)
            handles.Filtered_Accel_XYZ (i,10) = (handles.Filtered_Velocity_XYZ(i+1,10)-handles.Filtered_Velocity_XYZ(i,10))/delta_time;%Grip aperture velocity(z)
            handles.Filtered_Accel_XYZ (i,11) = (handles.Filtered_Velocity_XYZ(i+1,11)-handles.Filtered_Velocity_XYZ(i,11))/delta_time;
        end
end
if(handles.system ==2)
    for (num =1: length(handles.Master_array(:,1)))
       
        handles.Filtered_SagPos(i,2) =  sqrt((handles.Master_array(i,2))^2 + (handles.Master_array(i,3)-index_y)^2 + (index_z-handles.Master_array(i,4))^2); %Index
        handles.Filtered_SagPos(i,3) =  sqrt((handles.Master_array(i,5))^2 + (handles.Master_array(i,6)-index_y)^2 + (index_z-handles.Master_array(i,7))^2); %Palm

        handles.Filtered_SagPos(i,1) = handles.Master_array(i,1); %Time
            
        handles.Filtered_XYZ (i,1) = (handles.Master_array(i,1)/handles.frequency)*1e3; %Time
        
        handles.Filtered_XYZ (i,2) = handles.Master_array(i,2); %Index (x)
        handles.Filtered_XYZ (i,3) = handles.Master_array(i,3); %(y)
        handles.Filtered_XYZ (i,4) = handles.Master_array(i,4); %(z)
        handles.Filtered_XYZ (i,5) = handles.Master_array(i,5); %Palm (x)
        handles.Filtered_XYZ (i,6) = handles.Master_array(i,6); %(y)
        handles.Filtered_XYZ (i,7) = handles.Master_array(i,7); %(z) 
    end
    for(num =1:length(handles.Master_array(:,1))-1)
        delta_time = handles.Filtered_XYZ(i+1,1) - handles.Filtered_XYZ(i,1);
        
        handles.Filtered_Velocity(i,1) = handles.Filtered_SagPos(i,1);
        indextemp_2 = sqrt(handles.Master_array(i+1,2)^2 + handles.Master_array(i+1,3)^2 + handles.Master_array(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Master_array(i,2)^2 + handles.Master_array(i,3)^2 + handles.Master_array(i,4)^2);
        handles.Filtered_Velocity (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Master_array(i+1,5)^2 + handles.Master_array(i+1,6)^2 + handles.Master_array(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Master_array(i,5)^2 + handles.Master_array(i,6)^2 + handles.Master_array(i,7)^2);
        handles.Filtered_Velocity(i,3) = (palmtemp_2 - palmtemp_1) /delta_time;

        handles.Filtered_Velocity_XYZ(i,1) = (handles.Filtered_XYZ (i,1)); % time
        handles.Filtered_Velocity_XYZ(i,2) = (handles.Filtered_XYZ(i+1,2)-handles.Filtered_XYZ(i,2))/delta_time; %index velocity X
        handles.Filtered_Velocity_XYZ(i,3) = (handles.Filtered_XYZ(i+1,3)-handles.Filtered_XYZ(i,3))/delta_time; %index velocity Y
        handles.Filtered_Velocity_XYZ(i,4) = (handles.Filtered_XYZ(i+1,4)-handles.Filtered_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Filtered_Velocity_XYZ(i,5) = (handles.Filtered_XYZ(i+1,5)-handles.Filtered_XYZ(i,5))/delta_time; %palm velocity X
        handles.Filtered_Velocity_XYZ(i,6) = (handles.Filtered_XYZ(i+1,6)-handles.Filtered_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Filtered_Velocity_XYZ(i,7) = (handles.Filtered_XYZ(i+1,7)-handles.Filtered_XYZ(i,7))/delta_time; %palm velocity Z
    end
    for(num =1: length(handles.Master_array(:,1))-2)
        delta_time = handles.Filtered_Velocity(i+1, 1) - handles.Filtered_Velocity(i,1);
        
        handles.Filtered_Accel(i,1) = handles.Filtered_Velocity(i,1);
        indextemp_2 = sqrt(handles.Filtered_Velocity(i+1,2)^2 + handles.Filtered_Velocity(i+1,3)^2 + handles.Filtered_Velocity(i+1,4)^2); %index position
        indextemp_1 = sqrt(handles.Filtered_Velocity(i,2)^2 + handles.Filtered_Velocity(i,3)^2 + handles.Filtered_Velocity(i,4)^2);
        handles.Filtered_Accel (i,2) = (indextemp_2-indextemp_1)/delta_time;   
        palmtemp_2 = sqrt(handles.Filtered_Velocity(i+1,5)^2 + handles.Filtered_Velocity(i+1,6)^2 + handles.Filtered_Velocity(i+1,7)^2); %palm position
        palmtemp_1 = sqrt(handles.Filtered_Velocity(i,5)^2 + handles.Filtered_Velocity(i,6)^2 + handles.Filtered_Velocity(i,7)^2);
        handles.Filtered_Accel (i,3) = (palmtemp_2 - palmtemp_1) /delta_time;
        
        handles.Filtered_Accel_XYZ(i,1) = (handles.Filtered_Velocity (i,1)); % time
        handles.Filtered_Accel_XYZ(i,2) = (handles.Filtered_Velocity_XYZ(i+1,2)-handles.Filtered_Velocity_XYZ(i,2))/delta_time; %index velocity X
        handles.Filtered_Accel_XYZ(i,3) = (handles.Filtered_Velocity_XYZ(i+1,3)-handles.Filtered_Velocity_XYZ(i,3))/delta_time; %index velocity Y
        handles.Filtered_Accel_XYZ(i,4) = (handles.Filtered_Velocity_XYZ(i+1,4)-handles.Filtered_Velocity_XYZ(i,4))/delta_time; %index velocity Z
        
        handles.Filtered_Accel_XYZ(i,5) = (handles.Filtered_Velocity_XYZ(i+1,5)-handles.Filtered_Velocity_XYZ(i,5))/delta_time; %palm velocity X
        handles.Filtered_Accel_XYZ(i,6) = (handles.Filtered_Velocity_XYZ(i+1,6)-handles.Filtered_Velocity_XYZ(i,6))/delta_time; %palm velocity Y
        handles.Filtered_Accel_XYZ(i,7) = (handles.Filtered_Velocity_XYZ(i+1,7)-handles.Filtered_Velocity_XYZ(i,7))/delta_time; %palm velocity Z
    end

end

%Get rid of all unfilled data spaces in arrays
handles.Filtered_SagPos(all(handles.Filtered_SagPos==0,2),:)=[];
handles.Filtered_Velocity(all(handles.Filtered_Velocity==0,2),:)=[];
handles.Filtered_Accel(all(handles.Filtered_Accel==0,2),:)=[];
handles.Filtered_XYZ(all(handles.Filtered_XYZ==0,2),:)=[];
handles.Filtered_Velocity_XYZ(all(handles.Filtered_Velocity_XYZ==0,2),:)=[];
handles.Filtered_Accel_XYZ(all(handles.Filtered_Accel_XYZ == 0,2),:) =[];
    
handles.extract = 0;

name = strcat('Trial # : ',num2str(handles.Trial_Num), ' Filtered with: ', num2str(handles.Cutoff_Freq), ' Hz');
set(handles.Trial_Num_Text, 'String',name);

guidata(hObject, handles);
end


% --- Executes on button press in Calibration_Button.
function Calibration_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Calibration_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Calibration_gui;
% 
% handles.Calibration_array = findobj('Calibration_array','Calibration_gui');

hMainGui = getappdata(0, 'hMainGui');
Calibration_gui;
cal = getappdata(hMainGui, 'cal');
handles.Calibration_array = cal;

guidata(hObject, handles);
end

function updateCal

hMainGui = getappdata(0, 'hMainGui');
cal = getappdata(hMainGui, 'cal');
h = findobj(0, 'tag', 'figure1');
h(2).UserData = cal;
hf=findobj('Name','Calibration_gui');
close(hf);

end

function Resample_Rate_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Resample_Rate_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Resample_Rate_Edit as text
%        str2double(get(hObject,'String')) returns contents of Resample_Rate_Edit as a double
handles.Resample_Rate =  str2double(get(hObject,'String'));
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function Resample_Rate_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Resample_Rate_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.Resample_Rate = 50; %Pre-Set Resample Rate
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function Calibration_Button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Calibration_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

end


% --- Executes during object creation, after setting all properties.
function Index_SagPos_Check_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Index_SagPos_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

end


% --- Executes on button press in Kin_Var_Extract.
function Kin_Var_Extract_Callback(hObject, eventdata, handles)
% hObject    handle to Kin_Var_Extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;   
%Extract the kinematic variables

% peak velocity
% Time to peak velocity (percent of total time)
% peak Accel
% Time to peak acceleration (percent of total time)
% total time
% error (how off the x,y and z values are from the calibration points)
if(handles.system ==1)
    if(handles.extract == 0 && handles.point ==0)%Pointing
        handles.kin_array = zeros (1,56);
        handles.kin_array = KinVal_Extract (handles.Resample_Rate, handles.point, handles.VelEnd_Tol, handles.Vel_Tol, handles.Filtered_XYZ, handles.Filtered_Velocity_XYZ, handles.Filtered_Accel_XYZ,handles.Filtered_SagPos, handles.Filtered_Velocity, handles.Filtered_Accel, handles.vec_vel,handles.th_vec_vel, 0);
        handles.extract =1;
    end

    if(handles.extract == 0 && handles.point == 1) %Grasping
        handles.kin_array = zeros (1,32);
        input_array = [handles.Vel_Tol, handles.VelEnd_Tol, handles.obj_dia, handles.obj_dist, handles.obj_height];
        handles.kin_array = KinVal_Extract (handles.Resample_Rate, handles.point, handles.VelEnd_Tol, handles.Filtered_XYZ, handles.Filtered_SagPos, handles.Filtered_Velocity, handles.Filtered_Accel,0,0,0,handles.vec_vel,handles.th_vec_vel, input_array);
        handles.extract =1;
    end


    if(handles.point ==0)    
       if (get(handles.Index_XYZ_Check,'Value') == get(handles.Index_XYZ_Check,'Max')) %changing Index kin vars
            axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,1), '-r');
            hold on;
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,2), '-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,3), '-b');

            plot(handles.Filtered_XYZ(handles.kin_array(1,1),7), handles.Filtered_XYZ(handles.kin_array(1,1),1), 'or'); %Movement start X outgoing
            plot(handles.Filtered_XYZ(handles.kin_array(1,2),7), handles.Filtered_XYZ(handles.kin_array(1,2),2), 'og'); %Movement start Y outgoing
            plot(handles.Filtered_XYZ(handles.kin_array(1,3),7), handles.Filtered_XYZ(handles.kin_array(1,3),3), 'ob'); %Movement start Z outgoing

            plot(handles.Filtered_XYZ(handles.kin_array(1,7),7), handles.Filtered_XYZ(handles.kin_array(1,7),1), 'squarer'); %Movement end X outgoing
            plot(handles.Filtered_XYZ(handles.kin_array(1,8),7), handles.Filtered_XYZ(handles.kin_array(1,8),2), 'squareg'); %Movement end Y outgoing
            plot(handles.Filtered_XYZ(handles.kin_array(1,9),7), handles.Filtered_XYZ(handles.kin_array(1,9),3), 'squareb'); %Movement end Z outgoing
            
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,1), '-r'); 
            hold on;
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,2), '-g'); 
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,3), '-b'); 

            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,13),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,13),1), 'squarer'); % Peak velocity index X
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,14),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,14),2), 'squareg'); % Peak velocity index y
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),3), 'squareb'); % Peak velocity index z

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,1),'-r');
            hold on;
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,2),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,3),'-b');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,19),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,19),1),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,20),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,20),2),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,21),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,21),3),'squareb');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,25),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,25),1),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,26),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,26),2),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,27),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,27),3),'squareb');
       end

       if (get(handles.Thumb_XYZ_Check,'Value') == get(handles.Thumb_XYZ_Check,'Max')) %changing Thumb kin vars

           axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,4), '-r');
            hold on;
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,5), '-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,6), '-b');

            plot(handles.Filtered_XYZ(handles.kin_array(1,4),7), handles.Filtered_XYZ(handles.kin_array(1,4),4), 'or'); %Movement start X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,5),7), handles.Filtered_XYZ(handles.kin_array(1,5),5), 'og'); %Movement start Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,6),7), handles.Filtered_XYZ(handles.kin_array(1,6),6), 'ob'); %Movement start Z outgoing

             plot(handles.Filtered_XYZ(handles.kin_array(1,10),7), handles.Filtered_XYZ(handles.kin_array(1,10),4), 'squarer'); %Movement end X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,11),7), handles.Filtered_XYZ(handles.kin_array(1,11),5), 'squareg'); %Movement end Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,12),7), handles.Filtered_XYZ(handles.kin_array(1,12),6), 'squareb'); %Movement end Z outgoing
           
                         
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,4), '-r'); 
            hold on;
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,5), '-g'); 
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,6), '-b'); 

            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,16),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,16),4), 'squarer'); % Peak velocity index X
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,17),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,17),5), 'squareg'); % Peak velocity index y
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,18),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,18),6), 'squareb'); % Peak velocity index z

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,4),'-r');
            hold on;
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,5),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,6),'-b');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,22),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,22),4),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,23),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,23),5),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,24),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,24),6),'squareb');
            
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,28),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,28),4),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,29),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,29),5),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,30),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,30),6),'squareb');
       end
      
       if (get(handles.Index_Accel_Check,'Value') == get(handles.Index_Accel_Check,'Max')) %changing Index Vector kin vars
            axes(handles.Top_Graph);
            plot(handles.Filtered_SagPos(:,5), handles.Filtered_SagPos(:,1), '-r');
            hold on;

            plot(handles.Filtered_SagPos(handles.kin_array(1,1),5), handles.Filtered_SagPos(handles.kin_array(1,1),1), 'or'); %Movement start 
            plot(handles.Filtered_SagPos(handles.kin_array(1,7),5), handles.Filtered_SagPos(handles.kin_array(1,7),1), 'or'); %Movement end
            
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity(:,5), handles.Filtered_Velocity(:,1),'-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,31),5),handles.Filtered_Velocity(handles.kin_array(1,31),1),'or');
      end
       if (get(handles.Thumb_Accel_Check,'Value') == get(handles.Thumb_Accel_Check,'Max')) %changing Thumb Vector kin vars
         	axes(handles.Top_Graph);
            plot(handles.Filtered_SagPos(:,5), handles.Filtered_SagPos(:,2), '-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,4),5), handles.Filtered_SagPos(handles.kin_array(1,4),2), 'or'); %Movement start 
            plot(handles.Filtered_SagPos(handles.kin_array(1,10),5), handles.Filtered_SagPos(handles.kin_array(1,10),2), 'or'); %Movement end
            
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity(:,5), handles.Filtered_Velocity(:,2),'-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,32),5),handles.Filtered_Velocity(handles.kin_array(1,32),2),'or');
       end
    end
        if(handles.point ==1)%Grasping
            axes(handles.Top_Graph);
            %handles.Filtered_XYZ(:,11)
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,11), '-r');
            hold on;

            plot(handles.Filtered_XYZ(handles.kin_array(1,1),7), handles.Filtered_XYZ(handles.kin_array(1,1),11),'squarer');
        end
end
guidata(hObject,handles);
end


% --- Executes on button press in Reject_Trial_Button.
function Reject_Trial_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Reject_Trial_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output_array = [nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan];
xlswrite(handles.events_filename,output_array,1,strcat('H', num2str(handles.Trial_Num +1)));
str = strcat('Trial #: ', num2str(handles.Trial_Num),' was rejected.');
set(handles.Trial_Num_Text, 'String',str);

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;    
  aCheckbox = findobj('Tag','Index_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Wrist_Accel_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
set(handles.Resample_Radio,'Value',0);
set(handles.Raw_Radio,'Value',0);
set(handles.Filter_Radio,'Value',0);
end


% --- Executes during object creation, after setting all properties.
function Trial_Num_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trial_Num_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Trial_Num_Text.
function Trial_Num_Text_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Trial_Num_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in Raw_Radio.
function Raw_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Raw_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Raw_Radio
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.Raw_disp (1,1) = 1;
end

if (get(hObject,'Value') == get(hObject,'Min'))
    handles.Raw_disp (1,1) = 0;
end
guidata(hObject, handles);
end

% --- Executes on button press in Resample_Radio.
function Resample_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Resample_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Resample_Radio

if (get(hObject,'Value') == get(hObject,'Max'))
    handles.Raw_disp (1,2) = 1;
end

if (get(hObject,'Value') == get(hObject,'Min'))
    handles.Raw_disp (1,2) = 0;
end
guidata(hObject, handles);
end

% --- Executes on button press in Filter_Radio.
function Filter_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Filter_Radio
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.Raw_disp (1,3) = 1;
end

if (get(hObject,'Value') == get(hObject,'Min'))
    handles.Raw_disp (1,3) = 0;
end
guidata(hObject, handles);
end


% --- Executes on button press in Grip_Aperture_Check.
function Grip_Aperture_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Grip_Aperture_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Grip_Aperture_Check

axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;        

 if (get(hObject,'Value') == get(hObject,'Max')) %Checkbox is selected
     
     if (handles.Raw_disp (1,1) ==1) %plot Raw Values 
        axes(handles.Top_Graph);
        plot(handles.Raw_XYZ(:,7), handles.Raw_XYZ(:,11), '-r');
        ylabel(handles.Top_Graph,'Grasp Aperture (mm)');
        
        axes(handles.Middle_Graph);
        plot(handles.Raw_Velocity_XYZ (:,7), handles.Raw_Velocity_XYZ(:,11), '-r');
        
        axes(handles.Bottom_Graph);
        plot(handles.Raw_Accel_XYZ (:,7), handles.Raw_Accel_XYZ(:,11), '-r');
     end
     
     if (handles.Raw_disp (1,2) ==1) %plot Resampled Values 
        axes(handles.Top_Graph);
        plot(handles.Resampled_XYZ (:,7), handles.Resampled_XYZ(:,11), '-g');
        
        axes(handles.Middle_Graph);
        plot(handles.Resampled_Velocity_XYZ (:,7), handles.Resampled_Velocity_XYZ(:,11), '-g');
        
        axes(handles.Bottom_Graph);
        plot(handles.Resampled_Accel_XYZ (:,7), handles.Resampled_Accel_XYZ(:,11), '-g');
     end
     
     if (handles.Raw_disp(1,3) ==1) %plot Filtered Values 
        axes(handles.Top_Graph);
        plot(handles.Filtered_XYZ (:,7), handles.Filtered_XYZ(:,11), '-b');
        
        axes(handles.Middle_Graph);
        plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,11), '-b');
        
        axes(handles.Bottom_Graph);
        plot(handles.Filtered_Accel_XYZ (:,7), handles.Filtered_Accel_XYZ(:,11), '-b');
     end
    
    aCheckbox = findobj('Tag','Index_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Wrist_Accel_Check');
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(dCheckbox,'value',0);
 end
 
  guidata(hObject, handles); %Update GUI
  if ( (get(hObject,'Value') == get(hObject,'Min'))) %Checkbox is not selected
    axes(handles.Top_Graph);
     ylabel(handles.Top_Graph,'Position (mm)')
    cla; 
     
    axes(handles.Middle_Graph);
    cla;
    
    axes(handles.Bottom_Graph);
    cla;
  end  

end



function Vel_Tolerance_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Vel_Tolerance_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vel_Tolerance_Edit as text
%        str2double(get(hObject,'String')) returns contents of Vel_Tolerance_Edit as a double

handles.Vel_Tol = str2double(get(hObject,'String'));
handles.extract=0;
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Vel_Tolerance_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vel_Tolerance_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function VelEnd_Tol_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to VelEnd_Tol_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VelEnd_Tol_Edit as text
%        str2double(get(hObject,'String')) returns contents of VelEnd_Tol_Edit as a double
handles.VelEnd_Tol = str2double(get(hObject,'String'));
handles.extract = 0;
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function VelEnd_Tol_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelEnd_Tol_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in Accept_Trial_Button.
function Accept_Trial_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Accept_Trial_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.system == 1)
    handles.edited =0;
    index = 1;
    thumb =1;
     if (handles.marker_select == 2) %Index only selected
        thumb =0;
    end

    if(handles.marker_select ==3) %Thumb only selected
         index =1;
    end

    %handles.event_data
    %processing the accepted markers
    trial_validity = 1;
    hand_latency = handles.Master_array(handles.kin_array(1,1),13)/1000; 
    movement_time_index_z = (handles.Master_array(handles.kin_array(1,9),13)-handles.Master_array(handles.kin_array(1,3),13))/1000 * index; %used this as movement time (sec)
    movement_time_thumb_z = (handles.Master_array(handles.kin_array(1,12),13)-handles.Master_array(handles.kin_array(1,6),13))/1000 * thumb; 

    if(movement_time_index_z ==0) %if index finger not selected, use thumb movement start time
        movement_time_index_z = movement_time_thumb_z;
    end

    %disp(handles.Trial_Num);
    targetloc = handles.event_data{handles.Trial_Num, 7}; %assume target location is inputted as a numerical value following the order during calibration
    targetloc = str2double (targetloc);

    targetx = handles.Calibration_array (targetloc, 1);
    targety = handles.Calibration_array (targetloc, 2);
    targetz = handles.Calibration_array (targetloc, 3);

    index_end_pos_x = (handles.Filtered_XYZ(handles.kin_array(1,7),1)); %index x values when kept still
    index_end_pos_y = (handles.Filtered_XYZ(handles.kin_array(1,8),2));
    index_end_pos_z = (handles.Filtered_XYZ(handles.kin_array(1,9),3));


    accuracyx = (index_end_pos_x-targetx); %accuracy of 
    accuracyy = (index_end_pos_y-targety);
    accuracyz = (index_end_pos_z-targetz);
% 
%     if (index_end_pos_x ==0 && index_end_pos_y ==0 && index_end_pos_z ==0) %if index not selected, calculating the accuracy is nto feasible with the thumb (i think)
%         accuracyx = 0; %accuracy of 
%         accuracyy = 0;
%         accuracyz = 0;
%     end    

    index_x_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,19),1) * index;
    index_y_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,20),2) * index;
    index_z_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,21),3) * index;

    time_index_PA_z = (handles.Filtered_Accel_XYZ(handles.kin_array(1,21),7) - handles.Filtered_Accel_XYZ(handles.kin_array(1,3),7))/1000 * index;

    index_x_pos_PA = handles.Filtered_XYZ(handles.kin_array(1,21),1) * index;
    index_y_pos_PA = handles.Filtered_XYZ(handles.kin_array(1,21),2) * index;
    index_z_pos_PA = handles.Filtered_XYZ(handles.kin_array(1,21),3) * index;

    index_x_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,13),1) * index;
    index_y_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,14),2) * index;
    index_z_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),3) * index;

    time_index_PV_z = (handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),7) - handles.Filtered_Velocity_XYZ(handles.kin_array(1,3),7))/1000 * index;

    index_x_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,15),1) * index;
    index_y_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,15),2) * index;
    index_z_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,15),3) * index;

    index_x_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,25),1) * index;
    index_y_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,26),2) * index;
    index_z_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,27),3) * index;

    time_index_PD_z = (handles.Filtered_Accel_XYZ(handles.kin_array(1,27),7) - handles.Filtered_Accel_XYZ(handles.kin_array(1,3),7))/1000 * index;

    index_x_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,27),1) * index;
    index_y_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,27),2) * index;
    index_z_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,27),3) * index;

    thumb_end_pos_x = handles.Filtered_XYZ(handles.kin_array(1,10),1)* thumb;%thumb x value when kept still
    thumb_end_pos_y = handles.Filtered_XYZ(handles.kin_array(1,11),1)* thumb;
    thumb_end_pos_z = handles.Filtered_XYZ(handles.kin_array(1,12),1)* thumb;

    thumb_x_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,22),1)* thumb;
    thumb_y_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,23),2)* thumb;
    thumb_z_PA = handles.Filtered_Accel_XYZ(handles.kin_array(1,24),3)* thumb;

    time_thumb_PA_z = (handles.Filtered_Accel_XYZ(handles.kin_array(1,24),7)-handles.Filtered_Accel_XYZ(handles.kin_array(1,6),7))/1000* thumb;

    thumb_x_pos_PA= handles.Filtered_XYZ(handles.kin_array(1,24),1)* thumb;
    thumb_y_pos_PA = handles.Filtered_XYZ(handles.kin_array(1,24),2)* thumb;
    thumb_z_pos_PA = handles.Filtered_XYZ(handles.kin_array(1,24),3)* thumb;

    thumb_x_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,16),1)* thumb;
    thumb_y_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,17),2)* thumb;
    thumb_z_PV = handles.Filtered_Velocity_XYZ(handles.kin_array(1,18),3)* thumb;

    time_thumb_PV_z = (handles.Filtered_Accel_XYZ(handles.kin_array(1,18),7) - handles.Filtered_Accel_XYZ(handles.kin_array(1,6),7))/1000* thumb;

    thumb_x_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,18),1)* thumb;
    thumb_y_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,18),2)* thumb;
    thumb_z_pos_PV = handles.Filtered_XYZ(handles.kin_array(1,18),3)* thumb;

    thumb_x_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,28),1)* thumb;
    thumb_y_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,29),2)* thumb;
    thumb_z_PD = handles.Filtered_Accel_XYZ(handles.kin_array(1,30),3)* thumb;

    time_thumb_PD_z = (handles.Filtered_Accel_XYZ(handles.kin_array(1,30),7) - handles.Filtered_Accel_XYZ(handles.kin_array(1,6),7))/1000* thumb;

    thumb_x_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,30),1)* thumb;
    thumb_y_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,30),2)* thumb;
    thumb_z_pos_PD = handles.Filtered_XYZ(handles.kin_array(1,30),3)* thumb;

    index_peak_vel_vec =handles.Filtered_Velocity(handles.kin_array(1,31),1) *index;
    thumb_peak_vel_vec = handles.Filtered_Velocity(handles.kin_array(1,32),2) *thumb;
    
    output_array = [trial_validity hand_latency movement_time_index_z accuracyx accuracyy accuracyz index_x_PA index_y_PA index_z_PA time_index_PA_z index_x_pos_PA index_y_pos_PA index_z_pos_PA index_x_PV index_y_PV index_z_PV time_index_PV_z index_x_pos_PV index_y_pos_PV index_z_pos_PV index_x_PD index_y_PD index_z_PD time_index_PD_z index_x_pos_PD index_y_pos_PD index_z_pos_PD index_end_pos_x index_end_pos_y index_end_pos_z thumb_x_PA thumb_y_PA thumb_z_PA time_thumb_PA_z thumb_x_pos_PA thumb_y_pos_PA thumb_z_pos_PA thumb_x_PV thumb_y_PV thumb_z_PV time_thumb_PV_z thumb_x_pos_PV thumb_y_pos_PV thumb_z_pos_PV thumb_x_PD thumb_y_PD thumb_z_PD time_thumb_PD_z thumb_x_pos_PD thumb_y_pos_PD thumb_z_pos_PD thumb_end_pos_x thumb_end_pos_y thumb_end_pos_z index_peak_vel_vec thumb_peak_vel_vec handles.kin_array(1,33)*index handles.kin_array(1,34)*index handles.kin_array(1,35)*index handles.kin_array(1,36)*index handles.kin_array(1,37)*index handles.kin_array(1,38)*index handles.kin_array(1,39)*index handles.kin_array(1,40)*index handles.kin_array(1,41)*index handles.kin_array(1,42)*index handles.kin_array(1,43)*index handles.kin_array(1,44)*index handles.kin_array(1,45)*thumb handles.kin_array(1,46)*thumb handles.kin_array(1,47)*thumb handles.kin_array(1,48)*thumb handles.kin_array(1,49)*thumb handles.kin_array(1,50)*thumb handles.kin_array(1,51)*thumb handles.kin_array(1,52)*thumb handles.kin_array(1,53)*thumb handles.kin_array(1,54)*thumb handles.kin_array(1,55)*thumb handles.kin_array(1,56)*thumb];
   
    %First output format
    num = num2str(handles.Trial_Num+1);
    str2 = strcat('H',num);
    xlswrite(handles.events_filename,output_array, 1,str2);
end

str = strcat('Trial #: ', num2str(handles.Trial_Num),' was accepted.');
set(handles.Trial_Num_Text, 'String',str);
axes(handles.Top_Graph);
        cla;
axes(handles.Middle_Graph);
        cla;        
axes(handles.Bottom_Graph);
        cla;    
  aCheckbox = findobj('Tag','Index_Accel_Check');
    bCheckbox = findobj('Tag','Thumb_Accel_Check');
    cCheckbox = findobj('Tag','Palm_Accel_Check');
    dCheckbox = findobj('Tag','Grip_Aperture_Check');
    hCheckbox = findobj('Tag','Index_XYZ_Check');
    eCheckbox = findobj('Tag','Thumb_XYZ_Check');
    fCheckbox = findobj('Tag','Wrist_Accel_Check');
    set(dCheckbox,'value',0);
    set(aCheckbox,'value',0);
    set(bCheckbox,'value',0);
    set(cCheckbox,'value',0);
    set(hCheckbox,'value',0);
    set(eCheckbox,'value',0);
    set(fCheckbox,'value',0);
set(handles.Resample_Radio,'Value',0);
set(handles.Raw_Radio,'Value',0);
set(handles.Filter_Radio,'Value',0);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if(handles.system ==1)
    handles.curr_state = get(hObject,'Value');
    i=0;
        if (handles.curr_state > handles.initial_state)
            i = 1;
        end
        if (handles.curr_state<handles.initial_state)
            i = -1;
        end
        start =0;
        if (get(handles.Index_XYZ_Check,'Value')==get(handles.Index_XYZ_Check,'Max'))
            start = 1;
        end
        if (get(handles.Index_Accel_Check,'Value')==get(handles.Index_Accel_Check,'Max'))
            start =2;
        end

        if (get(handles.Thumb_XYZ_Check,'Value')==get(handles.Thumb_XYZ_Check,'Max'))
            start = 4;
        end
        if(get(handles.Thumb_Accel_Check, 'Value') == get(handles.Thumb_Accel_Check,'Max'))
            start =3;
        end

            if(handles.kin_var_select == 1) %Movement Start X
                handles.kin_array(1,start) = handles.kin_array(1,start)+i;
            end
            if(handles.kin_var_select == 2) %Movement Start Y
               handles.kin_array(1,start+1) = handles.kin_array(1,start+1) + i; 
            end

            if(handles.kin_var_select == 3) %Movement Start Z
               handles.kin_array(1,start+2) = handles.kin_array(1,start+2) + i; 
            end

            if(handles.kin_var_select == 4) %Movement End X
               handles.kin_array(1,start+6) = handles.kin_array(1,start+6) + i; 
            end

            if(handles.kin_var_select == 5) %Movement End Y
                handles.kin_array(1,start+7) = handles.kin_array(1,start+7) + i;
            end

            if(handles.kin_var_select == 6) %Movement End Z
                handles.kin_array(1,start+8) = handles.kin_array(1,start+8) + i;
            end

            if(handles.kin_var_select == 7) %Peak Velocity X
                handles.kin_array(1,start+12) = handles.kin_array(1,start+12) + i;
            end

            if(handles.kin_var_select == 8) %Peak Velocity Y
                handles.kin_array(1,start+13) = handles.kin_array(1,start+13) + i;
            end

            if(handles.kin_var_select == 9) %Peak Velocity Z
                handles.kin_array(1,start+14) = handles.kin_array(1,start+14) + i;
            end

            if(handles.kin_var_select == 10) %Peak Acceleration X
                handles.kin_array(1,start+18) = handles.kin_array(1,start+18) + i;
            end

            if(handles.kin_var_select == 11) %Peak Acceleration Y
                handles.kin_array(1,start+19) = handles.kin_array(1,start+19) + i;
            end

            if(handles.kin_var_select == 12) %Peak Acceleration Z
                handles.kin_array(1,start+20) = handles.kin_array(1,start+20) + i;
            end

            if(handles.kin_var_select == 13) %Peak Decceleration X
                handles.kin_array(1,start+24) = handles.kin_array(1,start+24) + i;
            end

            if(handles.kin_var_select == 14) %Peak Decceleration Y
                handles.kin_array(1,start+25) = handles.kin_array(1,start+25) + i;
            end

            if(handles.kin_var_select == 15) %Peak Decceleration Z
                handles.kin_array(1,start+26) = handles.kin_array(1,start+26) + i;
            end
            if(handles.kin_var_select == 16) %Index Vector Peak Velocity
                handles.kin_array(1,31) = handles.kin_array(1,31) + i;                
            end
            if(handles.kin_var_select == 17) %Thumb Vector Peak Velocity
                handles.kin_array(1,32) = handles.kin_array(1,32)+i;
            end
        guidata(hObject,handles);

        axes(handles.Top_Graph);
                cla;
        axes(handles.Middle_Graph);
                cla;        
        axes(handles.Bottom_Graph);
                cla;    

       if (get(handles.Index_XYZ_Check,'Value') == get(handles.Index_XYZ_Check,'Max')) %changing Index kin vars
            axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,1), '-r');
            hold on;
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,2), '-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,3), '-b');

            plot(handles.Filtered_XYZ(handles.kin_array(1,1),7), handles.Filtered_XYZ(handles.kin_array(1,1),1), 'or'); %Movement start X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,2),7), handles.Filtered_XYZ(handles.kin_array(1,2),2), 'og'); %Movement start Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,3),7), handles.Filtered_XYZ(handles.kin_array(1,3),3), 'ob'); %Movement start Z outgoing

             plot(handles.Filtered_XYZ(handles.kin_array(1,7),7), handles.Filtered_XYZ(handles.kin_array(1,7),1), 'squarer'); %Movement end X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,8),7), handles.Filtered_XYZ(handles.kin_array(1,8),2), 'squareg'); %Movement end Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,9),7), handles.Filtered_XYZ(handles.kin_array(1,9),3), 'squareb'); %Movement end Z outgoing

            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,1), '-r'); 
            hold on;
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,2), '-g'); 
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,3), '-b'); 

            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,13),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,13),1), 'squarer'); % Peak velocity index X
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,14),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,14),2), 'squareg'); % Peak velocity index y
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,15),3), 'squareb'); % Peak velocity index z

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,1),'-r');
            hold on;
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,2),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,3),'-b');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,19),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,19),1),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,20),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,20),2),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,21),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,21),3),'squareb');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,25),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,25),1),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,26),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,26),2),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,27),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,27),3),'squareb');
       end

       if (get(handles.Thumb_XYZ_Check,'Value') == get(handles.Thumb_XYZ_Check,'Max')) %changing Thumb kin vars

           axes(handles.Top_Graph);
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,4), '-r');
            hold on;
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,5), '-g');
            plot(handles.Filtered_XYZ(:,7), handles.Filtered_XYZ(:,6), '-b');

            plot(handles.Filtered_XYZ(handles.kin_array(1,4),7), handles.Filtered_XYZ(handles.kin_array(1,4),4), 'or'); %Movement start X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,5),7), handles.Filtered_XYZ(handles.kin_array(1,5),5), 'og'); %Movement start Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,6),7), handles.Filtered_XYZ(handles.kin_array(1,6),6), 'ob'); %Movement start Z outgoing

             plot(handles.Filtered_XYZ(handles.kin_array(1,10),7), handles.Filtered_XYZ(handles.kin_array(1,10),4), 'squarer'); %Movement end X outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,11),7), handles.Filtered_XYZ(handles.kin_array(1,11),5), 'squareg'); %Movement end Y outgoing
             plot(handles.Filtered_XYZ(handles.kin_array(1,12),7), handles.Filtered_XYZ(handles.kin_array(1,12),6), 'squareb'); %Movement end Z outgoing

            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,4), '-r'); 
            hold on;
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,5), '-g'); 
            plot(handles.Filtered_Velocity_XYZ (:,7), handles.Filtered_Velocity_XYZ(:,6), '-b'); 

            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,16),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,16),4), 'squarer'); % Peak velocity index X
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,17),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,17),5), 'squareg'); % Peak velocity index y
            plot(handles.Filtered_Velocity_XYZ(handles.kin_array(1,18),7),handles.Filtered_Velocity_XYZ(handles.kin_array(1,18),6), 'squareb'); % Peak velocity index z

            axes(handles.Bottom_Graph);
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,4),'-r');
            hold on;
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,5),'-g');
            plot(handles.Filtered_Accel_XYZ(:,7), handles.Filtered_Accel_XYZ (:,6),'-b');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,22),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,22),4),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,23),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,23),5),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,24),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,24),6),'squareb');

            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,28),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,28),4),'squarer');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,29),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,29),5),'squareg');
            plot(handles.Filtered_Accel_XYZ(handles.kin_array(1,30),7),handles.Filtered_Accel_XYZ(handles.kin_array(1,30),6),'squareb');

       end
        
       if(get(handles.Index_Accel_Check,'Value') == get(handles.Index_Accel_Check,'Max'))
            axes(handles.Top_Graph);
            plot(handles.Filtered_SagPos(:,5), handles.Filtered_SagPos(:,1), '-r');
            hold on;

            plot(handles.Filtered_SagPos(handles.kin_array(1,1),5), handles.Filtered_SagPos(handles.kin_array(1,1),1), 'or'); %Movement start 
            plot(handles.Filtered_SagPos(handles.kin_array(1,7),5), handles.Filtered_SagPos(handles.kin_array(1,7),1), 'or'); %Movement end
            
            
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity(:,5), handles.Filtered_Velocity(:,1),'-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,31),5),handles.Filtered_Velocity(handles.kin_array(1,31),1),'or');
       end
       if(get(handles.Thumb_Accel_Check,'Value') == get(handles.Thumb_Accel_Check,'Max'))
            axes(handles.Top_Graph);
            plot(handles.Filtered_SagPos(:,5), handles.Filtered_SagPos(:,2), '-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,4),5), handles.Filtered_SagPos(handles.kin_array(1,4),2), 'or'); %Movement start 
            plot(handles.Filtered_SagPos(handles.kin_array(1,10),5), handles.Filtered_SagPos(handles.kin_array(1,10),2), 'or'); %Movement end
            
            axes(handles.Middle_Graph);
            plot(handles.Filtered_Velocity(:,5), handles.Filtered_Velocity(:,2),'-r');
            hold on;
            plot(handles.Filtered_SagPos(handles.kin_array(1,32),5),handles.Filtered_Velocity(handles.kin_array(1,32),2),'or');
       end
    if(handles.curr_state == 50000 || handles.curr_state == 0)
        handles.curr_state = 25000;
        set(hObject, 'Value', 25000);
    end

    handles.initial_state = handles.curr_state;
    guidata(hObject,handles);
end
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    set(hObject, 'min', 0);
    set(hObject, 'max', 50000);
    set(hObject, 'Value', 25000);
    handles.initial_state = 25000;
    guidata(hObject,handles);
end

% --- Executes on mouse press over axes background.
function Top_Graph_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Top_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;
pan on;
end


% --- Executes on mouse press over axes background.
function Middle_Graph_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Middle_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;
pan on;
end


% --- Executes on mouse press over axes background.
function Bottom_Graph_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Bottom_Graph (see GCBO)
% eventdata  reserved - to be defined in a future version76uyh5/t of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;
pan on;
end


% --- Executes on button press in zoom_button.
function zoom_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  hAllAxes = findobj(gcf,'type','axes');
linkaxes( hAllAxes, 'x' );
axes(handles.Middle_Graph);
zoom on;
axes(handles.Bottom_Graph);
zoom on;
axes(handles.Top_Graph);
zoom on;
end


% --- Executes on button press in pan_button.
function pan_button_Callback(hObject, eventdata, handles)
% hObject    handle to pan_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Middle_Graph);
pan on;
axes(handles.Bottom_Graph);
pan on;
axes(handles.Top_Graph);
pan on;
end


% --- Executes on button press in eventFile_Button.
function eventFile_Button_Callback(hObject, eventdata, handles)
% hObject    handle to eventFile_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.system ==1)
    try
        [filename, pathname] = uigetfile('*.txt', 'Select the Events File');
        C = strsplit(filename,'.'); 
        handles.events_filename = strcat(C{1},'.xls');
        event_d = readtable(filename);
        event_d = table2cell(event_d);
    catch
        disp('Error: Please make sure the text file was exported on a Mac.');
    end
    handles.event_data = cell (length(event_d), 7);
    for i=1: length(event_d)
        remain = event_d{i};
        for j=1: 7
            [first, remain] = strtok(remain);
            handles.event_data {i, j} = first; %Trial Number
        end
    end
    handles.curr_col = length(handles.event_data(:,1));
    set(handles.table1,'Data',handles.event_data);

         xlswrite(handles.events_filename,{'Trial Number'}, 1,'A1'); %loaded events file information
         xlswrite(handles.events_filename,{'Condition'}, 1,'B1'); 
         xlswrite(handles.events_filename,{'Stimulus'}, 1,'C1'); %loaded events file information
         xlswrite(handles.events_filename,{'Delay'}, 1,'D1'); %loaded events file information
         xlswrite(handles.events_filename,{'Location'}, 1,'E1'); %loaded events file information
         xlswrite(handles.events_filename,{'Side'}, 1,'F1'); %loaded events file information
         xlswrite(handles.events_filename,{'Calibration Value'}, 1,'G1'); %loaded events file information
         xlswrite(handles.events_filename, handles.event_data, 1,'A2'); %loaded events file information


%          [coloumn, ~] = size(handles.event_data);
%          handles.curr_col = coloumn+2;
         output_headers ={'Pointing Valid Data 1/0','Hand Latency (sec)','Movement Time (sec)','Index X Accuracy','Index Y Accuracy','Index Z Accuracy','Peak Acceleration Index X','Peak Acceleration Index Y','Peak Acceleration Index Z','Time from onset to PA_Z','Index Position X @ PA_Z','Index Position Y @ PA_Z','Index Position Z @ PA_Z','Peak Velocity Index X','Peak Velocity Index Y','Peak Velocity Index Z','Time from onset to PV_Z','Index Position X @ PV_Z','Index Position Y @ PV_Z','Index Position Z @ PV_Z','Peak Deceleration Index X','Peak Deceleration Index Y','Peak Deceleration Index Z','Time from onset to PD_Z',	'Index Position X @ PD_Z',	'Index Position Y @ PD_Z',	'Index Position Z @ PD_Z',	'Index End Position X',	'Index End Position Y',	'Index End Position Z',	'Peak Acceleration thumb X','Peak Acceleration thumb Y','Peak Acceleration thumb Z','Time from onset to PA thumb Z','Finger Position X @ PA thumb Z','Finger Position Y @ PA thumb Z','Finger Position Z @ PA thumb Z','Peak Velocity thumb X','Peak Velocity thumb Y','Peak Velocity thumb Z',	'Time from onset to PV thumb Z','Finger Position X @ PV thumb Z','Finger Position Y @ PV thumb Z','Finger Position Z @ PV thumb Z',	'Peak Deceleration thumb X','Peak Deceleration thumb Y','Peak Deceleration thumb Z','Time from onset to PD thumb Z','Thumb Position X @ PD thumb Z','Thumb Position Y @ PD_Z','Thumb Position Z @ PD thumb Z','thumb End Position X','thumb End Position Y','thumb End Position z', 'Index Peak Velocity (Vector)','Thumb Peak Velocity (Vector)', 'Index (x) 50 msec before PV', 'Index (y) 50 msec before PV', 'Index (z) 50 msec before PV', 'Index (x) 50 msec after PV', 'Index (y) 50 msec after PV', 'Index (z) 50 msec after PV', 'Index (x) 100 msec before PV','Index (y) 100msec before PV','Index (z) 100 msec before PV','Index (x) 100 msec after PV','Index (y) 100 msec after PV','Index (z) 100 msec after PV','Thumb (x) 50 msec before PV', 'Thumb (y) 50 msec before PV', 'Thumb (z) 50 msec before PV', 'Thumb (x) 50 msec after PV', 'Thumb (y) 50 msec after PV', 'Thumb (z) 50 msec after PV', 'Thumb (x) 100 msec before PV','Thumb (y) 100msec before PV','Thumb (z) 100 msec before PV','Thumb (x) 100 msec after PV','Thumb (y) 100 msec after PV','Thumb (z) 100 msec after PV'};
         %str1 = strcat('H', 1,':BI1');
         xlswrite(handles.events_filename,output_headers, 1,'H1:CI1');
%          handles.curr_col = handles.curr_col +1;
    guidata(hObject, handles);
end
end


% --- Executes on selection change in kin_var_menu.
function kin_var_menu_Callback(hObject, eventdata, handles)
% hObject    handle to kin_var_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kin_var_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kin_var_menu

handles.kin_var_select = get(hObject,'Value');

guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function kin_var_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kin_var_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Movement Start X';'Movement Start Y';'Movement Start Z';'Movement End X'; 'Movement End Y';'Movement End Z';'Peak Velocity X';'Peak Velocity Y';'Peak Velocity Z';'Peak Acceleration X';'Peak Acceleration Y';'Peak Acceleration Z';'Peak Deceleration X';'Peak Deceleration Y';'Peak Deceleration Z';'Index Peak Velocity (Vector)';'Thumb Peak Velocity (Vector)'});
handles.kin_var_select = 1;
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function table1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'ColumnName',{'Trial #';'Trial Condition' ;'Stimulus';'Delay'; 'Location';'Side';'Calibration Value'});
guidata(hObject, handles);
end


% --- Executes when entered data in editable cell(s) in table1.
function table1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

handles.event_data{eventdata.Indices(1) , eventdata.Indices(2)} = eventdata.EditData;
str = 'A';
if eventdata.Indices(2) == 2
    str = 'B';
end
if eventdata.Indices(2) == 3
    str = 'C';
end
if eventdata.Indices(2) == 4
    str = 'D';
end
if eventdata.Indices(2) == 5
    str = 'E';
end
if eventdata.Indices(2) == 6
    str = 'F';
end
if eventdata.Indices(2) == 7
    str = 'G';
end
str = strcat(str, num2str(eventdata.Indices(1)));

xlswrite(handles.events_filename, cellstr(eventdata.EditData), 1,str); %loaded events file information
guidata(hObject,handles);
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.point = 0; 
    set(handles.radiobutton5,'Value',0);
end
if (get(hObject,'Value') == get(hObject,'Min'))
    handles.point = -1;
end

guidata(hObject, handles);
end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

if (get(hObject,'Value') == get(hObject,'Max'))
    handles.point = 1;
   set(handles.radiobutton4,'Value',0);
end
if (get(hObject,'Value') == get(hObject,'Min'))
    handles.point = -1;
end
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function radiobutton4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% 
% For the pointing stand alone app only
handles.point =1;
set(hObject,'Value',1);
guidata(hObject, handles);
end


% --- Executes on selection change in markers_popupmenu.
function markers_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to markers_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns markers_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from markers_popupmenu

contents = cellstr(get(hObject,'String'));
first = strcmp (contents{get(hObject,'Value')}, 'Index & Thumb');
second = strcmp (contents{get(hObject,'Value')}, 'Index Only');
third = strcmp (contents{get(hObject,'Value')}, 'Thumb Only');

    if(first)
        handles.marker_select =1;
    end
    if(second)
        handles.marker_select =2;
    end
    if(third)
        handles.marker_select =3;
    end
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function markers_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markers_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'Index & Thumb';'Index Only';'Thumb Only'});
handles.marker_select = 1;
guidata(hObject, handles);
end



function object_dia_edit_Callback(hObject, eventdata, handles)
% hObject    handle to object_dia_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of object_dia_edit as text
%        str2double(get(hObject,'String')) returns contents of object_dia_edit as a double
handles.obj_dia = str2double(get(hObject,'String'));
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function object_dia_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_dia_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.obj_dia = 0;
guidata(hObject,handles);
end



function object_dist_edit_Callback(hObject, eventdata, handles)
% hObject    handle to object_dist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of object_dist_edit as text
%        str2double(get(hObject,'String')) returns contents of object_dist_edit as a double
handles.obj_dia = str2double(get(hObject,'String'));
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function object_dist_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_dist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.obj_dist = 0;
guidata(hObject,handles);
end



function obj_height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to obj_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obj_height_edit as text
%        str2double(get(hObject,'String')) returns contents of obj_height_edit as a double
handles.obj_height = str2double(get(hObject,'String'));
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function obj_height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.obj_height = 0;
guidata(hObject, handles);
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
contents = cellstr(get(hObject,'String'));
first = strcmp (contents{get(hObject,'Value')}, 'Leap System');
second = strcmp (contents{get(hObject,'Value')}, 'Optotrak System');

    if(first)
        handles.system =1;
    end
    if(second)
        handles.system =2;
    end
    guidata(hObject,handles);

end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Leap System';'Optotrak System'});
handles.system = 1;
guidata(hObject, handles);
end



function edit12_Callback(hObject, eventdata, handles) %Vector Velocity
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
handles.vec_vel = str2double(get(hObject,'String'));
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles) %Vector Velocity
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.vec_vel =0;
guidata(hObject,handles);
end



function edit13_Callback(hObject, eventdata, handles)%thumb vector velocity
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
handles.th_vec_vel = str2double(get(hObject,'String'));
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)%thumb vector velocity
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.th_vec_vel =0.1;
guidata(hObject, handles);
end


function trial_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_num_edit as text
%        str2double(get(hObject,'String')) returns contents of trial_num_edit as a double
handles.Trial_Num = str2double(get(hObject,'String'));
name = strcat('Trial # : ',num2str(handles.Trial_Num), ' Loaded');
set(handles.Trial_Num_Text, 'String',name);
guidata(hObject, handles);

end

% --- Executes during object creation, after setting all properties.
function trial_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes during object creation, after setting all properties.
function warning_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to warning_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'String','Warning:');
guidata(hObject,handles);
end
