function MenuFcn_SettingFolder(varargin)
% ADD PATHS AND EXTERNAL LIBS
addpath(genpath('.\uhlib'));
addpath('.\Includes');
% Import javaswing
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.lang.*;
% DEFINE
global gvar;
gvar=def_gvar;
iconlist=getmatlabicons;
% Link with main GUI;
handles.mainguifig = findall(0, '-depth',1, 'type','figure','Name','UHBMIGUI_NEUROLEG');
if ~isempty(handles.mainguifig) % if maingui is open    
    mainguihandles = getappdata(handles.mainguifig,'handles');
    handles.mainguihandles = mainguihandles;
end
% Create a new figure
handles.figure = uh_uiframe('figname',mfilename,'units','norm','position',[0.3 0.1 0.5 0.5]);

uistring={icontext(iconlist.action.newfolder,''),icontext(iconlist.action.updir,''),{'.\','C:\','C:\Phat Luu'}};
height=0.1;
[container_combo, handles.pushbutton_newdir,handles.pushbutton_updir,handles.combo_currdir]=uigridcomp({'pushbutton','pushbutton','combobox'},'uistring',uistring,...
            'gridsize',[1 3],'gridmargin',10,'position',[gvar.margin.l 1-gvar.margin.gap-height 0.4 height],'hweight',[1.5 1.5 7],'vweight',1);
uistring={icontext(iconlist.arrowleft,''),'',icontext(iconlist.folder,'Processed Mat'),...
          icontext(iconlist.arrowleft,''),'',icontext(iconlist.folder,'Raw Mat'),...
          icontext(iconlist.arrowleft,''),'',icontext(iconlist.folder,'Exp Data')};
for i=1:3      
[container_edit(i),handles.pushbutton_path(i), handles.edit_path(i),~]=uigridcomp({'pushbutton','edit','label'},'uistring',uistring((i-1)*3+1:(i)*3),...
            'gridsize',[1 3],'gridmargin',5,'hweight',[1 7 2],'vweight',1);
end
[container_list,~,handles.listbox_filelist]=uigridcomp({'label','list'},'uistring',{'',{'1'}},...
            'gridsize',[2 1],'gridmargin',5,'hweight',1,'vweight',[0.01 9.99]);
[container_save,~,handles.pushbutton_save]=uigridcomp({'label','pushbutton'},'uistring',{'',icontext(iconlist.action.save,'SAVE')},...
            'gridsize',[1, 2],'gridmargin',5,'hweight',[8 2],'vweight',1);
        
uipanel_edit=uipanellist('title','','border','none','fontsize',8,'objects',container_edit,...
                         'itemheight',[0.15 0.15 0.15],'itemwidth',(1-gvar.margin.l).*[1 1 1],'gap',[0 0.55/2]);
% Alignment
uialign(container_list,container_combo,'align','southeast','scale',[1 7],'gap',[0 -gvar.margin.gap]);
uialign(uipanel_edit,container_list,'align','east','scale',[1.4 1.05],'gap',[gvar.margin.t 0]);
uialign(container_save,uipanel_edit,'align','southeast','scale',[1 0.15],'gap',[0 -gvar.margin.gap]);
% Set Look and Feel
uisetlookandfeel('window');
% Warning off
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
warning('off','MATLAB:uigridcontainer:MigratingFunction');
% Initiate
set(handles.combo_currdir,'SelectedIndex',0)
uijlist_setfiles(handles.listbox_filelist,'.\','type',{'.folder'});

handles.datadirpath='.\Includes\DataDirName';
matstruct=load(handles.datadirpath);
datadir=matstruct.datadir;
for i=1:length(handles.edit_path)
    set(handles.edit_path(i),'string',datadir{i});
end
%Define Callback function
set(handles.pushbutton_path(1),'Callback',{@pushbutton_processedpath_Callback,handles});
set(handles.pushbutton_path(2),'Callback',{@pushbutton_rawpath_Callback,handles});
set(handles.pushbutton_path(3),'Callback',{@pushbutton_expdatapath_Callback,handles});
set(handles.pushbutton_newdir,'Callback',{@pushbutton_newdir_Callback,handles});
set(handles.pushbutton_updir,'Callback',{@pushbutton_updir_Callback,handles});
set(handles.pushbutton_save,'Callback',{@pushbutton_save_Callback,handles});
set(handles.combo_currdir,'ActionPerformedCallback',{@combo_currdir_Callback,handles});
set(handles.listbox_filelist,'MousePressedCallback',{@listbox_filelist_MousePressed_Callback,handles});
% Setappdata
setappdata(handles.figure,'handles',handles);


function setstatbar(statbar,waitbar,val,maxval,varargin)
msg='Processing...';
iconlist=getmatlabicons;
if length(varargin)>=2
    for i=1:2:length(varargin)
        param=varargin{i};
        val=varargin{i+1};
        switch lower(param)
            case 'msg'
                msg=val;
            otherwise
        end
    end
end
set(waitbar,'maximum',maxval);
set(waitbar,'value',val);
if val<maxval
    set(statbar,'text',msg);
else
    set(statbar,'text',icontext(iconlist.status.check,'DONE'));
end

function pushbutton_processedpath_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currdir=handles.combo_currdir.getSelectedItem;
dirselhtml=get(handles.listbox_filelist,'selectedValue');
dirsel=html2item(dirselhtml);
set(handles.edit_path(1),'string',fullfile(currdir,dirsel));
setappdata(handles.figure,'handles',handles);

function pushbutton_rawpath_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currdir=handles.combo_currdir.getSelectedItem;
dirselhtml=get(handles.listbox_filelist,'selectedValue');
dirsel=html2item(dirselhtml);
set(handles.edit_path(2),'string',fullfile(currdir,dirsel));
setappdata(handles.figure,'handles',handles);

function pushbutton_expdatapath_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currdir=handles.combo_currdir.getSelectedItem;
dirselhtml=get(handles.listbox_filelist,'selectedValue');
dirsel=html2item(dirselhtml);
set(handles.edit_path(3),'string',fullfile(currdir,dirsel));
setappdata(handles.figure,'handles',handles);

function pushbutton_newdir_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currdir=handles.combo_currdir.getSelectedItem;
setappdata(handles.figure,'handles',handles);

function pushbutton_updir_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currpath=handles.combo_currdir.getSelectedItem;
if strcmpi(currpath,'.\')
    currpath = pwd;
end
[updir,thisdir,ext]=fileparts(currpath);
handles.combo_currdir.insertItemAt(updir,0);
handles.combo_currdir.setSelectedIndex(0);
setappdata(handles.figure,'handles',handles);


function pushbutton_save_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
for i=1: length (handles.edit_path)
    datadir{i}=get(handles.edit_path(i),'string');
end
cmdstr=sprintf('save(''%s'',''datadir'')',handles.datadirpath);
eval(cmdstr);
% Transfer data to main figure;
if ~isempty(handles.mainguifig)
    handles.mainguihandles.datadir = datadir;
    set(handles.mainguihandles.popupmenu_currdir,'string',datadir);
    %
    % mainguihdl=getappdata(handles.maingui,'handles');
    % mainguihdl.datadir=datadir;
    % set(mainguihdl.popupmenu_currdir,'string',datadir);
    
    setappdata(handles.mainguifig,'handles',handles.mainguihandles);
end
setappdata(handles.figure,'handles',handles);
close(handles.figure);

function combo_currdir_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
currdir=get(hObject,'selectedItem');
uijlist_setfiles(handles.listbox_filelist,currdir,'type',{'.folder'});
setappdata(handles.figure,'handles',handles);

function listbox_filelist_MousePressed_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
eventinf=get(eventdata);
if eventinf.Button==1 && eventinf.ClickCount==2 %double left click
    filesel=html2item(get(hObject,'selectedValue'));
    [~,foldname,ext]=fileparts(filesel);
    currdir=get(handles.combo_currdir,'selectedItem');    
    if isempty(ext)     %folder selection                
        handles.combo_currdir.insertItemAt(fullfile(currdir,foldname),0);
        handles.combo_currdir.setSelectedIndex(0);        
    end
end
setappdata(handles.figure,'handles',handles);
