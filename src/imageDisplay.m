function varargout = imageDisplay(varargin) %#ok<*DEFNU>
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @imageDisplay_OpeningFcn, ...
                       'gui_OutputFcn',  @imageDisplay_OutputFcn, ...
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

function imageDisplay_OpeningFcn(hObject, ~, handles, varargin)
    handles.output = hObject;
    if ~isempty(varargin)
        loadImage(varargin{1}, hObject, handles)
    end
    % guidata(hObject, handles);
end

function varargout = imageDisplay_OutputFcn(hObject, ~, handles) %#ok<INUSL>
    varargout{1} = handles.output;
end

% ==================== BUTTONS ============================================

function button_load_Callback(hObject, ~, handles)
    [filename, pathname] = uigetfile('*.image', 'Select an image file');
    if ~isequal(filename,0)
       loadImage(fullfile(pathname, filename),hObject,handles);
    end
end

function button_save_Callback(hObject, ~, handles)
    avgImage = handles.image; %#ok<NASGU>
    origImage = handles.originalImage; %#ok<NASGU>
    save(handles.filename,'avgImage','origImage','-append');
    set(handles.text_statusbar,'String',['Image saved to ' handles.filename]);
    guidata(hObject, handles);
end

% ==================== SLIDERS ============================================

function slider_greenLow_Callback(hObject, ~, handles)
    adjustImage(hObject, handles);
end

function slider_redLow_Callback(hObject, ~, handles)
    adjustImage(hObject, handles);
end

function slider_greenHigh_Callback(hObject, ~, handles)
    adjustImage(hObject, handles);
end

function slider_redHigh_Callback(hObject, ~, handles)
    adjustImage(hObject, handles);
end

% ==================== HELPER FUNCTIONS ===================================

function loadImage(filePath, hObject, handles)
    load(filePath,'-mat');
    handles.image = avgImage;
    handles.originalImage = avgImage;
    handles.filename = filePath;
    imshow(handles.image,'parent',handles.imageAxis)
    set(handles.text_statusbar,'String',['Image loaded from ' filePath]);
    guidata(hObject, handles);
end


function adjustImage(hObject, handles)
    gl = get(handles.slider_greenLow,'Value');
    gh = get(handles.slider_greenHigh,'Value');
    rl = get(handles.slider_redLow,'Value');
    rh = get(handles.slider_redHigh,'Value');
    
    handles.image(:,:,1) = imadjust(handles.originalImage(:,:,1),[rl rh],[0 1]);
    handles.image(:,:,2) = imadjust(handles.originalImage(:,:,2),[gl gh],[0 1]);
    
    imshow(handles.image,'parent',handles.imageAxis);
    
    guidata(hObject, handles);
end

% ==================== CREATEFCNs =========================================

function slider_redHigh_CreateFcn(hObject, ~, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    guidata(hObject, handles);
end

function slider_greenLow_CreateFcn(hObject, ~, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    guidata(hObject, handles);
end

function slider_greenHigh_CreateFcn(hObject, ~, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    guidata(hObject, handles);
end

function slider_redLow_CreateFcn(hObject, ~, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    guidata(hObject, handles);
end
