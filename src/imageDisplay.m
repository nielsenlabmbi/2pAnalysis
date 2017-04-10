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
        loadImage(varargin{2}, hObject, handles)
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
    handles.image = avgImage; %#ok<NODEF>
    handles.originalImage = avgImage;
    handles.filename = filePath;
    if isequal(avgImage(:,:,1),avgImage(:,:,2))
        handles.noRed = true;
        set(handles.slider_redLow,'Enable','off');
        set(handles.slider_redHigh,'Enable','off');
    else
        handles.noRed = false;
        set(handles.slider_redLow,'Enable','on');
        set(handles.slider_redHigh,'Enable','on');
    end
    imshow(handles.image,'parent',handles.imageAxis)
    set(handles.text_statusbar,'String',['Image loaded from ' filePath]);
    guidata(hObject, handles);
end


function adjustImage(hObject, handles)
    gl = get(handles.slider_greenLow,'Value');
    gh = get(handles.slider_greenHigh,'Value');
    rl = get(handles.slider_redLow,'Value');
    rh = get(handles.slider_redHigh,'Value');
    
    if handles.noRed
        handles.image(:,:,2) = imadjust(handles.originalImage(:,:,2),[gl gh],[0 1]);
        handles.image(:,:,1) = handles.image(:,:,2);
        handles.image(:,:,3) = handles.image(:,:,2);
    else
        handles.image(:,:,1) = imadjust(handles.originalImage(:,:,1),[rl rh],[0 1]);
        handles.image(:,:,2) = imadjust(handles.originalImage(:,:,2),[gl gh],[0 1]);
        handles.image(:,:,3) = zeros(size(handles.image,1),size(handles.image,2));
    end
    
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
