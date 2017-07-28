%% Module:UHBMIGUI_EEG.M
% * *Filename* : UHBMIGUI_EEG.m
% * *MATLAB Ver* : 8.3.0.532 (R2014a)
% * *Date Created* : 22-Nov-2015 20:01:11
% * *Revision* : 1.0
% * *Description*: 
% 
%   This function continues to explain what the function does.
%   Required Input: input to the function. 
%   Optional Inputs: 
%   Outputs: 
%   Algorithm: 
%   Notes: 
%   Syntax or Exmample: 
% 
% * *Author's Information*: 
% * *Author name*:_Your name here_
% * *Contact*: _youremailadress@server.com_ 
% 
% _Laboratory for Noninvasive Brain Machine Interface Systems_ 
%
% _University of Houston_

function varargout=MODULE_007_EEGDIPROI(handles,varargin)
global gvar;
gvar=def_gvar;
getfunclist=0;
runopt=0;
filename='';
getfunclist = get_varargin(varargin,'getfunclist',0);
filename = get_varargin(varargin,'filename','');
runopt = get_varargin(varargin,'runopt',0);
mydir = class_dir;

funchdl=localfunctions;
UHBMIFuncList={};
varargout{1}=UHBMIFuncList;
k=1;
for i=1:length(funchdl)
    funcname=func2str(funchdl{i});
    if strfind(lower(funcname),'uhbmi');
        UHBMIFuncList{k}=funcname;
        k=k+1;
    end
end
% For debugging. Only work for one trial data which are available in WS
if nargin == 0       %Press F5, No input argument
     % Access UHBMI_AVATARGUI         
    maingui=getappdata(0,'UHBMIGUI_NEUROLEG');
    handles=getappdata(maingui,'handles');    
    moduleList = fieldnames(handles.FunctionList);
    for i=1:length(moduleList)        
        if strfind(mfilename, moduleList{i})
            pathrows=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
            break;
        end
    end    
    selrows=handles.juitree_funclist.getSelectionRows;
    runopt=selrows-pathrows;
    for i=1:length(UHBMIFuncList)
        for j=1:length(runopt)
            if i==runopt(j)
                cmdstr=sprintf('%s(handles);',UHBMIFuncList{i});
                eval(cmdstr);
            end
        end
    end
else
    if getfunclist==1
        varargout{1}=UHBMIFuncList;
        return;
    else
        [stacktrace, ~]=dbstack;
        thisFuncName=stacktrace(1).name;
        logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.brain);
        groupopt = 0;
        for i = 1 : length(runopt)
            if strfind(UHBMIFuncList{runopt(i)},'Group')
                groupopt = 1;
            end
        end
        if groupopt == 1
            for i=1:length(UHBMIFuncList)
                for j=1:length(runopt)
                    if i==runopt(j)
                        cmdstr=sprintf('%s(handles,''filename'',filename)',UHBMIFuncList{i});
                        eval(cmdstr);
                    end
                end
            end
        else
            for f=1:length(filename)
                thisfilename=filename{f};
                logMessage(sprintf('%s',thisfilename),handles.jedit_log, 'useicon',handles.iconlist.file.mat);
                uiupdatestatbar(handles,f,length(filename));
                evalin('base','clearvars -except handles filename gvar');
                
                myfile = class_FileIO('fullfilename',thisfilename);
                myfile.loadtows;
                for i=1:length(UHBMIFuncList)
                    for j=1:length(runopt)
                        if i==runopt(j)
                            cmdstr=sprintf('%s(handles,''filename'',thisfilename)',UHBMIFuncList{i});
                            eval(cmdstr);
                        end
                    end
                end
                logMessage(sprintf('%s',thisfilename),handles.jedit_log, 'useicon',handles.iconlist.status.check);
            end
        end
    end
    logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
end

function UHBMIGUI_EEG_GroupMakeDipList(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
fprintf('RUNNING: %s.\n',thisFuncName);
%==
selectedfiles=uigetjlistbox(handles.jlistbox_filelist);
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
alldippos = [];
for i=1:length(selectedfiles)
    filenameinput=fullfile(currdir,selectedfiles{i});
    matdata = matfile(filenameinput);
    EEGprocess = matdata.EEGprocess;
    thismodel = EEGprocess.dipfit.model;
    for j = 1 : length(thismodel)
        alldippos = [alldippos; mni2tal(EEGprocess.dipfit.model(j).posxyz)];    
    end
end
txtoutput = class_FileIO('filedir',currdir,'filename','Talairach_All_Dipoles','ext','.txt');
txtoutput.mat2txt(alldippos);
winopen(txtoutput.fullfilename);
%====
fprintf('DONE: %s.\n',thisFuncName);
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_GroupBAmap(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
fprintf('RUNNING: %s.\n',thisFuncName);
%==
selectedfiles=uigetjlistbox(handles.jlistbox_filelist);
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
txtfile = class_FileIO('filedir',currdir,'filename','Talairach_All_Dipoles.td.txt');
if uh_isvarexist('BAid')
    BAid = evalin('base','BAid');
else
    fid = fopen(txtfile.fullfilename);
    txtscan = textscan(fid,'%s','delimiter','\n');
    txtline = txtscan{:}; % Open settings file (importdata does not work)
    BAid = [];
    keyword = 'brodmann area';
    for i = 2 : length(txtline) % .td file header is line number 1
        thisline = txtline{i};
        keypos = strfind(lower(thisline),keyword)+length(keyword);
        if isempty(keypos)
            BAid = [BAid; NaN];
        else
            BAid = [BAid; str2num(thisline(keypos+1:keypos+2))];
        end
    end
    assignin('base','BAid',BAid);
    fclose(fid);
end
if uh_isvarexist('lendip')
    lendip = evalin('base','lendip');
else
    for i=1:length(selectedfiles)
        filenameinput=fullfile(currdir,selectedfiles{i});
        matdata = matfile(filenameinput);
        EEGprocess = matdata.EEGprocess;
        thismodel = EEGprocess.dipfit.model;
        lendip(i) = length(thismodel);
    end
    assignin('base','lendip',lendip);
end
cumsumlendip = [0,cumsum(lendip)];
for i = 1 : length(cumsumlendip)-1
    dipmap{i} = cumsumlendip(i)+1:cumsumlendip(i+1);
end
assignin('base','dipmap',dipmap);
outputfile = class_FileIO('filedir',currdir,'filename','DIPROI_dipmap.mat');
outputfile.savevars(dipmap);
%====
fprintf('DONE: %s.\n',thisFuncName);
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_Save(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
% --------
fullfilename = get_varargin(varargin,'filename','filename');
myfile = class_FileIO('fullfilename',fullfilename);
% fprintf('Saving...Filename: %s\n',myfile.filename); 
myfile.savews;
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.save);
