function varargout = flagGui(varargin)
% FLAGGUI MATLAB code for flagGui.fig
%      FLAGGUI, by itself, creates a new FLAGGUI or raises the existing
%      singleton*.
%
%      H = FLAGGUI returns the handle to a new FLAGGUI or the handle to
%      the existing singleton*.
%
%      FLAGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLAGGUI.M with the given input arguments.
%
%      FLAGGUI('Property','Value',...) creates a new FLAGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before flagGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to flagGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help flagGui

% Last Modified by GUIDE v2.5 27-May-2014 17:40:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @flagGui_OpeningFcn, ...
                   'gui_OutputFcn',  @flagGui_OutputFcn, ...
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


% --- Executes just before flagGui is made visible.
function flagGui_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to flagGui (see VARARGIN)

% Choose default command line output for flagGui
handles.output = hObject;

%%%%% MY INIT CODE HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get input
zFile = varargin{1};
handles.zFile = zFile{1};
load(handles.zFile,'-mat');
handles.Z = Z;
handles.S = S;
[~,b,c] = fileparts(handles.zFile);
set(handles.FileName,'String',[b c]);

% Assign unit number to 1
handles.unitNumber = 1;
set(handles.UnitNumber,'String',num2str(handles.unitNumber));

% Start by showing all events, can go individually if desired
set(handles.AllEvents,'Value',1);
set(handles.EventNumber,'Enable','Off');
set(handles.EventUp,'Enable','Off');
set(handles.EventDown,'Enable','Off');

% Set a default flag level
handles.flagLevel = 2.5;
set(handles.FlagLevel,'String',num2str(handles.flagLevel));

% Get z-scored responses for selected events of selected unit
r = handles.Z(handles.unitNumber).raw; allR = r(:); % unit responses, needs to be scaled
handles.r = (r-mean(allR))/std(allR);               % z-scored responses
% Also grab time and flags, for convenience
handles.t = handles.Z(handles.unitNumber).times;
handles.f = handles.Z(handles.unitNumber).flags;

% Update handles structure
guidata(hObject, handles);

% Plot z-scored responses
plotTimeCourse(handles);


% --- Outputs from this function are returned to the command line.
function varargout = flagGui_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function UnitNumber_CreateFcn(~, ~, ~) %#ok<*DEFNU>
function UnitNumber_Callback(hObject, ~, handles)
handles.unitNumber = str2double(get(hObject,'String'));
if isnan(handles.unitNumber)
    handles.unitNumber = 1;
end
% Get z-scored responses for selected events of selected unit
r = handles.Z(handles.unitNumber).raw; allR = r(:); % unit responses, needs to be scaled
handles.r = (r-mean(allR))/std(allR);               % z-scored responses
% Also grab time and flags, for convenience
handles.t = handles.Z(handles.unitNumber).times;
handles.f = handles.Z(handles.unitNumber).flags;
guidata(hObject, handles);
plotTimeCourse(handles);

% --- Executes on button press in UnitUp.
function UnitUp_Callback(hObject, ~, handles)
handles.unitNumber = handles.unitNumber+1;
if handles.unitNumber > max(handles.S.mask(:))
    handles.unitNumber = max(handles.S.mask(:));
end
set(handles.UnitNumber,'String',num2str(handles.unitNumber));
% Get z-scored responses for selected events of selected unit
r = handles.Z(handles.unitNumber).raw; allR = r(:); % unit responses, needs to be scaled
handles.r = (r-mean(allR))/std(allR);               % z-scored responses
% Also grab time and flags, for convenience
handles.t = handles.Z(handles.unitNumber).times;
handles.f = handles.Z(handles.unitNumber).flags;
guidata(hObject, handles);
plotTimeCourse(handles);

% --- Executes on button press in UnitDown.
function UnitDown_Callback(hObject, ~, handles)
handles.unitNumber = handles.unitNumber - 1;
if handles.unitNumber < 1
    handles.unitNumber = 1;
end
set(handles.UnitNumber,'String',num2str(handles.unitNumber));
% Get z-scored responses for selected events of selected unit
r = handles.Z(handles.unitNumber).raw; allR = r(:); % unit responses, needs to be scaled
handles.r = (r-mean(allR))/std(allR);               % z-scored responses
% Also grab time and flags, for convenience
handles.t = handles.Z(handles.unitNumber).times;
handles.f = handles.Z(handles.unitNumber).flags;
guidata(hObject, handles);
plotTimeCourse(handles);


function EventNumber_CreateFcn(~, ~, ~)
function EventNumber_Callback(hObject, ~, handles)
handles.eventNumber = str2double(get(hObject,'String'));
if isnan(handles.eventNumber)
    handles.eventNumber = 1;
end
guidata(hObject, handles);
plotTimeCourse(handles);

% --- Executes on button press in EventUp.
function EventUp_Callback(hObject, ~, handles)
handles.eventNumber = handles.eventNumber+1;
if handles.eventNumber > size(handles.S.events,1)
    handles.eventNumber = size(handles.S.events,1);
end
set(handles.EventNumber,'String',num2str(handles.eventNumber));
guidata(hObject, handles);
plotTimeCourse(handles);

% --- Executes on button press in EventDown.
function EventDown_Callback(hObject, ~, handles)
handles.eventNumber = handles.eventNumber-1;
if handles.eventNumber < 1
    handles.eventNumber = 1;
end
set(handles.EventNumber,'String',num2str(handles.eventNumber));
guidata(hObject, handles);
plotTimeCourse(handles);

% --- Executes on button press in AllEvents.
function AllEvents_Callback(hObject, ~, handles)
switch get(hObject,'Value')
    case 0
        handles.eventNumber = 1;
        set(handles.EventNumber,'String',num2str(handles.eventNumber));
        set(handles.EventNumber,'Enable','On');
        set(handles.EventUp,'Enable','On');
        set(handles.EventDown,'Enable','On');
    case 1
        handles.eventNumber = 0;
        set(handles.EventNumber,'String',num2str(handles.eventNumber));
        set(handles.EventNumber,'Enable','Off');
        set(handles.EventUp,'Enable','Off');
        set(handles.EventDown,'Enable','Off');
end
guidata(hObject, handles);
plotTimeCourse(handles);


function FlagLevel_CreateFcn(~, ~, ~)
function FlagLevel_Callback(hObject, ~, handles)
handles.flagLevel = str2double(get(hObject,'String'));
guidata(hObject, handles);
plotTimeCourse(handles);


% --- Executes on button press in ApplyFlags.
function ApplyFlags_Callback(hObject, ~, handles)
% Determine which events to flag
switch get(handles.AllEvents,'Value')
    case 1
        js = 1:size(handles.S.events,1);
    case 0
        js = str2double(get(handles.EventNumber,'String'));
end
% Cycle through events
for j = js
    % get times and responses for the event
    t = handles.t(j,:);
    r = handles.r(j,:);
    % constrain them to the flag level
    i1 = t > handles.S.epochs.base0 & t < handles.S.epochs.base1;
    i2 = r > handles.flagLevel;
    % find the flags
    flags = find(i1&i2);
    % include a buffer of 1 frame either way
    flags = unique([flags flags+1 flags-1]);
    % NEED A BETTER WAY TO RESTRICT THIS RANGE
    flags = flags(flags>0);             % no flags outside of frame range
    flags = flags(flags<find(t>0,1));   % no flags at stimulus presentation (could be signal)
    % add in flags to the Z structure
    handles.Z(handles.unitNumber).flags(j,:) = 0;
    handles.Z(handles.unitNumber).flags(j,flags) = 1;
end
% update flags for the current unit
handles.f = handles.Z(handles.unitNumber).flags;
% Update handles structure
guidata(hObject, handles);
% plot the new flags
plotTimeCourse(handles);

function plotTimeCourse(handles)
% Call axes and clear
axes(handles.TimeCourse); cla; hold on;

% Plot either a single event or all events for the unit
switch get(handles.AllEvents,'Value')
    case 0  % single event
        % get times, responses and flags for that event
        t = handles.t(handles.eventNumber,:);
        r = handles.r(handles.eventNumber,:);
        f = handles.f(handles.eventNumber,:);
        % plot the responses for that event
        plot(t,r,'Color',[.3 .3 .3],'LineWidth',2);
        % overlay any flags
        t(~f) = nan; r(~f) = nan;
        plot(t,r,'Color',[.7 0 0],'LineWidth',2);
    case 1  % all events
        % get times, responses and falgs for all events
        t = handles.t;
        r = handles.r;
        f = handles.f;
        % plot the responses for all events
        plot(t',r','Color',[.3 .3 .3]);
        % overlay any flags
        t(~f) = nan; r(~f) = nan;
        plot(t',r','Color',[.7 0 0]);
end

% Set x-axis limits
set(gca,'XLim',[handles.S.epochs.range0 handles.S.epochs.range1]);
% Plot the flag level over the base line epoch
plot([handles.S.epochs.base0 handles.S.epochs.base1],[handles.flagLevel handles.flagLevel],'r','LineWidth',2);


% --- Executes on button press in SaveFlags.
function SaveFlags_Callback(hObject, ~, handles)
% hObject    handle to SaveFlags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Z = handles.Z;
S = handles.S;
N = max(S.mask(:));     % number of units
M = size(S.events,1);   % number of events
% Update dF with flagged baseline
for j = 1:N     % Cycle through units
    for i = 1:M % Cycle through events
        t = Z(j).times(i,:);            % time
        r = Z(j).raw(i,:);              % raw response
        f = logical(Z(j).flags(i,:));   % flags
        fr = r; fr(f) = nan;            % flagged raw response
        % Grab the baseline for dF
        b = mean(fr(t >= S.epochs.base0 & t < S.epochs.base1 & ~f));
        % Use baseline to calculate dF from raw response
        Z(j).dF(i,:) = (r-b)/abs(b);
        % Get a filtered signal, use the filter sigma, convert to frames
        % from msec (the length of each frame is 64.4999 msec)
        Z(j).filt(i,:) = SDFnormFilt(Z(j).dF(i,:),S.filterSigma/64.4999);
        % Take mean for signal response
        Z(j).sig(i) = mean(Z(j).dF(i,(t > S.epochs.sig0 & t < S.epochs.sig1)));
    end
end

save(handles.zFile,'Z','S');

% Update handles.Z for further use in GUI
handles.Z = Z;
guidata(hObject, handles);
