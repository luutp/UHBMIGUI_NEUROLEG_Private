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
function varargout = MODULE_005_SourceLocalization(handles,varargin)
global gvar;
gvar=def_gvar;
getfunclist=0;
runopt=0;
global filename;
getfunclist = get_varargin(varargin,'getfunclist',0);
filename = get_varargin(varargin,'filename','');
runopt = get_varargin(varargin,'runopt',0);
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
    maingui=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
    handles=getappdata(maingui,'handles');
    assignin('base','handles',handles);
    hObjectCallback = get(handles.pushbutton_uitreerun, 'Callback');
    hObjectCallback{1}(maingui,[],hObjectCallback{2:end}); % Run pushbutton_uitreerun Callback
else
    if getfunclist==1
        varargout{1}=UHBMIFuncList;
        return;
    else
        [stacktrace, ~]=dbstack;
        thisFuncName=stacktrace(1).name;
        logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.brain);
        for i=1:length(UHBMIFuncList)
            for j=1:length(runopt)
                if i==runopt(j)
                    cmdstr=sprintf('%s(handles,''filename'',filename)',UHBMIFuncList{i});
                    eval(cmdstr);
                end
            end
        end
    end
    logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
end

function UHBMIGUI_ICcluster(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
filelist = get_varargin(varargin,'filename','untitiled_file');
for i =1:length(filelist)
    myfile(i) = class_FileIO('fullfilename',[filelist{i} '.mat']);
end
% currdirlist=get(handles.popupmenu_currdir,'string');
% currdir=currdirlist{get(handles.popupmenu_currdir,'value')};
currdir = myfile(1).filedir;
% prefix = {'pre','exp','post','rest1','clda','bmi','cldalesion','lesion','rest2'};
for i = 1 : length(myfile)
    [subj{i} thistrial] =  uh_getfilenameinfo(myfile(i).filename);
    if thistrial < 10
        trial{i} = ['0' num2str(thistrial)];
    else
        trial{i}=num2str(thistrial);
    end
    %     studyfilename = [handles.study '-studyfile-' prefix{i} '.study'];
end
% studyfilename = [strjoin(unique(subj),'-') '-studyfile.study'];
% strtrial = strjoin(unique(cellfun(@num2str,trial,'uniformoutput',false)),'-')
strtrial = strjoin(unique(trial),'-');
eegsourcefilename = ['EEGsource-' strjoin(unique(subj),'-') '-Trial ' strtrial '-eeg.mat'];
studyfilename = strrep(eegsourcefilename,'-eeg.mat','-study.study');

uh_ICcluster('datapath',currdir,'filelist',{myfile.filename},'editeeginfo',1,...
    'makestudyfile',0,'clusternum',7,'visualize',1,'studyfilename',studyfilename);
EEGsource.STUDY = evalin('base','STUDY');
EEGsource.ALLEEG = evalin('base','ALLEEG');
eegsourcefile = class_FileIO('filedir',currdir,'filename',eegsourcefilename);
eegsourcefile.savevars(EEGsource);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
sprintf('DONE: %s.\n',thisFuncName)
% function UHBMIGUI_CallTalairachJava(handles,varargin)
% global gvar;
% folder = '..\uhlib\Includes\java\TalairachClient 2.4.3\TalairachClient';
% winopen([folder '\TalairachClient.exe']);

function UHBMIGUI_ICclusterAct(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
fullfilename = get_varargin(varargin,'filename','filename');
try
    EEGsource = evalin('base','EEGsource');
catch
    thismatfile = matfile(fullfilename{1});
    EEGsource = thismatfile.EEGsource;
    assignin('base','EEGsource',EEGsource);
end
ALLEEG = EEGsource.ALLEEG;
STUDY = EEGsource.STUDY;
numcluster = 7;
lencluster = length(STUDY.cluster); % the first two clusters in eeglab cluster format are Parent and outlier
lenshift = lencluster - numcluster;
remcluster = find(uh_findvalidcluster('STUDY',EEGsource.STUDY,'numcluster',7,'numsubj',6,'numtrial',9));
% remcluster = remcluster + lenshift;
remcluster = lenshift+1 : lenshift+numcluster;
inputfile = class_FileIO('fullfilename',fullfilename{1});
for j = 1 : length(remcluster)
    thiscluster = remcluster(j);
    numIC = length(STUDY.cluster(thiscluster).sets);
    for i = 1 : numIC
        fprintf('IC activation Cluster %d/%d. IC: %d/%d\n',j,length(remcluster),i,numIC);
        thisset = STUDY.cluster(thiscluster).sets(i);
        thisIC = STUDY.cluster(thiscluster).comps(i);
        allICact = ALLEEG(thisset).icaweights*ALLEEG(thisset).icasphere*ALLEEG(thisset).data;
        thisICact = allICact(thisIC,:); % ICact has different size for each IC. ICs could be from different trials or subjects.
        thiseegfile = ALLEEG(thisset).filename;
        ClusterAct(j).IC(i).eeg = thisICact;
        ClusterAct(j).IC(i).eegfilename = thiseegfile;
    end
end
assignin('base','ClusterAct',ClusterAct);
% Create Activation File
myfile = class_FileIO('filedir',inputfile.filedir,...
    'filename',['ClusterAct-' inputfile.filename]);
fprintf('Saving...Filename: %s\n',myfile.filename);
myfile.savevars(ClusterAct);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)


