function MenuFcn_Newfunction
%====STEP 1: FRAME====
path('.\Includes\mfiles',path);
global gvar;
gvar=def_globalvar;
iconlist=getmatlabicons;
% Create a new figure
handles.mainfig = findall(0, '-depth',1, 'type','figure', 'Name',gvar.mainfigname);
refpos=get(handles.mainfig,'position');
w=refpos(3)/2;h=refpos(4)/5;
handles.figure=uiframedefine('figname',mfilename,...                
                'position',[refpos(1)+w/2,sum(refpos([2,4]))-h w h],...
                'menubar','none',...
                'toolbar','none',...
                'icon',iconlist.uh);
%====STEP 2: UI DESIGN====
% Use uigridcomp to create GUI components
% Example:
% Combobox for file list;
uistring={{''},icontext(iconlist.function,'New')};
w=0.95; h=0.5;
[container_filelist, handles.combo_module,handles.pushbutton_newfunc]=uigridcomp({'combobox','pushbutton'},...
        'uistring',uistring,...
        'position',[gvar.margin.l 1-gvar.margin.gap-h w h],...
        'gridsize',[1 2],'gridmargin',10,'hweight',[8 2],'vweight',1);
% Alignment
% uialign(container,container_ref,'align','southwest','scale',[1 1],'gap',[0 0]);
% Set Look and Feel
uisetlookandfeel('window');
% Warning off
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
warning('off','MATLAB:uigridcontainer:MigratingFunction');
%====STEP 3: INITIALIZE====
handles.modulename=uigetmodulename('rootdir',gvar.rootdir);
uisetjcombolist(handles.combo_module,handles.modulename);
%====STEP 4: DEFINE CALLBACK====
set(handles.pushbutton_newfunc,'Callback',{@pushbutton_newfunc_Callback,handles});
% Setappdata
setappdata(handles.figure,'handles',handles);

% insertcode('line','laset','callback',1)

%---------------------------------------------------------------------
%====PART II: CALLBACK FUNC
function pushbutton_newfunc_Callback(hObject,eventdata,handles) 
global gvar;
handles=getappdata(handles.figure,'handles'); 
selmodule=handles.combo_module.getSelectedItem;
filename=fullfile(gvar.rootdir,selmodule);
insertcode('line','last','filename',filename,'strvar',selmodule,'addguifunc',1);
setappdata(handles.figure,'handles',handles); 
close gcf;
