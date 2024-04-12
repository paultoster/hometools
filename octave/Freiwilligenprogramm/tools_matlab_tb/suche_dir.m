function [c_dir,len] = suche_dir(sdir,subdirflag,tdir,tdir_type)
%
% function c_dir = suche_dir(sdir,[subdirflag,tdir,tdir_type])
% 
% c_dir = suche_dir('D:\')          sucht Verzeichnisse unter D: flach
% c_dir = suche_dir('D:\',1)        sucht alle UnterVerzeichnisse unter D: tief
% c_dir = suche_dir('D:\',1,'temp') sucht alle Unterverzeichnisse die temp heiﬂen
% c_dir = suche_dir('D:\',1,'temp',1) sucht alle Unterverzeichnisse die temp enthalten
% Suche alle Unterverzeichnisse von sdir
% sdir          string Verzeichnis zum suchen
% subdirflag    0/1    Unterverzeichnisse suchen
% tdir          string Name des Unterverzeichnisses
% tdir_type     0: tdir muss exakt so heissen
%               1: tdir muss entahlten sein
% Ergebnis:
% c_dir         Verzeichnisliste cellarray
  c_dir = {};    
  len   = 0;
  if( iscell(sdir) )
      sdir = sdir{1};
  end
  if( ~exist('subdirflag','var') )
    subdirflag = 0;
  end
  if( ~exist('tdir','var') )
    use_tdir = 0;
    tdir     = '';
  else
    use_tdir = 1;
    tdir     = lower(tdir);
  end
  if( ~exist('tdir_type','var') )
    tdir_type = 0;
  end

  [c_dir,len] = suche_dir_sub(c_dir,len,sdir,subdirflag,use_tdir,tdir,tdir_type);
end
function  [c_dir,len] = suche_dir_sub(c_dir,len,sdir,subdirflag,use_tdir,tdir,tdir_type)
  liste = dir(sdir);
  for j=1:length(liste)    
    if( liste(j).isdir && ~strcmp(liste(j).name,'.') && ~strcmp(liste(j).name,'..'))
      if(  ~use_tdir ...
        || (use_tdir && ~tdir_type && strcmpi(lower(liste(j).name),tdir)) ...
        || (use_tdir && tdir_type && str_find_f(lower(liste(j).name),tdir)) ...
        )
        len        = len+1;
        c_dir{len} =  fullfile(sdir, liste(j).name);
      end
      if( subdirflag )
        [c_dir,len] = suche_dir_sub(c_dir,len,fullfile(sdir, liste(j).name),subdirflag,use_tdir,tdir,tdir_type);
      end
    end
  end
end


    

