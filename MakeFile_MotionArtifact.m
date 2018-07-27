%% MakeFile_MotionArtifact.m
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
% * *MATLAB Ver :* 9.3.0.713579 (R2017b)
% * *Date Created :* 02-Jul-2018 23:01:58
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
function varargout = MakeFile_MotionArtifact(varargin) 
rawdir = 'G:\OneDrive\MotionArtifact\RAW DATA';
filename = 'G:\OneDrive\MotionArtifact\RAW DATA\MotartData_to_Luu.mat';
mydate = class_datetime;
% makeeeg = 1;
% makekin = 0;
if ~uh_isvarexist('DATA')    
    fprintf('Load data file \n');
    datastruct = load(filename);
    data = datastruct.DATA;    
else
    fprintf('Load data from Workspace \n');
    data = evalin('base','DATA');
end
selsubj = [1,2,4,5,6,8,9,10];
for i = selsubj
    eegdata = data(i).EEG;
    kindata = data(i).GaitPhase;
    if ~isempty(eegdata)
        for j = 1 : length(eegdata)
            eegraw = double(transpose(eegdata(j).data));
            gc = kindata(j).data;
            gccheck = find(gc);
            restidx = 1:gccheck(1);
            walkidx = gccheck(1):gccheck(end);
            condition = {'Rest','Walk'};
            RestWalkRestIdx = [1,gccheck(1),gccheck(end),size(eegraw,2)];
            for k = 1:length(condition)
                EEG = eeg_emptyset;
                thiscondition = condition{k};
                if (strcmpi(thiscondition,'rest'))
                    EEG = pop_importdata('setname','Motion Artifact Study','data',eegraw(:,restidx),'nbchan',size(eegraw,1),'srate',100);                        
                    EEG.gc = gc(restidx);
                elseif (strcmpi(thiscondition,'walk'))
                    EEG = pop_importdata('setname','Motion Artifact Study','data',eegraw(:,walkidx),'nbchan',size(eegraw,1),'srate',100);                        
                    EEG.gc = gc(walkidx);
                end
                eegfilename = sprintf('H%.2d-T%.2d-%s-%s-eeg',i,j,thiscondition,mydate.ymd);            
                EEG.condition = thiscondition;
                EEG.filename = eegfilename;
                EEG.filepath = rawdir;
                EEG.subject = sprintf('H%.2d',i);
                EEG.trial = j;
                EEG.RestWalkRestIdx = RestWalkRestIdx;
                
                eegfileobj = class_FileIO('filedir',rawdir,'filename',eegfilename);
                eegfileobj.savevars(EEG);
            end                        
        end
    end
    
%     if makekin == 1
%         kindata = data(i).GaitPhase;
%         if ~isempty(kindata)
%             for j = 1 : length(kindata)
%                 gc = kindata(j).data;
%                 kin.gc = gc;
%                 kinfilename = sprintf('H%.2d-T%.2d-%s-kin',i,j,mydate.ymd);            
%                 kinfileobj = class_FileIO('filedir',rawdir,'filename',kinfilename);
%                 kinfileobj.savevars(kin);
%             end
%         end
%     end
end
% 
