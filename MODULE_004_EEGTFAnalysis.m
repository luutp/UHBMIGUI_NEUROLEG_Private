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

function varargout=MODULE_004_EEGTFAnalysis(handles,varargin)
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
if nargin==0       %Press F5, No input argument
    % Access UHBMI_AVATARGUI
    maingui=getappdata(0,handles.mainfigname);
    handles=getappdata(maingui,'handles');
    for i=1:length(gvar.mfilesequence)
        if strcmpi(gvar.mfilesequence{i},mfilename)
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
    logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
end

function UHBMIGUI_EEGTFAnalysis_Coherence(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName = stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% -----
EEGin = evalin('base','EEG');
Hinfobj = class_Hinf('input',EEGin,'eog',EEGin.EEGcap.EOGch);
EEGout = Hinfobj.execute;
assignin('base','EEG',EEGout);
% -----
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);





