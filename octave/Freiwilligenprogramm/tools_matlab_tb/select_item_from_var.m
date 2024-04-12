function [select_cell,select_names,okay,back] = select_item_from_var(var,var_name,back_flag,promptstring,single_flag,listsize,no_char_flag);
%
% [select_cell,okay] = select_item_from_var(var,[promptstring],[single_flag],[listsize],[no_char_flag]);
%
% Auswahl aus der variable var machen, wenn var eine Struktur oder
% cellarray Listdialog wird verwendet
%
% var           struct,cell         Inputstruktur oder cellarray
% var_name      char                Name der variable
% back_flag     double              1: Es eine '..' zur Auswahlgestellt, um
%                                      ein Wieder zurück auswählen zu
%                                      können
% promptstring  char                Ausgabe text
% single_flag   double              1:  Einzelwert auswählen, 0: multi
% listsize      [double,double]     Fenstergröße [width height]
%
% select_cell    cell               ausgewähltes Ergebnis in cellarray, wegen multi
% select_names   cell               ausgewählte  Namen in cellarray, wegen multi
% okay          double              Wenn nicht abgebrochen == 1
% back          double              wenn back_flag gesetzt kann man in der
%                                   Hierachie zurückgehen = 1
%

select_cell = {};
select_names = {};
okay = 0;
back = 0;

if( ~exist('promptstring','var') | ~ischar(promptstring) )
    
    promptstring = 'Wähle Element aus';
end
if( ~exist('single_flag','var') | ~isnumeric(single_flag) )
    
    single_flag = 1;
else
    single_flag = single_flag(1);
end
if( single_flag )
    single_flag = 'single';
else
    single_flag = 'multiple';
end
if( ~exist('listsize','var') | ~isnumeric(listsize) | (length(listsize) ~= 2) )
    
    listsize = [300,300];
    
end
if( ~exist('no_char_flag','var') | ~isnumeric(no_char_flag)  )
    
    no_char_flag = 0;
else
    no_char_flag = no_char_flag(1);
end
%=======================================================================
c_names = {};

if( isstruct(var) & length(var) > 1 ) % Strukturvektor auswerten
    
    if( back_flag )
        c_names{1} = '..';
    end
    for i=1:length(var)
    
        c_names{length(c_names)+1} = [var_name,'(',num2str(i),')','(struct)'];
    end
    
    [select,okay] = listdlg('PromptString',  promptstring ...
                           ,'SelectionMode', single_flag ... 
                           ,'ListSize',      listsize ...
                           ,'ListString',    c_names ...
                           );
    if( okay )
        if( back_flag )
            if( min(select) == 1 )
                back = 1; % Es soll zurückgesprungen werden
            else
                
                for i=1:length(select)
                    select_cell{length(select_cell)+1}   = var(select(i)-1);
                    select_names{length(select_names)+1} = [var_name,'(',num2str(select(i)-1),')'];
                end
            end
        else
            for i=1:length(select)
                select_cell{length(select_cell)+1}   = var(select(i));
                select_names{length(select_names)+1} = [var_name,'(',num2str(select(i)),')'];
            end
        end

    end
    
elseif( isstruct(var) ) % Struktur auswerten
    
    f_names = fieldnames(var);
    
    c_names = {};

    if( back_flag )
        c_names{1} = '..';
    end
    
    for i=1:length(f_names)
        
        if( ischar(var.(f_names{i})) & ~no_char_flag )
            
            c_names{length(c_names)+1} = [var_name,'.',f_names{i},'(char)'];
        
        elseif( isnumeric(var.(f_names{i})) )
            
            [n,m] = size(var.(f_names{i}));
            c_names{length(c_names)+1} = [var_name,'.',f_names{i},'(double ',num2str(n),'x',num2str(m),')'];
            
        elseif( isstruct(var.(f_names{i})) )
 
            c_names{length(c_names)+1} = [var_name,'.',f_names{i},'(struct)'];
        
        elseif( iscell(var.(f_names{i})) )
            
            c_names{length(c_names)+1} = [var_name,'.',f_names{i},'(cell)'];
        end
    end
        
    [select,okay] = listdlg('PromptString',  promptstring ...
                           ,'SelectionMode', single_flag ... 
                           ,'ListSize',      listsize ...
                           ,'ListString',    c_names ...
                           );
    if( okay )
        
        if( back_flag )
            if( min(select) == 1 )
                back = 1; % Es soll zurückgesprungen werden
            else
                
                for i=1:length(select)
                    select_cell{length(select_cell)+1}   = var.(f_names{select(i)-1});
                    select_names{length(select_names)+1} = [var_name,'.',f_names{select(i)-1}];
                end
            end
        else
            for i=1:length(select)
                select_cell{length(select_cell)+1}   = var.(f_names{select(i)});
                select_names{length(select_names)+1} = [var_name,'.',f_names{select(i)}];
            end
        end

    end

elseif( iscell(var) ) % cellarray auswerten
    
    c_names = {};

    if( back_flag )
        c_names{1} = '..';
    end
    
    for i=1:length(var)
        
        if( ischar(var{i}) & ~no_char_flag )
            
            c_names{length(c_names)+1} = [var_name,'{',num2str(i),'}','(char)'];
        
        elseif( isnumeric(var{i}) )
            
            [n,m] = size(var{i});
            c_names{length(c_names)+1} = [var_name,'{',num2str(i),'}','(double ',num2str(n),'x',num2str(m),')'];
            
        elseif( isstruct(var{i}) )
 
            c_names{length(c_names)+1} = [var_name,'{',num2str(i),'}','(struct)'];
        
        elseif( iscell(var{i}) )
            
            c_names{length(c_names)+1} = [var_name,'{',num2str(i),'}','(cell)'];
        end
    end
        
    [select,okay] = listdlg('PromptString',  promptstring ...
                           ,'SelectionMode', single_flag ... 
                           ,'ListSize',      listsize ...
                           ,'ListString',    c_names ...
                           );
    if( okay )
        if( back_flag )
            if( min(select) == 1 )
                back = 1; % Es soll zurückgesprungen werden
            else
                
                for i=1:length(select)
                    select_cell{length(select_cell)+1}   = var{select(i)-1};
                    select_names{length(select_names)+1} = [var_name,'{',num2str(select(i)-1),'}'];
                end
            end
        else
            for i=1:length(select)
                select_cell{length(select_cell)+1}   = var{select(i)};
                select_names{length(select_names)+1} = [var_name,'{',num2str(select(i)),'}'];
            end
        end

    end

else
    
    error(sprintf('Diese Variablen typ <%s> wird nicht bearbeitet !!!',class(var)));
end