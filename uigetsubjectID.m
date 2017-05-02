function subjectID = uigetsubjectID(selectedfiles)
subjectID = [];
subjlist = {};
if ~isempty(selectedfiles)
    k=1;
    for i=1:length(selectedfiles)
        thisfile=selectedfiles{i};
        dashpos = strfind(thisfile,'-');
        if ~isempty(dashpos)
            subjlist{k}=thisfile(1:dashpos(1)-1);
            k=k+1;
        end
    end
    if ~isempty(subjlist)
        subjectID=unique(subjlist);
    else
    end
end