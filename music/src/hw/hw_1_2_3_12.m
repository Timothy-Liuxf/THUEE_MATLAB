function varargout = hw_1_2_3_12(varargin)
% HW_1_2_3_12 MATLAB code for hw_1_2_3_12.fig
%      HW_1_2_3_12, by itself, creates a new HW_1_2_3_12 or raises the existing
%      singleton*.
%
%      H = HW_1_2_3_12 returns the handle to a new HW_1_2_3_12 or the handle to
%      the existing singleton*.
%
%      HW_1_2_3_12('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW_1_2_3_12.M with the given input arguments.
%
%      HW_1_2_3_12('Property','Value',...) creates a new HW_1_2_3_12 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hw_1_2_3_12_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hw_1_2_3_12_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hw_1_2_3_12

% Last Modified by GUIDE v2.5 04-Sep-2021 23:38:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw_1_2_3_12_OpeningFcn, ...
                   'gui_OutputFcn',  @hw_1_2_3_12_OutputFcn, ...
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


% --- Executes just before hw_1_2_3_12 is made visible.
function hw_1_2_3_12_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hw_1_2_3_12 (see VARARGIN)

% Choose default command line output for hw_1_2_3_12
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hw_1_2_3_12 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hw_1_2_3_12_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_filepath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filepath as text
%        str2double(get(hObject,'String')) returns contents of edit_filepath as a double


% --- Executes during object creation, after setting all properties.
function edit_filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_samples.
function lb_samples_Callback(hObject, eventdata, handles)
% hObject    handle to lb_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_samples contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_samples


% --- Executes during object creation, after setting all properties.
function lb_samples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_getsample.
function btn_getsample_Callback(hObject, eventdata, handles)
% hObject    handle to btn_getsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    file_path = get(handles.edit_filepath, 'String');
    % disp(char("get_component(""" + file_path + """);"));
    cmd = char("get_component(""" + file_path + """);");
    disp(cmd);
    [freq, comp] = evalin('base', cmd);
    handles.freq = freq;
    handles.comp = comp;
    guidata(hObject, handles);
    lb_strs = cell(length(freq), 1);
    for i = 1 : 1 : length(freq)
        lb_strs{i} = char(string(num2str(freq(i))) + ": [" + string(num2str(comp{i}')) + "]");
    end
    set(handles.lb_samples, 'String', lb_strs);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_playsound.
function btn_playsound_Callback(hObject, eventdata, handles)
% hObject    handle to btn_playsound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    var_name = get(handles.edit_filepath, 'String');
    song = evalin('base', var_name);
    freq = handles.freq;
    comp = handles.comp;
    main_tune = get(handles.edit_main_tune, 'String');
    beat_len = str2num(get(handles.edit_beat_len, 'String'));
    offset = get(handles.edit_tune_offset, 'String');
    tunes = get_tunes(main_tune) * str2num(offset);
    play_song(song, tunes, beat_len, freq, comp);

% --- Executes on button press in btn_clear.
function btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_main_tune_Callback(hObject, eventdata, handles)
% hObject    handle to edit_main_tune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_main_tune as text
%        str2double(get(hObject,'String')) returns contents of edit_main_tune as a double


% --- Executes during object creation, after setting all properties.
function edit_main_tune_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_main_tune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_beat_len_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beat_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beat_len as text
%        str2double(get(hObject,'String')) returns contents of edit_beat_len as a double


% --- Executes during object creation, after setting all properties.
function edit_beat_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beat_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tune_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tune_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tune_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_tune_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_tune_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tune_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
