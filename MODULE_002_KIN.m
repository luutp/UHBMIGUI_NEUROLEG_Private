function varargout = MODULE_002_KIN(handles,varargin)
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
    maingui=getappdata(0,'NEUROLEG_PROJECT')
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
        logMessage(sprintf('%s',thisFuncName),handles.jedit_log,'useicon',handles.iconlist.walk);
        for f=1:length(filename)
            thisfilename=filename{f};
            logMessage(sprintf('%s',thisfilename),handles.jedit_log, 'useicon',handles.iconlist.file.mat);
            evalin('base','clearvars -except handles filename gvar');
            myfile = class_FileIO('fullfilename',thisfilename);
            myfile.loadtows;
            assignin('base','kinmatfilename',thisfilename);
            for i=1:length(UHBMIFuncList)
                for j=1:length(runopt)
                    if i==runopt(j)
                        cmdstr=sprintf('%s(handles,''filename'',thisfilename)',UHBMIFuncList{i});
                        eval(cmdstr);
                    end
                end
            end
            uiupdatestatbar(handles,f,length(filename));
            logMessage(sprintf('%s',thisfilename),handles.jedit_log, 'useicon',handles.iconlist.status.check);
        end
    end
    logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);
end

function UHBMIGUI_KIN_Process(handles,varargin)
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
%==
global gvar processor;
kinematics=evalin('base','kinematics');
conductor=evalin('base','conductor');
settings=evalin('base','settings');
opal=evalin('base','opal');
kindata=kinematics.data;
timeline=conductor.timelineKin;
timemark=conductor.time;
study = handles.study; % study is defined in UHBMI_AVATARGUI
if strcmpi(study,'lesion')
    posmark=length(timeline).*[1 1];
    perturbmark=length(timeline).*[1 1];
else
    if ~isempty(timemark)
        if length(timemark)>=6
            timemark(1)=[];     %Conductor insconsistence before and after ICVR
        end
        posmark=markerpos_def(timemark,timeline);
        if strcmpi(study,'gonio-perturb') || strcmpi(study,'gonio')
            perturbmark=posmark(3:4);
        elseif strcmpi(study,'gonio-zerog') % Gonio perturb with zero Gravity treadmill. 160708
            posmark = markerpos_def([timemark(end)-720, timemark(end)],timeline); %perturbation for 12 mins
            perturbmark = posmark;
        end
    else
        posmark=length(timeline).*[1 1];
        perturbmark=length(timeline).*[1 1];
    end
end
if iscell(settings.Joint_Factor)
    for i=1:length(settings.Joint_Factor)
        joint_factor(i)=str2num(settings.Joint_Factor{i});
    end
else
    joint_factor=settings.Joint_Factor;
end
calib=[90 90 43 90 90 43]./joint_factor;
%=============KINSUBJECT and KINAVATAR=====================================
for i=1:size(kindata,2)
    kinfilt = uh_filter(kindata(:,i),'fs',100,'order',2,'type','low');
    preprocessdata(:,i)=kinfilt;
end
kinsubject=preprocessdata(:,1:6);
for i=1:size(kinsubject,2)
    kinsubject(:,i)=kinsubject(:,i)*calib(i);
end
kinsubject(:,4:6)=-kinsubject(:,4:6);
rheelpos_subject=heelposcal(kinsubject(:,1:3));
lheelpos_subject=heelposcal(kinsubject(:,4:6));
kinematics.preprocessdata=preprocessdata;
kinematics.kinsubject=kinsubject;
if strcmpi(study,'lesion')
    leftava=kinsubject(:,4:6);
    rightava=preprocessdata(:,7:9);                                       %eeg control
    kinavatar=[rightava leftava];
    rheelpos_avatar=heelposcal(kinavatar(:,1:3));
    
    kinematics.kinavatar=kinavatar;
    kinematics.rheelpos.avatar=rheelpos_avatar;
    kinematics.rheelpos.subject=rheelpos_subject;
    kinematics.lheelpos.subject=lheelpos_subject;
elseif strcmpi(study,'gonio-perturb') || strcmpi(study,'gonio-zerog') || strcmpi(study,'gonio');
    leftava=kinsubject(:,4:6);
    rightava=preprocessdata(:,7:9);                                       %eeg control
    rightava(1:posmark(2),:)=kinsubject(1:posmark(2),1:3); %gonio control
    rightava(posmark(2):perturbmark(1))=rightava(posmark(2):perturbmark(1)); %eeg control pre-perturb
    rightava(perturbmark(1):perturbmark(2),:)=gvar.pertgain*rightava(perturbmark(1):perturbmark(2),:); %perturbation
    kinavatar=[rightava leftava];
    
    leftgonio=kinsubject(:,4:6);
    rightgonio=kinsubject(:,1:3);                                       %eeg control
    rightgonio(1:posmark(2),:)=kinsubject(1:posmark(2),1:3); %gonio control
    rightgonio(posmark(2):perturbmark(1))=rightgonio(posmark(2):perturbmark(1)); %eeg control pre-perturb
    rightgonio(perturbmark(1):perturbmark(2),:)=gvar.pertgain*rightgonio(perturbmark(1):perturbmark(2),:); %perturbation
    kinmovdot=[rightgonio leftgonio];
    
    rheelpos_avatar=heelposcal(kinavatar(:,1:3));
    rheelpos_movdot=heelposcal(kinmovdot(:,1:3));
    
    kinematics.kinavatar=kinavatar;
    kinematics.rheelpos.avatar=rheelpos_avatar;
    kinematics.rheelpos.subject=rheelpos_subject;
    kinematics.lheelpos.subject=lheelpos_subject;
    kinematics.rheelpos.movdot=rheelpos_movdot;
end
% [rval_decoder, snrval_decoder]=EvalDecoder_slide('actual',preprocessdata(:,1:3),...
%     'predicted',preprocessdata(:,7:9),...
%     'ropt',1,'snropt',1);
% window_avatar=rawkin_slide(gvar.Fs,kinavatar',gvar.movsize,gvar.movstep,'romslide',1);
% rom_avatar=window_avatar.romslide';
% romratio_avatar=rom_avatar(:,1:3)./rom_avatar(:,4:6);
% window_subject=rawkin_slide(gvar.Fs,kinsubject',gvar.movsize,gvar.movstep,'romslide',1);
% rom_subject=window_subject.romslide';
% romratio_subject=rom_subject(:,1:3)./rom_subject(:,4:6);
% tslide=windowtime(length(rval_decoder),timeline,gvar.Fs,gvar.movsize,gvar.movstep);tslide=tslide';
% winsize = gvar.movsize*gvar.Fs; stepsize = gvar.movstep*gvar.Fs;
% tslide = uh_gettimeslide(timeline,winsize,stepsize,length(rval_decoder));
% conductor.tslidekin=tslide;
%==
% kinematics.rom_avatar=rom_avatar;
% kinematics.romratio_avatar=romratio_avatar;
% kinematics.rom_subject=rom_subject;
% kinematics.romratio_subject=romratio_subject;
% kinematics.rval_decoder=rval_decoder;
% kinematics.snrval_decoder=snrval_decoder;
%==
assignin('base','conductor',conductor);
assignin('base','kinematics',kinematics);
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_KIN_Save(handles,varargin)
fullfilename = get_varargin(varargin,'filename','filename');
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
myfile = class_FileIO('fullfilename',fullfilename);
fprintf('Saving...Filename: %s\n',myfile.filename);
myfile.savews;
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.save);



