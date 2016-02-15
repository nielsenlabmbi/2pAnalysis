function varargout = standardDataFormat(varargin)
% STANDARDDATAFORMAT MATLAB code for standardDataFormat.fig
%      STANDARDDATAFORMAT, by itself, creates a new STANDARDDATAFORMAT or raises the existing
%      singleton*.
%
%      H = STANDARDDATAFORMAT returns the handle to a new STANDARDDATAFORMAT or the handle to
%      the existing singleton*.
%
%      STANDARDDATAFORMAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STANDARDDATAFORMAT.M with the given input arguments.
%
%      STANDARDDATAFORMAT('Property','Value',...) creates a new STANDARDDATAFORMAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before standardDataFormat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to standardDataFormat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help standardDataFormat

% Last Modified by GUIDE v2.5 26-May-2014 11:01:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @standardDataFormat_OpeningFcn, ...
                   'gui_OutputFcn',  @standardDataFormat_OutputFcn, ...
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


% --- Executes just before standardDataFormat is made visible.
function standardDataFormat_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to standardDataFormat (see VARARGIN)

% Choose default command line output for standardDataFormat
handles.output = hObject;

%%%%% SET UP THE GUI HERE! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.S = varargin{1};

% Set file path and names
set(handles.FilePath,'String',handles.S.filePath);
set(handles.InfoFile,'String',handles.S.infoFile);
set(handles.ImageFile,'String',handles.S.imageFile);
set(handles.MaskFile,'String',handles.S.maskFile);
set(handles.SignalsFile,'String',handles.S.signalsFile);
set(handles.EventsFile,'String',handles.S.eventsFile);

% check that file path is valid
if exist(handles.S.filePath,'dir');
    % if path is valid, set as such, check for files
    set(handles.PathOK,'Value',1);
    if exist(fullfile(handles.S.filePath,handles.S.infoFile),'file')
        set(handles.InfoOK,'Value',1);
    end
    if exist(fullfile(handles.S.filePath,handles.S.imageFile),'file')
        set(handles.ImageOK,'Value',1);
    end
    if exist(fullfile(handles.S.filePath,handles.S.maskFile),'file')
        set(handles.MaskOK,'Value',1);
    end
    if exist(fullfile(handles.S.filePath,handles.S.signalsFile),'file');
        set(handles.SignalsOK,'Value',1);
    end
    if exist(fullfile(handles.S.filePath,handles.S.eventsFile),'file');
        set(handles.EventsOK,'Value',1);
    end
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = standardDataFormat_OutputFcn(~, ~, handles) 
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
handles.S.filePath = get(hObject,'String');
if exist(handles.S.filePath,'dir'); set(handles.PathOK,'Value',1);
else set(handles.PathOK,'Value',0); end;
guidata(hObject, handles);

function InfoFile_CreateFcn(~,~,~)
function InfoOK_Callback(~,~,~)
function InfoFile_Callback(hObject, ~, handles)
% get new file name
handles.S.infoFile = get(hObject,'String');
% assume it is invalid
set(handles.InfoOK,'Value',0);
% check validity
if exist(fullfile(handles.S.filePath,handles.S.infoFile),'file')
    set(handles.InfoOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function ImageFile_CreateFcn(~,~,~)
function ImageOK_Callback(~,~,~)
function ImageFile_Callback(hObject, ~, handles)
% get new file name
handles.S.imageFile = get(hObject,'String');
% assume it is invalid
set(handles.ImageOK,'Value',0);
% check validity
if exist(fullfile(handles.S.filePath,handles.S.imageFile),'file')
    set(handles.ImageOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function MaskFile_CreateFcn(~,~,~)
function MaskOK_Callback(~,~,~)
function MaskFile_Callback(hObject, ~, handles)
% get new file name
handles.S.maskFile = get(hObject,'String');
% assume it is invalid
set(handles.MaskOK,'Value',0);
% check validity
if exist(fullfile(handles.S.filePath,handles.S.maskFile),'file')
    set(handles.MaskOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function SignalsFile_CreateFcn(~,~,~)
function SignalsOK_Callback(~,~,~)
function SignalsFile_Callback(hObject, ~, handles)
% get new file name
handles.S.signalsFile = get(hObject,'String');
% assume it is invalid
set(handles.SignalsOK,'Value',0);
% check validity
if exist(fullfile(handles.S.filePath,handles.S.signalsFile),'file')
    set(handles.SignalsOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

function EventsFile_CreateFcn(~,~,~)
function EventsOK_Callback(~,~,~)
function EventsFile_Callback(hObject, ~, handles)
% get new file name
handles.S.eventsFile = get(hObject,'String');
% assume it is invalid
set(handles.EventsOK,'Value',0);
% check validity
if exist(fullfile(handles.S.filePath,handles.S.eventsFile),'file')
    set(handles.EventsOK,'Value',1);
end
% save file name to handles
guidata(hObject, handles);

% --- Executes on button press in OpenSettings.
function OpenSettings_Callback(hObject, ~, handles)
% Check for all necessary files
check = get([handles.PathOK,handles.InfoOK,handles.ImageOK,handles.MaskOK,handles.SignalsOK,handles.EventsOK],'Value');
if check{1} && check{2} && check{3} && check{4} && check{5} && check{6}
    % Disable file editing
    set([handles.FilePath,handles.InfoFile,handles.ImageFile,handles.MaskFile,handles.SignalsFile,handles.EventsFile],'Enable','Off');
    % Open up settings panel
    set(handles.SettingsPanel,'Visible','On');
    % Disable this button to prevent reinitialization
    set(handles.OpenSettings','Enable','Off');
    
    % Load files needed for settings
    a = load(fullfile(handles.S.filePath,handles.S.infoFile),'-mat');
    handles.info = a.info;
    a = load(fullfile(handles.S.filePath,handles.S.imageFile),'-mat');
    handles.image = a.avgImage;
    a = load(fullfile(handles.S.filePath,handles.S.maskFile),'-mat');
    handles.mask = a.mask;
    handles.maskFlags = a.maskFlags;
    a = load(fullfile(handles.S.filePath,handles.S.signalsFile),'-mat');
    handles.signals = a.signals;
    a = load(fullfile(handles.S.filePath,handles.S.eventsFile),'-mat');
    handles.Analyzer = a.Analyzer;
    
    % Now get some acquisition timing information
    handles.S.preDelay = 1000*handles.Analyzer.P.param{1}{3};
    handles.S.postDelay = 1000*handles.Analyzer.P.param{2}{3};
    handles.S.stimDur = 1000*handles.Analyzer.P.param{3}{3};
    % Place this text in the GUI
    cellstr = {[num2str(handles.S.preDelay) ' ms'];
               [num2str(handles.S.postDelay) ' ms'];
               [num2str(handles.S.stimDur) ' ms']};
    set(handles.StimulusTiming,'String',cellstr);
    
    % Use these to set up default signal acquisition epochs
    handles.base0 = -min(1000,handles.S.preDelay);
    handles.base1 = 0;
    handles.sig0 = 0;
    handles.sig1 = handles.S.stimDur+min(1000,handles.S.postDelay);
    handles.range0 = handles.base0;
    handles.range1 = handles.sig1;
    % Place these values in the GUI
    set(handles.Base0,'String',num2str(handles.base0));
    set(handles.Base1,'String',num2str(handles.base1));
    set(handles.Sig0,'String',num2str(handles.sig0));
    set(handles.Sig1,'String',num2str(handles.sig1));
    set(handles.Range0,'String',num2str(handles.range0));
    set(handles.Range1,'String',num2str(handles.range1));
    
    % Set a default filter sigma
    handles.filterSigma = 100;
    set(handles.FilterSigma,'String',num2str(handles.filterSigma));
    
    % Set a Z Data File
    handles.S.zFile = [handles.S.infoFile(1:end-3) 'zdata'];
    set(handles.ZFile,'String',handles.S.zFile);
    if exist(fullfile(handles.S.filePath,handles.S.zFile),'file')
        set(handles.ZCheck,'Value',1);
        set(handles.ViewData,'Enable','On');
        set(handles.FlagData,'Enable','On');
    end
    
    % Save file info to handles
    guidata(hObject, handles);
else
    warndlg('One or more needed files not found!');
end

%%%%% Settings Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Base0_CreateFcn(~,~,~)
function Base0_Callback(hObject, ~, handles)
base0 = str2double(get(hObject,'String'));
if ~isnan(base0) && base0~=handles.base0
    handles.base0 = base0;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.base0));
end

function Base1_CreateFcn(~,~,~)
function Base1_Callback(hObject, ~, handles)
base1 = str2double(get(hObject,'String'));
if ~isnan(base1) && base1~=handles.base1
    handles.base1 = base1;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.base1));
end

function Sig0_CreateFcn(~,~,~)
function Sig0_Callback(hObject, ~, handles)
sig0 = str2double(get(hObject,'String'));
if ~isnan(sig0) && sig0~=handles.sig0
    handles.sig0 = sig0;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.sig0));
end

function Sig1_CreateFcn(~,~,~)
function Sig1_Callback(hObject, ~, handles)
sig1 = str2double(get(hObject,'String'));
if ~isnan(sig1) && sig1~=handles.sig1
    handles.sig1 = sig1;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.sig1));
end

function Range0_CreateFcn(~,~,~)
function Range0_Callback(hObject, ~, handles)
range0 = str2double(get(hObject,'String'));
if ~isnan(range0) && range0~=handles.range0
    handles.range0 = range0;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.range0));
end

function Range1_CreateFcn(~,~,~)
function Range1_Callback(hObject, ~, handles)
range1 = str2double(get(hObject,'String'));
if ~isnan(range1) && range1~=handles.range1
    handles.range1 = range1;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.range1));
end

function FilterSigma_CreateFcn(~,~,~)
function FilterSigma_Callback(hObject, ~, handles)
filterSigma = str2double(get(hObject,'String'));
if ~isnan(filterSigma) && filterSigma~=handles.filterSigma
    handles.filterSigma = filterSigma;
    guidata(hObject,handles);
else
    set(hObject,'String',num2str(handles.filterSigma));
end

function ZFile_CreateFcn(~,~,~)
function ZCheck_Callback(~,~,~)
function ZFile_Callback(hObject, ~, handles)
handles.S.zFile = get(hObject,'String');
if exist(fullfile(handles.S.filePath,handles.S.zFile),'file')
    set(handles.ZCheck,'Value',1);
    set(handles.ViewData,'Enable','On');
    set(handles.FlagData,'Enable','On');
else
    set(handles.ZCheck,'Value',0);
    set(handles.ViewData,'Enable','Off');
    set(handles.FlagData,'Enable','Off');
end

% --- Executes on button press in SaveData.
function SaveData_Callback(~, ~, handles)

if get(handles.ZCheck,'Value')
    a = questdlg('Overwrite?','Overwrite warning','Yes','No','No');
    if strcmp(a,'No');
        return
    end
end

%%%%% PROCESS THE SIGNALS TO MAKE FURTHER CALCULATIONS EASIER
% Make two new handles arrays: handles.events and handles.times
% handles.events will be an n x 2 matrix, each row is a different event
%   with column 1 listing condition and column 2 giving a time stamp
% handles.times will be an m x n matrix the same size as signals, where
%   each entry provides a time stamp of the signal (m is frame, n is unit)
%%% Get handles.events, first get the conditions of each event
handles.events(:,1) = getcondtrial(handles.Analyzer);
% Then get frame and line of each event, then convert to msec
handles.frameT = 64.4999; handles.lineT = 0.1260; % Period of frame, line acquisition in msec -- VALUES DEPEND ON HARDWARE
ind = find(handles.info.event_id == 2); % indices of event 1 (stimulus onset)
ind = ind(1:2:end);

% correct for aborted experiments
ind = ind(1:length(handles.events));

handles.events(:,2) = handles.frameT*handles.info.frame(ind) + handles.lineT*handles.info.line(ind);
%%% Get handles.times, I know the time of each signal to position of frame
% acquisition in the signals array (given by row index), but the signal of
% each unit was acquired at a different time within a frame based on the
% position of the unit in the image, given by it's line in the image.
N = max(handles.mask(:)); maskLines = nan(1,N);
for i = 1:N; maskLines(i) = floor(mean(find(any(handles.mask==i,2)))); end;
% Now make a matrix with the frame at which each signal was acquired
sigFrames = repmat((0:size(handles.signals,1)-1)',[1 size(handles.signals,2)]);
% And at which line each signal was acquired
sigLines = repmat(maskLines,[size(handles.signals,1) 1]);
% Convert to msec and add
handles.times = handles.frameT*sigFrames + handles.lineT*sigLines;

% Set up parameters
[handles.params,handles.paramValues,handles.blank] = getdomainvalue(handles.Analyzer);

% Need an array providing the response of each unit to each event
M = size(handles.events,1);     % Number of events
N = max(handles.mask(:));       % Number of units
F = ceil(abs(handles.range0)/handles.frameT)+ceil(abs(handles.range1)/handles.frameT)+1; % Number of frames, dividing msec by frame period

% Create the Z structure array to hold the data
Z = struct;
% Create the S structure array to hold settings
S = struct;

% Get the parameters and the values for each event
S.params = handles.params;       % List of parameters that were varied
nParams = length(S.params);      % number of parameters
x = [handles.paramValues; nan(1,nParams)];  % parameter value lists
for i = 1:nParams  % cycle through parameters to fill out events
    S.events(:,i) = x(handles.events(:,1),i);     % register of parameter values for each event
end
% Get the time epochs
S.epochs.base0 = handles.base0;     S.epochs.base1 = handles.base1;
S.epochs.sig0 = handles.sig0;       S.epochs.sig1 = handles.sig1;
S.epochs.range0 = handles.range0;   S.epochs.range1 = handles.range1;
S.epochs.preDelay = handles.S.preDelay;
S.epochs.postDelay = handles.S.postDelay;
S.epochs.stimDur = handles.S.stimDur;
% Get image, mask, and mask flags
S.image = handles.image;
S.mask = handles.mask;
S.maskFlags = handles.maskFlags;
% Get filter sigma
S.filterSigma = handles.filterSigma;
% Cycle through units
for j = 1:N
    times = handles.times(:,j);     % signal times
    signals = handles.signals(:,j); % fluorescent signal in arbitrary units
    Z(j).times = nan(M,F+1);        % timestamps for signals aligned to events
    Z(j).raw = nan(M,F+1);          % raw signal aligned to events (arbitrary units)
    Z(j).flags = zeros(M,F+1);      % signal flags -- primarily to exclude when calculating baseline
    Z(j).dF = nan(M,F+1);           % signal normalized to a baseline aligned to events
    Z(j).filt = nan(M,F+1);         % signal normalized and filtered
    Z(j).sig = nan(M,1);            % mean dF in signal epoch
    [x,y] = find(handles.mask == j);% unit center in pixels
    Z(j).xPix = round(mean(x));
    Z(j).yPix = round(mean(y));
   
    % Cycle through events
    for i = 1:M
        % get time of event
        tE = handles.events(i,2); % time of event in ms
        % get baseline and signal
        base = mean(signals(times >= tE+handles.base0 & times < tE+handles.base1));
        % find index of the first frame captured AFTER the event -- this
        % will be used to align signals
        ind = find(times > tE & times <= tE+handles.frameT);
        % Grab time stamps for signal from event time  
        if isempty(ind)
            ind = min(max(find(times <= tE+handles.frameT)),min(find(times > tE)));
        end
        
        Z(j).times(i,:) = times(ind-ceil(abs(handles.range0)/handles.frameT)-1:ind+ceil(abs(handles.range1)/handles.frameT))-tE;
        % Get the raw signal
        Z(j).raw(i,:) = signals(ind-ceil(abs(handles.range0)/handles.frameT)-1:ind+ceil(abs(handles.range1)/handles.frameT));
        % Get the dF signal (normalized to baseline)
        Z(j).dF(i,:) = (signals(ind-ceil(abs(handles.range0)/handles.frameT)-1:ind+ceil(abs(handles.range1)/handles.frameT))-base)/abs(base);
        % Get a filtered signal, use the filter sigma, convert to frames from msec
        [Z(j).filt(i,:),f] = SDFnormFilt(Z(j).dF(i,:),handles.filterSigma/handles.frameT);
        % Take mean for signal response
        Z(j).sig(i) = mean(Z(j).dF(i,(Z(j).times(i,:) > handles.sig0 & Z(j).times(i,:) < handles.sig1)));
    end
    if j == 1; S.filter = f; end    % Filter used to get Z.filt from Z.dF
end

save(fullfile(handles.S.filePath,handles.S.zFile),'Z','S');
set(handles.ZCheck,'Value',1);
set(handles.ViewData,'Enable','On');
set(handles.FlagData,'Enable','On');

%%%%% OTHER BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in ViewData.
function ViewData_Callback(~, ~, handles)
viewdataGui({fullfile(handles.S.filePath,handles.S.zFile)});

% --- Executes on button press in ExitGUI.
function ExitGUI_Callback(~, ~, handles)
close(handles.figure1)

% --- Executes on button press in FlagData.
function FlagData_Callback(~, ~, handles)
flagGui({fullfile(handles.S.filePath,handles.S.zFile)});
