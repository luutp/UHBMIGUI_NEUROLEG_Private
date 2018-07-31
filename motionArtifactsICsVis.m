%% templatecode_gui.m 
%% *Description:* 
%% *Usages:* 
% 
% *Inputs:* 
%  
% *Outputs:* 
%  
% *Options:* 
%  
% *Notes:* 
% 
%% *Authors:* 
% * *MATLAB Ver :* 9.0.0.341360 (R2016a) 
% * *Date Created :* 04-Dec-2016 01:39:26 
% * *Author:* Phat Luu. ptluu2@central.uh.edu 
% 
% _Laboratory for Noninvasive Brain Machine Interface Systems._ 
%  
% _University of Houston_ 
%  
 
% This program is free software; you can redistribute it and/or modify 
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation; either version 2 of the License, or 
% (at your option) any later version. 
% 
% This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. 
%% 
function motionArtifactsICsVis(varargin)
% Add Paths and external libs 
uhlib = '..\uhlib'; 
addpath(genpath(uhlib)); 
% Import Java 
import javax.swing.*; 
import java.awt.*; 
import java.awt.event.*; 
import java.util.*; 
import java.lang.*; 
global gvar 
gvar=def_gvar; 
mfilepath = mfilename('fullpath'); 
[filedir, filename, ~] = fileparts(mfilepath); 
%====STEP 1: FRAME======================================================== 
handles.iconlist=getmatlabicons; 
% Create a new figure 
[handles.figure, handles.jstatusbarhdl,handles.jwaitbarhdl]=uh_uiframe('figname',mfilename,... 
'units','norm','position',[0.1 0.3 0.5 0.6],... 
'toolbar','figure',... 
'statusbar',1, 'icon',handles.iconlist.uh,'logo','none',... 
'logopos',[0.89,0.79,0.2,0.2]); 
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
% combobox and List files 
uistring={icontext(handles.iconlist.action.updir,''),... 
{'G:\OneDrive\MotionArtifact\PROCESS DATA',cd,filedir,'C:\','P:\MatlabCode\uhlib','P:\Dropbox\LTP_Publication'},... 
icontext(handles.iconlist.action.newfolder,''),...     
}; 
w=0.55-gvar.margin.gap; h=0.1; 
[container_currdir,handles.pushbutton_updir,handles.combobox_currdir,handles.pushbutton_newdir,...     
]=uigridcomp({'pushbutton','combobox','pushbutton',...     
},... 
'uistring',uistring,... 
'position',[gvar.margin.l 1-4*gvar.margin.l-h w h],... 
'gridsize',[1 3],'gridmargin',5,'hweight',[1 8 1],'vweight',1); 
% Listbox for file list 
uistring={'','',...     
}; 
[container_filelist,handles.jlistbox_filenameinput,... 
    handles.jlistbox_ICsInfo,...
]=uigridcomp({'list','list',...     
},... 
'uistring',uistring,...     
'gridsize',[1 2],'gridmargin',5,'hweight',[2 1],'vweight',1); 
% ICs display control
% combobox and List files 
uistring={{'Poorfit','Outside','EOG','EMG'},...
}; 
w=0.5-gvar.margin.gap; h=0.1; 
[container_showICs,handles.combobox_ICstype,...
]=uigridcomp({'combobox',...     
},... 
'uistring',uistring,... 
'position',[gvar.margin.l 1-4*gvar.margin.l-h w h],... 
'gridsize',[1 1],'gridmargin',5,'hweight',[1],'vweight',1);

uistring={'Dip',icontext(handles.iconlist.eeg.dipplot,''),... 
icontext(handles.iconlist.eeg.selectcomp,''),'Topo',...     
}; 
w=0.5-gvar.margin.gap; h=0.1; 
[container_showICsbuttons,~,...
    handles.pushbutton_dipplot,...     
    handles.pushbutton_selectcomp,~,...
]=uigridcomp({'label','pushbutton','pushbutton','label',...     
},... 
'uistring',uistring,... 
'position',[gvar.margin.l 1-4*gvar.margin.l-h w h],... 
'gridsize',[1 4],'gridmargin',5,'hweight',[0.5 1 1 0.5],'vweight',1);
uipanel_showICs=uipanellist('title','Visualize',...
                'objects',[container_showICs,container_showICsbuttons],...
                'itemheight',[0.4 0.5],...
                'gap',[0 gvar.margin.gap]); 
% Cleaning EEG options
uistring={{'Poor fit',icontext(handles.iconlist.yes,'Yes'),icontext(handles.iconlist.no,'No')},...
    {'Outside',icontext(handles.iconlist.yes,'Yes'),icontext(handles.iconlist.no,'No')},...
    {'Eye Artifacts',icontext(handles.iconlist.yes,'Yes'),icontext(handles.iconlist.no,'No')},...
    {'Muscle Artifacts',icontext(handles.iconlist.yes,'Yes'),icontext(handles.iconlist.no,'No')},...
    '',...
    icontext(handles.iconlist.action.save,''),...
    };
[container_cleanPanel,handles.radio_poorfit,...
    handles.radio_outside,...
    handles.radio_eog,...
    handles.radio_emg,...
    handles.edit_saveFilename,...
    handles.pushbutton_save,...
]=uigridcomp({'radio','radio','radio','radio',...
'edit',...
'pushbutton',...
},... 
'uistring',uistring,... 
'position',[gvar.margin.l 1-4*gvar.margin.l-h w h],... 
'gridsize',[6 1],'gridmargin',5,'hweight',1,'vweight',[1 1 1 1 0.5 0.5]); 

uipanel_cleanPanel=uipanellist('title','EEG Clean Options',...
                'objects',container_cleanPanel,...
                'itemheight',1,...
                'gap',[0 gvar.margin.gap]); 
% Alignment
uialign(container_filelist,container_currdir,'align','southwest','scale',[1 8],'gap',[0 -gvar.margin.gap]); 
uialign(uipanel_showICs,container_currdir,'align','east','scale',[0.75 1.75],'gap',[gvar.margin.gap 0]); 
uialign(uipanel_cleanPanel,uipanel_showICs,'align','southwest','scale',[1 4],'gap',[0 -2*gvar.margin.gap]); 
% Initialize 
set(handles.combobox_currdir,'selectedindex',0); 
set(handles.combobox_ICstype,'selectedindex',0); 
uijlist_setfiles(handles.jlistbox_filenameinput,get(handles.combobox_currdir,'selecteditem')); 
handles.keyholder = ''; 
% Set callback 
% Keyboar thread 
set(handles.figure,'WindowKeyPressFcn',{@KeyboardThread_Callback,handles}); 
% Pushbutton 
set(handles.pushbutton_updir,'Callback',{@pushbutton_updir_Callback,handles}); 
% combobox 
set(handles.combobox_currdir,'ActionPerformedCallback',{@combobox_currdir_Callback,handles}); 
% jlistbox 
set(handles.jlistbox_filenameinput,'MousePressedCallback',{@jlistbox_filenameinput_Mouse_Callback,handles}); 
set(handles.jlistbox_filenameinput,'KeyPressedCallback',{@KeyboardThread_Callback,handles}); 
% ICs display control.
set(handles.pushbutton_dipplot,'Callback',{@pushbutton_dipplot_Callback,handles}); 
set(handles.pushbutton_selectcomp,'Callback',{@pushbutton_selectcomp_Callback,handles}); 
set(handles.pushbutton_save,'Callback',{@pushbutton_save_Callback,handles}); 
% Setappdata 
setappdata(handles.figure,'handles',handles); 
%============= 
 
function pushbutton_updir_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
currdir=get(handles.combobox_currdir,'selecteditem'); 
% ==== START 
if strfind(currdir,'.\') 
slash=strfind(currdir,'\'); 
updir=currdir(1:slash(end)); 
if strcmpi(currdir,'.\') 
[updir,~,~]=fileparts(cd); 
end 
else 
[updir,~,~]=fileparts(currdir); 
end 
handles.combobox_currdir.insertItemAt(updir,0); 
set(handles.combobox_currdir,'selectedindex',0); 
% ==== END 
fprintf('DONE: %s.\n',thisFuncName); 
setappdata(handles.figure,'handles',handles); 
 
function jlistbox_filenameinput_Mouse_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
eventinf=get(eventdata); 
% ==== START 
if eventinf.Button==1 && eventinf.ClickCount==2 %double left click 
% Convert list item with html char (icon) to filename 
filename = html2item(get(hObject,'SelectedValue'));         
[~,selname,ext]=fileparts(filename);     
currdir = get(handles.combobox_currdir,'selecteditem'); 
if isempty(ext)     %folder selection 
if strcmpi(currdir(end),'\') 
newdir=strcat(currdir,selname); 
else 
newdir=strcat(currdir,'\',selname); 
end 
uijlist_setfiles(hObject,newdir,'type',{'.all'});         
updatejcombo(handles.combobox_currdir,newdir) 
elseif strcmpi(ext,'.txt') 
jeditload(handles.jedit_editor,fullfile(currdir,filename));         
elseif strcmpi(ext,'.m') 
edit(fullfile(currdir,filename)); 
elseif strcmpi(ext,'.mat') 
myfile = class_FileIO('filename',filename,'filedir',currdir); 
myfile.loadtows; 
assignin('base','FileObj',myfile);   
% Load ICs data to edit 
EEGprocess = evalin('base','EEGprocess');
uisetjlistbox(handles.jlistbox_ICsInfo,ICsInfo2list(EEGprocess));
set(handles.edit_saveFilename,'string',filename);
else         
end 
end 
% ==== END 
setappdata(handles.figure,'handles',handles); 
 
function combobox_currdir_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
newdir=get(hObject,'selecteditem'); 
% ==== START 
if strcmpi(newdir,'.\'); 
newdir=cd; 
end 
if ~strcmpi(newdir,hObject.getItemAt(0)) 
hObject.insertItemAt(newdir,0); 
end 
uijlist_setfiles(handles.jlistbox_filenameinput,newdir,'type',{'.all'}); 
% ==== END 
fprintf('DONE: %s.\n',thisFuncName); 
setappdata(handles.figure,'handles',handles); 
 
function handles=KeyboardThread_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI input 
handles=getappdata(handles.figure,'handles'); 
% ==== START 
if isprop(eventdata,'Key') 
key = lower(eventdata.Key); % Matlab component; Ctrl: 'control' 
else 
key = lower(char(eventdata.getKeyText(eventdata.getKeyCode)));    % Java component; 
end 
if any([strcmpi(key,'g'),strcmpi(key,'ctrl'),strcmpi(key,'control'),... 
strcmpi(key,'shift'),strcmpi(key,'alt')]) 
handles.keyholder = key; 
setappdata(handles.figure,'handles',handles); 
return; 
end 
% fprintf('KeyPressed: %s\n',key); 
% Go to component;
if strcmpi(key,'delete')
    filename = html2item(get(hObject,'SelectedValue'));         
    [~,selname,ext]=fileparts(filename);     
    currdir = get(handles.combobox_currdir,'selecteditem'); 
    selfile = fullfile(currdir,selname);
    strcmd=sprintf('delete(''%s.mat'')',selfile);
    eval(strcmd);
    uijlist_setfiles(handles.jlistbox_filenameinput,currdir,'type',{'.all'}); 
    fprintf('File deleted\n');    
end
if strcmpi(handles.keyholder,'g')
    if strcmpi(key,'f') % Set focus on function list
        handles.jlistbox_filenameinput.requestFocus;
        fprintf('jlistbox_filenameinput is selected.\n');
    end
elseif strcmpi(handles.keyholder,'shift')
elseif strcmpi(handles.keyholder,'ctrl') || strcmpi(handles.keyholder,'control') && strcmpi(key,'s')
    %     pushbutton_save_Callback(handles.pushbutton_save,[],handles);
else
    if strcmpi(key,'f1')
        winopen('.\hotkey.txt');
    end
end
handles.keyholder = ''; % reset keyholder;
% ==== END 
fprintf('DONE: %s.\n',thisFuncName); 
setappdata(handles.figure,'handles',handles); 
 
function handles=uimenubar(handles) 
import javax.swing.* 
import java.awt.* 
import java.awt.event.* 
icons=handles.iconlist; 
jMenuBar=JMenuBar; 
% Build a menu bar 
% + File 
%       +New 
%           + File Type 1... 
%       + Open... 
% + Help 
jMenuFile=JMenu('File'); 
jMenuBar.add(jMenuFile); % Add to jMenuBar 
jMenuFile_New = JMenu('New'); 
jMenuFile.add(jMenuFile_New); % Add to jMenuFile 
jMenuFile_New_Type1 = JMenuItem('Type 1...',ImageIcon(icons.file.m)); 
jMenuFile_New.add(jMenuFile_New_Type1); 
jMenuFile_Open = javax.swing.JMenuItem('Open...',ImageIcon(icons.action.open)); 
jMenuFile.add(jMenuFile_Open); 
 
jMenuHelp = JMenu('Help'); 
jMenuBar.add(jMenuHelp); 
jMenuHelp_Doc = JMenuItem('Document...',ImageIcon(icons.web)); 
jMenuHelp.add(jMenuHelp_Doc); 
jMenuBar.setPreferredSize(Dimension(100,28)); 
jMenuBar.setBackground(Color.white); 
handles.jMenuBar=jMenuBar; 
% Callback Define and Functions 
hjMenuFile_New_Type1 = handle(jMenuFile_New_Type1,'CallbackProperties'); 
set(hjMenuFile_New_Type1,'ActionPerformedCallback',{@jMenuFile_New_Type1_Callback,handles}); 
% Open 
hjMenuFile_Open = handle(jMenuFile_Open,'CallbackProperties'); 
set(hjMenuFile_Open,'ActionPerformedCallback',{@jMenuFile_Open_Callback,handles}); 
% Help 
hjMenuHelp_Doc = handle(jMenuHelp_Doc,'CallbackProperties'); 
set(hjMenuHelp_Doc,'ActionPerformedCallback',{@jMenuHelp_Doc_Callback,handles}); 
 
javacomponent(jMenuBar,'North',handles.figure); 

% ICs display control panel
function pushbutton_dipplot_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
% ==== START 
EEGprocess = evalin('base','EEGprocess');
badICstype = get(handles.combobox_ICstype,'selecteditem');
if strcmpi(badICstype,'poorfit')
    badICs = EEGprocess.uh_ICsPoorfit;
elseif strcmpi(badICstype,'outside')
    badICs = EEGprocess.uh_ICsOutsideBrain;
elseif strcmpi(badICstype,'EOG')
    badICs = EEGprocess.uh_ICsEOG;
elseif strcmpi(badICstype,'EMG')
    badICs = EEGprocess.uh_ICsEMG; 
else
end
if badICs ~= 0
    dipplot(EEGprocess.dipfit.model(badICs),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
else
    fprintf('There is no bad ICs of this type.\n');
end
% ==== END
fprintf('DONE: %s.\n',thisFuncName); 
setappdata(handles.figure,'handles',handles); 

function pushbutton_selectcomp_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
% ==== START 
EEGprocess = evalin('base','EEGprocess');
badICstype = get(handles.combobox_ICstype,'selecteditem');
alldip = 1: length(EEGprocess.chanlocs);
if strcmpi(badICstype,'poorfit')
    badICs = EEGprocess.uh_ICsPoorfit;
    pop_topoplot(EEGprocess,0,badICs,'',0,1);
elseif strcmpi(badICstype,'outside')
    badICs = EEGprocess.uh_ICsOutsideBrain;
    selectICs = luu_selectcomps(EEGprocess,alldip,...
        'rejcomp',badICs,...
        'auto',0,'nosedir','+Y');
    EEGprocess.uh_ICsOutsideBrain = selectICs;
elseif strcmpi(badICstype,'EOG')
    badICs = EEGprocess.uh_ICsEOG;
    selectICs = luu_selectcomps(EEGprocess,alldip,...
        'rejcomp',badICs,...
        'auto',0,'nosedir','+Y');
    EEGprocess.uh_ICsEOG = selectICs;
elseif strcmpi(badICstype,'EMG')
    badICs = EEGprocess.uh_ICsEMG;
    selectICs = luu_selectcomps(EEGprocess,alldip,...
        'rejcomp',badICs,...
        'auto',0,'nosedir','+Y');
    EEGprocess.uh_ICsEMG = selectICs;
else
end
assignin('base','EEGproces',EEGprocess);
uisetjlistbox(handles.jlistbox_ICsInfo,ICsInfo2list(EEGprocess));
allfig=findall(0,'type','figure');
GUIfig=findall(0, '-depth',1, 'type','figure', 'Name','motionArtifactsICsVis');
clcfig=setdiff(allfig,[GUIfig]);
if ~strcmpi(badICstype,'poorfit')
    close(clcfig);
end
% ==== END
fprintf('DONE: %s.\n',thisFuncName);
setappdata(handles.figure,'handles',handles); 

function pushbutton_save_Callback(hObject,eventdata,handles) 
[stacktrace, ~]=dbstack; 
thisFuncName=stacktrace(1).name; 
fprintf('RUNNING: %s.\n',thisFuncName); 
% ==== GUI INPUT 
handles=getappdata(handles.figure,'handles'); 
currdir = get(handles.combobox_currdir,'selecteditem'); 
% ==== START 
EEGprocess = evalin('base','EEGprocess');
rejcomps = [];
if get(handles.radio_poorfit.group,'selectedobject')==handles.radio_poorfit.items{1}
    rejcomps =[rejcomps, EEGprocess.uh_ICsPoorfit]; 
end
if get(handles.radio_outside.group,'selectedobject')==handles.radio_outside.items{1}
    rejcomps =[rejcomps, EEGprocess.uh_ICsOutsideBrain]; 
end
if get(handles.radio_eog.group,'selectedobject')==handles.radio_eog.items{1}
    rejcomps =[rejcomps, EEGprocess.uh_ICsEOG]; 
end
if get(handles.radio_emg.group,'selectedobject')==handles.radio_emg.items{1}
    rejcomps =[rejcomps, EEGprocess.uh_ICsEMG]; 
end
EEGprocess.uh_ICsrejected = rejcomps;
EEGclean = pop_subcomp(EEGprocess,rejcomps,0); %0 dont ask for confirm
EEGclean.icaact=EEGclean.icaweights*EEGclean.icasphere*EEGclean.data;
EEGclean.reject = EEGprocess.reject;
assignin('base','EEGclean',EEGclean);
filename = get(handles.edit_saveFilename,'string');
myfile = class_FileIO('filename',filename,'filedir',currdir); 
myfile.savews;
uijlist_setfiles(handles.jlistbox_filenameinput,currdir,'type',{'.all'}); 
% ==== END
fprintf('DONE: %s.\n',thisFuncName);
setappdata(handles.figure,'handles',handles); 

function liststr = ICsInfo2list(EEGprocess)
% EEGprocess = evalin('base','EEGprocess');
for i = 1 : length(EEGprocess.chanlocs)
    matlist{i} = sprintf('%02d     -     ',i);
    label{i} = 'Good';
end
for i = 1 : length(EEGprocess.uh_ICsPoorfit)
    label{EEGprocess.uh_ICsPoorfit(i)} = 'Poorfit';
end
for i = 1 : length(EEGprocess.uh_ICsOutsideBrain)
    label{EEGprocess.uh_ICsOutsideBrain(i)} = 'Outside';
end
for i = 1 : length(EEGprocess.uh_ICsEOG)
    label{EEGprocess.uh_ICsEOG(i)} = 'EOG';
end
for i = 1 : length(EEGprocess.uh_ICsEMG)
    label{EEGprocess.uh_ICsEMG(i)} = 'EMG';
end
liststr = strcat(matlist,label);
