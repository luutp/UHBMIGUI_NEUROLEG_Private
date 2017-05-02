function varargout = MODULE_001_FileIO(handles,varargin)
global gvar;
gvar=def_gvar;
getfunclist = get_varargin(varargin,'getfunclist',0);
runopt = get_varargin(varargin,'runopt',0);
filename = get_varargin(varargin,'filename','filename');
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
    % Access maingui
    maingui=getappdata(0,'NEUROLEG_PROJECT');
    handles=getappdata(maingui,'handles');
    for i=1:length(gvar.mfilesequence)
        if strcmpi(gvar.mfilesequence{i},mfilename)
            pathrows=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});
            break;
        end
    end
    selrows=handles.juitree_funclist.getSelectionRows;
    runopt=selrows-pathrows;
    for i=1:length(UHBMIFuncList)-1  % Run Selected Func Except for Save
        for j=1:length(runopt)
            if i==runopt(j)
                cmdstr=sprintf('%s(handles)',UHBMIFuncList{i});
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
        logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.folder);
        for f=1:length(filename)
            thisfilename = filename{f};
            myfile = class_FileIO('fullfilename',thisfilename);
            logMessage(sprintf('%s',myfile.filename),handles.jedit_log, 'useicon',handles.iconlist.file.mat);
            evalin('base','clearvars -except handles filename gvar');
            if strcmpi(myfile.ext,'.mat') % if selected file is .mat file
                myfile.loadtows;
            end
            for i=1:length(UHBMIFuncList)
                for j=1:length(runopt)
                    if i==runopt(j)
                        cmdstr=sprintf('%s(handles,''filename'',thisfilename)',UHBMIFuncList{i});
                        eval(cmdstr);
                    end
                end
            end
            uiupdatestatbar(handles,f,length(filename));
            logMessage(sprintf('%s',myfile.filename),handles.jedit_log, 'useicon',handles.iconlist.status.check);
        end
    end
    logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
end

function UHBMIGUI_FileIO_Makeelecfile(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.import);
rawdir=get_varargin(varargin,'outputdir',handles.datadir{2});
fullfilename = get_varargin(varargin,'filename','filename');
% Make elec file which is compatiable with Fieldtrip
uh_readcaptrak(fullfilename,'format','.elc','caplayout','EOG_neuroleg');
% -----
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_FileIO_MakebstMatfile(handles,varargin)
% Create channel matfile follow brainstorm format.
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.import);
rawdir=get_varargin(varargin,'outputdir',handles.datadir{2});
fullfilename = get_varargin(varargin,'filename','filename');
inputfile = class_FileIO('fullfilename',fullfilename);
structdata = in_channel_brainvision(fullfilename); % ChannelMat in bst format.
Channel = structdata.Channel;
for i = 1 : length(Channel)
    if strcmpi(structdata.Channel(i).Name,'A1'); structdata.Channel(i).Name = 'LPA'; end
    if strcmpi(structdata.Channel(i).Name,'A2'); structdata.Channel(i).Name = 'RPA'; end
end
structdata.Comment = inputfile.filename;
fname=fieldnames(structdata);
for fn=1:length(fname)
    assignin('base',sprintf('%s',fname{fn}),structdata.(fname{fn}));
end
outputfile = class_FileIO('filedir',inputfile.filedir,'filename',['channel_' inputfile.filename '.mat']); %channel filetype in brainstorm
outputfile.savews;
% -----
uh_fprintf(sprintf('DONE: %s',thisFuncName));
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_FileIO_MakeEEGfile(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.import);
rawdir = handles.datadir{2};
processdir = handles.datadir{1};
fullfilename = get_varargin(varargin,'filename','filename');
EEGraw = evalin('base','EEG');
% --------
inputfile = class_FileIO('fullfilename',fullfilename);
locsfile = class_FileIO('filedir','.\Includes','filename','60Ch_EOG_NeuroLeg.locs');
subject = uh_getfilenameinfo(inputfile.filename);
filelist = dir(rawdir);
elecfile = '';
for i = 1 : length(filelist)
    if ~filelist(i).isdir
        thisfilename = filelist(i).name;
        if ~isempty(strfind(thisfilename,subject)) && ~isempty(strfind(thisfilename,'.elc'));
            elecfile = class_FileIO('filedir',rawdir,'filename',thisfilename);            
            break;       
        end
    end
end
mycap = class_EEGcap('layout','EOG_Neuroleg','locsfile',locsfile,'elecfile',elecfile);
EEGraw.EEGcap = mycap;
EEGraw.chanlocs = pop_chanedit([], 'load',{mycap.elecfile.fullfilename, 'filetype', 'autodetect'});
outputfile = class_FileIO('filedir',processdir,'filename',inputfile.filename);
filename = outputfile.filename;
outputfile.savevars(EEGraw,mycap,filename);
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_FileIO_MakeEMGfile(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.import);
uh_fprintf(sprintf('RUNNING: %s',thisFuncName));
processdir = handles.datadir{1};
fullfilename = get_varargin(varargin,'filename','filename');
% --------
inputfile = class_FileIO('fullfilename',fullfilename);
outputfile = class_FileIO('filedir',processdir,'filename',inputfile.filename);
EMG = evalin('base','EMG');
EMG.filename = outputfile.filename;
assignin('base','EMG',EMG);
outputfile.savews;
% --------
uh_fprintf(sprintf('DONE: %s',thisFuncName));
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_FileIO_MakeKINfile(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.action.import);
uh_fprintf(sprintf('RUNNING: %s',thisFuncName));
processdir = handles.datadir{1};
fullfilename = get_varargin(varargin,'filename','filename');
% --------
inputfile = class_FileIO('fullfilename',fullfilename);
outputfile = class_FileIO('filedir',processdir,'filename',inputfile.filename);
kin = evalin('base','kin');
kin.filename = outputfile.filename;
assignin('base','kin',kin);
outputfile.savews;
% --------
uh_fprintf(sprintf('DONE: %s',thisFuncName));
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

