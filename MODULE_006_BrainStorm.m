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

function varargout=MODULE_006_BrainStorm(handles,varargin)
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
    uhbmigui_handles = evalin('base','uhbmigui_handles');
    maingui=getappdata(0,uhbmigui_handles.figure.Name);
    handles=getappdata(maingui,'handles');    
    moduleList = fieldnames(uhbmigui_handles.FunctionList);
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

% function UHBMIGUI_bstMakeCap(handles,varargin)
% global gvar;
% gvar=def_gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
% fprintf('%s.\n',thisFuncName)
% %======
% fullfilename = get_varargin(varargin,'filename','filename');
% inputfile = class_FileIO('fullfilename',fullfilename);
% [subjectname, ~, ~] = uh_getfilenameinfo(inputfile.filename);
% EEGclean = evalin('base','EEGclean');
% CleanEEGset.EEG = EEGclean;
% structdata = in_channel_eeglab_set(CleanEEGset, 1);
% structdata.Comment = subjectname;
% fname=fieldnames(structdata);
% evalin('base','clear all');
% for fn=1:length(fname)
%     assignin('base',sprintf('%s',fname{fn}),structdata.(fname{fn}));
% end
% outputfile = class_FileIO('filedir',inputfile.filedir,'filename',['channel_' subjectname '.mat']); %channel filetype in brainstorm
% outputfile.savews;
% %====
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
% fprintf('DONE: %s.\n',thisFuncName)

function UHBMIGUI_bstMakesFile(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
% Convert to EEG format that Brainstorm can understand.
fullfilename = get_varargin(varargin,'filename','filename');
inputfile = class_FileIO('fullfilename',fullfilename);
[subjectname, ~, ~] = uh_getfilenameinfo(inputfile.filename);
EEGclean = evalin('base','EEGclean');
EEG = EEGclean;
filterobj = class_filter('input',EEG,'fs',EEG.srate,'cutoff',gvar.beta,'type','bandpass',...
    'method','filtfilt','order',4);
EEG = filterobj.execute;
% Convert the Chanlocs format to match with brainstorm
for ch = 1 : length(EEG.chanlocs)
    warp_temp = EEG.chanlocs(ch).X;
    EEG.chanlocs(ch).X = EEG.chanlocs(ch).Y;
    EEG.chanlocs(ch).Y = -warp_temp;
end
outputfile = class_FileIO('filedir',inputfile.filedir,'filename',[inputfile.filename '-EEGclean-beta.mat']); %channel filetype in brainstorm
outputfile.savevars(EEG);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)

function UHBMIGUI_bstAddEvents(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
fullfilename = get_varargin(varargin,'filename','filename');
inputfile = class_FileIO('fullfilename',fullfilename);
eegfilename = inputfile.filename;
iden = strfind(eegfilename,'-eeg');
eegfilename(iden:end) = [];
kinfilename = fullfile(inputfile.filedir,[eegfilename, '-kin.mat']);
% kinfilename = fullfile(inputfile.filedir,strrep(eegfilename,'-eeg-EEGclean','-kin.mat'));
kinmatfile = matfile(kinfilename);
kin = kinmatfile.kin;
gc = kin.gc;
label = gc.label; gctime = gc.time; transleg = gc.transleg;
% find LW3F and SA time
saidx = find(cellfun(@isempty,strfind(label,'SA')) == 0);
if isempty(saidx)
    fprintf('Missing Gait Segmented data.\n');
else
    % Find transition time for the right leg only.
    try
        if strcmpi(transleg{1},'R')
            lw2sa = gctime(saidx(1),1);            
        else
            lw2sa = gctime(saidx(1),3);
        end
        sabreakid = find(diff(saidx)>10);
        if ~isempty(sabreakid)            
            if strcmpi(transleg{5},'R')
                lw2sa(end+1) = gctime(saidx(sabreakid+1),1);                            
            else
                lw2sa(end+1) = gctime(saidx(sabreakid+1),3);            
            end
        end        
    catch
    end
end
eegcleanmatfile = matfile(inputfile.fullfilename,'Writable',true);
EEG = eegcleanmatfile.EEG;
timeline = 0:1/EEG.srate:1/EEG.srate*(EEG.pnts-1);
EEG.event = struct;
for i = 1 : length(lw2sa)
    EEG.event(i).type = 'LW2SA';
    EEG.event(i).latency = uh_getmarkerpos(lw2sa(i),timeline);
end
EEG.eventdescription = {'Terrain Transition'};
eegcleanmatfile.EEG = EEG;
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)

function UHBMIGUI_GroupbstMakeProtocol(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
% [modulepath,~,~] = fileparts(mfilename('fullpath'));
% [~,mainfigname,~] = fileparts(modulepath);
% maingui=findall(0, '-depth',1, 'type','figure', 'Name',mainfigname);
% handles=getappdata(maingui,'handles');
uhbmigui_handles = evalin('base','uhbmigui_handles');
mainfigname = uhbmigui_handles.figure.Name;
selectedfiles=uigetjlistbox(handles.jlistbox_filelist);
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
% Get subjectlist
for i = 1 : length(selectedfiles)
    [SubjList{i}, ~, ~] = uh_getfilenameinfo(selectedfiles{i});
end
SubjectList = unique(SubjList);
% =========================BRAINSTORM PROTOCOL SETUP
% Setup protocol Home and Database Dir
% Initiate Brainstorm Before Running this
HomeDir = fullfile(fileparts(fileparts(mfilename('fullpath'))),'brainstorm3');
DbDir = fullfile(currdir,'brainstorm_db');
ProtocolName = ['Protocol_' mainfigname];
assignin('base','brainstorm_db',DbDir);
assignin('base','brainstorm_home',HomeDir);
assignin('base','ProtocolName',ProtocolName);
% Reset brainstorm
% bst_reset;
bst_startup(HomeDir, 0, 0, DbDir);
try
    gui_brainstorm('DeleteProtocol', ProtocolName);
    fprintf('%s has been DELETED.\n',ProtocolName);
catch
end
% Initialize random generator
% rng('default');
BrainstormDbDir = bst_get('BrainstormDbDir');
if ~strcmpi(BrainstormDbDir,DbDir)
    if ~isdir(DbDir), mkdir(DbDir); end;
    bst_set('BrainstormDbDir',DbDir);
end
gui_brainstorm('CreateProtocol', ProtocolName, 0, 0, BrainstormDbDir);
% iProtocol = bst_get('Protocol',ProtocolName); % Get indice of the protocol name;
% if isempty(iProtocol)
%     fprintf('NEW> %s is not available. Create new protocol.\n',ProtocolName);
%     % Create new protocol
%     gui_brainstorm('CreateProtocol', ProtocolName, 0, 0, BrainstormDbDir);
% else
%     % Set current protocol
%     gui_brainstorm('SetCurrentProtocol',iProtocol);
% end
% Start a new report
bst_report('Start');
%% ===== CREATE SUBJECT =====
% Create subject
for i = 1 : length(SubjectList)
    SubjectName = SubjectList{i};
    isexist_subj = bst_get('Subject',SubjectName); % Check if this subject is already exist in protocol
    if isempty(isexist_subj)
        [sSubject, iSubject] = db_add_subject(SubjectName);
        % Set anatomy
        sTemplates = bst_get('AnatomyDefaults');
        iTemplate = find(strcmpi('ICBM152', {sTemplates.Name}));
        db_set_template(iSubject, sTemplates(iTemplate), 0);
    end
end
for i = 1 : length(selectedfiles)
    DataFile = fullfile(currdir,selectedfiles{i});
    subjname = uh_getfilenameinfo(selectedfiles{i});
    subjid = str2num(subjname(end-1:end));
    [sFile, ChannelMat] = in_fopen_eeglab(DataFile);
    % ChannelMat is EEG channel location in bst format. 
    % Fix coordinate mismatch btw EEGLab and Brainstorm
%     for ch = 1 : length(ChannelMat.Channel)
%         warp_temp = ChannelMat.Channel(ch).Loc([2 1 3]);
%         ChannelMat.Channel(ch).Loc = warp_temp.*[1; -1; 1];
%     end
%     assignin('base','ChannelMat',ChannelMat);
%     assignin('base','sFile',sFile)
    importoptions = db_template('ImportOptions');
    importoptions.ImportMode = 'Event';
    importoptions.UseEvents = 1;   
    importoptions.TimeRange = [0 sFile.header.Time(end)];
    importoptions.events = sFile.events;    
    importoptions.EventsTimeRange = [-3 3];
    importoptions.SplitLength = length(sFile.events.samples);
    importoptions.ResampleFreq = 0;
    importoptions.EventsMode = 'ask';
    importoptions.EventsTrackMode = 'ask';
    importoptions.DisplayMessages = 0;
    NewFiles = import_data(sFile,ChannelMat, 'EEG-EEGLAB', [], subjid,importoptions);
end
brainstorm;
% Input files
sFiles = bst_getallfiles('protocolname',ProtocolName,'filetype','data');
% Average input data in time domain.
bst_avg(sFiles,'type','subject','func','mean')
% TF morlet for all files
bst_tf_morlet(sFiles);
% Average wavelet morlet
sFiles = bst_getallfiles('protocolname',ProtocolName,'filetype','timefreq');
bst_avg(sFiles,'type','subject','func','mean')
%====
% Time frequency analysis using Morlet
% Morlet wavelet for average file
% Find all the average files in the @intra folder for each subject
% numsubj = bst_get('SubjectCount');
% sFiles = {};
% f = 1;
% for i = 1 : numsubj
%     thissubj = bst_get('Subject',i);
%     thissubjname = thissubj.Name;
%     intradir = fullfile(DbDir,ProtocolName,'data',thissubjname,'@intra');
%     intrafile = dir(intradir);
%     for j = 1 : length(intrafile)
%         if strfind(intrafile(j).name,'average')
%             intra_avgfile = intrafile(j).name;
%             temp = fullfile(thissubjname,'@intra',intra_avgfile);
%             sFiles{f} = temp;
%             f = f + 1;
%         end
%     end
% end
% bst_tf_morlet(sFiles);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)

function UHBMIGUI_GroupbstMakeBetaProtocol(handles,varargin)
UHBMIGUI_GroupbstMakeProtocol(handles);

function UHBMIGUI_GroupImportMEEGHeadModel(handles,varargin)
% Group Initial indicates that the Func only runs one time
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
fprintf('Copy Channel file and head model to @intra folder.\n');
% [modulepath,~,~] = fileparts(mfilename('fullpath'));
% [~,mainfigname,~] = fileparts(modulepath);
% maingui=findall(0, '-depth',1, 'type','figure', 'Name',mainfigname);
% handles=getappdata(maingui,'handles');
uhbmigui_handles = evalin('base','uhbmigui_handles');
mainfigname = uhbmigui_handles.figure.Name;
dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
currdir=dirlist{get(handles.popupmenu_currdir,'value')};
HomeDir = fullfile(fileparts(fileparts(mfilename('fullpath'))),'brainstorm3');
DbDir = fullfile(currdir,'brainstorm_db');
brainstormfig = findall(0, '-depth',1, 'type','figure', 'Name','Brainstorm');
if isempty(brainstormfig) % If brainstorm is not running
%     bst_startup(HomeDir, 0, 0, DbDir); % Start brainstorm    
    brainstorm;
end
BrainstormDbDir = bst_get('BrainstormDbDir');
ProtocolName = ['Protocol_' mainfigname];
headmodeldirname = 'brainstorm_MEEG_headmodel';
subjdir = dir(fullfile(currdir,headmodeldirname));
for i = 3 : length(subjdir) % folder . and .. returned by dir function
    if subjdir(i).isdir == 1
        thissubjdir = subjdir(i).name;        
        orgdirname = fullfile(currdir,headmodeldirname,thissubjdir);
%         targetdir = fullfile(BrainstormDbDir,ProtocolName,'data',thissubjdir,'@intra');
        targetdirlist = dir(fullfile(BrainstormDbDir, ProtocolName,'data',thissubjdir));
        headmodelfilelist = dir(orgdirname);
        if length(headmodelfilelist)>2
            for j = 3 : length(headmodelfilelist) % exclude . and .. copy 2 files channel.mat and openmeeg.mat
                headmodelfile = fullfile(orgdirname,headmodelfilelist(j).name);
                for k = 3 : length(targetdirlist)
                    targetdir = fullfile(BrainstormDbDir, ProtocolName,'data',thissubjdir,...
                        targetdirlist(k).name);
                    copyfile(headmodelfile,targetdir);
                end
            end
        end
    end
end
db_reload_database('current'); %Reload database since headmodels are copied manually to brainstorm
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)

function UHBMIGUI_GroupbstsLORETA(handles,varargin)
global gvar;
gvar=def_gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.play);
fprintf('%s.\n',thisFuncName)
%======
brainstormfig = findall(0, '-depth',1, 'type','figure', 'Name','Brainstorm');
if isempty(brainstormfig) % If brainstorm is not running
    brainstorm; % Start Brainstorm
end
DbDir = bst_get('BrainstormDbDir');
% mainfignamepath = uh_fileparts('fullpath',mfilename('fullpath'),'level',1);
% [~,mainfigname,~] = fileparts(mainfignamepath);
uhbmigui_handles = evalin('base','uhbmigui_handles');
mainfigname = uhbmigui_handles.figure.Name;
ProtocolName = ['Protocol_' mainfigname];
%====
% Time frequency analysis using Morlet
% Find all the average files in the @intra folder for each subject
sFiles = bst_getallfiles('protocolname',ProtocolName,'intra',0,'filetype','data_LW2SA');
% Process: Compute covariance (noise or data)
sFiles_Noisecov = bst_process('CallProcess', 'process_noisecov', sFiles, [], ...
    'baseline',       [-3, 3], ...
    'datatimewindow', [-3, 3], ...
    'sensortypes',    'EEG', ...
    'target',         1, ...  % Noise covariance     (covariance over baseline time window)
    'dcoffset',       1, ...  % Block by block, to avoid effects of slow shifts in data
    'identity',       0, ...
    'copycond',       0, ...
    'copysubj',       0, ...
    'replacefile',    1);  % Replace
% sLORETA
% Process: Compute sources [2016]
sFiles_slor = bst_process('CallProcess', 'process_inverse_2016', sFiles, [], ...
    'output',  3, ...  % Kernel only: 1: shared, 2: one per file 3: Full results: one per file        
    'inverse', struct(...
         'Comment',        'sLORETA: EEG', ...
         'InverseMethod',  'minnorm', ...
         'InverseMeasure', 'sloreta', ...
         'SourceOrient',   {{'free'}}, ...
         'Loose',          0.2, ...
         'UseDepth',       0, ...
         'WeightExp',      0.5, ...
         'WeightLimit',    10, ...
         'NoiseMethod',    'reg', ...
         'NoiseReg',       0.1, ...
         'SnrMethod',      'fixed', ...
         'SnrRms',         1e-06, ...
         'SnrFixed',       3, ...
         'ComputeKernel',  1, ...
         'DataTypes',      {{'EEG'}}));
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.status.check);
fprintf('DONE: %s.\n',thisFuncName)

function varargout = bst_getallfiles(varargin)
% This function resturns all filename included in Brainstorm analysis.
ProtocolName = get_varargin(varargin,'protocolname','Protocol_UHBMIGUI_NEUROLEG');
filetype = get_varargin(varargin,'filetype','data');
intraopt = get_varargin(varargin,'intra',0); % Find avg subject or @intra folder
% Filetype defined in Brainstorm
DbDir = bst_get('BrainstormDbDir');
numsubj = bst_get('SubjectCount');
f = 1;
sFiles = {};
for i = 1 : numsubj
    thissubj = bst_get('Subject',i);
    thissubjname = thissubj.Name;
    subjdir = fullfile(DbDir,ProtocolName,'data',thissubjname); %Protocol_UHBMIGUI_NEUROLEG\data\AB_UH_xx
    subjdirlist = dir(subjdir);
    if intraopt == 1
        subjdirkey = '@intra'; % Compute sLoreta for average file in @intra folder
    else
        subjdirkey = thissubjname;
    end
    for j = 1 : length(subjdirlist)                
        if strfind(subjdirlist(j).name,subjdirkey)
            %fprintf('%s/%s.\n',thissubjname,subjdirlist(j).name);
            subjdatadir = dir(fullfile(subjdir,subjdirlist(j).name)); %Protocol_UHBMIGUI_NEUROLEG\data\AB_UH_xx\AB_UH_xx, @intra
            for k = 1 : length(subjdatadir)                                
                if strfind(subjdatadir(k).name,filetype)
                    %fprintf('%s/%s/%s.\n',thissubjname,subjdirlist(j).name,subjdatadir(k).name);
                    temp = fullfile(thissubjname,subjdirlist(j).name,subjdatadir(k).name);
                    %Protocol_UHBMIGUI_NEUROLEG\data\AB_UH_xx\filetype_xxx_xxx.mat
                    %Filetype: data, timefreq, etc
                    sFiles{f} = temp;
                    f = f + 1;
                end
            end
        end
    end
end
varargout{1} = sFiles;

function varargout = bst_tf_morlet(sFiles,varargin)
% This function call brainstorm process to perform time-frequency analsysis
% using morlet wavelet.
if ~isempty(sFiles)
    bst_report('Start', sFiles);
    % Process: Time-frequency (Morlet wavelets)
    sFiles = bst_process('CallProcess', 'process_timefreq', sFiles, [], ...
        'sensortypes', 'MEG, EEG', ...
        'edit',        struct(...
        'Comment',         'Power,1-50Hz', ...
        'TimeBands',       [], ...
        'Freqs',           [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50], ...
        'MorletFc',        1, ...
        'MorletFwhmTc',    3, ...
        'ClusterFuncTime', 'none', ...
        'Measure',         'power', ...
        'Output',          'all', ...
        'RemoveEvoked',    0, ...
        'SaveKernel',      0), ...
        'normalize',   'none');  % None: Save non-standardized time-frequency maps    
    % Save and display report
    ReportFile = bst_report('Save', sFiles);
    bst_report('Open', ReportFile);
    varargout{1} = sFiles;
else
    uh_fprintf('No input files.','color','r');
end

function varargout = bst_avg(sFiles,varargin)
avgtype = get_varargin(varargin,'type','subject');
avgfunc = get_varargin(varargin,'func','mean');
if strcmpi(avgtype,'subject')
    avgtypeval = 2;
else
end
if strcmpi(avgfunc,'mean')
    avgfuncval = 1;
else
end
if ~isempty(sFiles)
    % Start a new report
    bst_report('Start', sFiles);
    % Process: Average: By subject
    sFiles = bst_process('CallProcess', 'process_average', sFiles, [], ...
        'avgtype',    avgtypeval, ...  % By subject
        'avg_func',   avgfuncval, ...  % Arithmetic average:  mean(x)
        'weighted',   0, ...
        'keepevents', 0);
    % Save and display report
    ReportFile = bst_report('Save', sFiles);
    bst_report('Open', ReportFile);
else
    uh_fprintf('No input files.','color','r');
end