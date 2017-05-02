function uiupdatestatbar(handles,val,maxval,varargin)
iconlist=getmatlabicons;
jstatusbarhdl=handles.jstatusbarhdl;
jwaitbarhdl=handles.jwaitbarhdl;
msg=sprintf('Processing...%d of %d',val,maxval);
if length(varargin)>=2
   for i=1:2:length(varargin)
      param=varargin{i};
      val=varargin{i+1};
      switch lower(param)        
          case 'msg'
              msg=val;
         otherwise
      end
   end
end
set(jwaitbarhdl,'maximum',maxval);
set(jwaitbarhdl,'value',val);
if val<maxval
    set(jstatusbarhdl,'text',msg);
else
    set(jstatusbarhdl,'text',icontext(iconlist.status.check,'DONE'));
end