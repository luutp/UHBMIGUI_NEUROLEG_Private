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

function varargout=MODULE_003_EEGclean(handles,varargin)
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
    dirlist=cellstr(get(handles.popupmenu_currdir,'string'));
    currdir=dirlist{get(handles.popupmenu_currdir,'value')};
    filename = fullfile(currdir,uigetjlistbox(handles.jlistbox_filelist,'select','selected'));
    moduleList = fieldnames(handles.FunctionList);
    for i=1:length(moduleList)        
        if strfind(mfilename, moduleList{i})
            pathrows=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
            break;
        end
    end    
    selrows=handles.juitree_funclist.getSelectionRows;
    runopt=selrows-pathrows;
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

% function UHBMIGUI_EEG_RemoveEOG(handles,varargin)
% global gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% fprintf('RUNNING: %s.\n',thisFuncName);
% %==
% EEGin = evalin('base','EEGraw'); % Run resample in the first step, all the other steps, use EEGprocess
% if uh_isvarexist('EEGclean')
%     evalin('base','clearvars EEGclean');
% end
% EEGout = EEGin;
% try
% EEGout.EEGcap = EEGin.EEGcap;
% catch
%     EEGout.EEGcap = evalin('base','mycap');
% end
% EEGout.data = EEGin.data;
% if isfield(EEGout.EEGcap.chlabel,'EOG')
%     EEGout.data(EEGout.EEGcap.chlabel.EOG,:) = []; % Remove EOG channel
% end
% EEGout.nbchan = length(EEGin.chanlocs);
% EEGout.chanlocs = EEGin.chanlocs;
% EEGout.reject = EEGin.reject;
% assignin('base','EEGprocess',EEGout);
% %====
% fprintf('DONE: %s.\n',thisFuncName);
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

% function UHBMIGUI_EEG_SegmentLWSA(handles,varargin)
% global gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% fprintf('RUNNING: %s.\n',thisFuncName);
% %==
% fullfilename = get_varargin(varargin,'filename','filename');
% inputfile = class_FileIO('fullfilename',fullfilename);
% eegfilename = inputfile.filename;
% iden = strfind(eegfilename,'-eeg');
% eegfilename(iden:end) = [];
% kinfilename = fullfile(inputfile.filedir,[eegfilename, '-kin.mat']);
% kinmatfile = matfile(kinfilename);
% kin = kinmatfile.kin;
% gc = kin.gc;
% label = gc.label; gctime = gc.time; transleg = gc.transleg;
% assignin('base','gc',gc);
% % find LW3F and SA time
% lw3fidx = find(cellfun(@isempty,strfind(label,'LW3F')) == 0);
% saidx = find(cellfun(@isempty,strfind(label,'SA')) == 0);
% lwbreak = find(diff(lw3fidx)>2);
% sabreak = find(diff(saidx)>2);
% gcloop = [lw3fidx(1), saidx(sabreak)-1];
% if ~isempty(lwbreak)
%     gcloop = [gcloop; [lw3fidx(lwbreak+1), saidx(end-1)]];
% end
% EEGraw = evalin('base','EEGraw');
% timeline = 0:1/EEGraw.srate:1/EEGraw.srate*(EEGraw.pnts-1);
% for i = 1 : size(gcloop,1)
%     for j = 1 : size(gcloop,2)
%         if j == 1, gctimeloop(i,j) = gctime(gcloop(i,j),1);
%         else, gctimeloop(i,j) = gctime(gcloop(i,j),end);
%         end
%     end
% end
% for i = 1:size(gctimeloop,1)
%     looppos = uh_getmarkerpos(gctimeloop(i,:),timeline);
%     EEGloop = EEGraw;
%     EEGloop.data = EEGloop.data(:,looppos(1):looppos(end));
%     EEGloop.pnts = size(EEGloop.data,2);
%     EEGloop.times = timeline(looppos(1):looppos(end));
%     assignin('base','EEGraw',EEGloop);
%     evalin('base','clearvars -except mycap FileObj EEGraw');        
%     myfile = class_FileIO('filedir',inputfile.filedir,...
%                           'filename',['L' inputfile.filename sprintf('-Loop%d',i)]);
%     myfile.savews;
% end
% %====
% fprintf('DONE: %s.\n',thisFuncName);
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
% 
% function UHBMIGUI_EEG_resample(handles,varargin)
% global gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% fprintf('RUNNING: %s.\n',thisFuncName);
% %==
% evalin('base','clearvars -except mycap FileObj EEGraw');        
% 
% EEGin = evalin('base','EEGraw'); % Run resample in the first step, all the other steps, use EEGprocess
% try
%     EEGout = eeg_emptyset;
% catch
%     uh_fprintf('Error: Include and Initiate EEGLAB','color','r');
% end
% newrate = 100;
% resampledata = transpose(resample(transpose(double(EEGin.data)),newrate,EEGin.srate));
% EEGout = pop_importdata('setname','Sample EEG','data',resampledata,'nbchan',size(resampledata,1),'srate',newrate);
% EEGout.srate = newrate;
% % EEGout.trigger = [EEGin.event.latency]/EEGin.srate;
% EEGout.chanlocs = EEGin.chanlocs;
% try
% EEGout.EEGcap = EEGin.EEGcap;
% catch
%     EEGout.EEGcap = evalin('base','mycap');
% end
% EEGout.reject = EEGin.reject;
% assignin('base','EEGprocess',EEGout);
% %====
% fprintf('DONE: %s.\n',thisFuncName);
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
% 
% function UHBMIGUI_EEG_Hinf(handles,varargin)
% global gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% % -----
% EEGin = evalin('base','EEG');
% Hinfobj = class_Hinf('input',EEGin,'EOGch',EEGin.EEGcap.chlabel.EOG);
% EEGout = Hinfobj.execute;
% assignin('base','EEG',EEGout);
% % -----
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_filter(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGraw');
filterobj = class_filter('input',EEGin,'fs',EEGin.srate,'cutoff',0.1,'type','high',...
    'method','filtfilt','order',4);
EEGout = filterobj.execute;
if isfield(mycap.chlabel,'EOG')
    EEGout.uh_EOG = mycap.chlabel.EOG;
    EEGout.uh_chlabel = mycap.chlabel;
end
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_rejchan(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
rejchanobj = class_rejchan('input',EEGin,'threshold',5,'elec',1:size(EEGin.data,1),...
    'norm','on','measure','kurt');
EEGout = rejchanobj.execute;
EEGout.reject.remove_badchannel_opt = 1;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_interpbadchan(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
fprintf('RUNNING: %s.\n',thisFuncName);
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
[~, badchannel] = pop_rejchan(EEGin,'elec',1:size(EEGin.data,1),...
    'threshold',5,'norm','on','measure','kurt');
EEGout = pop_interp(EEGin, badchannel, 'spherical');
EEGout.reject.uh_badchannel = badchannel;
EEGout.reject.remove_badchannel_opt = 0;
assignin('base','EEGprocess',EEGout);
%====
fprintf('DONE: %s.\n',thisFuncName);
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_CAR(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
carobj = class_CAR('input',EEGin);
EEGout = carobj.execute;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

% function UHBMIGUI_EEG_CleanLine(handles,varargin)
% global gvar;
% [stacktrace, ~]=dbstack;
% thisFuncName=stacktrace(1).name;
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% %==
% EEGin = evalin('base','EEGprocess');
% EEGout = cleanline(EEGin);
% assignin('base','EEGprocess',EEGout);
% %====
% logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);


function UHBMIGUI_EEG_ASR(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
% Define baseline for ASR, using rest file in T00
% baseline = EEGin.data(:,0.5*gvar.Fs:1.5*gvar.Fs);
fullfilename = get_varargin(varargin,'filename','filename');
myfile = class_FileIO('fullfilename',fullfilename);
filename = myfile.filename;
% Process for Motion Artifact study;
[subj,trial] = uh_getfilenameinfo(filename);
filename = strrep(filename,'eeg','kin');
kinmatfile = matfile(fullfile(myfile.filedir,[filename '.mat']));
kindata = kinmatfile.kin;
gc = kindata.gc;
gccheck = find(gc);
baseline = EEGin.data(:,1:gccheck(1));
% Process for Neuroleg study on Healthy subject.
% [subj,trial] = uh_getfilenameinfo(filename);
% filename = strrep(filename,trial,'T00');
% restmatfile = matfile(fullfile(myfile.filedir,[filename '.mat']));
% restEEGraw = restmatfile.EEGraw;
% baseline = restEEGraw.data;
%
ASRobj = class_ASR('input',EEGin,'cutoff',10,'baseline',baseline,'windowlen',0.5);
EEGout = ASRobj.execute;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_ASRBaselineAll(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
ASRobj = class_ASR('input',EEGin,'cutoff',10,'windowlen',0.5,'ref_fullopt','off');
EEGout = ASRobj.execute;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_InfomaxICA(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
ICAobj = class_ICA('input',EEGin,'icatype','runica','chanind',1:size(EEGin.data,1));
EEGout = ICAobj.execute;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_AMICA(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
% if the date before this is not processed well, it sometimes give you
% error, then try with low maxiter.
% Read: https://sccn.ucsd.edu/wiki/Makoto's_preprocessing_pipeline
% for data rank compensation

% data rank compensation
try
    fprintf('Remove channels that were identified as bad during in before\n');
    disp(EEGin.reject.uh_badchannel);
    EEGin = pop_select(EEGin,'nochannel',EEGin.reject.uh_badchannel);
    fprintf('Removing done. You could also interpolate them after ICA process to get all the channels back.\n');
catch e
    fprintf('Something happened, it failed.\n');
end
% running the actual amica
try
    AMICAobj = class_ICA('input',EEGin,'icatype','amica','maxiter',1200);
    EEGout = AMICAobj.execute;
catch e
    try
        AMICAobj = class_ICA('input',EEGin,'icatype','amica','maxiter',1000);
        EEGout = AMICAobj.execute;
    catch e
        AMICAobj = class_ICA('input',EEGin,'icatype','amica','maxiter',500);
        EEGout = AMICAobj.execute;
    end
end
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_dipfit(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
EEGin = evalin('base','EEGprocess');
% if EEGin.reject.remove_badchannel_opt == 1
%     EEGin.chanlocs([EEGin.reject.uh_badchannel])=[];
% end
dipfitobj = class_dipfit('input',EEGin);
EEGout = dipfitobj.execute;
assignin('base','EEGprocess',EEGout);
%====
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_ScanPoorfitICs(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
% Dipfit to remove bad ICs.
poordipfit.model  = dipfit_reject(EEGprocess.dipfit.model, 0.3);
for i=1:length(poordipfit.model)
    poordippos(i)= isempty(poordipfit.model(i).posxyz);
end
poorfitdip=find(poordippos);
EEGprocess.uh_ICsPoorfit = poorfitdip;
mycap = evalin('base','mycap');
remdip = setdiff(1:length(EEGprocess.chanlocs),poorfitdip); 
tempmodel = EEGprocess.dipfit.model;
for i = 1 : length(remdip)
    tempmodel(remdip(i)).posxyz = [0,0,0];
    tempmodel(remdip(i)).momxyz = [0,0,0];
end
% Visualization
% dipplot(tempmodel,'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
% pop_topoplot(EEGprocess,0,poorfitdip,'',0,1);

% EEGcleanPoorfit = EEGprocess;
% EEGcleanPoorfit = pop_subcomp(EEGcleanPoorfit,poorfitdip,0);
% EEGcleanPoorfit.icaact=EEGcleanPoorfit.icaweights*EEGcleanPoorfit.icasphere*EEGcleanPoorfit.data;
% EEGcleanPoorfit.uh_badchans = EEGprocess.reject.uh_badchannel;
% EEGcleanPoorfit.uh_ICsPoorfit = poorfitdip;
% assignin('base','EEGcleanPoorfit',EEGcleanPoorfit);
assignin('base','EEGprocess',EEGprocess);
evalin('base','clearvars -except mycap FileObj EEGcleanPoorfit EEGraw EEGprocess');
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_ScanOutsideBrainICs(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
maindir = uh_fileparts('fullpath',mfilename('fullpath'),'level',2);
mriboundfile = class_FileIO('fullfilename',...
    fullfile(maindir,'uhlib\Graphics\GUI','uh_gui_mri_boundary_Extended_data.mat'));
mriboundfile.loadtows;
mribound = evalin('base','mribound');
remdip = setdiff(1:length(EEGprocess.chanlocs), EEGprocess.uh_ICsPoorfit);
[insideBrainComp, outsideBrainComp] = mriBoundaryCheck(remdip, mribound);
% Show Remaining dipoles after removing poorfit
% hideDip = EEGprocess.uh_ICsPoorfit;
% dipplotHide(EEGprocess.dipfit.model,hideDip);
% Show outside brain dipoles
% hideDip = setdiff(1:length(EEGprocess.chanlocs),outsideBrainComp);
% dipplotHide(EEGprocess.dipfit.model,hideDip);

% ICsOutsideBrain = luu_selectcomps(EEGprocess,remdip,...
%     'rejcomp',outsideBrainComp,...
%     'auto',1,'nosedir','+Y');
ICsOutsideBrain = outsideBrainComp;
EEGprocess.uh_ICsOutsideBrain = ICsOutsideBrain;
assignin('base','EEGprocess',EEGprocess);
evalin('base','clearvars -except mycap FileObj EEGraw EEGprocess');
allfig=findall(0,'type','figure');
printfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_PRINT');
avatarfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_AVATAR');
neurolegfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
clcfig=setdiff(allfig,[printfig,avatarfig,neurolegfig]);
close(clcfig);
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_ScanEOGICs(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
maindir = uh_fileparts('fullpath',mfilename('fullpath'),'level',2);
mriboundfile = class_FileIO('fullfilename',...
    fullfile(maindir,'uhlib\Graphics\GUI','uh_gui_mri_boundary_EOG_data.mat'));
mriboundfile.loadtows;
mribound = evalin('base','mribound');
allDip = 1:length(EEGprocess.chanlocs);
poorNOut = [EEGprocess.uh_ICsPoorfit,EEGprocess.uh_ICsOutsideBrain];
remdip = setdiff(allDip, poorNOut);
[EOGdip, ~] = mriBoundaryCheck(remdip, mribound);
% Visualization
% Show Remaining dipoles after removing poorfit and outside the brain ICs
% dipplotHide(EEGprocess.dipfit.model,poorNOut);
% Show EOG brain dipoles
% dipplotHide(EEGprocess.dipfit.model,setdiff(allDip,EOGdip));

% ICsEOG = luu_selectcomps(EEGprocess,remdip,...
%     'rejcomp',EOGdip,...
%     'auto',1,'nosedir','+Y');
ICsEOG = EOGdip;
EEGprocess.uh_ICsEOG = ICsEOG;
assignin('base','EEGprocess',EEGprocess);
evalin('base','clearvars -except mycap FileObj EEGraw EEGprocess');
allfig=findall(0,'type','figure');
printfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_PRINT');
avatarfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_AVATAR');
neurolegfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
clcfig=setdiff(allfig,[printfig,avatarfig,neurolegfig]);
close(clcfig);
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_DetectMuscleICs(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
maindir = uh_fileparts('fullpath',mfilename('fullpath'),'level',2);
mriboundfile = class_FileIO('fullfilename',...
    fullfile(maindir,'uhlib\Graphics\GUI','uh_gui_mri_boundary_Extended_data.mat'));
mriboundfile.loadtows;
allDip = 1:length(EEGprocess.chanlocs);
poorfitDip = EEGprocess.uh_ICsPoorfit;
outDip = EEGprocess.uh_ICsOutsideBrain;
eogDip = EEGprocess.uh_ICsEOG;
badDip = [poorfitDip,outDip,eogDip];
remdip = setdiff(allDip, badDip);
% Visualization
% Show Remaining dipoles after removing poorfit and outside the brain ICs
dipplotHide(EEGprocess.dipfit.model,badDip);
if isfield(EEGprocess,'uh_ICsEMG')
    fprintf('Current Results: '); 
    display(EEGprocess.uh_ICsEMG); 
    fprintf('\n');
    ICsEMG = EEGprocess.uh_ICsEMG;
else
    ICsEMG = [];
end
ICsEMG = luu_selectcomps(EEGprocess,remdip,...
    'rejcomp',ICsEMG,...
    'auto',0,'nosedir','+Y');
EEGprocess.uh_ICsEMG = ICsEMG;
assignin('base','EEGprocess',EEGprocess);
evalin('base','clearvars -except mycap FileObj EEGraw EEGprocess');
allfig=findall(0,'type','figure');
printfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_PRINT');
avatarfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_AVATAR');
neurolegfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
clcfig=setdiff(allfig,[printfig,avatarfig,neurolegfig]);
close(clcfig);
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_RemoveICs(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
% Dipfit to remove bad ICs.
poordipfit.model  = dipfit_reject(EEGprocess.dipfit.model, 0.3);
for i=1:length(poordipfit.model)
    poordippos(i)= isempty(poordipfit.model(i).posxyz);
end
rejectdip=find(poordippos);
mycap = evalin('base','mycap');

% EEGprocess.chanlocs = pop_chanedit(EEGprocess.chanlocs,'load',{mycap.locsfile.fullfilename,'filetype','autodetect'});
% EEGprocess.chanlocs([EEGprocess.reject.uh_badchannel])=[];
% if EEGprocess.reject.remove_badchannel_opt == 1
%     EEGprocess.chanlocs([EEGprocess.reject.uh_badchannel])=[];
% end

assignin('base','EEGprocess',EEGprocess);
remdip = setdiff(1:length(EEGprocess.chanlocs),rejectdip); 
% dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','on','num','on','verbose','off');
dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');

hold on;
% eyelim = [-51, -72;,...
%           91,8];
% plot3(90,eyelim(1,1),eyelim(1,2),'marker','o','markersize',8,'color','r');
% plot3(90,eyelim(2,1),eyelim(2,2),'marker','o','markersize',8,'color','r');
% line('xdata',[90 90],'ydata',eyelim(:,1),'zdata',eyelim(:,2),'color','r');
if uh_isvarexist('EEGclean')
        EEGclean = evalin('base','EEGclean');
    if isfield(EEGclean.reject,'uh_nonbraincomps')
        fprintf('Current Results: '); display(EEGclean.reject.uh_nonbraincomps); fprintf('\n');
        uh_nonbraincomps = EEGclean.reject.uh_nonbraincomps;
    else
        uh_nonbraincomps = [];
    end
else 
    uh_nonbraincomps = [];
end
% uh_nonbraincomps = [];
% Automatic detection
autorej = 1;
autorejcomp = [];
if autorej == 1
    maindir = uh_fileparts('fullpath',mfilename('fullpath'),'level',2);
    mriboundfile = class_FileIO('fullfilename',...
        fullfile(maindir,'uhlib\Graphics\GUI','uh_gui_mri_boundary_data.mat'));
    mriboundfile.loadtows;
    mribound = evalin('base','mribound');
%     dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
%     hold on;
%     plot3(mribound.xy(:,1),mribound.xy(:,2),zeros(1,size(mribound.xy,1)),'color','r');
%     plot3(zeros(1,size(mribound.yz,1)),mribound.yz(:,1),mribound.yz(:,2),'color','r');
%     plot3(mribound.xz(:,1),zeros(1,size(mribound.xz,1)),mribound.xz(:,2),'color','r');
    k = 1;
    for i = 1 : length(remdip)
        for j = 1 : 3
            if j == 1
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([1,2]);
                node = mribound.xy;
            elseif j == 2
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([2,3]);
                node = mribound.yz;
            elseif j == 3
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([1,3]);
                node = mribound.xz;
            end
            n = size(node,1);
            cnect  = [(1:n-1)' (2:n)'; n 1];
            diprej = inpoly(dipos,node,cnect);
            if diprej == 0
                autorejcomp(k) = remdip(i);
                k = k + 1;
                break;
            end            
        end
    end
    tempmodel = EEGprocess.dipfit.model;
    rejtemp = [rejectdip, autorejcomp];
    for i = 1 : length(rejtemp)
        tempmodel(rejtemp(i)).posxyz = [0,0,0];
        tempmodel(rejtemp(i)).momxyz = [0,0,0];
    end    
    dipplot(tempmodel,'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
    hold on;
    plot3(mribound.xy(:,1),mribound.xy(:,2),zeros(1,size(mribound.xy,1)),'color','r');
    plot3(zeros(1,size(mribound.yz,1)),mribound.yz(:,1),mribound.yz(:,2),'color','r');
    plot3(mribound.xz(:,1),zeros(1,size(mribound.xz,1)),mribound.xz(:,2),'color','r');
else
    dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','off','verbose','off');
end
% eyecomp = [];
% for i = 1 : length(remdip)
%     dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([2,3]);
%     mattest = eyelim - repmat(dipos,2,1);
%     linetest = det(mattest);
%     if linetest < 0
%         eyecomp(j) = remdip(i);
%         j = j + 1;
%     end
% end
nonbraincomps = luu_selectcomps(EEGprocess,remdip,...
    'rejcomp',unique([uh_nonbraincomps autorejcomp]),'nosedir','+Y');  
if nonbraincomps == 0
    EEGclean=pop_subcomp(EEGprocess,rejectdip,0); %0 dont ask for confirm
else
    EEGclean=pop_subcomp(EEGprocess,unique([rejectdip, nonbraincomps]),0); %0 dont ask for confirm
end
EEGclean.icaact=EEGclean.icaweights*EEGclean.icasphere*EEGclean.data;
EEGclean.chanlocs = EEGprocess.chanlocs;
EEGclean.reject = EEGprocess.reject;
if isfield(mycap.chlabel,'EOG')
    EEGclean.reject.uh_EOG = mycap.chlabel.EOG;
end
EEGclean.reject.uh_badchans = EEGprocess.reject.uh_badchannel;
EEGclean.reject.uh_poorfit = rejectdip;
EEGclean.reject.uh_nonbraincomps = nonbraincomps;
EEGclean.poordipfit.model = poordipfit.model;
assignin('base','EEGclean',EEGclean);
evalin('base','clearvars -except mycap FileObj EEGclean EEGraw EEGprocess');

allfig=findall(0,'type','figure');
printfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_PRINT');
avatarfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_AVATAR');
neurolegfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
clcfig=setdiff(allfig,[printfig,avatarfig,neurolegfig]);
close(clcfig);
fprintf('DONE:%s.\n',thisFuncName);
% Visualization;
% figure;pop_topoplot(EEGclean,0,1:length(EEGclean.icachansind),'',0,1)
% dipplot(EEGclean.dipfit.model,'mri',EEGclean.dipfit.mrifile,'summary','on')
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_RemoveICsAuto(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGprocess = evalin('base','EEGprocess');
% Dipfit to remove bad ICs.
poordipfit.model  = dipfit_reject(EEGprocess.dipfit.model, 0.3);
for i=1:length(poordipfit.model)
    poordippos(i)= isempty(poordipfit.model(i).posxyz);
end
rejectdip=find(poordippos);
mycap = evalin('base','mycap');
% EEGprocess.chanlocs = pop_chanedit(EEGprocess.chanlocs,'load',{mycap.locsfile.fullfilename,'filetype','autodetect'});
% EEGprocess.chanlocs([EEGprocess.reject.uh_badchannel])=[];
% if EEGprocess.reject.remove_badchannel_opt == 1
%     EEGprocess.chanlocs([EEGprocess.reject.uh_badchannel])=[];
% end
assignin('base','EEGprocess',EEGprocess);
remdip = setdiff(1:length(EEGprocess.chanlocs),rejectdip); 
dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','on','num','on','verbose','off');
hold on;
% eyelim = [-51, -72;,...
%           91,8];
% plot3(90,eyelim(1,1),eyelim(1,2),'marker','o','markersize',8,'color','r');
% plot3(90,eyelim(2,1),eyelim(2,2),'marker','o','markersize',8,'color','r');
% line('xdata',[90 90],'ydata',eyelim(:,1),'zdata',eyelim(:,2),'color','r');
% if uh_isvarexist('EEGclean')
%         EEGclean = evalin('base','EEGclean');
%     if isfield(EEGclean.reject,'uh_nonbraincomps')
%         fprintf('Current Results: '); display(EEGclean.reject.uh_nonbraincomps); fprintf('\n');
%         uh_nonbraincomps = EEGclean.reject.uh_nonbraincomps;
%     else
%         uh_nonbraincomps = [];
%     end
% else 
%     uh_nonbraincomps = [];
% end
uh_nonbraincomps = [];
% Automatic detection
autorej = 1;
autorejcomp = [];
if autorej == 1
    maindir = uh_fileparts('fullpath',mfilename('fullpath'),'level',2);
    mriboundfile = class_FileIO('fullfilename',...
        fullfile(maindir,'uhlib\Graphics\GUI','uh_gui_mri_boundary_data.mat'));
    mriboundfile.loadtows;
    mribound = evalin('base','mribound');
    dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
    hold on;
    plot3(mribound.xy(:,1),mribound.xy(:,2),zeros(1,size(mribound.xy,1)),'color','r');
    plot3(zeros(1,size(mribound.yz,1)),mribound.yz(:,1),mribound.yz(:,2),'color','r');
    plot3(mribound.xz(:,1),zeros(1,size(mribound.xz,1)),mribound.xz(:,2),'color','r');
    k = 1;
    for i = 1 : length(remdip)
        for j = 1 : 3
            if j == 1
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([1,2]);
                node = mribound.xy;
            elseif j == 2
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([2,3]);
                node = mribound.yz;
            elseif j == 3
                dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([1,3]);
                node = mribound.xz;
            end
            n = size(node,1);
            cnect  = [(1:n-1)' (2:n)'; n 1];
            diprej = inpoly(dipos,node,cnect);
            if diprej == 0
                autorejcomp(k) = remdip(i);
                k = k + 1;
                break;
            end            
        end
    end
else
    dipplot(EEGprocess.dipfit.model(remdip),'mri',EEGprocess.dipfit.mrifile,'summary','off','num','off','verbose','off');
end
% eyecomp = [];
% for i = 1 : length(remdip)
%     dipos = EEGprocess.dipfit.model(remdip(i)).posxyz([2,3]);
%     mattest = eyelim - repmat(dipos,2,1);
%     linetest = det(mattest);
%     if linetest < 0
%         eyecomp(j) = remdip(i);
%         j = j + 1;
%     end
% end
nonbraincomps = luu_selectcomps(EEGprocess,remdip,...
    'rejcomp',unique([uh_nonbraincomps autorejcomp]),...
    'auto', 1, 'nosedir','+Y');  
if nonbraincomps == 0
    EEGclean=pop_subcomp(EEGprocess,rejectdip,0); %0 dont ask for confirm
else
    EEGclean=pop_subcomp(EEGprocess,unique([rejectdip, nonbraincomps]),0); %0 dont ask for confirm
end
EEGclean.icaact=EEGclean.icaweights*EEGclean.icasphere*EEGclean.data;
EEGclean.chanlocs = EEGprocess.chanlocs;
EEGclean.reject = EEGprocess.reject;
if isfield(mycap.chlabel,'EOG')
    EEGclean.reject.uh_EOG = mycap.chlabel.EOG;
end
EEGclean.reject.uh_badchans = EEGprocess.reject.uh_badchannel;
EEGclean.reject.uh_poorfit = rejectdip;
EEGclean.reject.uh_nonbraincomps = nonbraincomps;
EEGclean.poordipfit.model = poordipfit.model;
EEGclean.dataBeforeRejdip = EEGprocess.data;

assignin('base','EEGclean',EEGclean);
evalin('base','clearvars -except mycap FileObj EEGclean EEGraw EEGprocess');

allfig=findall(0,'type','figure');
printfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_PRINT');
avatarfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_AVATAR');
neurolegfig=findall(0, '-depth',1, 'type','figure', 'Name','UHBMIGUI_NEUROLEG');
clcfig=setdiff(allfig,[printfig,avatarfig,neurolegfig]);
close(clcfig);
fprintf('DONE:%s.\n',thisFuncName);
% Visualization;
% figure;pop_topoplot(EEGclean,0,1:length(EEGclean.icachansind),'',0,1)
% dipplot(EEGclean.dipfit.model,'mri',EEGclean.dipfit.mrifile,'summary','on')
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_CleanTasks(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% --------
EEGin = evalin('base','EEG');
EEGin.data(:,100000:end) = []; % REMOVE THIS. For debugging only.
EEGout = EEGin;
% Hinf
% myobj = class_Hinf('input',EEGin,'EOGch',EEGin.EEGcap.chlabel.EOG,'gamma',2,'q',1e-10);
% EEGout = myobj.execute;
% Remove EOG channel;
% EEGout.chanlocs(EEGin.EEGcap.chlabel.EOG) = [];
EEGout.data(EEGout.EEGcap.chlabel.EOG,:) = []; %Uncommented this if Hinf is
% not run. Hinf will remove EOG channels in the output.
% Filtering
myobj = class_filter('input',EEGout,'Fs',100,'cutoff',0.1,'type','high','method','filtfilt','order',4);
EEGout = myobj.execute;
% Reject bad channels
myobj = class_rejchan('input',EEGout,'threshold',5,'elec',1:length(EEGout.chanlocs),'norm','on','measure','kurt'); % Is elec from 1 to 60 or the remaining channels??
EEGout = myobj.execute;
% CAR
myobj = class_CAR('input',EEGout);
EEGout = myobj.execute;
% ASR
baseline = EEGout.data(:,0.5*gvar.Fs:1.5*gvar.Fs); % Your baseline data here.
myobj = class_ASR('input',EEGout,'cutoff',5,'baseline',baseline,'windowlen',0.5);
EEGout = myobj.execute;
% ICA
myobj = class_ICA('input',EEGout,'icatype','runica','chanind',1:size(EEGout.data,1));
EEGout = myobj.execute;
% dipfit
myobj = class_dipfit('input',EEGout);
EEGout = myobj.execute;
assignin('base','EEG',EEGout);
% Remove bad ICs
myobj = class_removeICs('input',EEGout,'threshold',0.1,'adjfilename','ADJUST_report.txt');
EEGout = myobj.execute;

assignin('base','EEG',EEGout);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_Save(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
% --------
fullfilename = get_varargin(varargin,'filename','filename');
myfile = class_FileIO('fullfilename',fullfilename);
% fprintf('Saving...Filename: %s\n',myfile.filename); 
clear fid;
myfile.savews;
fprintf('DONE:%s.\n',thisFuncName);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.save);

function dipplotHide(dipmodel, hideDip, varargin)
boudaryPlot = get_varargin(varargin,'boundary',1);

EEGprocess = evalin('base','EEGprocess');
for i = 1 : length(hideDip)
    dipmodel(hideDip(i)).posxyz = [0,0,0];
    dipmodel(hideDip(i)).momxyz = [0,0,0];
end
dipplot(dipmodel,'mri',EEGprocess.dipfit.mrifile,'summary','off','num','on','verbose','off');
if boudaryPlot == 1
    hold on;
    mribound = evalin('base','mribound');
    plot3(mribound.xy(:,1),mribound.xy(:,2),zeros(1,size(mribound.xy,1)),'color','r');
    plot3(zeros(1,size(mribound.yz,1)),mribound.yz(:,1),mribound.yz(:,2),'color','r');
    plot3(mribound.xz(:,1),zeros(1,size(mribound.xz,1)),mribound.xz(:,2),'color','r');
end

function [inside, outside] = mriBoundaryCheck(inputDip,mribound)
EEGprocess = evalin('base','EEGprocess');
inside = [];
outside = [];
for i = 1 : length(inputDip)
    for j = 1 : 3
        if j == 1
            dipos = EEGprocess.dipfit.model(inputDip(i)).posxyz([1,2]);
            node = mribound.xy;
        elseif j == 2
            dipos = EEGprocess.dipfit.model(inputDip(i)).posxyz([2,3]);
            node = mribound.yz;
        elseif j == 3
            dipos = EEGprocess.dipfit.model(inputDip(i)).posxyz([1,3]);
            node = mribound.xz;
        end
        n = size(node,1);
        cnect  = [(1:n-1)' (2:n)'; n 1];
        insideCheck = inpoly(dipos,node,cnect);
        if insideCheck == 0
            outside = [outside, inputDip(i)];            
            break;
        end        
    end        
end
inside = setdiff(inputDip,outside);

