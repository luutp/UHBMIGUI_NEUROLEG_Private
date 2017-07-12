function UHBMIGUI_NEUROLEG(varargin)
% v 1.0
% 2016/09/24
% Author: Phat Luu. tpluu2207@gmail.com
% Brain Machine Interface Lab
% University of Houston, TX, USA.
% ===================================================================
% Add Paths and external libs
uhlib = '..\uhlib';
% restoredefaultpath;
addpath(genpath(uhlib));
% Import Java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.lang.*;
% DEFINES
handles.filekeyword = 'MODULE';
global gvar;
gvar=def_gvar;
%====STEP 1: FRAME====
handles.iconlist=getmatlabicons;
handles=sub_definefuncmap(handles); % Function map for uitree component
% Create a new figure
[handles.figure, handles.jstatusbarhdl,handles.jwaitbarhdl]=uh_uiframe('figname',mfilename,...
    'units','norm','position',[0.1 0.1 0.5 0.7],...
    'statusbar',1, 'icon',handles.iconlist.uh,'logo',handles.iconlist.logo,...
    'logopos',[0.89,0.79,0.2,0.2]);
% Frame-Title
handles.text_title = uicontrol('Style','text', 'Units','norm', 'Position',[.2,.8,.6,.17],...
    'FontSize',20, 'Background','w', 'Foreground','r',...
    'String','NEUROLEG DATA ANALYSIS');
%==============================UI CONTROL=================================
% Set Look and Feel
uisetlookandfeel('window');
% Warning off
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
warning('off','MATLAB:uigridcontainer:MigratingFunction');
warning('off','MATLAB:uitree:MigratingFunction');
warning('off','MATLAB:uitreenode:DeprecatedFunction');
% Menu bar;
handles=uimenubar(handles);
% Popup and List files
uistring={{'.\','C:\'},icontext(handles.iconlist.action.updir,''),...
    '','',...
    {'.All','.Folder','.mat','.m','.fig','.png','.jpg'},icontext(handles.iconlist.action.finddir,''),...
    '','All Vars',...
    };
w=0.5; h=0.6;
[container_filelist,handles.popupmenu_currdir, handles.pushbutton_updir,...
    handles.jlistbox_filelist,~,...
    handles.jcombo_dirlookup,handles.pushbutton_finddir,...
    handles.edit_subjectID,handles.checkbox_selvarname,...
    ]=uigridcomp({'popupmenu','pushbutton',...
    'list','label',...
    'combobox','label',...
    'edit','checkbox',...
    },...
    'uistring',uistring,...
    'position',[gvar.margin.l 0.25 w h],...
    'gridsize',[4 2],'gridmargin',5,'hweight',[8 2],'vweight',[0.75 7.75 0.75 0.75]);
% JEdit Logging Message
[container_jedit_log, handles.jedit_log] =uigridcomp({'jeditorpane'});
% UITree Function List
handles=uitreefunclist(handles);
handles.juitree_funclist=handles.uitree_funclist.getTree;
% UITree Run button
uistring={icontext(handles.iconlist.user,'Link'),'',...
    icontext(handles.iconlist.action.play,'')};
[container_uitreerun,...
    handles.pushbutton_linkmatfiles,~,...
    handles.pushbutton_uitreerun] =uigridcomp({'pushbutton','label','pushbutton'},...
    'uistring',uistring,...
    'gridsize',[1 3],'gridmargin',10,...
    'hweight',[2.5 5 2.5],'vweight',1);
% Alignment
uialign(container_jedit_log,container_filelist,'align','southwest','scale',[1.95 0.36],'gap',[0 0]);
uialign(handles.uitree_funclist,container_filelist,'align','east','scale',[0.92 0.88],'gap',[gvar.margin.gap -0.01])
uialign(container_uitreerun,handles.uitree_funclist,'align','southwest','scale',[1.025 0.12],'gap',[-gvar.margin.gap 0])
%====STEP 3: INITIALIZE====
%= Load settings
if uh_isfileExist('.\Includes','DataDirName')
    datastruct=load(fullfile('.\Includes\DataDirName'));
    datadir=datastruct.datadir;
else
    datadir{1}='.\Processed Mat';
    datadir{2}='.\Raw Mat';
    datadir{3}='.\Exp Data';
    cmdstr=sprintf('save(''%s'',''datadir'')',fullfile('.\Includes','DataDirName'));
    eval(cmdstr);
end
handles.datadir=datadir;
if uh_isfileExist('.\Includes','Linkvarname')
    datastruct=load(fullfile('.\Includes\Linkvarname'));
    cmdstr=sprintf('handles.selvarname=datastruct.%s;','selvarname');
    eval(cmdstr);
else
end
handles.editor_runcount=1;
% =Initialize UIs
logMessage(sprintf('START: %s.Date:%s',mfilename,gvar.timenow.all),handles.jedit_log,'useicon',handles.iconlist.action.play);
set(handles.popupmenu_currdir,'string',datadir);
try
    uijlist_setfiles(handles.jlistbox_filelist,datadir{1},'type',{'.all'});
catch
    logMessage(sprintf('Folder: %s is not available. Try Setting Menu to set Folder.',datadir{3},gvar.timenow.all),handles.jedit_log,'useicon',handles.iconlist.action.play);
end
set(handles.popupmenu_currdir,'value',1);
set(handles.jcombo_dirlookup,'SelectedIndex',0); % For filetype lookup
% Set tooltiptext
set(handles.edit_subjectID,'TooltipString',...
    [sprintf('Select Subjects To Link Files.\n'),...
    sprintf('Seperated by comma , and space ')]);
set(handles.pushbutton_linkmatfiles,'TooltipString','Link .mat files of selected subjects');
set(handles.popupmenu_currdir,'TooltipString',...
    [sprintf('List of data dir paths:\n'),...
    sprintf('Processed, Raw, and Exp Data Dir.\n'),...
    sprintf('View Setting Menu')]);
% Setappdata
setappdata(0,mfilename,handles.figure);
setappdata(handles.figure,'handles',handles);
%====STEP 4: DEFINE CALLBACK====
% figure handles
set(handles.figure,'WindowKeyPressFcn',{@KeyboardThread_Callback,handles});
% Listbox and Edit text
set(handles.jlistbox_filelist,'MousePressedCallback',{@jlistbox_filenameinput_Mouse_Callback,handles});
set(handles.jlistbox_filelist,'KeyPressedCallback',{@jlistbox_filenameinput_Keypress_Callback,handles});
% popupmenu callback
set(handles.popupmenu_currdir,'Callback',{@popupmenu_currdir_Callback,handles});
% pushbutton
set(handles.pushbutton_updir,'Callback',{@pushbutton_updir_Callback,handles});
set(handles.pushbutton_uitreerun,'Callback',{@pushbutton_uitreerun_Callback,handles});
set(handles.pushbutton_linkmatfiles,'Callback',{@pushbutton_linkmatfiles_Callback,handles});
% Combobox callback
set(handles.jcombo_dirlookup,'ActionPerformedCallback',{@jcombo_dirlookup_Callback,handles});
% UITree
set(handles.uitree_funclist,'NodeSelectedCallback',{@uitree_funclist_Callback,handles});
% Setappdata
setappdata(handles.figure,'handles',handles);
assignin('base','uhbmigui_handles',handles)


function jlistbox_filenameinput_Mouse_Callback(hObject,eventdata,handles)
eventinf=get(eventdata);
if eventinf.Button==1 && eventinf.ClickCount==2 %double left click
    val=get(hObject,'SelectedValue');
    mark1=strfind(val,'>');mark1=mark1(end-1);
    mark2=strfind(val,'<');mark2=mark2(end);
    filename=val(mark1+1:mark2-1);
    [~,selname,ext]=fileparts(filename);
    currdirlist=get(handles.popupmenu_currdir,'string');
    currdir=currdirlist{get(handles.popupmenu_currdir,'value')};
    if isempty(ext)     %folder selection
        if strcmpi(currdir(end),'\')
            newdir=strcat(currdir,selname);
        else
            newdir=strcat(currdir,'\',selname);
        end
        uijlist_setfiles(handles.jlistbox_filelist,newdir,'type',{'.all'});
        handles.jcombo_dirlookup.setSelectedIndex(0);
        popuplist=get(handles.popupmenu_currdir,'string');
        if length(popuplist)<=10
            popuplist{end+1}=newdir;
        else
            popuplist{end}=newdir;
        end
        set(handles.popupmenu_currdir,'string',popuplist);
        set(handles.popupmenu_currdir,'value',length(popuplist));
    elseif strcmpi(ext,'.txt')
        jeditload(handles.jedit_editor,fullfile(currdir,filename));
        updatejcombo(handles.jcombo_editor,fullfile(currdir,filename));
    elseif strcmpi(ext,'.m')
        edit(fullfile(currdir,filename));
    elseif strcmpi(ext,'.mat')
        myfile = class_FileIO('filename',filename,'filedir',currdir);
        myfile.loadtows;
        assignin('base','FileObj',myfile);
        %         cmdstr=sprintf('load(''%s'')',fullfile(currdir,filename));
        %         datastruct=load(fullfile(currdir,filename));
        %         fname=fieldnames(datastruct);
        %         allvar=datastruct.(fname{1});
        %         fname=fieldnames(allvar);
        %         for fn=1:length(fname)
        %             assignin('base',sprintf('%s',fname{fn}),allvar.(fname{fn}));
        %         end
        %         assignin('base','trial',filename);
        logMessage(sprintf('Loading: %s',myfile.fullfilename),handles.jedit_log, 'useicon',handles.iconlist.action.open);
    else
        logMessage(sprintf('%s%s',filename,handles.msg.nottxt),handles.jedit_log, 'useicon',handles.iconlist.status.info);
    end
end

function popupmenu_currdir_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
strlist=get(hObject,'string');
val=get(hObject,'value');
newdir=strlist{val};
if strcmpi(newdir,'.\');
    newdir=cd;
end
uijlist_setfiles(handles.jlistbox_filelist,newdir,'type',{'.all'});
selectedfiles=uigetjlistbox(handles.jlistbox_filelist,'select','all');
subjectID=uigetsubjectID(selectedfiles);
if ~isempty(subjectID)
    subjectIDtxt=subjectID{1};
    for i=2:length(subjectID)
        subjectIDtxt=[subjectIDtxt, ', ' subjectID{i}];
    end
    set(handles.edit_subjectID,'string',subjectIDtxt);
end
%update uitree
% selrows=handles.juitree_funclist.getSelectionRows;
if strcmpi(newdir,handles.datadir{3})
    exppath=1;clspath=setdiff([1:length(handles.funclistpath)],exppath);
    for i=1:length(exppath)
        handles.juitree_funclist.expandPath(handles.funclistpath{exppath(i)});
    end
    for i=1:length(clspath)
        handles.juitree_funclist.collapsePath(handles.funclistpath{clspath(i)});
    end
    for i=1:length(handles.funclistpath)
        pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
    end
    newrows=pathrows(1)+1;
elseif strcmpi(newdir,handles.datadir{2})
    exppath=1;clspath=setdiff([1:length(handles.funclistpath)],exppath);
    for i=1:length(exppath)
        handles.juitree_funclist.expandPath(handles.funclistpath{exppath(i)});
    end
    for i=1:length(clspath)
        handles.juitree_funclist.collapsePath(handles.funclistpath{clspath(i)});
    end
    for i=1:length(handles.funclistpath)
        pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
    end
    newrows=pathrows(1)+2;
elseif strcmpi(newdir,handles.datadir{1})
    exppath=2:3;clspath=setdiff([1:length(handles.funclistpath)],exppath);
    for i=1:length(exppath)
        handles.juitree_funclist.expandPath(handles.funclistpath{exppath(i)});
    end
    for i=1:length(clspath)
        handles.juitree_funclist.collapsePath(handles.funclistpath{clspath(i)});
    end
    for i=1:length(handles.funclistpath)
        pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
    end
    newrows=pathrows(2):pathrows(4)-1;
else
    for i=1:length(handles.funclistpath)
        handles.juitree_funclist.collapsePath(handles.funclistpath{i});
    end
    newrows=0;
end
handles.juitree_funclist.setSelectionRows(newrows);
setappdata(handles.figure,'handles',handles);

function jcombo_dirlookup_Callback(hObject,eventdata,handles)
strlist=get(handles.popupmenu_currdir,'string');
val=get(handles.popupmenu_currdir,'value');
currdir=strlist{val};
thisitem=hObject.getSelectedItem;
j=1;k=1;
dirtype={};searchtxt={};
if ~isempty(thisitem)
    cellstr=strsplit(thisitem,{', ',' '});
    for i=1:length(cellstr)
        if strfind(cellstr{i},'.')
            dirtype{j}=cellstr{i};
            j=j+1;
        else
            searchtxt{k}=cellstr{i};
            k=k+1;
        end
    end
else
    dirtype={'.all'};
end
if ~isempty(dirtype)
    for i=1:length(dirtype)
        if strcmpi(dirtype{i},'.folder')
            handles.juitree_funclist.expandPath(handles.funclistpath{1});
            for k=2:length(handles.funclistpath)
                handles.juitree_funclist.collapsePath(handles.funclistpath{k});
            end
            handles.juitree_funclist.setSelectionRows(handles.juitree_funclist.getRowForPath(handles.funclistpath{1})+1);
        elseif strcmpi(dirtype{i},'.mat')
            handles.juitree_funclist.collapsePath(handles.funclistpath{1});
            j=1;
            for k=2:length(handles.funclistpath)
                handles.juitree_funclist.expandPath(handles.funclistpath{k});
                selectedrows(j)=handles.juitree_funclist.getRowForPath(handles.funclistpath{k});
                j=j+1;
            end
            lastrow=handles.juitree_funclist.getRowCount;
            handles.juitree_funclist.setSelectionRows(selectedrows(1):lastrow);
        end
    end
end
uijlist_setfiles(handles.jlistbox_filelist,currdir,'type',dirtype,'search',searchtxt);

function jcombo_editor_Callback(hObject,eventdata,handles)
thisitem=hObject.getSelectedItem;
jeditload(handles.jedit_editor,thisitem);
logMessage(sprintf('%s%s',thisitem,handles.msg.loaded),handles.jedit_log, 'useicon',handles.iconlist.status.fileloaded);

function uitree_funclist_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
selrows=handles.juitree_funclist.getSelectionRows;
for i=1:length(handles.funclistpath)
    pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
end
for i=1:length(selrows)
    thisrow=selrows(i);
    for j=1:length(pathrows)
        thispath=pathrows(j);
        if thisrow==thispath
            handles.juitree_funclist.expandPath(handles.funclistpath{j});
        end
    end
end
selrows=handles.juitree_funclist.getSelectionRows;
for i=1:length(handles.funclistpath)
    pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
end
for i=1:length(selrows)
    thisrow=selrows(i);
    for j=1:length(pathrows)
        thispath=pathrows(j);
        if thisrow==thispath
            numofrows=handles.juitree_funclist.getRowCount;
            if j<length(pathrows)
                newrows=[selrows', pathrows(j):pathrows(j+1)-1];
            else
                newrows=[selrows', pathrows(j):numofrows-1];
            end
            handles.juitree_funclist.setSelectionRows(newrows);
        end
    end
end
eegopt=0;kinopt=0;
for i=1:length(selrows)
    selpath=handles.juitree_funclist.getPathForRow(selrows(i));
    nopath=selpath.getPathCount;
    funcname='';
    for j=1:nopath
        thispath=selpath.getPathComponent(j-1);
        thispathstr=char(thispath.toString);
        thispathstr=thispathstr(strfind(thispathstr,':')+1:end);
        thispathstr(isspace(thispathstr))=[];
        funcname=[funcname '.' thispathstr];
    end
    if strfind(lower(funcname),'importfolder')
        set(handles.popupmenu_currdir,'value',3);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{3},'type',{'.folder'});
        break;
    elseif strfind(lower(funcname),'makeeegkin')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.mat'});
        break;
    elseif strfind(lower(funcname),'makeeeg')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.mat'},'search',{'-eeg'});
        break;
    elseif strfind(lower(funcname),'bstmakesfile') % brainstorm
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'-eeg'},'exclude',{'EEGclean'});
        break;
    elseif strfind(lower(funcname),'bstmakeprotocol') % brainstorm
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'EEGClean'},'exclude',{'beta'});
        break;
    elseif strfind(lower(funcname),'bstaddevents') % brainstorm
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'EEGClean'});
        break;
    elseif strfind(lower(funcname),'bstmakebetaprotocol') % brainstorm
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'EEGClean-beta'});
        break;
    elseif strfind(lower(funcname),'makeemg')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.mat'},'search',{'-emg'});
        break;
    elseif strfind(lower(funcname),'makekin')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.mat'},'search',{'-kin'});
        break;
    elseif strfind(lower(funcname),'elecfile')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.bvct'});
        break;
    elseif strfind(lower(funcname),'makebstmatfile')
        set(handles.popupmenu_currdir,'value',2);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{2},'type',{'.bvct'});
        break;
    elseif strfind(lower(funcname),'linkmatfile')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'});
        break;
    elseif strfind(lower(funcname),'print')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'});
        break;
    elseif strfind(lower(funcname),'emgprocessing')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'-emg'},'exclude',{''});
        break;
    elseif strfind(lower(funcname),'eegclean')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'eeg'},'exclude',{'eegclean'});
        break;
    elseif strfind(lower(funcname),'sourcelocalization.icclusteract')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'EEGsource'},'exclude',{''});
        break;
    elseif strfind(lower(funcname),'sourcelocalization.icclusteremg')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'ClusterAct'},'exclude',{''});
        break;
    elseif strfind(lower(funcname),'sourcelocalization.iccluster')
        set(handles.popupmenu_currdir,'value',1);
        uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'eeg'},'exclude',{'EEGsource-','-EEGclean','T00'});
        break;    
    else
        if strfind(lower(funcname),'eeg')
            eegopt=1;
        end
        if strfind(lower(funcname),'kin')
            kinopt=1;
        end
    end
end
if eegopt==1 && kinopt==0
    set(handles.popupmenu_currdir,'value',1);
    uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'-eeg'},'exclude',{'linkmatfile'});
elseif eegopt==0 && kinopt==1
    set(handles.popupmenu_currdir,'value',1);
    uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'},'search',{'-kin'},'exclude',{'linkmatfile'});
elseif eegopt==1 && kinopt==1
    set(handles.popupmenu_currdir,'value',1);
    uijlist_setfiles(handles.jlistbox_filelist,handles.datadir{1},'type',{'.mat'});
else
end
handles.jlistbox_filelist.setSelectionInterval(0,handles.jlistbox_filelist.getModel.getSize-1);
% Set subjectID to edit text;
% Scan jlistbox for subject name. Filename format SUBJ-
selectedfiles=uigetjlistbox(handles.jlistbox_filelist,'select','all');
subjectID=uigetsubjectID(selectedfiles);
if ~isempty(subjectID)
    subjectIDtxt=subjectID{1};
    for i=2:length(subjectID)
        subjectIDtxt=[subjectIDtxt, ', ' subjectID{i}];
    end
    set(handles.edit_subjectID,'string',subjectIDtxt);
end
setappdata(handles.figure,'handles',handles);

function pushbutton_updir_Callback(hObject,eventdata,handles)
dirlist=get(handles.popupmenu_currdir,'string');
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
if strfind(currdir,'.\')
    slash=strfind(currdir,'\');
    updir=currdir(1:slash(end));
    if strcmpi(currdir,'.\')
        [updir,~,~]=fileparts(cd);
    end
else
    [updir,~,~]=fileparts(currdir);
end
if length(dirlist)<=10
    dirlist{end+1}=updir;
else
    dirlist{end}=updir;
end
set(handles.popupmenu_currdir,'string',dirlist,'value',length(dirlist));
uijlist_setfiles(handles.jlistbox_filelist,updir,'type',{'.all'});

function pushbutton_editorsave_Callback(hObject,eventdata,handles)
editorfile=which(handles.jcombo_editor.getSelectedItem);
fid=fopen(editorfile,'w'); %allow write to text file
txtcode=char(handles.jedit_editor.getText);
txtcode=strrep(txtcode,'%','%%');
txtcode=strrep(txtcode,'\','\\');
fprintf(fid,txtcode);
logMessage(sprintf('%s%s',editorfile,handles.msg.saved),handles.jedit_log, 'useicon',handles.iconlist.status.saved);
fclose(fid)

function pushbutton_editoropen_Callback(hObject,eventdata,handles)
[filename pathname] = uigetfile('.\*.txt','Select File Directory...');
%if file selection is cancelled, pathname should be zero
%and nothing happen
if filename == 0 %Cancel without selection
    return
else
    filepath=sprintf('%s%s',pathname,filename);
    [~,~,ext]=fileparts(filepath);
    if strcmpi(ext,'.txt')
        updatejcombo(handles.jcombo_editor,filepath);
        jeditload(handles.jedit_editor,filepath);
        logMessage(sprintf('%s%s',filename,handles.msg.loaded),handles.jedit_log, 'useicon',handles.iconlist.status.fileloaded);
    else
        logMessage(sprintf('%s%s',filename,handles.msg.nottxt),handles.jedit_log, 'useicon',handles.iconlist.status.info);
    end
end

function pushbutton_uitreerun_Callback(hObject,eventdata,handles)
handles=getappdata(handles.figure,'handles');
selectedfiles=uigetjlistbox(handles.jlistbox_filelist);
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
for i=1:length(selectedfiles)
    filenameinput{i}=fullfile(currdir,selectedfiles{i});
end
selrows=handles.juitree_funclist.getSelectionRows;
set(handles.jwaitbarhdl,'value',0);
for i=1:length(handles.funclistpath)
    pathrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
    thispath=handles.funclistpath{i}.getLastPathComponent;
    thispathstr=char(thispath.toString);
    thispathstr=thispathstr(strfind(thispathstr,':')+1:end);
    thispathstr(isspace(thispathstr))=[];
    pathnames{i}=thispathstr;
end
% pathrows
% pathnames
handles.runopt={};
k=1;
jold=1;
for i=1:length(selrows)
    thisrow=selrows(i);
    for j=2:length(pathrows)    % Next main path
        thispath=pathrows(j);
        if thisrow<thispath
            if j>jold
                k=1;
            end
            strcmd=sprintf('handles.runopt{j-1,k}=thisrow-pathrows(j-1);');
            eval(strcmd);
            if handles.runopt{j-1,k}==0
                handles.runopt{j-1,k}=[];
            end;
            strcmd=sprintf('handles.pathrun{j-1}=''handles.FunctionList.%s.%s'';',pathnames{j-1},pathnames{j-1});
            eval(strcmd);
            k=k+1;
            jold=j;
            break;
        end
    end
end
for i=1:length(handles.pathrun)
    pathrunfunc=handles.pathrun{i};
    pathrunopt=[];
    k=1;
    for j=1:size(handles.runopt,2)
        try
            if ~isempty(handles.runopt{i,j})
                pathrunopt(k)=handles.runopt{i,j};
                k=k+1;
            end
        catch
        end
    end
    
    pathrunopt=sort(pathrunopt);
    
    if ~isempty(pathrunopt) && ~isempty(pathrunfunc)
        cmdstr=sprintf('mfilefunc=%s;',pathrunfunc);
        eval(cmdstr);
        cmdstr=sprintf('%s(handles,''filename'',filenameinput,''runopt'',[%s]);',mfilefunc,num2str(pathrunopt));
        %         try
        eval(cmdstr);
        %         catch ME
        %             logMessage(sprintf('Program Terminated at: %s',mfilefunc),handles.jedit_log, 'useicon',handles.iconlist.status.error);
        %             logMessage(sprintf('%s',ME.message),handles.jedit_log, 'useicon',handles.iconlist.status.error);
        %             logMessage(sprintf('Error in: %s.  Line:%d',ME.stack.name,ME.stack.line),handles.jedit_log, 'useicon',handles.iconlist.status.error);
        %             return;
        %         end
    end
end
% thisfig=findall(0, '-depth',1, 'type','figure', 'Name',mfilename);
% allfig=findall(0, '-depth',1, 'type','figure');
% close(setdiff(allfig,thisfig));
logMessage(sprintf('%s',mfilename),handles.jedit_log,'useicon',handles.iconlist.status.stop);
setappdata(handles.figure,'handles',handles);

function pushbutton_linkmatfiles_Callback(hObject,eventdata,handles)
global gvar;
handles=getappdata(handles.figure,'handles');
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.user);
% Get Subject ID in edit text
txtsubjectID=get(handles.edit_subjectID,'string');
delimi=strfind(txtsubjectID,',');
if isempty(delimi)
    subjectlist{1}=txtsubjectID;
else
    subjectlist{1}=txtsubjectID(1:delimi(1)-1);
    for i=1:length(delimi)-1
        subjectlist{i+1}=txtsubjectID(delimi(i)+2:delimi(i+1)-1);
    end
    subjectlist{end+1}=txtsubjectID(delimi(end)+2:end);
end
subjectliststr=strrep(txtsubjectID,',','-');
subjectliststr = subjectliststr(~isspace(subjectliststr));
% Get file list
filelist=uigetjlistbox(handles.jlistbox_filelist,'select','all');
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
% iskin=0;
% iseeg=0;
% 160404: Updated version. Using matfile class instead of saving large file
AllEEG = [];
AllKin = [];
for s = 1:length(subjectlist)
    thissubj = lower(subjectlist{s});
    j = 1; k=1;
    for i=1:length(filelist)
        %     fullfilelist{i}=fullfile(currdir,filelist{i});
        thisfile = lower(filelist{i});
        
        if ~isempty(strfind(thisfile,thissubj)) && ~isempty(strfind(thisfile,'eeg')) && isempty(strfind(thisfile,'linkmatfile'))
            AllEEG{s,j} = matfile(fullfile(currdir,filelist{i}),'Writable',true);
            j = j+1;
            %         iseeg=1;
        elseif ~isempty(strfind(thisfile,thissubj)) && ~isempty(strfind(thisfile,'kin')) && isempty(strfind(thisfile,'linkmatfile'))
            thisfile
            AllKin{s,k} = matfile(fullfile(currdir,filelist{i}),'Writable',true);
            k = k+1;
            %         iskin=1;
        end
    end
end
mydate = class_datetime;
if ~isempty(AllEEG)
    filetype = 'EEG';
    filename=['Linkmatfile-' mydate.all '-' subjectliststr '-' filetype '.mat'];
    fprintf('Saving...Filename: %s\n',filename);
    myfile = class_FileIO('filename',filename,'filedir',currdir);
    myfile.savevars(AllEEG);
end
if ~isempty(AllKin)
    filetype = 'Kin';
    filename=['Linkmatfile-' mydate.all '-' subjectliststr '-' filetype '.mat'];
    fprintf('Saving...Filename: %s\n',filename);
    myfile = class_FileIO('filename',filename,'filedir',currdir);
    myfile.savevars(AllKin);
end
% if get(handles.checkbox_selvarname,'value')==0
%     uilinkmatfiles(fullfilelist,subjectlist,'varname',gvar.linkmatfilevarname,...
%         'kinvarlist',handles.selvarname.kinvar,'eegvarlist',handles.selvarname.eegvar);
% else
%     uilinkmatfiles(fullfilelist,subjectlist,'varname',gvar.linkmatfilevarname,...
%         'kinvarlist','all','eegvarlist','all');
% end
% % ==
% WSVARS = evalin('base','who');
% for wscon=1:size(WSVARS,1)
%     if strcmpi(WSVARS{wscon},gvar.linkmatfilevarname)
%         thisvar=evalin('base', WSVARS{wscon});
%         THEWORKSPACE.(WSVARS{wscon})=thisvar;
%     end
% end
% var=THEWORKSPACE;
% assignin('base','var',var);
% if iskin==1 && iseeg==1
%     filetype='All_';
% elseif iskin==1 && iseeg==0
%     filetype='Kin_';
% elseif iskin==0 && iseeg==1
%     filetype='EEG_';
% end
% filename=[gvar.linkmatfilename '_' filetype subjectliststr '.mat'];
% fprintf('Saving...Filename: %s\n',filename);
% cmdstr=sprintf('save(''%s'',''var'',''-v7.3'')',fullfile(currdir,filename));
% evalin('base',cmdstr);
uijlist_setfiles(handles.jlistbox_filelist,currdir,'type',{'.all'});
logMessage(sprintf('%s',filename),handles.jedit_log,'useicon',handles.iconlist.action.save);
setappdata(handles.figure,'handles',handles);

function handles=KeyboardThread_Callback(hObject,eventdata,handles)
key=eventdata.Key;
if strcmpi(key,'f5')
    pushbutton_editorrun_Callback(handles.pushbutton_editorrun,eventdata,handles);
    % elseif strcmpi(key,'return') || strcmpi(key,'space')
    %     pushbutton_uitreerun_Callback(handles.pushbutton_uitreerun,eventdata,handles);
end

function handles=jlistbox_filenameinput_Keypress_Callback(hObject,eventdata,handles)
% double(eventdata.getKeyChar)
pathsel=[];
numofpath=length(handles.funclistpath);
key=eventdata.getKeyText(eventdata.getKeyCode);
%Press 1
if strcmpi(key,'numpad-0') || strcmpi(key,'0')
    pathsel=1:numofpath;
elseif strcmpi(key,'numpad-1') || strcmpi(key,'1')
    pathsel=1;
elseif strcmpi(key,'numpad-2') || strcmpi(key,'2')
    pathsel=2;
elseif strcmpi(key,'numpad-3') || strcmpi(key,'3')
    pathsel=3;
else
end
if ~isempty(pathsel)
    pathclose=setdiff(1:numofpath,pathsel);
    for i=1:length(pathsel)
        k=pathsel(i);
        handles.juitree_funclist.expandPath(handles.funclistpath{k});
        selectedrows(i)=handles.juitree_funclist.getRowForPath(handles.funclistpath{k});
    end
    handles.juitree_funclist.setSelectionRows(selectedrows);
    for j=1:length(pathclose)
        k=pathclose(j);
        handles.juitree_funclist.collapsePath(handles.funclistpath{k});
    end
end
%Short cut for file list
if strcmpi(key,'left') || strcmpi(key,'backspace')       %press arrow up 'leftarrow
    pushbutton_updir_Callback(handles.pushbutton_updir,eventdata,handles);
elseif strcmpi(key,'up')
    selrow=get(handles.jlistbox_filelist,'value');
    if selrow>1
        set(handles.jlistbox_filelist,'value',selrow-1);
    else
    end
elseif strcmpi(key,'down')
    selrow=get(handles.jlistbox_filelist,'value');
    if selrow<length(get(handles.jlistbox_filelist,'string'))
        set(handles.jlistbox_filelist,'value',selrow+1);
    else
    end
end
if strcmpi(key,'r')     %go to root folder
    set(handles.popupmenu_currdir,'value',1);
    popupmenu_currdir_Callback(handles.popupmenu_currdir,eventdata,handles);
end
%working with find directory
if strcmpi(key,'m')
    handles.jcombo_dirlookup.setSelectedItem('.mat');
    jcombo_dirlookup_Callback(handles.jcombo_dirlookup,eventdata,handles);
elseif strcmpi(key,'f')
    handles.jcombo_dirlookup.setSelectedItem('.folder');
    jcombo_dirlookup_Callback(handles.jcombo_dirlookup,eventdata,handles);
elseif strcmpi(key,'t')
    handles.jcombo_dirlookup.setSelectedItem('.txt');
    jcombo_dirlookup_Callback(handles.jcombo_dirlookup,eventdata,handles);
elseif strcmpi(key,'e')
    handles.jcombo_dirlookup.setSelectedItem('.all');
    jcombo_dirlookup_Callback(handles.jcombo_dirlookup,eventdata,handles);
else
end
%Enter
if strcmpi(key,'enter')
    val=get(hObject,'SelectedValue');
    mark1=strfind(val,'>');mark1=mark1(end-1);
    mark2=strfind(val,'<');mark2=mark2(end);
    filename=val(mark1+1:mark2-1);
    [~,selname,ext]=fileparts(filename);
    currdirlist=get(handles.popupmenu_currdir,'string');
    currdir=currdirlist{get(handles.popupmenu_currdir,'value')};
    if isempty(ext)     %folder selection
        if strcmpi(currdir(end),'\')
            newdir=strcat(currdir,selname);
        else
            newdir=strcat(currdir,'\',selname);
        end
        uijlist_setfiles(handles.jlistbox_filelist,newdir,'type',{'.all'});
        handles.jcombo_dirlookup.setSelectedIndex(0);
        popuplist=get(handles.popupmenu_currdir,'string');
        if length(popuplist)<=10
            popuplist{end+1}=newdir;
        else
            popuplist{end}=newdir;
        end
        set(handles.popupmenu_currdir,'string',popuplist);
        set(handles.popupmenu_currdir,'value',length(popuplist));
    elseif strcmpi(ext,'.txt')
        jeditload(handles.jedit_editor,fullfile(currdir,filename));
        updatejcombo(handles.jcombo_editor,fullfile(currdir,filename));
    else
        logMessage(sprintf('%s%s',filename,handles.msg.nottxt),handles.jedit_log, 'useicon',handles.iconlist.status.info);
    end
end

function handles=jedit_editor_Keypress_Callback(hObject,eventdata,handles)
key=eventdata.getKeyText(eventdata.getKeyCode);
keycode=eventdata.getKeyCode;
%Press Ctr-S
if keycode==java.awt.event.KeyEvent.VK_S && eventdata.isControlDown
    hObjectCallback = get(handles.pushbutton_editorsave, 'Callback');
    hObjectCallback{1}(hObject,[],hObjectCallback{2:end}); % Run Callback
elseif strcmpi(key,'F5')
    hObjectCallback = get(handles.pushbutton_editorrun, 'Callback');
    hObjectCallback{1}(hObject,[],hObjectCallback{2:end}); % Run Callback
end

function codeline=read_textfile(filein)
fid = fopen(filein);
if fid==-1 % No file found
    codeline{1}=sprintf('%s is missing',filein);
else
    filescan = textscan(fid,'%s','delimiter','\n');
    filescan = filescan{:}; % Open settings file (importdata does not work)
    for line = 1:length(filescan)
        codeline{line}=filescan{line};
    end
end

function pushbutton_editorrun_Callback(hObject,eventdata,handles)
global gvar;
timenow=gvar.timenow;
handles=getappdata(handles.figure,'handles');
selitem=handles.jcombo_editor.getSelectedItem;
[~,editorfilename,~]=fileparts(selitem);
hObjectCallback = get(handles.pushbutton_editorsave, 'Callback');
hObjectCallback{1}(hObject,[],hObjectCallback{2:end}); % Run Callback
edit(editorfilename);
% cmdstr=sprintf('%s(handles)',editorfilename);
% eval(cmdstr);
setappdata(handles.figure,'handles',handles);

function updatejcombo(jcombohdl,newitem,varargin)
maxitem=10;
if length(varargin)>=2
    for i=1:2:length(varargin)
        param=varargin{i};
        val=varargin{i+1};
        switch lower(param)
            case 'maxitem'
                maxitem=val;
            otherwise
        end
    end
end
jcombohdl.insertItemAt(newitem,0);
lastrow=jcombohdl.getItemCount;
if lastrow>maxitem
    jcombohdl.removeItemAt(lastrow-1); %java index from 0
end
jcombohdl.setSelectedIndex(0);

function jeditload(jedithdl,filename,varargin)
codeline=read_textfile(filename);
%  writecodeline(jedithdl,codeline);
cr=[char(13) char(10)]; %carry return
thiscode=[];
for i=1:length(codeline)
    thiscode=[thiscode codeline{i} cr];
end
jedithdl.setText(thiscode);

function funclist=sub_getfunclist(funcname,handles)
cmdstr=sprintf('list=%s(handles,''getfunclist'',1);',funcname);
eval(cmdstr);
funclist=cell(1,length(list)+1);
funclist{1}=funcname;
for i=1:length(list)
    funclist{i+1}=list{i};
end

function handles=sub_definefuncmap(handles)
treeroot='Function List';
treerootfunc=treeroot(~isspace(treeroot));
treepath='pathlist';
%From mfile
rootdir=dir('.\');
j=1;
filekeyword = handles.filekeyword;
% find all filename with 'uhbmigui' in working directory.
for i=1:length(rootdir)
    thisfile=rootdir(i).name;
    [~,name,ext]=fileparts(thisfile);
    if ~isempty(strfind(lower(name),lower(filekeyword))) && strcmpi(ext,'.m')
        mfilemain{j}=name;
        j=j+1;
    end
end
for i=1:length(mfilemain)
    thismfilemain=mfilemain{i};
    underscoremark = strfind(thismfilemain,'_');
    thistreemain=thismfilemain(underscoremark(end)+1:end); % Keep string after '_';
    % Get all sub function in mfilemain. e.g. UHBMIGUI_FileIO;
    mainfilefunclist={};
    mainfilefunclist=sub_getfunclist(thismfilemain,handles);
    k=1;
    cmdstr=sprintf('%s.%s={};',...
        treepath,thistreemain);
    eval(cmdstr);
    cmdstr=sprintf('%s.%s.main=''%s'';',treerootfunc,thistreemain,thismfilemain);
    eval(cmdstr);
    %===============
    for j=1:length(mainfilefunclist)
        thissubfunc=mainfilefunclist{j};
        mark=strfind(thissubfunc,'_');
        mark=mark(end);
        thistreeleaf=thissubfunc(mark+1:end);
        cmdstr=sprintf('%s.%s.%s=''%s'';',...
            treerootfunc,thistreemain,thistreeleaf,thissubfunc);
        eval(cmdstr);
        cmdstr=sprintf('%s.%s{%d}=''%s'';k=k+1;',...
            treepath,thistreemain,k,thistreeleaf);
        eval(cmdstr);
    end
end
cmdstr=sprintf('handles.%s=%s;',treerootfunc,treerootfunc);
eval(cmdstr);
cmdstr=sprintf('handles.%s=%s;',treepath,treepath);
eval(cmdstr);
handles.treeroot=treeroot;

function sub_maketreepath(mainpath,childpath)
%inputname is the variable name of input number 1;
iconlist=getmatlabicons;
if strcmpi(inputname(1),'fileio')
    defaulticon='iconlist.action.open';
elseif strcmpi(inputname(1),'print')
    defaulticon='iconlist.action.print';
elseif strcmpi(inputname(1),'end')
    defaulticon='iconlist.status.stop';
else
    defaulticon='iconlist.uh';
end
strcmd=sprintf('%s=mainpath;',inputname(1));
eval(strcmd);
for i=1:length(childpath)
    if strfind(lower(childpath{i}),'import')
        icon='iconlist.action.import';
    elseif strfind(lower(childpath{i}),'export')
        icon='iconlist.action.export';
    elseif strfind(lower(childpath{i}),'link')
        icon='iconlist.link';
    elseif strfind(lower(childpath{i}),'save')
        icon='iconlist.action.save';
    elseif strfind(lower(childpath{i}),'make')
        icon='iconlist.file.foldermat';
    elseif strfind(lower(childpath{i}),'preprocess')
        icon='iconlist.action.filter';
    elseif strfind(lower(childpath{i}),'print')
        icon='iconlist.action.print';
    else
        icon=defaulticon;
    end
    cmdstr=sprintf('%s.add(uitreenode(''v0'', ''%s'',  ''%s'',  %s, true));',...
        inputname(1),childpath{i},childpath{i},icon);
    eval(cmdstr);
end

function handles=uimenubar(handles)
import javax.swing.*
import java.awt.*
import java.awt.event.*
icons=handles.iconlist;
jMenuBar=JMenuBar;
jMenuFile=JMenu('File');
jMenuBar.add(jMenuFile);
%Sub menu
%jMenuFile.addSeparator();
jSubMenu=JMenu('New');
jSubMenu.setMnemonic(KeyEvent.VK_N);
jMenuFile.add(jSubMenu);
jMenuItem=JMenuItem('Module...',ImageIcon(icons.file.m));
jMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_M, ActionEvent.CTRL_MASK));
hjMenuItemModule = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemModule,'ActionPerformedCallback',{@jMenuItemModule_Callback,handles});
jSubMenu.add(jMenuItem);

jMenuItem=JMenuItem('Function...',ImageIcon(icons.function));
jMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F, ActionEvent.CTRL_MASK));
hjMenuItemFunc = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemFunc,'ActionPerformedCallback',{@jMenuItemFunc_Callback,handles});
jSubMenu.add(jMenuItem);
jMenuItem=javax.swing.JMenuItem('Open...',ImageIcon(icons.action.open));
jMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, ActionEvent.CTRL_MASK));
hjMenuItemOpen = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemOpen,'ActionPerformedCallback',{@jMenuItemOpen_Callback,handles});
jMenuFile.add(jMenuItem);
jMenuSetting=JMenu('Setting');
jMenuSetting.setMnemonic(KeyEvent.VK_S);
jMenuBar.add(jMenuSetting);
jMenuItem=JMenuItem('Set Data Folder...',ImageIcon(icons.folder));
hjMenuItemModule = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemModule,'ActionPerformedCallback',{@jMenuItemSettingFolder_Callback,handles});
jMenuSetting.add(jMenuItem);
%
% jMenuItem=JMenuItem('Set Link Vars...',ImageIcon(icons.vars.struct));
% hjMenuItemsetlinkvar = handle(jMenuItem,'CallbackProperties');
% set(hjMenuItemsetlinkvar,'ActionPerformedCallback',{@jMenuItemSetLinkVar_Callback,handles});
% jMenuSetting.add(jMenuItem);

jMenusubGUI=JMenu('Sub GUI');
jMenuBar.add(jMenusubGUI);
jMenuItem=JMenuItem('Gait Segment...',ImageIcon(icons.walk));
jMenuItem.setMnemonic(KeyEvent.VK_G);
jMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_G, ActionEvent.CTRL_MASK));
hjMenuItemGaitSegment = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemGaitSegment,'ActionPerformedCallback',{@jMenuItemGaitSegment_Callback,handles});
jMenusubGUI.add(jMenuItem);
jMenuHelp=JMenu('Help');
jMenuHelp.setMnemonic(KeyEvent.VK_H);
jMenuBar.add(jMenuHelp);
jMenuItem=JMenuItem('Document...',ImageIcon(icons.web));
hjMenuItemViewdoc = handle(jMenuItem,'CallbackProperties');
set(hjMenuItemViewdoc,'ActionPerformedCallback',{@jMenuItemViewdoc_Callback,handles});
jMenuHelp.add(jMenuItem);
jMenuBar.setPreferredSize(Dimension(100,28));
jMenuBar.setBackground(Color.white);
handles.jMenuBar=jMenuBar;
javacomponent(jMenuBar,'North',handles.figure);

function handles=uitreefunclist(handles)
% Import javax for uitree
import javax.swing.*
import java.awt.*
import java.awt.event.*
%--
root = uitreenode('v0',handles.treeroot,handles.treeroot, handles.iconlist.function, false);
mainpath=fieldnames(handles.pathlist);
iconnode = {};

for i=1:length(mainpath)
    thismainpath = lower(mainpath{i});
    if ~isempty(strfind(thismainpath,'kin'))
        iconnode{i}=sprintf('''%s''',handles.iconlist.walk);
    elseif ~isempty(strfind(thismainpath,'eeg'))
        iconnode{i}=sprintf('''%s''',handles.iconlist.brain);
    elseif ~isempty(strfind(thismainpath,'fileio'))
        iconnode{i}=sprintf('''%s''',handles.iconlist.action.import);
    elseif strcmpi(thismainpath,'end')
        iconnode{i}=sprintf('''%s''',handles.iconlist.status.stop);
    else
        iconnode{i}=sprintf('''%s''',handles.iconlist.uh);
    end
end

for i=1:length(mainpath)
    cmdstr=sprintf('thispath=handles.pathlist.%s;',mainpath{i});
    eval(cmdstr);
    mainnode=thispath{1};
    subnode={};
    for j=2:length(thispath) subnode{j-1}=thispath{j}; end;
    cmdstr=sprintf('%s=uitreenode(''v0'',''%s'',''%s'',%s,false);',...
        mainnode,mainnode,mainnode,...
        iconnode{i});
    eval(cmdstr);
    cmdstr=sprintf('sub_maketreepath(%s,subnode);',...
        mainnode);
    eval(cmdstr);
    cmdstr=sprintf('root.add(%s);',mainnode);eval(cmdstr);
    cmdstr=sprintf('handles.funclistpath{i}=tree.TreePath(%s.getPath);',...
        mainnode);eval(cmdstr); %Use handles to get this funclistpath var
end
% Tree1
uitree_funclist = uitree('v0', 'Root', root);
juitree_funclist=uitree_funclist.getTree; %Important: Get Java object
width=0.15;height=0.58;relpos=[0.4 0.1 0.5 0.5];%get(handles.combo_currdir,'position');
set(uitree_funclist,'units','normalized',...
    'Position',[sum(relpos([1,3]))+0.01 sum(relpos([2,4]))-height+0.035 width height],...
    'MultipleSelectionEnabled',1);
for i=1:length(handles.funclistpath)
    juitree_funclist.expandPath(handles.funclistpath{i});
end
handles.uitree_funclist=uitree_funclist;

function jMenuItemModule_Callback(hObject,eventdata,handles)
modulefilename='UHBMIGUI_untitled';
MenuFcn_CreateTemplate(modulefilename);
edit(modulefilename);

function jMenuItemGaitSegment_Callback(hObject,eventdata,handles)
GUIAVATAR_GaitSegment;

function jMenuItemSettingFolder_Callback(hObject,eventdata,handles)
MenuFcn_SettingFolder;

function jMenuItemSetLinkVar_Callback(hObject,eventdata,handles)
MenuFcn_SettingVars;

function jMenuItemFunc_Callback(hObject,eventdata,handles)
MenuFcn_Newfunction;

function jMenuItemOpen_Callback(hObject,eventdata,handles)
uigetfile('.\*.m','Select File');

function jMenuItemViewdoc_Callback(hObject,eventdata,handles)
web('.\Publish\html\PublishGUIAVATAR.html');
