%% UH BMI GUI PROJECT
%% Function Description
% * *Filename* :
% * *Matlab Version* :
% * *Date Created* :
% * *Revision*:
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
%% Author's Information
% * *Author name*:
% * *Contact*: _youremailadress@server.com_
%
%  Laboratory for Noninvasive Brain Machine Interface Systems
%  University of Houston
%
function MenuFcn_CreateTemplate(varargin)
if length(varargin)==0
    help(mfilename);return;
elseif length(varargin)==1
    fcnname=varargin{1};
    author=[];
    printoption=1;
else
    fcnname=varargin{1};
    author=[];
    printoption=1;      %printoption=2; stepoption
    for i=2:2:length(varargin)
        param=varargin{i};
        val=varargin{i+1};
        switch lower(param)
            case 'author'
                author=val;
            case 'printopt'
                printoption=val;   %add figdir and figname for printing
            otherwise
        end
    end
end
ex = exist(fcnname);  % does M-Function already exist ? Loop statement
while ex == 2         % rechecking existence
    overwrite = 0;    % Creation decision
    msg = sprintf(['Sorry, but Function -< %s.m >- does already exist!\n', ...
        'Do you wish to Overwrite it ?'], fcnname);
    % Action Question: Text, Title, Buttons and last one is the Default
    action = questdlg(msg, ' Overwrite Function?', 'Yes', 'No','No');
    if strcmp(action,'Yes') == 1
        ex = 0; % go out of While Loop, set breaking loop statement
    else
        % Dialog for new Functionname
        fcnname = char(inputdlg('Enter new Function Name ... ', 'NEWFCN - New Name'));
        if isempty(fcnname) == 1  % {} = Cancel Button => "1"
            disp('   MSG: User decided to Cancel !')
            return
        else
            ex = exist(fcnname);  % does new functionname exist ?
        end
    end
end

overwrite = 1;

if overwrite == 1
    if ~isempty(author)
        CreationMsg = CreateFcn(fcnname,'author',author,'printopt',printoption);   % Call of Sub-Function
    else
        CreationMsg = CreateFcn(fcnname,'printopt',printoption);   % Call of Sub-Function
    end
    disp(['   MSG: <' fcnname '.m> ' CreationMsg])
end

function s = CreateFcn(fcnname,varargin)
printoption=1;
author='_Your name here_';
for i=1:2:length(varargin)
    param=varargin{i};
    val=varargin{i+1};
    switch lower(param)
        case 'printopt'
            printoption=val;
        case 'author'
            author=val;
        otherwise
    end
end
ext = '.m';  % Default extension for a FUNCTION !!
filename = [fcnname ext];
fid = fopen(filename,'w');
% Writer settings will be consructed ...
header=txtheader(filename,author);
printtofile(fid,header);
fcnline = ['function ','varargout=',fcnname,'(handles,varargin)']; % Function Header
fprintf(fid,'%s \n', fcnline);
define=txtdefine;
vargin=txtvarargin;
mainfunc=txtmainfunc;
subfuncinf=txtfuncinf(filename,author);
subfunc=txtsubfunc;
if printoption==0
    printtofile(fid,header,vargin,vargout);
elseif printoption==1
    printtofile(fid,define,vargin,mainfunc,subfunc);
end
% Close the written File
st = fclose(fid);
if st == 0  % "0" for successful
    % Open the written File in the MATLAB Editor/Debugger
    v = version;
    if v(1) == '7'                 % R14 Version
        opentoline(filename, 12);  % Open File and highlight the start Line
    else
        % ... for another versions of MATLAB
        edit(filename);
    end
    s = 'successfully done !!';
else
    s = ' ERROR: Problems encounter while closing File!';
end

function printtofile(fid,varargin)
for i=1:length(varargin)
    thistext=varargin{i};
    for j=1:length(thistext)
        fprintf(fid,'%s\n', thistext{j});
    end
end

function outtext=txtheader(filename,author)
outtext{1} = ['%% Module:' upper(filename)];
outtext{end+1} = ['% * *Filename* : ', filename];
outtext{end+1} = ['% * *MATLAB Ver* : ', version];
outtext{end+1} = ['% * *Date Created* : ', datestr(now)];
outtext{end+1} = '% * *Revision* : 1.0';
outtext{end+1} = '% * *Description*: ';
outtext{end+1} = '% ';
outtext{end+1} = '%   This function continues to explain what the function does.';
outtext{end+1} = '%   Required Input: input to the function. ';
outtext{end+1} = '%   Optional Inputs: ';
outtext{end+1} = '%   Outputs: ';
outtext{end+1} = '%   Algorithm: ';
outtext{end+1} = '%   Notes: ';
outtext{end+1} = '%   Syntax or Exmample: ';
outtext{end+1} = '% ';
outtext{end+1} = '% * *Author''s Information*: ';
outtext{end+1} = ['% * *Author name*:' author];
outtext{end+1} = '% * *Contact*: _youremailadress@server.com_ ';
outtext{end+1} = '% ';
outtext{end+1} = '% _Laboratory for Noninvasive Brain Machine Interface Systems_ ';
outtext{end+1} = '%';
outtext{end+1} = '% _University of Houston_';

function outtext=txtfuncinf(filename,author)
outtext{1} = ['%% Function:' upper(filename) '_untitleFunc'];
outtext{end+1} = '% * *Revision* : 1.0';
outtext{end+1} = '% * *Description*: ';
outtext{end+1} = '% ';
outtext{end+1} = '%   This function continues to explain what the function does. ';
outtext{end+1} = '%   Required Input: input to the function. ';
outtext{end+1} = '%   Optional Inputs: ';
outtext{end+1} = '%   Outputs: ';
outtext{end+1} = '%   Algorithm: ';
outtext{end+1} = '%   Notes: ';
outtext{end+1} = '%   Syntax or Exmample: ';
outtext{end+1} = '% ';
outtext{end+1} = '% * *Author''s Information:* ';
outtext{end+1} = ['% * *Author name*:' author];
outtext{end+1} = '% * *Contact*: _youremailadress@server.com_ ';

function outtext=txtdefine
outtext{1}='%==YOU: Change ''untitled'' to module name( 1 line above);';
outtext{end+1}='%==YOU: Go to module Function (line 92) and write you module function;';
outtext{end+1}='%==GUI: Setup communication with main GUI and Load trials data ;';
outtext{end+1}='global gvar;';
outtext{end+1}='gvar=def_globalvar;';

function outtext=txtvarargin
outtext{1}='getfunclist=0;';
outtext{end+1}='runopt=0;';
outtext{end+1}='filename='''';';
outtext{end+1}='if length(varargin)>=2';
outtext{end+1}='   for i=1:2:length(varargin)';
outtext{end+1}='      param=varargin{i};';
outtext{end+1}='      val=varargin{i+1};';
outtext{end+1}='      switch lower(param)';
outtext{end+1}='        case ''getfunclist''';
outtext{end+1}='           getfunclist=val;';
outtext{end+1}='        case ''runopt''';
outtext{end+1}='           runopt=val;';
outtext{end+1}='        case ''filename''';
outtext{end+1}='           filename=val;';
outtext{end+1}='         otherwise';
outtext{end+1}='      end';
outtext{end+1}='   end';
outtext{end+1}='end';

function outtext=txtmainfunc
outtext{1}='funchdl=localfunctions;';
outtext{end+1}='UHBMIFuncList={};';
outtext{end+1}='varargout{1}=UHBMIFuncList;';
outtext{end+1}='k=1;';
outtext{end+1}='for i=1:length(funchdl)';
outtext{end+1}='    funcname=func2str(funchdl{i});';
outtext{end+1}='    if strfind(lower(funcname),''uhbmi'');';
outtext{end+1}='        UHBMIFuncList{k}=funcname;';
outtext{end+1}='        k=k+1;';
outtext{end+1}='    end';
outtext{end+1}='end';
outtext{end+1}='% For debugging. Only work for one trial data which are available in WS';
outtext{end+1}='if nargin==0       %Press F5, No input argument';
outtext{end+1}='    try';
outtext{end+1}='        % Access UHBMI_AVATARGUI';
outtext{end+1}='        maingui=getappdata(0,''AVATARGUI'');';
outtext{end+1}='        handles=getappdata(maingui,''handles'');';
outtext{end+1}='        for i=1:length(gvar.mfilesequence)';
outtext{end+1}='            if strcmpi(gvar.mfilesequence{i},mfilename)';
outtext{end+1}='                pathrows=handles.juitree_funclist.getRowForPath(handles.funclistpath{i});';
outtext{end+1}='                break;';
outtext{end+1}='            end';
outtext{end+1}='        end';
outtext{end+1}='        selrows=handles.juitree_funclist.getSelectionRows;';
outtext{end+1}='        runopt=selrows-pathrows;';
outtext{end+1}='        for i=1:length(UHBMIFuncList)-1  % Run Selected Func Except for Save';
outtext{end+1}='            for j=1:length(runopt)';
outtext{end+1}='                    if i==runopt(j)';
outtext{end+1}='                       cmdstr=sprintf(''%s(handles)'',UHBMIFuncList{i});';
outtext{end+1}='                       eval(cmdstr);';
outtext{end+1}='                    end';
outtext{end+1}='            end';
outtext{end+1}='        end';
outtext{end+1}='    catch';
outtext{end+1}='        fprintf(''In this version: Debugging Mode only works when UHBMI_AVATARGUI is opened \n'');';
outtext{end+1}='        fprintf(''Open UHBMI_AVATARGUI and selection Function that you are working on \n'');';
outtext{end+1}='        fprintf(''Check trial data are available in Workspace \n'');';
outtext{end+1}='    end';
outtext{end+1}='else';
outtext{end+1}='    if getfunclist==1';
outtext{end+1}='        varargout{1}=UHBMIFuncList;';
outtext{end+1}='        return;';
outtext{end+1}='    else';
outtext{end+1}='        [stacktrace, ~]=dbstack;';
outtext{end+1}='        thisFuncName=stacktrace(1).name;';
outtext{end+1}='        logMessage(sprintf(''%s'',thisFuncName),handles,''useicon'',handles.iconlist.brain);';
outtext{end+1}='        for f=1:length(filename)';
outtext{end+1}='            thisfilename=filename{f};';
outtext{end+1}='            logMessage(sprintf(''%s'',thisfilename),handles,''useicon'',handles.iconlist.file.mat);';
outtext{end+1}='            updatestatusbar(handles,f,length(filename));';
outtext{end+1}='            evalin(''base'',''clearvars -except handles filename gvar'');';
outtext{end+1}='            datastruct=load(thisfilename);';
outtext{end+1}='            fname=fieldnames(datastruct);';
outtext{end+1}='            allvar=datastruct.(fname{1});';
outtext{end+1}='            fname=fieldnames(allvar);';
outtext{end+1}='            for fn=1:length(fname)';
outtext{end+1}='                assignin(''base'',sprintf(''%s'',fname{fn}),allvar.(fname{fn}));';
outtext{end+1}='            end ';       
outtext{end+1}='           for i=1:length(UHBMIFuncList)';
outtext{end+1}='                for j=1:length(runopt)';
outtext{end+1}='                    if i==runopt(j)';
outtext{end+1}='                        cmdstr=sprintf(''%s(handles,''''filename'''',thisfilename)'',UHBMIFuncList{i});';
outtext{end+1}='                        eval(cmdstr);';
outtext{end+1}='                    end';
outtext{end+1}='                end';
outtext{end+1}='            end';
outtext{end+1}='            logMessage(sprintf(''%s'',thisfilename),handles,''useicon'',handles.iconlist.status.check);';
outtext{end+1}='        end';
outtext{end+1}='    end';
outtext{end+1}='logMessage(sprintf(''%s'',thisFuncName),handles,''useicon'',handles.iconlist.status.check);';
outtext{end+1}='end';
outtext{end+1}='';


function outtext=txtsubfunc
outtext{1}='';
outtext{end+1}='function UHBMIGUI_untitled_untitled(handles,varargin)';
outtext{end+1}='%==YOU: Change ''untitled'' in the func name ( 1 line above);';
outtext{end+1}='%==GUI: Log Message';
outtext{end+1}='[stacktrace, ~]=dbstack; ';
outtext{end+1}='thisFuncName=stacktrace(1).name; ';
outtext{end+1}='logMessage(sprintf(''%s'',thisFuncName),handles,''useicon'',handles.iconlist.action.play);';
outtext{end+1}='%==YOU: Load data from WorkSpace and Process from HERE';
outtext{end+1}='';
outtext{end+1}='';
outtext{end+1}='%==GUI: Take Note. Func info is stored in processingnote var';
outtext{end+1}='if evalin(''base'',''exist(''''processingnote'''',''''var'''')'')==0';
outtext{end+1}='else';
outtext{end+1}='processingnote=evalin(''base'',''processingnote'');';
outtext{end+1}='end';
outtext{end+1}='%==YOU: Place your note in notestr variable';
outtext{end+1}='notestr='''';';
outtext{end+1}='%==GUI: Log message and save processing note. ';
outtext{end+1}='cmdstr=sprintf(''processingnote.%s=notestr;'',thisFuncName);';
outtext{end+1}='eval(cmdstr);';
outtext{end+1}='assignin(''base'',''processingnote'',processingnote);';
outtext{end+1}='logMessage(sprintf(''%s'',thisFuncName),handles,''useicon'',handles.iconlist.status.check);';

function outtext=txtnargout
outtext{1}='';
outtext{end+1}='%Outputs from this function,...';
outtext{end+1}='%Change output1, output2, etc to your output variables';
outtext{end+1}='switch nargout';
outtext{end+1}='    case 0';
outtext{end+1}='    case 1';
outtext{end+1}='        varargout{1}=output1;';
outtext{end+1}='    case 2';
outtext{end+1}='        varargout{1}=output1;';
outtext{end+1}='        varargout{2}=output2;';
outtext{end+1}='    otherwise';
outtext{end+1}='end';
outtext{end+1}='';
outtext{end+1}='';



