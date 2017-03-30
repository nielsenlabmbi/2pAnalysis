function varargout = GuiAddendum3(varargin)
% GUIADDENDUM3 MATLAB code for GuiAddendum3.fig
%      GUIADDENDUM3, by itself, creates a new GUIADDENDUM3 or raises the existing
%      singleton*.
%
%      H = GUIADDENDUM3 returns the handle to a new GUIADDENDUM3 or the handle to
%      the existing singleton*.
%
%      GUIADDENDUM3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIADDENDUM3.M with the given input arguments.
%
%      GUIADDENDUM3('Property','Value',...) creates a new GUIADDENDUM3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiAddendum3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiAddendum3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiAddendum3

% Last Modified by GUIDE v2.5 28-May-2015 14:46:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiAddendum3_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiAddendum3_OutputFcn, ...
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


% --- Executes just before GuiAddendum3 is made visible.
function GuiAddendum3_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiAddendum3 (see VARARGIN)

% Choose default command line output for GuiAddendum3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiAddendum3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%% SET UP THE GUI HERE! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.G = varargin{1};

% Set file path and names
set(handles.FilePath,'String',handles.G.filePath);
set(handles.InfoFile,'String',handles.G.infoFile);
set(handles.ImageFile,'String',handles.G.imageFile);
set(handles.MaskFile,'String',handles.G.maskFile);
set(handles.SignalsFile,'String',handles.G.signalsFile);
set(handles.LogFile,'String',handles.G.logFile);

% check that file path is valid
if exist(handles.G.filePath,'dir');
    % if path is valid, set as such, check for files
    set(handles.PathOK,'Value',1);
    if exist(fullfile(handles.G.filePath,handles.G.infoFile),'file')
        set(handles.InfoOK,'Value',1);
    end
    if exist(fullfile(handles.G.filePath,handles.G.imageFile),'file')
        set(handles.ImageOK,'Value',1);
    end
    if exist(fullfile(handles.G.filePath,handles.G.maskFile),'file')
        set(handles.MaskOK,'Value',1);
    end
    if exist(fullfile(handles.G.filePath,handles.G.signalsFile),'file');
        set(handles.SignalsOK,'Value',1);
    end
    if exist(fullfile(handles.G.filePath,handles.G.logFile),'file');
        set(handles.LogOK,'Value',1);
    end
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GuiAddendum3_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%% FILES PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FilePath_CreateFcn(~,~,~) %#ok<*DEFNU>
function PathOK_Callback(~,~,~)
function FilePath_Callback(hObject, ~, handles)
handles.G.filePath = get(hObject,'String');
if exist(handles.G.filePath,'dir'); set(handles.PathOK,'Value',1);
else set(handles.PathOK,'Value',0); end;
guidata(hObject, handles);

function InfoFile_CreateFcn(~,~,~)
function InfoOK_Callback(~,~,~)
function InfoFile_Callback(hObject, ~, handles)
% get new file name
handles.G.infoFile = get(hObject,'String');
% assume it is invalid
set(handles.InfoOK,'Value',0);
% check validity
if exist(fullfile(handles.G.filePath,handles.G.infoFile),'file')
    set(handles.InfoOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function ImageFile_CreateFcn(~,~,~)
function ImageOK_Callback(~,~,~)
function ImageFile_Callback(hObject, ~, handles)
% get new file name
handles.G.imageFile = get(hObject,'String');
% assume it is invalid
set(handles.ImageOK,'Value',0);
% check validity
if exist(fullfile(handles.G.filePath,handles.G.imageFile),'file')
    set(handles.ImageOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function MaskFile_CreateFcn(~,~,~)
function MaskOK_Callback(~,~,~)
function MaskFile_Callback(hObject, ~, handles)
% get new file name
handles.G.maskFile = get(hObject,'String');
% assume it is invalid
set(handles.MaskOK,'Value',0);
% check validity
if exist(fullfile(handles.G.filePath,handles.G.maskFile),'file')
    set(handles.MaskOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function SignalsFile_CreateFcn(~,~,~)
function SignalsOK_Callback(~,~,~)
function SignalsFile_Callback(hObject, ~, handles)
% get new file name
handles.G.signalsFile = get(hObject,'String');
% assume it is invalid
set(handles.SignalsOK,'Value',0);
% check validity
if exist(fullfile(handles.G.filePath,handles.G.signalsFile),'file')
    set(handles.SignalsOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function LogFile_CreateFcn(~,~,~)
function LogOK_Callback(~,~,~)
function LogFile_Callback(hObject, ~, handles)
% get new file name
handles.G.logFile = get(hObject,'String');
% assume it is invalid
set(handles.LogOK,'Value',0);
% check validity
if exist(fullfile(handles.G.filePath,handles.G.logFile),'file')
    set(handles.LogOK,'Value',1);
end

% save file name to handles
guidata(hObject, handles);

function OpenSettings_Callback(hObject, ~, handles)
% Check for all necessary files
check = get([handles.PathOK,handles.InfoOK,handles.ImageOK,handles.MaskOK,handles.SignalsOK,handles.LogOK],'Value');
if check{1} && check{2} && check{3} && check{4} && check{5} && check{6}
    
    % Disable file editing
    set([handles.FilePath,handles.InfoFile,handles.ImageFile,handles.MaskFile,handles.SignalsFile,handles.LogFile],'Enable','Off');
    % Allow edits in the settings panel
    set(handles.SaveData,'Enable','On');
    set(handles.KernelStart,'Enable','On');
    set(handles.KernelEnd,'Enable','On');
    set(handles.FilterWidth,'Enable','On');
    set(handles.FilterCheck,'Enable','On');
    
    % Disable this button to prevent reinitialization
    set(handles.OpenSettings','Enable','Off');
    
    
    % default settings in ms
    handles.kernelstart = 500;
    handles.kernelend = 2000;
    handles.filterwidth = 5000;
    % place in gui
    set(handles.KernelStart,'String',num2str(handles.kernelstart));
    set(handles.KernelEnd,'String',num2str(handles.kernelend));
    set(handles.FilterWidth,'String',num2str(handles.filterwidth));

    % Set a Z Data File
    handles.G.zFile = [handles.G.fileName '.zdata'];
    set(handles.ZFile,'String',handles.G.zFile);
    if exist(fullfile(handles.G.filePath,handles.G.zFile),'file')
        set(handles.ZCheck,'Value',1);
    end
    % Save file info to handles
    guidata(hObject, handles);

end

%%%%% SETTINGS PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function KernelStart_CreateFcn(~,~,~)
function KernelStart_Callback(hObject, ~, handles)
kernelstart = str2double(get(hObject,'String'));
if ~isnan(kernelstart) && kernelstart~=handles.kernelstart
    handles.kernelstart = kernelstart;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.kernelstart));
end

function KernelEnd_CreateFcn(~,~,~)
function KernelEnd_Callback(hObject, ~, handles)
kernelend = str2double(get(hObject,'String'));
if ~isnan(kernelend) && kernelend~=handles.kernelend
    handles.kernelend = kernelend;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.kernelend));
end

% --- Executes on button press in FilterCheck.
function FilterCheck_Callback(hObject, eventdata, handles)
% hObject    handle to FilterCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FilterCheck
get(handles.FilterCheck,'Value');
if ~get(handles.FilterCheck,'Value');
    set(handles.FilterWidth,'Enable','Off');
else
    set(handles.FilterWidth,'Enable','On');
end

function FilterWidth_CreateFcn(~,~,~)
function FilterWidth_Callback(hObject, ~, handles)
filterwidth= str2double(get(hObject,'String'));
if ~isnan(filterwidth) && filterwidth~=handles.filterwidth
    handles.filterwidth = filterwidth;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.filterwidth));
end

function ZFile_CreateFcn(~,~,~)
function ZCheck_Callback(~,~,~)
function ZFile_Callback(hObject, ~, handles)
%handles.G.zFile = get(hObject,'String');
handles.G.zFile = get(hObject,'String');
if exist(fullfile(handles.G.filePath,handles.G.zFile),'file')
    set(handles.ZCheck,'Value',1);
else
    set(handles.ZCheck,'Value',0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THIS IS THE TOTALLY NEW PART %%%%%%%%%%%%%%%%

% --- Executes on button press in SaveData.
function SaveData_Callback(~, ~, handles)
if get(handles.ZCheck,'Value')
    a = questdlg('Overwrite?','Overwrite warning','Yes','No','No');
    if strcmp(a,'No');
        return
    end
end
h = msgbox('Please wait');
if get(handles.FilterCheck,'Value')
[all_stimuli, trial,Info,center] = trials2(handles.G.filePath, handles.G.fileName, handles.filterwidth/1000, {handles.kernelstart/1000 handles.kernelend/1000});
else
    [all_stimuli, trial,Info,center] = trials2(handles.G.filePath, handles.G.fileName,{handles.kernelstart/1000 handles.kernelend/1000});
end
[Z_session, Stimuli, Info] = z_scored2(handles.G.fileName,trial,all_stimuli,center,Info,{handles.kernelstart/1000 handles.kernelend/1000});

    
save(fullfile(handles.G.filePath,handles.G.zFile),'Z_session','Stimuli','Info');
set(handles.ZCheck,'Value',1);
set(handles.TuningMap,'Enable','On');
delete(h);
h = msgbox('File saved!');


% --- Executes on button press in TuningMap.
function TuningMap_Callback(hObject, ~, handles)
% Throw path information into a settings structure to be used by the data
% viewing gui
% L.filePath = handles.G.filePath;
% L.infoFile = [handles.G.fileName '.mat'];
% L.imageFile = handles.G.imageFile;
% L.maskFile = handles.G.maskFile;
% L.signalsFile = handles.G.signalsFile;
% L.logFile = [handles.G.fileName '_log.mat'];
% L.fileName = handles.G.fileName;
% L.zData = handles.G.zFile;

TuningMap2({fullfile(handles.G.filePath,handles.G.zFile)});
%TuningMap(handles.G);
