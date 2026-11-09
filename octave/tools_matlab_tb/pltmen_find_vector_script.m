%        pltmen_find_vector_script
%        finds Vector from the workspace
%        input : pltmen_none_possible     = 0 none selsction not posible
%                                         = 1 possible
%        output : pltmen_vector_name      Name of Vector or 'none'

       
pltmen_whos = whos;
pltmen_list = {};
pltmen_ilist = 0;
   
if(  exist('pltmen_none_possible','var') ...
  & pltmen_none_possible == 1 ...
  )
    pltmen_ilist = pltmen_ilist+1;
    pltmen_name=sprintf('(none  )');
    pltmen_list{pltmen_ilist}=pltmen_name;
end

for pltmen_fvs_i=1:length(pltmen_whos)
      
    pltmen_n=min(length(pltmen_whos(pltmen_fvs_i).name),7);
    if ~strcmp('pltmen_',pltmen_whos(pltmen_fvs_i).name(1:pltmen_n))
       
      
        if strcmp(pltmen_whos(pltmen_fvs_i).class,'double')         
            
            pltmen_ilist = pltmen_ilist+1;
            pltmen_name=sprintf('(double) %s',pltmen_whos(pltmen_fvs_i).name);
            pltmen_list{pltmen_ilist}=pltmen_name;
            
        elseif strcmp(pltmen_whos(pltmen_fvs_i).class,'struct')
            
            pltmen_ilist = pltmen_ilist+1;
            pltmen_name=sprintf('(struct) %s',pltmen_whos(pltmen_fvs_i).name);
            pltmen_list{pltmen_ilist}=pltmen_name;
           
        elseif strcmp(pltmen_whos(pltmen_fvs_i).class,'cell')
            
            pltmen_ilist = pltmen_ilist+1;
            pltmen_name=sprintf('(cell  ) %s',pltmen_whos(pltmen_fvs_i).name);
            pltmen_list{pltmen_ilist}=pltmen_name;
           
        end         
    end      
end
   
[pltmen_select,pltmen_okay] = listdlg('PromptString',pltmen_title,...
                                      'SelectionMode','single', ... 
                                      'ListSize',[300,300],...
                                     'ListString',pltmen_list);
if ~pltmen_okay
    fprintf('??? listdlg workspace was not okay');
else
           
    pltmen_vector_name = pltmen_list{pltmen_select};
    
    if( strcmp(pltmen_vector_name(2:5),'none') )
        pltmen_vector_name = 'none';
    else
        pltmen_vector_name = pltmen_vector_name(10:length(pltmen_vector_name));
        pltmen_command = sprintf('[pltmen_vector_name,pltmen_okay] = pltmen_find_vector_function(%s,pltmen_vector_name,pltmen_title);', ...
                             pltmen_vector_name);
        eval(char(pltmen_command));
    end
    
    if( ~pltmen_okay )
         fprintf('??? pltmen_find_vector_function workspace was not okay');
    end
                   
            
end

