%% Module:UHBMIGUI_EEG.M
% * *Filename* : UHBMIGUI_EEG.m
% * *MATLAB Ver* : 9.0.0.341360 (R2016a)
% * *Date Created* : 30-Sep-2016 13:00:30
% * *Revision* : 1.0
% * *Description*: 
% 
%   This function continues to explain what the function does.
%   Required Input:
%           EMG --- left------ rawdata
%                 |_ right    |_ trigger
%                 |_ srate    |_ header
%                           |_ resampdata (The one you should use
%   Optional Inputs: 
%   Outputs: EMG.right.cleandata and EMG.left.cleandata
%   Algorithm:
%       1) Bandpass filter using zero phase filter (30-300Hz, 4th)
%       2) Rectify
%       3) Lowpass using the same filter (2-8Hz, 4th or 3rd order)
%   Notes: 
%   Syntax or Exmample: 
% 
% * *Author's Information*: 
% * *Author name*: Sho Nakagome
% * *Contact*: snakagome@uh.edu 
% 
% _Laboratory for Noninvasive Brain Machine Interface Systems_ 
%
% _University of Houston_

function varargout=MODULE_050_EMGprocess(handles,varargin)
global gvar; 
gvar=def_gvar;
getfunclist=0;
runopt=0;
filename='';
getfunclist = get_varargin(varargin,'getfunclist',0)
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

function UHBMIGUI_EMGprocessing(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName = stacktrace(1).name;
uh_fprintf(sprintf('RUNNING: %s',thisFuncName));
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.play);
% -----
% define input
EMGin = evalin('base', 'EMG');
% 1) Bandpass filter (0.1 - 30Hz, 4th order)
% assign your value
h_cut = 30; % Hz
l_cut = 300; % Hz
order = 4;
% srate = round(EMGin.srate * size(EMGin.right.resampdata,2)/size(EMGin.right.rawdata,1))
srate = EMGin.srate;
filtobj = class_filter('input', EMGin.right.resampdata, 'fs', srate, 'cutoff', [h_cut l_cut], 'type', 'bandpass',...
    'method', 'filtfilt', 'order', order);
% 170114: Edited by Luu. class_filter object need
% to execute to get filtered EMG
EMGfilt_right = filtobj.execute;
filtobj = class_filter('input', EMGin.left.resampdata, 'fs', srate, 'cutoff', [h_cut l_cut], 'type', 'bandpass',...
    'method', 'filtfilt', 'order', order);
EMGfilt_left = filtobj.execute;
EMGin.right.filtered = EMGfilt_right.data;
EMGin.left.filtered = EMGfilt_left.data;
% 2) Rectify
EMGrect_right = abs(EMGfilt_right.data);
EMGrect_left = abs(EMGfilt_left.data);
EMGin.right.rectified = EMGrect_right;
EMGin.left.rectified = EMGrect_left;
% 3) Lowpass filter (option: 2 to 8Hz (Choose))
% assign your value
cutoff = 5; % Hz
order = 4;
filtobj = class_filter('input', EMGrect_right, 'fs', EMGin.srate, 'cutoff', cutoff, 'type', 'low',...
    'method', 'filtfilt', 'order', order);
output = filtobj.execute; EMGin.right.envelope = output.data;
filtobj = class_filter('input', EMGrect_left, 'fs', EMGin.srate, 'cutoff', cutoff, 'type', 'low',...
    'method', 'filtfilt', 'order', order);
output = filtobj.execute; EMGin.left.envelope = output.data;
% Down sample to 100 Hz; srate = 1000;
EMGin.right.filtered = transpose(resample(transpose(EMGin.right.filtered),100,srate));
EMGin.left.filtered = transpose(resample(transpose(EMGin.left.filtered),100,srate));
EMGin.right.rectified = transpose(resample(transpose(EMGin.right.rectified),100,srate));
EMGin.left.rectified = transpose(resample(transpose(EMGin.left.rectified),100,srate));
EMGin.right.envelope = transpose(resample(transpose(EMGin.right.envelope),100,srate));
EMGin.left.envelope = transpose(resample(transpose(EMGin.left.envelope),100,srate));
% Put the output back into the structure
assignin('base', 'EMG', EMGin);
% -----
uh_fprintf(sprintf('DONE: %s',thisFuncName));
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.status.check);

function UHBMIGUI_EEG_Save(handles,varargin)
global gvar;
[stacktrace, ~]=dbstack;
thisFuncName=stacktrace(1).name;
% --------
fullfilename = get_varargin(varargin,'filename','filename');
myfile = class_FileIO('fullfilename',fullfilename);
uh_fprintf(sprintf('Saving...Filename: %s',myfile.filename)); 
myfile.savews;
uh_fprintf(sprintf('DONE:%s.',thisFuncName));
% --------
logMessage(sprintf('%s',thisFuncName),handles.jedit_log, 'useicon',handles.iconlist.action.save);




