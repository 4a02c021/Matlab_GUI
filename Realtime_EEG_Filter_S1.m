function varargout = Realtime_EEG_Filter_S1(varargin)
% REALTIME_EEG_FILTER_S1 MATLAB code for Realtime_EEG_Filter_S1.fig
%      REALTIME_EEG_FILTER_S1, by itself, creates a new REALTIME_EEG_FILTER_S1 or raises the existing
%      singleton*.
%
%      H = REALTIME_EEG_FILTER_S1 returns the handle to a new REALTIME_EEG_FILTER_S1 or the handle to
%      the existing singleton*.
%
%      REALTIME_EEG_FILTER_S1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIME_EEG_FILTER_S1.M with the given input arguments.
%
%      REALTIME_EEG_FILTER_S1('Property','Value',...) creates a new REALTIME_EEG_FILTER_S1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Realtime_EEG_Filter_S1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Realtime_EEG_Filter_S1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Realtime_EEG_Filter_S1

% Last Modified by GUIDE v2.5 03-Nov-2017 20:31:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Realtime_EEG_Filter_S1_OpeningFcn, ...
                   'gui_OutputFcn',  @Realtime_EEG_Filter_S1_OutputFcn, ...
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


% --- Executes just before Realtime_EEG_Filter_S1 is made visible.
function Realtime_EEG_Filter_S1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Realtime_EEG_Filter_S1 (see VARARGIN)

% Choose default command line output for Realtime_EEG_Filter_S1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes5);

%% Define the name of picture.
%set(handles.output,'Units', 'normalized');
set(handles.output,'Position', [1000 1000 110 25]);
Picture_Name = 'EEG_Topomap.jpg';
path = strcat(pwd,Picture_Name); % cat the string
tmp = path(1:(size(path,2)-size(Picture_Name ,2))); % find the path of folder 
%% Check the path ( if lack the ' \ ' )
if tmp(end) ~= '\'
    path = strcat(pwd,'\',Picture_Name); % add the ' \ '
end
imshow(path);
% UIWAIT makes Realtime_EEG_Filter_S1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Realtime_EEG_Filter_S1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Delclare varaible for default
clc;
delete(instrfindall);
%% Add the path of EEGLab toolbox
Default_EEGLab_Path = genpath('C:\Users\adm\Desktop\GUI_Exe_File\EEGLab\eeglab_current\eeglab13_6_5b');
addpath(Default_EEGLab_Path, '-begin');
%% Setting of default value
Default_Serial_COM_Port = 'COM18';
Default_Baud_Rate = 115200;
Default_File_Name = 'Session1-S1-01.txt';
Defualt_File_Path = 'D:\';
Default_Channel_Selection = [1,2,3,4,5,6,7,8,9,10]; % 10 channel (EEG channel: 2 ~ 9 )
%% Declare Data Matrix
Fs = 500;
buffer = Fs*5; % Sampling Setting
              %     Arduino fs:500Hz  send data byte to Matlab
                      %     data: MSB + LSB  , Matlab receive:500 data quantity
                      %     but 500 data quantity contian (MSB and LSB)
                      %     ADC real data is 500/2=250 data quantity
                      %     So, we defined buffer must be 500*2=1000 data size
                      %     as 1 (sec) data quantity  
channel = size(Default_Channel_Selection,2);
%% 宣告x變數大小
Packet_Header = 2;
Break_event = 4;
Byte = 8;
Gain = 1; % setting of gaing
Filter_Flag = 1; % used filter or not
HPF = 1; % Hz
LPF = 50; % Hz
Renew_pts = Fs/10; % 更新點數
Data_Array_Default = {
       'Default_Serial_COM_Port',Default_Serial_COM_Port;...
       'Samppling Rate (Hz)',Fs;...
       'Buffer Size',buffer ;...
       'Packet_Header',Packet_Header;...
       'Break_event',Break_event;...
       'Gain',Gain;...
       'Filter_Flag',Filter_Flag;...
       'LPF',LPF;...
       'HPF',HPF;...
       'Channel',channel;...
       'Baud_rate',Default_Baud_Rate;...
       'EEG byte',Byte;...
       'EEG packet peader',Packet_Header;...
       'EEG break_event',Break_event;...
       'EEG Renew_pts',Renew_pts;...
       'EEG Filter_Flag',Filter_Flag;
       'Default_File_Name ',Default_File_Name;...
       'Default_File_Path ',Defualt_File_Path;...
       'Default_Channel_Selection',Default_Channel_Selection...
      };
%% Set the UserData for default  
set(handles.output,'UserData',Data_Array_Default); % Set the Data Array to UserData
%% Set the edit box for default
set(handles.edit1,'string',Default_Serial_COM_Port,'FontSize',15,'FontName','Times New Roman'); 
set(handles.edit2,'string',Default_Baud_Rate ,'FontSize',15,'FontName','Times New Roman');
set(handles.edit4,'string',LPF,'FontSize',15,'FontName','Times New Roman');
set(handles.edit3,'string',HPF,'FontSize',15,'FontName','Times New Roman');
set(handles.edit6,'string',Default_File_Name,'FontSize',12,'FontName','Times New Roman');
set(handles.edit8,'string',Gain,'FontSize',15,'FontName','Times New Roman');
set(handles.edit9,'string',Fs,'FontSize',15,'FontName','Times New Roman');

set(handles.text11,'string',strcat(Defualt_File_Path ,Default_File_Name),'FontSize',12,'FontName','Times New Roman');
set(handles.pushbutton1,'string','Start','FontSize',15,'FontName','Times New Roman'); 
%% Set the check box for default (Enable all checkbox)
for index = 4:12
    set(handles.(sprintf('checkbox%d',index)),'value', 1) % inital all the checkbox  
end
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Get the data from UserData   //get(handles.edit6,'string')
Data_array = get(handles.output,'UserData');
EEG_buffer = Data_array{3,2}; % Buffer size
EEG_byte = Data_array{12,2};
EEG_packet_header =  Data_array{13,2};
EEG_break_event = Data_array{14,2};
EEG_Renew_pts = Data_array{15,2};
EEG_Filter_flag = Data_array{16,2};
EEG_Channel_Selection = Data_array{19,2};
EEG_channel = 10;
%% Variable of Digital Filter
EEG_LPF = str2num(get(handles.edit3,'string'));
EEG_HPF = str2num(get(handles.edit4,'string'));
EEG_fs = str2num(get(handles.edit9,'string'));
EEG_Gain = str2num(get(handles.edit8,'string'));
%% Data Matrix Setting
for i=1:EEG_channel
  x{i} = zeros(1,EEG_buffer,'int16');
  data{i} = zeros(EEG_buffer,'int16');
  fig_cells{i} = zeros(1,1);
end
packet = zeros(1,10);
Read_Byte = zeros(11,1); % Read 11 bytes
bin_code = char(zeros(12,8));
index = zeros(1,10)+1; %Matrix index init=1
%val = zeros(1,18); %宣告data變數大小
%% Figure Setting
Time_val_max = 62500/125;
offset = [4500:-500:500,0];
ADC_val_max = offset(1) + Time_val_max; % Setting max scale of y axis value
Y_Low_Bound = 0;
Count_pts = 0;
%% Open.txt file and save
File_name = get(handles.edit6,'string');
Directory = Data_array{18,2} ;
Directory_file = get(handles.text11,'string');
path = Directory_file;
File = dir(Directory);
File_Matrix = struct2cell(File)';
file_flag = 0;
for step=1:size(File_Matrix,1)
   if(strcmp(File_Matrix(step,1),File_name) == 1)   
       file_flag = 1;
   end    
end
if file_flag > 0
    val = questdlg({'The file:';File_name;'already exists, do you want to overwrite it?'});
    if strcmp(val,'Yes')  == 1
        fprintf('Save the file... \n');
        file = fopen(path,'w'); % Create file
    else
        fprintf('Return... \n');
        return;
    end
else
 %   fprintf('Save the file... \n');
    file = fopen(path,'w'); % Create file 
end

%% Minimize the GUI window
jFrame = get(handle(gcf),'JavaFrame');
pause(0.1)  %//This is important
jFrame.setMinimized(true);
%-------figure plot object
figure('Name','Slave-1','position', [10 150,650, 800]);  % Create new figure with specified size  
%set(gcf,'Position',get(0,'ScreenSize'))   % Full Screen
hold on;
for i = 1:EEG_channel
    switch i
             case 1 
                 fig_cells{i} = plot(0,'LineWidth',1.5,'color','k');
             case EEG_channel %% Event Code
                 fig_cells{i} = plot(0,'LineWidth',1.5,'color','r');    
             otherwise
                 fig_cells{i} = plot(0,'LineWidth',1.5,'color','b');    
    end
end
%title('Interface of Potting EEG and Event Code (S-1)');
%axis_label=xlabel('Duration (sec)');
%title_label=title('Interface of Potting EEG and Event Code (S-2)');
axis([0,EEG_buffer,0,ADC_val_max]);
set(gca,'FontWeight','bold','fontsize',12,...
        'linewidth',3,'Fontname','times new Roman',...
        'XTickLabel',[0:(EEG_buffer/EEG_fs)],...
        'YTickLabel',{'Event','P4','Pz','P3','C4','C3','F4','Fz','F3','0','Arduino Clock'});   
set(get(gca,'XLabel'),'String','Duration (sec)');
set(get(gca,'Title'),'String','Interface of Potting EEG and Event Code (S-1)');
grid on;
text(0,0,'');
count=0;
number=[3,4;5,6;7,8;9,10;11,12;13,14;15,16];
%pause(0.5);
%% Open serial port
EEG_baud_rate = str2num(get(handles.edit2,'string'));
EEG_com_port = get(handles.edit1,'string');
delete(instrfindall);
EEG_serial_port = serial(EEG_com_port,'BaudRate',EEG_baud_rate ,'Timeout',60*10);  % Create Serial Port Object
if ~strcmp(EEG_com_port(1:3),'COM')
    close figure 1;
    msgbox('Com port is incorrect...');
    return;
end
fopen(EEG_serial_port);
flushinput(EEG_serial_port);
pause(1);
%% Main Funtion
 while(1)     
     val = fread(EEG_serial_port,1); % Read first byte
%% Decode Head
     bin_code = dec2bin(val,EEG_byte); %Decimal to Binary Code (decode first byte)
     head = bin2dec(bin_code(1,1:2)); % Head, 2bit
     if head == EEG_packet_header
         Read_Byte = fread(EEG_serial_port,11);% Read 11 bytes
         bin_code = [bin_code;dec2bin(Read_Byte,EEG_byte)];  % convert (1+17)byte to binary code
         %fprintf('%d \n',head);
     else
          flushinput(EEG_serial_port); % remove data form serial port
          continue;
     end
 %% Decode Package: Time, ADC_0~ADC_6, ADC_7 and Event Code 
     for i=1:EEG_channel
            packet(i) = Decode_Package(packet(i),...
                                              i,...
                                              bin_code,...
                                              EEG_channel);
          if i == EEG_channel && packet(i)>0 && Count_pts < EEG_buffer
                text(Count_pts,200,num2str(packet(i)),'Fontsize',20);
               % fprintf('index(1) = %d \n',index(1));
          elseif Count_pts == EEG_buffer
                 Count_pts = 0;
                 delete(findall(findall(gcf,'Type','axe'),'Type','text'));
                 set(get(gca,'XLabel'),'String','Duration (sec)');
                 set(get(gca,'Title'),'String','Interface of Potting EEG and Event Code (S-2)');
           end
     end
 %%  Store packet into data array
     for i = 1:EEG_channel
       data{i}(index(i)) = packet(i); % store data in the matrix
     end
 %% Save data to txt_file
     for i=1:EEG_channel
         if i ~= EEG_channel        
             fprintf(file,'%d ', data{i}(index(i)));
         else
             fprintf(file,'%d \r\n ',data{i}(index(i)));
         end
     end     
    if packet(10) == EEG_break_event && head == EEG_packet_header
        fprintf('End... \n');
        break;
    end
%%  Plot and Filter data
     for Step = 1:size(EEG_Channel_Selection,2)-1
        i = EEG_Channel_Selection(Step); % read the channel we want to show
       % fprintf('i=%d \n',i);
        if i == 1
            Set_EEG_Gain = 1;
            Set_EEG_Filter_flag = 0;
        else
            Set_EEG_Gain = EEG_Gain;
            Set_EEG_Filter_flag = EEG_Filter_flag;
        end      
         [x{i},index(i)] = Plot_function(EEG_buffer,...
                                         Set_EEG_Filter_flag,... % filter Flag
                                         index(i),...
                                         EEG_Renew_pts,...
                                         x{i},...
                                         fig_cells{i},...
                                         data{i},offset(i),...
                                         Set_EEG_Gain,... % Gain
                                         EEG_fs,...
                                         EEG_LPF,...
                                         EEG_HPF); 
     end  % end for loop  
     Count_pts = Count_pts + 1;
    % fprintf('Count_pts = %d \n',Count_pts);
%   end % end if  end 
 end
fclose(file);
fclose(EEG_serial_port);
delete(EEG_serial_port);
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Dir_name = uigetdir('C:\'); 
if Dir_name == 0
    return;
else
    Data_array = get(handles.output,'UserData');
    Data_array{18,2} = Dir_name;
    set(handles.output,'UserData',Data_array); % Set the Data Array to UserData
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Data_array = get(handles.output,'UserData');
File_name = get(handles.edit6,'string');
Directory = Data_array{18,2}; % 
path = strcat(Directory,File_name); % cat the string
tmp = path(1:(size(path,2)-size(File_name,2))); % find the path of folder 
%% Check the path ( if lack the ' \ ' )
if tmp(end) ~= '\'
    path = strcat(Directory,'\',File_name); % add the ' \ '
end
set(handles.text11,'string',path,'FontSize',12,'FontName','Times New Roman'); % show the path on the text
delete(instrfindall);



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,6);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,9);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,2);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,1);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,7);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,3);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,4);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,5);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox11
Data_array = get(handles.output,'UserData');
Channel_Selection = Data_array{19,2};
Data_array = Checkbox_Val_Change(get(hObject,'Value'),Data_array,Channel_Selection,8);
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16
flag = get(hObject,'Value');
Data_array = get(handles.output,'UserData');
switch flag 
    case 1
            set(handles.edit3, 'enable', 'on'); % HPF
            set(handles.edit4, 'enable', 'on'); % LPF 
            set(handles.edit3, 'string', 1); 
            set(handles.edit4, 'string', 50); 
            Data_array{16,2} = 1; % enable EEG filter flag
    case 0   
            set(handles.edit3, 'enable', 'off');
            set(handles.edit4, 'enable', 'off');
            set(handles.edit3, 'string', ''); 
            set(handles.edit4, 'string', '');
            Data_array{16,2} = 0;
end
set(handles.output,'UserData',Data_array); % Set the Data Array to UserData
