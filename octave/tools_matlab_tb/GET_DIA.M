% Einlesen der Dia_daten und Zuweisen der Namen
%function [ ] = get_dia (filename, dataSelectNr, selectedChannels)
if exist ('dataSelectNr') == 0
  dataSelectNr = 1;
end
%{{{  selection of channel is not implemented
%if exist ('selectedChannels') == 0,
  selectedChannels = '';
% end
%}}}  

if exist (filename) ~= 2,
  sprintf('*** No File %s found ! ***',filename)
  return
end

%----- read file and create matlab variables
[var, names, lengths, dims, coms] = diaload(filename, dataSelectNr, selectedChannels);
if exist('var') == 1 
   var_size = size(var);
   for i=1:var_size(1) 
     varname = names(i,:);
     if exist(varname)
        disp (['warning:  ',varname,' already used as var,m-file,build in, etc.']) 
     end
     if exist(varname,'var') %this var already exists, cut extension from the filename
	    file=strtok(filename,'.');
	    varname=sprintf('%s_%s',varname,file);
     end   
     string=sprintf(' %s = var(i,:);',varname);
     eval(string);
   end
end
%}}}
%special for SWT Daten
if(exist('Timer_1_1')==1), Timer_1=Timer_1_1; clear Timer_1_1, end
if(exist('Timer_1')==1), disp(['Messzeit:  ', num2str(Timer_1(length(Timer_1))),' s' ]), end

%clear i var names lengths dims coms var_size varname string filename file dataSelectNr selectedChannels 
clear i var names lengths dims coms var_size varname string file dataSelectNr selectedChannels 
