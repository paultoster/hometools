function [c_names,icount] = str_split_quot1(text,delim,quot0,quot1,elim,elimq)
% $JustDate:: 11.01.06  $, $Revision:: 1 $ $Author:: Tftbe1    $
%
% [c_names,icount] = str_split(text,delim,quot0,quot1)
% [c_names,icount] = str_split(text,delim,quot0,quot1,elim)
%
% quot0 cell oder char   Startquot mehrere quots können bearbeitet werden
% z.B. {'"','['}
% quot1 cell oder char   Endquot mehrere quots können bearbeitet werden z.B. {'"',']'}
% elim                   ~= 0: bereinigt Leerzellen (default: 0)
% elimq                  ~= 0: bereinigt die quotzeichen (defaul: 0)
%
% Text wird nach delim gesplittet aber die quots werden beachtet
% Ausgabe cellarray mit den Textteilen
%
% str_split_quot1('abc   def "geh ijk" lmn [123, 456]',' ',{'"','['},{'"',']'},1)
% => {'abc','def','"geh ijk",'lmn','[123, 456]'}

if( ischar(delim) )
    if( strcmp(delim,'\t') )
      delim  = sprintf(delim);
    end
    delim = {delim};
else
  for i=1:length(delim)
    if( strcmp(delim{i},'\t') )
      delim{i}  = sprintf(delim{i});
    end
end

ld = [];
for i = 1:length(delim)
    ld(i) = length(delim{i});
end

if( ischar(quot0) )
    quot0 = {quot0};
end
if( ischar(quot1) )
    quot1 = {quot1};
end
lq = min(length(quot0),length(quot1));
l0q = [];
l1q = [];
for iq=1:lq
    l0q(iq) = length(quot0{iq});
    l1q(iq) = length(quot1{iq});
end
if( ~exist('elim','var') )
    elim = 0;
end
if( ~exist('elimq','var') )
    elimq = 0;
end
%=========================
status = 0; % kein quot
c_names = {};
nc     = 0;
ttext  = '';
it = 1;
lt = length(text);
while it <= lt
    
    if( status == 0 )
        %  quot0 suchen
        for iq=1:lq
            
            if( strcmp(text(it:min(lt,it+l0q(iq)-1)),quot0{iq}) )
                status = iq;
                if( ~elimq )
                    ttext = [ttext,text(it:it+l0q(iq)-1)];
                end
                it = it+l0q(iq)-1;
                break;
            end
        end
        if( status == 0 )
            
            %delim suchen
            flag_delim = 0;
            for idelim = 1:length(delim)
                if( strcmp(text(it:min(lt,it+ld(idelim)-1)),delim{idelim}) )
                    flag_delim = 1;
                    break;
                end
            end
            if( flag_delim )
                nc = nc+1;
                c_names{nc} = ttext;
                ttext      = '';                
                it = it+ld(idelim)-1;
            else
                ttext = [ttext,text(it)];
            end
        end
    else
        %quot1 suchen
        if( strcmp(text(it:min(lt,it+l1q(status)-1)),quot1{status}) )
            if( ~elimq )
                ttext = [ttext,text(it:it+l1q(status)-1)];
            end
            it = it+l1q(status)-1;
            status = 0;
        else
            ttext = [ttext,text(it)];
        end
    end
    it = it+1;
end

if( length(ttext) > 0 )
    nc = nc+1;
    c_names{nc} = ttext;
end
    

if( elim )
    i1 = 0;
    c_names1={};
    for i=1:length(c_names)
        if( length(c_names{i}) > 0 )
            i1           = i1+1;
            c_names1{i1} = c_names{i};
        end
    end
    c_names = c_names1;
end
            
            