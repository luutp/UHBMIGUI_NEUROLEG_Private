function varargout=UHBMIGUI_END(handles,varargin)
global gvar;
gvar=def_gvar;
getfunclist=0;
runopt=0;
filename='';
if length(varargin)>=2
    for i=1:2:length(varargin)
        param=varargin{i};
        val=varargin{i+1};
        switch lower(param)            
            case 'getfunclist'
                getfunclist=val;  
            case 'filename'
                filename=val;
            case 'runopt'
                runopt=val;
        end
    end
end
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
    try
        % Access UHBMI_AVATARGUI
        maingui=getappdata(0,'AVATARGUI');
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
    catch
        fprintf('In this version: Debugging Mode only works when UHBMI_AVATARGUI is opened \n');
        fprintf('Open UHBMI_AVATARGUI and selection Function that you''re working on \n');
        fprintf('Check trial data are available in Workspace \n');
    end
else
    if getfunclist==1
        varargout{1}=UHBMIFuncList;
        return;
    else
        [stacktrace, ~]=dbstack;
        thisFuncName=stacktrace(1).name;
        logMessage(sprintf('%s',thisFuncName),handles,'useicon',handles.iconlist.figure);
        filename
        runopt
        for f=1:length(filename)
            thisfilename=filename{f};
            logMessage(sprintf('%s',thisfilename),handles,'useicon',handles.iconlist.file.mat);
            evalin('base','clearvars -except handles filename gvar');
            datastruct=load(thisfilename);
            fname=fieldnames(datastruct);
            allvar=datastruct.(fname{1});
            fname=fieldnames(allvar);
            for fn=1:length(fname)
                assignin('base',sprintf('%s',fname{fn}),allvar.(fname{fn}));
            end
            assignin('base','trial',thisfilename);
            for i=1:length(UHBMIFuncList)
                for j=1:length(runopt)
                    if i==runopt(j)
                        cmdstr=sprintf('%s(handles,''filename'',thisfilename)',UHBMIFuncList{i});
                        eval(cmdstr);
                    end
                end
            end
            uiupdatestatbar(handles,f,length(filename));
            logMessage(sprintf('%s',thisfilename),handles,'useicon',handles.iconlist.status.check);
        end
    end
    logMessage(sprintf('%s',thisFuncName),handles,'useicon',handles.iconlist.status.check);
end