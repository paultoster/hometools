function okay = e_data_print_signal_names_excel(e,excel_file_name, flagLetOpen)
%
% okay = e_data_print_signal_names_excel(e,excel_file_name)
% okay = e_data_print_signal_names_excel(e,excel_file_name, flagLetOpen)
%
  okay = 1;
  if( ~exist('e','var') )
    error(' Keinen Input' )
  end
  if( ~exist('excel_file_name','var') )
    excel_file_name = 'e_dat_excel_file';
  end
  if( ~exist('flagLetOpen','var') )
    flagLetOpen = 0;
  end
  

  
  % Datei öffnen
  %=============
  [okay,s_e] = ausgabe_excel('init','name',excel_file_name,'visible',1);
  if( ~okay )

    error('Datei <%s> konnte nicht erstellt werden',excel_file_name)
  end

  % Überschrift
  %============
  names = {'name','type','unit','lin','comment'};
  nnames = length(names);
  irow   = 1;
  for k=1:nnames

    [okay,s_e] = ausgabe_excel('val',s_e,'col',k,'row',irow,'val',names{k});
    if( ~okay )
        error('ausgabe_excel');
    end
  end

  c_names = fieldnames(e);
  
  for i=1:length(c_names)
    
    if( e_data_is_vecinvec(e,c_names{i}) )
      sig  = 1;
      type = 'vecvec';
    elseif( e_data_is_timevec(e,c_names{i}) )
      sig  = 1;
      type = 'timevec';
    elseif( e_data_is_param(e,c_names{i}) )
      sig  = 0;
      type = 'param';
    else
      type = 'timevec';
    end
    
    [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',irow+i,'val',c_names{i});
    [okay,s_e] = ausgabe_excel('val',s_e,'col',2,'row',irow+i,'val',type);
    [okay,s_e] = ausgabe_excel('val',s_e,'col',3,'row',irow+i,'val',e.(c_names{i}).unit);
    
    if( isfield(e.(c_names{i}),'lin') )
      [okay,s_e] = ausgabe_excel('val',s_e,'col',4,'row',irow+i,'val',e.(c_names{i}).lin);
    end
    if( isfield(e.(c_names{i}),'comment') )
      [okay,s_e] = ausgabe_excel('val',s_e,'col',5,'row',irow+i,'val',e.(c_names{i}).comment);
    end
      
  end
  
  [okay,s_e] = ausgabe_excel('format',s_e,'col',[1,5],'row',[1,irow+length(c_names)],'col_width','auto','row_height','auto');
  
  % Datei speichern
  %================
  if( okay )
    s_file = str_get_pfe_f(excel_file_name);
    if( isempty(s_file.dir) )
      s_file.dir = pwd;
    end
    % Datei speichern
    [okay,s_e] = ausgabe_excel('save',s_e,'name',s_file.body,'path',s_file.dir);
  end
  if( okay && ~flagLetOpen )
    [okay,s_e] = ausgabe_excel('close',s_e);
  end
  
end
