function varargout = Calibration_gui(varargin)
% CALIBRATION_GUI MATLAB code for Calibration_gui.fig
%      CALIBRATION_GUI, by itself, creates a new CALIBRATION_GUI or raises the existing
%      singleton*.
%
%      H = CALIBRATION_GUI returns the handle to a new CALIBRATION_GUI or the handle to
%      the existing singleton*.
%
%      CALIBRATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_GUI.M with the given input arguments.
%
%      CALIBRATION_GUI('Property','Value',...) creates a new CALIBRATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibration_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibration_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calibration_gui

% Last Modified by GUIDE v2.5 31-Jul-2016 14:43:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibration_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibration_gui_OutputFcn, ...
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
% End initialization code - DO NOT EDIT
end
% --- Executes just before Calibration_gui is made visible.
function Calibration_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibration_gui (see VARARGIN)

% Choose default command line output for Calibration_gui
handles.output = hObject;
handles.sys = varargin{1};
%  Ax = findall(0,'type','axes') ;
%  axis(Ax,[0 1000 -250 500]);

% Update handles structure

guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Calibration_gui.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
    %hMainGui = getappdata(0, 'hMainGui');
    %cal  = getappdata(hMainGui, 'cal');
    
end

% UIWAIT makes Calibration_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calibration_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%c = 'X_1:      X_2:';
%set(handles.text5, 'String', c);
if(handles.sys == 1) %Leap
    [~,~,handles.Cal_array] = load_LEAP_data_gui(0);
end
if(handles.sys ==2) %Optotrak
    [~,~,handles.Cal_array] = load_LEAP_data_gui(2);
end
handles.start =1;
handles.count =1;

%Get rid of all unfilled data spaces in arrays
handles.Cal_array(all(handles.Cal_array== 0, 2), :)= [];


guidata(hObject, handles);
axes(handles.axes1);
cla;
if(handles.sys == 1) %Leap
    plot(handles.Cal_array (:,4), handles.Cal_array(:,1), '.r'); %x
    hold(handles.axes1,'on')
    plot(handles.Cal_array (:,4), handles.Cal_array(:,2), '.g'); %y
    plot(handles.Cal_array (:,4), handles.Cal_array(:,3), '.b'); %z
end
if(handles.sys ==2) %Optotrak
    plot(handles.Cal_array(:,1),handles.Cal_array(:,2),'.r');
    hold(handles.axes1,'on')
    plot(handles.Cal_array(:,1),handles.Cal_array(:,3),'.g');
    plot(handles.Cal_array(:,1),handles.Cal_array(:,4),'.b');
end
if(handles.count ==1)
    handles.x = zeros (handles.num_cal, 2);
    handles.y = zeros (handles.num_cal, 2);
    handles.values = cell(handles.num_cal,9);
end
space = repmat('  ',[handles.num_cal 1]);
guidata(hObject, handles);

end




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end
end
% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)
end
% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});
end


function Cal_Points_Num_Callback(hObject, eventdata, handles)
% hObject    handle to Cal_Points_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cal_Points_Num as text
%        str2double(get(hObject,'String')) returns contents of Cal_Points_Num as a double
handles.num_cal = str2double(get(hObject,'String'));
guidata(hObject, handles);

str = 'Calibration Points: '; 
a = num2str(handles.num_cal);
     %  set(handles.Status_Text,'string', [str a]);
end
% --- Executes during object creation, after setting all properties.
function Cal_Points_Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cal_Points_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.num_cal = 5;
guidata(hObject, handles);



end

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function text5_CreateFcn(hObject,eventdata,handles)
% c = 'X_1:      X_2:';
%        %c = num2str(y);
%        set(handles.Status_Text,'String', [str a]);
end


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

hMainGui = getappdata(0, 'hMainGui');
end


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'ColumnName',{'Difference (X)';'Difference (Y)' ;'Difference (Z)';'Mean (X)'; 'Mean (Y)';'Mean (Z)';'STD (X)';'STD (Y)';'STD(Z)'});
end


% --- Executes on button press in zoom_button.
function zoom_button_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.start ==0)
    handles.start =1;
else
    handles.start =0;
end

zoom on;
guidata(hObject, handles);
end


% --- Executes on button press in pan_button.
function pan_button_Callback(hObject, eventdata, handles)
% hObject    handle to pan_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan on;
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off;
pan off;
if(handles.count <= handles.num_cal)
    if(handles.sys == 1) %Leap
       i = handles.count;
       hold(handles.axes1,'on')
       [x,y]=ginputax(handles.axes1,1);
       handles.x(i,1) = x;
       handles.y(i,1) = y;
       plot(handles.x(i,1),handles.y(i,1),'ro');
       [handles.x(i,2),handles.y(i,2)]=ginputax(handles.axes1,1);
       plot(handles.x(i,2),handles.y(i,2),'ro');
       [~, index] = min(abs(handles.Cal_array(:,4)-handles.x(i,1)));
       [~, index2] = min(abs(handles.Cal_array(:,4)-handles.x(i,2)));

       handles.x(i,1) = handles.Cal_array(index,4); %time
       handles.x(i,2) = handles.Cal_array(index2,4);

       handles.values{i,1} = handles.Cal_array(index2, 1)-handles.Cal_array(index, 1); %Differences
       handles.values{i,2} = handles.Cal_array(index2, 2)-handles.Cal_array(index, 2);
       handles.values{i,3} = handles.Cal_array(index2, 3)-handles.Cal_array(index, 3);
       
       if(index2>index)
           meanx = mean(handles.Cal_array(index: index2, 1));
           meany = mean(handles.Cal_array(index: index2, 2));
           meanz = mean(handles.Cal_array(index: index2, 3));
       else
           meanx = mean(handles.Cal_array(index2: index, 1));
           meany = mean(handles.Cal_array(index2: index, 2));
           meanz = mean(handles.Cal_array(index2: index, 3));
       end
       
       handles.values{i, 4} = meanx; %Means
       handles.values{i, 5} = meany;
       handles.values{i, 6} = meanz;
       if(index2>index)
           handles.values{i, 7} = std(handles.Cal_array(index: index2, 1)); %Standard deviations
           handles.values{i, 8} = std(handles.Cal_array(index: index2, 2));
           handles.values{i, 9} = std(handles.Cal_array(index: index2, 3));
       else
           handles.values{i, 7} = std(handles.Cal_array(index2: index, 1));
           handles.values{i, 8} = std(handles.Cal_array(index2: index, 2));
           handles.values{i, 9} = std(handles.Cal_array(index2: index, 3));
       end
       set(handles.uitable1,'Data',handles.values);
       handles.count = handles.count + 1;
       guidata(hObject, handles);
       return;
    end
    
    if(handles.sys == 2) %Optotrak
       i = handles.count;
       hold(handles.axes1,'on')
       [handles.x(i,1),handles.y(i,1)]=ginputax(handles.axes1,1);
       plot(handles.x(i,1),handles.y(i,1),'ro');
       [handles.x(i,2),handles.y(i,2)]=ginputax(handles.axes1,1);
       plot(handles.x(i,2),handles.y(i,2),'ro');
       [~, index] = min(abs(handles.Cal_array(:,1)-handles.x(i,1)));
       [~, index2] = min(abs(handles.Cal_array(:,1)-handles.x(i,2)));
        %index = find(handles.Cal_array(:,1) == index);
        %index2 = find(handles.Cal_array(:,1) == index2);
       
       handles.x(i,1) = handles.Cal_array(index,1); %time
       handles.x(i,2) = handles.Cal_array(index2,1);

       handles.values{i,1} = handles.Cal_array(index2,2)-handles.Cal_array(index,2);%XYZ Differences
       handles.values{i,2} = handles.Cal_array(index2,3)-handles.Cal_array(index,3);
       handles.values{i,3} = handles.Cal_array(index2,4)-handles.Cal_array(index,4);

       
       if(index2>index)
           meanx = mean(handles.Cal_array(index:index2,2));
           meany = mean(handles.Cal_array(index:index2,3));
           meanz = mean(handles.Cal_array(index:index2,4));
       else
           meanx = mean(handles.Cal_array(index2:index,2));
           meany = mean(handles.Cal_array(index2:index,3));
           meanz = mean(handles.Cal_array(index2:index,4));
       end
       
       handles.values{i,4} = meanx;
       handles.values{i,5} = meany;
       handles.values{i,6} = meanz;
       
       if(index2>index)
           handles.values{i,7} = std(handles.Cal_array(index:index2,2));
           handles.values{i,8} = std(handles.Cal_array(index:index2,3));
           handles.values{i,9} = std(handles.Cal_array(index:index2,4));
       else
           handles.values{i,7} = std(handles.Cal_array(index2:index,2));
           handles.values{i,8} = std(handles.Cal_array(index2:index,3));
           handles.values{i,9} = std(handles.Cal_array(index2:index,4));
       end
       set(handles.uitable1,'Data',handles.values);
       handles.count = handles.count + 1;
       guidata(hObject, handles);
       return;
    end
end
% handles.xpos = x;
% handles.ypos = y;
% %disp(handles.xpos);

if(handles.count > handles.num_cal)
%     if(handles.sys== 1) % Leap
%         for(i=1: length(handles.x(:,1)))
%             [~, index] = min(abs(handles.Cal_array(:,4) - handles.x(i,1)));
%             [~, index2] = min(abs(handles.Cal_array(:,4) - handles.x(i,1)));
%             handles.x(i,1) = index;
%             handles.x(i,2) = index2;
%         end
%         temp_array = zeros(length(handles.x(:,1)),3);
%         temp_array(:, 1) = handles.values{:, 4};
%         temp_array(:, 2) = handles.values{:, 5};
%         temp_array(:, 3) = handles.values{:, 6};
% %         for(i= 1: length(handles.x(:, 1)))
% %             temp_x = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 1); %x data
% %             temp_y = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 2); %y data
% %             temp_z = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 3); %z data
% %             
% %             temp_array(i, 1) = mean(temp_x);
% %             temp_array(i, 2) = mean(temp_y);
% %             temp_array(i, 3) = mean(temp_z); 
% %             temp_array(i, 1) = handles.values{i, 4};
% %             temp_array(i, 2) = handles.values{i, 5};
% %             temp_array(i, 3) = handles.values{i, 6};
% %         end
%     end
%     if(handles.sys== 2) %Optotrak
%         for i =1: length(handles.x(:,1))
%             [~, index] = min(abs(handles.Cal_array(:,1)-handles.x(i,1)));
%             [~, index2] = min(abs(handles.Cal_array(:,1)-handles.x(i,2)));
%             handles.x(i,1) = index;
%             handles.x(i,2) = index2;
%         end
%         temp_array = zeros (length(handles.x(:,1)), 3);
%         temp_array(:, 1) = handles.values{
% 
%         for i = 1: length(handles.x(:,1))
%            temp_x = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 2); %x data
%            temp_y = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 3); %y data
%            temp_z = handles.Cal_array(handles.x(i, 1): handles.x(i, 2), 4); %z data
%            temp_array(i,1) = mean(temp_x);
%            temp_array(i,2) = mean(temp_y);
%            temp_array(i,3) = mean(temp_z);    
%         end
%     end
    %temp_array = cell2mat(handles.values(:,1:3));
    temp_array = zeros(length(handles.x(:, 1)), 3);
    for(i= 1: length(handles.x(:, 1)))
        temp_array(i, 1) = handles.values{i, 4};
        temp_array(i, 2) = handles.values{i, 5};
        temp_array(i, 3) = handles.values{i, 6};
    end
    
    cal= temp_array;
    varargout = num2cell(temp_array,[1 2]);
    guidata(hObject, handles);
    hMainGui = getappdata(0, 'hMainGui');
    setappdata(hMainGui, 'cal', cal);

    cal_update = getappdata(hMainGui, 'cal_update');
    feval(cal_update);
end
end
