function varargout = viewdataGui(varargin)
% VIEWDATAGUI MATLAB code for viewdataGui.fig
%      VIEWDATAGUI, by itself, creates a new VIEWDATAGUI or raises the existing
%      singleton*.
%
%      H = VIEWDATAGUI returns the handle to a new VIEWDATAGUI or the handle to
%      the existing singleton*.
%
%      VIEWDATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWDATAGUI.M with the given input arguments.
%
%      VIEWDATAGUI('Property','Value',...) creates a new VIEWDATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewdataGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewdataGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewdataGui

% Last Modified by GUIDE v2.5 19-Jan-2015 19:04:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewdataGui_OpeningFcn, ...
                   'gui_OutputFcn',  @viewdataGui_OutputFcn, ...
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

% --- Executes just before viewdataGui is made visible.
function viewdataGui_OpeningFcn(hObject,~,handles,varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewdataGui (see VARARGIN)

% Choose default command line output for viewdataGui
handles.output = hObject;

%%%%% SET UP VIEW DATA GUI HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Blank the main image
axes(handles.Image);colormap(gray);image(0);set(gca,'XTick',[],'YTick',[]);
% Establish the Z data file name and path
if ~isempty(varargin)
    zFile = varargin{1};
    zFile = zFile{1};   % converting from cell to string, necessary because string inputs to GUI are treated as callback functions
    [handles.filePath,handles.zFile,ext] = fileparts(zFile);
    handles.zFile = [handles.zFile ext];
    % Set file name in GUI
    set(handles.FileName,'String',handles.zFile);
    % If it exists, enable data viewing
    if exist(zFile,'file')
        set(handles.FileOK,'Value',1);
        set(handles.ViewData,'Enable','On');
    end
else
    handles.zFile = '';
    handles.filePath = '';
end

% Update handles structure
guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = viewdataGui_OutputFcn(hObject,~,handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%% DATA FILE PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---- Data file name ------------------------------------------------------
function FileName_CreateFcn(~,~,~)
function FileOK_Callback(~,~,~)
function FileName_Callback(hObject, eventdata, handles)
zFile = get(hObject,'String');
[handles.filePath,handles.zFile,ext] = fileparts(zFile);
handles.zFile = [handles.zFile ext];
if exist(zFile,'file')
    set(handles.FileOK,'Value',1);
    set(handles.ViewData,'Enable','On');
else
    set(handles.FileOK,'Value',0);
    set(handles.ViewData,'Enable','Off');
end
% Update handles structure
guidata(hObject,handles);

%---- FIND AN EXISTING DATA FILE ------------------------------------------
function FindData_Callback(hObject, eventdata, handles)
% hObject    handle to FindDataFile (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[zFile,filePath] = uigetfile('*.zdata','Choose a data file.');
% if user didn't cancel selection
if zFile ~= 0
    handles.zFile = zFile;
    handles.filePath = filePath;
    set(handles.FileName,'String',zFile);
    set(handles.FileOK,'Value',1);
    set(handles.ViewData,'Enable','On');
end
% Update handles structure
guidata(hObject,handles);

%---- VIEW Z DATA ---------------------------------------------------------
function ViewData_Callback(hObject, eventdata, handles)
% Load Z data and settings
load(fullfile(handles.filePath,handles.zFile),'-mat');
handles.Z = Z;
handles.S = S;

% Use the settings structure to fill out the settings panel
cellstr = {[num2str(handles.S.epochs.preDelay) ' ms'];
           [num2str(handles.S.epochs.postDelay) ' ms'];
           [num2str(handles.S.epochs.stimDur) ' ms']};
set(handles.StimulusTiming,'String',cellstr);
set(handles.Base0,'String',num2str(handles.S.epochs.base0));
set(handles.Base1,'String',num2str(handles.S.epochs.base1));
set(handles.Sig0,'String',num2str(handles.S.epochs.sig0));
set(handles.Sig1,'String',num2str(handles.S.epochs.sig1));
set(handles.Range0,'String',num2str(handles.S.epochs.range0));
set(handles.Range1,'String',num2str(handles.S.epochs.range1));
set(handles.FilterSigma,'String',num2str(handles.S.filterSigma));
set(handles.SettingsPanel,'Visible','On');  % Turn panel on

% Use the settings structure to fill out the parameters panel
handles.param1 = 1;     % Parameter 1 by default is 1
set(handles.Param1,'String',handles.S.params','Value',handles.param1);
handles.scaleColor = 1; % Default is that parameter 1 values are scaled according to unit strength
handles.circ = 0;       % Default is that parameter 1 is not considered circular
% Make circular if parameter name is 'ori'
if strcmp(handles.S.params{handles.param1},'ori')
    handles.circ = 1;
end
set(handles.Circ,'Value',handles.circ);
handles.param2 = 0;     % Parameter 2 is undefined unless enough params exist
if length(handles.S.params) > 1 % If more than 1 parameter
    handles.param2 = 2;     % Parameter 2 by default is 2
    set(handles.Param2,'String',handles.S.params','Value',handles.param2);
    exclude = isnan(handles.S.events(:,handles.param2));                    % don't include NaNs in param values
    param2values = num2str(unique(handles.S.events(~exclude,2)));           % unique parameter values
    while size(param2values,2) < 3; param2values = [repmat(' ',[size(param2values,1) 1]) param2values]; end % Get param 2 values as long as 'All'
    all = 'All'; while size(all,2) < size(param2values,2); all = [' ' all]; end % get all as long as param 2 values
    set(handles.Param2Value,'String',[all;param2values],'Value',1);
    handles.param2value = 0;% Parameter 2 by default is collapsed across all parameter values
    % Note that param2value is Param2Value's 'Value' - 1
    set(handles.Param2,'Enable','On');
    set(handles.Param2Value,'Enable','On');
else
    set(handles.Param2,'Enable','Off');
    set(handles.Param2Value,'Enable','Off');
end
set(handles.ViewingPanel,'Visible','On');   % Turn panel on

% Set unit to 1
handles.unitNumber = 1;
set(handles.UnitNumber,'String',num2str(handles.unitNumber));

% Update the image
handles = UpdateImage(handles);

% Update handles
guidata(hObject,handles);


%%%%% VIEWING PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---- PARAMETER SELECTION -------------------------------------------------
function Param1_CreateFcn(~,~,~)
function Param1_Callback(hObject,~,handles)
handles.param1 = get(hObject,'Value');
handles = UpdateImage(handles);
guidata(hObject,handles);

function Circ_Callback(hObject,~,handles)
handles.circ = get(handles.Circ,'Value');
handles = UpdateImage(handles);
guidata(hObject,handles);

function ScaleColor_Callback(hObject,~,handles)
handles.scaleColor = get(handles.ScaleColor,'Value');
handles = UpdateImage(handles);
guidata(hObject,handles);

function Param2_CreateFcn(~,~,~)
function Param2_Callback(hObject,~,handles)
handles.param2 = get(hObject,'Value');
exclude = isnan(handles.S.events(:,handles.param2));                        % don't include NaNs in param values
param2values = num2str(unique(handles.S.events(~exclude,handles.param2)));  % unique param values
while size(param2values,2) < 3; param2values = [repmat(' ',[size(param2values,1) 1]) param2values]; end % Get param 2 values as long as 'All'
all = 'All'; while size(all,2) < size(param2values,2); all = [' ' all]; end % get all as long as param 2 values
set(handles.Param2Value,'String',['All';param2values],'Value',1);
handles.param2value = 0;% Parameter 2 by default is collapsed across all parameter values
handles = UpdateImage(handles);
guidata(hObject,handles);

function Param2Value_CreateFcn(~,~,~)
function Param2Value_Callback(hObject,~,handles)
handles.param2value = get(hObject,'Value')-1;
handles = UpdateImage(handles);
guidata(hObject,handles);

%---- UNIT SELECTION ------------------------------------------------------
function UnitNumber_CreateFcn(~,~,~)
function UnitNumber_Callback(hObject,~,handles)
handles.unitNumber = str2double(get(hObject,'String'));
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject,handles);

% --- Executes on button press in UpUnit.
function UpUnit_Callback(hObject,~,handles)
handles.unitNumber = handles.unitNumber+1;
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject, handles);

% --- Executes on button press in DownUnit.
function DownUnit_Callback(hObject,~,handles)
handles.unitNumber = handles.unitNumber-1;
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject, handles);

%---- TIMECOURSE OPTIONS --------------------------------------------------
% --- Executes on button press in WorstResponse.
function WorstResponse_Callback(~,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
UpdateUnitNumber(handles);

% --- Executes on button press in AllTrials.
function AllTrials_Callback(~,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
UpdateUnitNumber(handles);

% --- Executes on button press in BestResponse.
function BestResponse_Callback(~,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
UpdateUnitNumber(handles);

% --- Executes on button press in FilterResponse.
function FilterResponse_Callback(~,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
UpdateUnitNumber(handles);


%%%%% SETTINGS FILE PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Base0_CreateFcn(~,~,~) %#ok<*DEFNU>
function Base0_Callback(~,~,~)
function Base1_CreateFcn(~,~,~)
function Base1_Callback(~,~,~)
function Sig0_CreateFcn(~,~,~)
function Sig0_Callback(~,~,~)
function Sig1_CreateFcn(~,~,~)
function Sig1_Callback(~,~,~)
function Range0_CreateFcn(~,~,~)
function Range0_Callback(~,~,~)
function Range1_CreateFcn(~,~,~)
function Range1_Callback(~,~,~)
function FilterSigma_CreateFcn(~,~,~)
function FilterSigma_Callback(~,~,~)


%%%%% AXES UPDATE FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---- Update the Image of All Units ---------------------------------------
function handles = UpdateImage(handles)

% TAKE SETTINGS OUT OF HANDLES FOR CONVENIENCE
S = handles.S;

im = S.image;   % Load the unmodified image from settings

N = max(S.mask(:));
% First get unique parameter values to vary in the image
exclude = isnan(S.events(:,handles.param1));                                % don't include NaNs in param values
handles.x = unique(S.events(~exclude,handles.param1));                      % unique param values
nV = length(handles.x);                                                     % number of unique param values
% Get the response and std of response to param1 for all units
y = nan(size(handles.x,1),N); yStd = nan(size(handles.x,1),N);
% Cycle through parameter 1 values
for i = 1:nV
    % Find events corresponding to current parameter value
    xInd = S.events(:,handles.param1) == handles.x(i);
    % Constrain by parameter 2 if not collapsed
    if handles.param2 && handles.param2value
        exclude = isnan(S.events(:,handles.param2));
        x2 = unique(S.events(~exclude,handles.param2));                     % unique parameter 2 values
        xInd = xInd & S.events(:,handles.param2)==x2(handles.param2value);  % constrain x to the desired param 2 value
    end
    % Average over these events
    for j = 1:N
        y(i,j) = mean(handles.Z(j).sig(xInd));
        yStd(i,j) = std(handles.Z(j).sig(xInd));
    end
end

% Find preferred parameter value and degree of preference for each unit
V = nan(1,N);   % Preferred variables
A = nan(1,N);   % Strength of that variable
handles.unitCond = ones(1,N);   % Starting condition for time courses will be the max response
for i = 1:N
    maxR = max(y(:,i)); minR = min(y(:,i));
    handles.unitCond(i) = find(y(:,i)==maxR);
    V(i) = handles.x(handles.unitCond(i));
    A(i) = maxR-minR;
end
A = A/max(A);   % Normalize tuning strength to the unit with the strongest tuning

% Now we can plot parameter preference and tuning strength of each unit
switch handles.circ
    case 0
        handles.cmap = jet;    % jet for non circular parameters
        handles.cvals = handles.cmap(1+round(0:(63/(nV-1)):63)',:);
    case 1
        handles.cmap = hsv;    % hsv for circular parameters (starts and ends on same color)
        handles.cvals = handles.cmap(1+round(0:(63/nV):63)',:);  % extra color value for return to start
end     

% Paint the units on the image
for unit = 1:N
    [i,j] = find(handles.S.mask==unit);
    for k = 1:length(i)                         % Going pixel by pixel
        col1 = squeeze(im(i(k),j(k),:));                    % grab the original color
        col2 = handles.cvals(handles.x==V(unit),:)';        % grab the color corresponding to the parameter value
        if handles.scaleColor   % If scaling color to the tuning strength
            im(i(k),j(k),:) = A(unit)*col2 + (1-A(unit))*col1;  % the hue of the paramter value corresponds to strength
%             im(i(k),j(k),:) = 0.3*col2 + (1-0.3)*col1;
        else                    % Tuning is indicated independent of tuning strength
            im(i(k),j(k),:) = col2;
        end
    end
end
% Update the image with colored units
axes(handles.Image);
image(im); set(gca,'XTick',[],'YTick',[]);
cbar = colorbar('West'); colormap(handles.cmap);

switch handles.circ     % The colorbar layout depends on whether or not the parameter is circular
    case 0
        if nV <= 16; yt = 0.5+round(0:(64/(nV-1)):64); ytl = handles.x;
        else yt = [.5 64.5]; ytl = [handles.x(1) handles.x(end)]; end
    case 1
        if nV <= 16; yt = 0.5+round(0:(64/nV):64); ytl = handles.x;
        else yt = [.5 32.5 64.5]; ytl = [handles.x(1) handles.x(round(nV/2)+1) handles.x(1)]; end
end
set(cbar,'XColor',[1 1 1],'YColor',[1 1 1],'YTick',yt,'YTickLabel',ytl);

handles.im = im;
UpdateUnitNumber(handles);

%---- Update the Selected Unit Plots --------------------------------------
function [unitNumber,unitCond] = UpdateUnitNumber(handles)

% FOR CONVENIENCE, MOVE SETTINGS OUT OF HANDLES
S = handles.S;

%%%%% CHECK UNIT NUMBER %%%%%
unitNumber = handles.unitNumber;
if isnan(unitNumber); unitNumber = 1; end;
if unitNumber < 1; unitNumber = 1; end;
if unitNumber > max(S.mask(:)); unitNumber = max(S.mask(:)); end;

%%%%% HIGHLIGHT THE CURRENT UNIT %%%%%
axes(handles.Image);
im = handles.im;
% THIS CODE FINDS THE BORDER, AND PAINTS IT WHITE, THERE MUST BE A BETTER WAY...
mask = S.mask == unitNumber; %if I don't do this, neighboring units will sometimes create border for their difference
top = diff([zeros(1,796);mask]) == 1;
bot = flipud(diff([zeros(1,796);flipud(mask)])) == 1;
lef = diff([zeros(512,1) mask],1,2) == 1;
rig = fliplr(diff([zeros(512,1) fliplr(mask)],1,2)) == 1;
bord = top | bot | lef | rig;
[i,j] = find(bord);
for k = 1:length(i); im(i(k),j(k),:) = 1; end;
% PLACE THE BORDER IN THE IMAGE, AT THIS POINT GIVE THE IMAGE A CLICKABLE FUNCTION 
h = image(im); set(handles.Image,'XTick',[],'YTick',[]);
set(h,'ButtonDownFcn',@(hObject,eventdata)viewdataGui('axes_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
set(h,'ButtonDownFcn',@(hObject,eventdata)viewdataGui('axes_ButtonDownFcn',hObject,eventdata,guidata(hObject)));
% NEED TO REPLACE THE COLOR BAR
cbar = colorbar('West');
nV = length(handles.x);
switch handles.circ     % The colorbar layout depends on whether or not the parameter is circular
    case 0
        if nV <= 16; yt = 0.5+round(0:(64/(nV-1)):64); ytl = handles.x;
        else yt = [.5 64.5]; ytl = [handles.x(1) handles.x(end)]; end
    case 1
        if nV <= 16; yt = 0.5+round(0:(64/nV):64); ytl = handles.x;
        else yt = [.5 32.5 64.5]; ytl = [handles.x(1) handles.x(round(nV/2)+1) handles.x(1)]; end
end
set(cbar,'XColor',[1 1 1],'YColor',[1 1 1],'YTick',yt,'YTickLabel',ytl);

% To show the image, unit response needs to be collapsed across conditions
y = nan(nV,1);
xInd = cell(nV,1);
% For convenience move data out of handles
Z = handles.Z(unitNumber);
yMin = sign(min(Z.sig))*ceil(100*abs(min(Z.sig)))/100;  % TRYING TO SET UP A REASONABLE Y-AXIS SCALE HERE--NOT SURE IF THIS IS BEST APPROACH
yMax = sign(max(Z.sig))*ceil(100*abs(max(Z.sig)))/100;
% Get param2 values if they will be needed
if handles.param2 && handles.param2value
    exclude = isnan(S.events(:,handles.param2));
    x2 = unique(S.events(~exclude,handles.param2));             % unique parameter 2 values
    x2Ind = S.events(:,handles.param2) == x2(handles.param2value);
end
% Cycle through through these values
for i = 1:nV
    % Find events corresponding to current parameter value
    xInd{i} = S.events(:,handles.param1) == handles.x(i);
    % Constrain by parameter 2 if not collapsed
    if handles.param2 && handles.param2value
        xInd{i} = xInd{i} & x2Ind;    % constrain x to the desired param 2 value
    end
    % Average over these events
    y(i) = mean(Z.sig(xInd{i}));
end

% Plot the tuning curve
axes(handles.Tuning); cla; hold on; box on;
plot([.5 length(handles.x)+.5],[0 0],':','Color',[.5 .5 .5]);
if get(handles.WorstResponse,'Value'); e = find(y == min(y)); plot([e e],[-10 10],'--r'); end
if get(handles.BestResponse,'Value'); e = find(y == max(y)); plot([e e],[-10 10],'--b'); end
plot(1:length(handles.x),y,'k','LineWidth',2);
if get(handles.Circ,'Value')
    plot(0:length(handles.x)+1,[y(end);y;y(1)],'k','LineWidth',2);
end
e = handles.unitCond(unitNumber);
plot([e e],[-10 10],'--k');
set(gca,'XLim',[.5 length(handles.x)+.5],'YLim',[yMin yMax]);
set(gca,'XTick',1:length(handles.x),'XTickLabel',handles.x);

% Plot time course of selected parameter conditions
axes(handles.Timing); cla; hold on; box on;
plot([S.epochs.range0 S.epochs.range1],[0 0],':','Color',[.5 .5 .5]);
plot([S.epochs.sig0 S.epochs.sig0],[-10 10],'Color',[.5 .5 .5]);
plot([S.epochs.sig1 S.epochs.sig1],[-10 10],'Color',[.5 .5 .5]);
if get(handles.WorstResponse,'Value')
    e = xInd{y == min(y)};
    if get(handles.FilterResponse,'Value')
        plot(mean(Z.times(e,:)),mean(Z.filt(e,:)),'r','LineWidth',2)
    else
        plot(mean(Z.times(e,:)),mean(Z.dF(e,:)),'r','LineWidth',2)
    end
end
if get(handles.BestResponse,'Value')
    e = xInd{y == max(y)};
    if get(handles.FilterResponse,'Value')
        plot(mean(Z.times(e,:)),mean(Z.filt(e,:)),'b','LineWidth',2)
    else
        plot(mean(Z.times(e,:)),mean(Z.dF(e,:)),'b','LineWidth',2)
    end
end
if get(handles.AllTrials,'Value')
    e = xInd{handles.unitCond(unitNumber)};
    if get(handles.FilterResponse,'Value')
        plot(Z.times(e,:)',Z.filt(e,:)','Color',[.5 .5 .5],'LineWidth',1);
    else
        plot(Z.times(e,:)',Z.dF(e,:)','Color',[.5 .5 .5],'LineWidth',1);
    end
end

e = xInd{handles.unitCond(unitNumber)};
if get(handles.FilterResponse,'Value')
    plot(mean(Z.times(e,:)),mean(Z.filt(e,:)),'k','LineWidth',3);
else
    plot(mean(Z.times(e,:)),mean(Z.dF(e,:)),'k','LineWidth',3);
end 
set(gca,'XLim',[S.epochs.range0 S.epochs.range1],'YLim',[yMin yMax]);
% axis tight;

% Update the unit number text
set(handles.UnitNumber,'String',num2str(unitNumber));

% Assign unit conditions for output (otherwise this will be lost as handles
% are NOT updated in this function)
unitCond = handles.unitCond;

% --- Executes on button press in IncreaseCond.
function IncreaseCond_Callback(hObject,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
handles.unitCond(handles.unitNumber) = handles.unitCond(handles.unitNumber)+1;
if handles.unitCond(handles.unitNumber) > length(handles.x)
    handles.unitCond(handles.unitNumber) = 1;
end
[~,handles.unitCond] = UpdateUnitNumber(handles);
guidata(hObject,handles);

% --- Executes on button press in DecreaseCond.
function DecreaseCond_Callback(hObject,~,handles)
handles.unitNumber = str2double(get(handles.UnitNumber,'String'));
handles.unitCond(handles.unitNumber) = handles.unitCond(handles.unitNumber)-1;
if handles.unitCond(handles.unitNumber) < 1
    handles.unitCond(handles.unitNumber) = length(handles.x);
end
[~,handles.unitCond] = UpdateUnitNumber(handles);
guidata(hObject,handles);

% --- Executes on mouse press over axes background.
function axes_ButtonDownFcn(hObject, eventdata, handles)

xy = get(handles.Image,'CurrentPoint');
x = round(xy(1,1)); y = round(xy(1,2));

if x < 1; x = 1; end; if x > size(handles.S.mask,2); x = size(handles.S.mask,2); end;
if y < 1; y = 1; end; if y > size(handles.S.mask,1); y = size(handles.S.mask,1); end;

unit = handles.S.mask(y,x);

if unit > 0
    handles.unitNumber = unit;
    set(handles.UnitNumber,'String',num2str(unit));
    UpdateUnitNumber(handles);
end

% --- Executes on button press in ZoomButton.
function ZoomButton_Callback(hObject, eventdata, handles)
axes(handles.Timing);
[~,y,b] = ginput(1);
if b == 1   % if mouse button 1, zoom in
    d = diff(get(gca,'YLim'))/4;
    set(gca,'YLim',[y-d y+d]);
    set(handles.Tuning,'YLim',[y-d y+d]);
else        % if any other mouse button, zoom out
    d = diff(get(gca,'YLim'));
    set(gca,'YLim',[y-d y+d]);
    set(handles.Tuning,'YLim',[y-d y+d]);
end
