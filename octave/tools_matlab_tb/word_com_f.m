function [okay,Word]=word_com_f(type,varargin)
%
% Kommunikation zu Word
%
% [okay,Word] = word_com_f('open','name',filename,['font_name','Courier New'],['font_size',10],['visible',1]);
% [okay,Word] = word_com_f('close',Word);
% [okay,Word] = word_com_f('line',Word,'trallala');
% [okay,Word] = word_com_f('figure',Word,handle);
% [okay,Word] = word_com_f('newpage',Word);
% [okay,Word] = word_com_f('newline',Word);
% [okay,Word] = word_com_f('landscape',Word);
% [okay,Word] = word_com_f('portrait',Word);
% [okay,Word] = word_com_f('table',Word,'tablearray',cellaaray{n,m});

char_new_line = char(13);
char_new_page = char(12);

okay = 1;
%=============
% Datei öffnen
%=============
type = lower(type);
if( strcmp(type,'open') )
    
    filename  = '';
    font_name = 'Courier New';
    font_size = 10;
    visible   = 1;
    i = 1;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'name'
                filename = varargin{i+1};
            case 'font_name'
                font_name = varargin{i+1};
            case 'font_size'
                font_size = varargin{i+1};
            case 'visible'
                visible = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                error(tdum)
                
        end
        i = i+2;
    end
    
    % Worddatei öffnen
    Word = actxserver('Word.Application'); 

    if( visible )
        Word.Visible = 1; 
    end
    Word.Document.Add;

    Word.ActiveDocument.Content.Font.Name = font_name;
    Word.ActiveDocument.Content.Font.Size = font_size;
    if( ~isempty(filename) )
        
        s_file = str_get_pfe_f(filename);
        if( isempty(s_file.dir) )
            s_file.dir = pwd;
        end
        Word.ActiveDocument.SaveAs(fullfile(s_file.dir,s_file.name),0);
    end
%=================
% Datei schliessen
%=================
elseif( strcmp(type,'close') || strcmp(type,'save')  )
    
    Word = varargin{1};

    filename  = ''; %fullfile(pwd,'erg.doc');
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'name'
                filename = varargin{i+1};
            otherwise
                 error('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                
        end
        i = i+2;
    end
    if( strcmp(class(Word),'COM.Word_Application') )
        if( ~isempty(filename) )
            s_file = str_get_pfe_f(filename);
            if( isempty(s_file.dir) )
                s_file.dir = pwd;
            end
            fname = fullfile(s_file.dir,s_file.name);
            Word.ActiveDocument.SaveAs(fname,0);
        end
        name = Word.ActiveDocument.FullName;
        if( ~isempty(name) )
            Word.ActiveDocument.Save;
        end
        if( strcmp(type,'close') )
            Word.ActiveDocument.Close;
            Word.Quit;
            delete(Word);
            Word = 0;
        end
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word))
        error(tdum)
    end

%=================
% Zeile ausgeben
%=================
elseif( strcmp(type,'line') )
    Word = varargin{1};
    text = varargin{2};
    if( ~strcmp(class(text),'char') )
        tdum = sprintf('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text))
        error(tdum)
    end
    if( strcmp(class(Word),'COM.Word_Application') )
        i_end = Word.ActiveDocument.content.end;
        Word.Application.Selection.Start = i_end;
        Word.ActiveDocument.Content.InsertAfter(text)

        i_end = Word.ActiveDocument.Content.End;
        Word.Application.Selection.Start = i_end;
        Word.ActiveDocument.Content.InsertAfter(char_new_line);
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word))
        error(tdum)
    end
%=================
% Figure/Plot ausgeben
%=================
elseif( strcmp(type,'figure') )
    Word   = varargin{1};
    handle = varargin{2};
    if( strcmp(class(Word),'COM.Word_Application') )
        
        print(handle,'-dmeta');
        print(handle,'-dmeta');
        
%          i_end = Word.ActiveDocument.Content.End;
%          Word.Application.Selection.End = i_end;
%          Word.ActiveDocument.Content.InsertAfter(char_new_line);
         i_end = Word.ActiveDocument.Content.End;
         Word.Application.Selection.Start = i_end;
         Word.Application.Selection.End = i_end;
         Word.Application.Selection.Paste;
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word))
        error(tdum)
    end
% [okay,Word] = word_com_f('figure',Word,handle);
%=================
% neue Zeile
%=================
elseif( strcmp(type,'newline') )
    Word = varargin{1};
    if( strcmp(class(Word),'COM.Word_Application') )
        i_end = Word.ActiveDocument.Content.End;
        Word.Application.Selection.Start = i_end;
        Word.ActiveDocument.Content.InsertAfter(char_new_line);
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word));
        error(tdum)
    end
%=================
% neue Seite
%=================
elseif( strcmp(type,'newpage') )
    Word = varargin{1};
    if( strcmp(class(Word),'COM.Word_Application') )
        i_end = Word.ActiveDocument.Content.End;
        Word.Application.Selection.Start = i_end;
        Word.ActiveDocument.Content.InsertAfter(char_new_page);
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word));
        error(tdum)
    end
%=================
% Querformat
%=================
elseif( strcmp(type,'landscape') )
    Word = varargin{1};
    if( strcmp(class(Word),'COM.Word_Application') )
        
        Word.ActiveDocument.PageSetup.Orientation = 'wdOrientLandscape';
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word));
        error(tdum)
    end
    
%=================
% Hochformat
%=================
elseif( strcmp(type,'portrait') )
    Word = varargin{1};
    if( strcmp(class(Word),'COM.Word_Application') )
        
        Word.ActiveDocument.PageSetup.Orientation = 'wdOrientPortrait';
    else
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word));
        error(tdum)
    end
    
% [okay,Word] = word_com_f('table',Word,'tabarray',cellarray{n,m});
%=================
% Table
%=================
elseif( strcmp(type,'table') )
   Word = varargin{1};
   tabarray  = {}; %fullfile(pwd,'erg.doc');
   i = 2;
   while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'tablearray'
                tabarray = varargin{i+1};
            otherwise
                 error('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)                
        end
        i = i+2;
   end
   
   if( isempty(tabarray) )
     error('%s: tablearray is empty !!!',mfilename);
   end
   if( ~iscell(tabarray) )
     error('%s: tablearray is not cellarray !!!',mfilename);
   end
   
   [nrow,ncol]=size(tabarray);
    if( ~strcmp(class(Word),'COM.Word_Application') )
        tdum = sprintf('%s: type = <%s>, Word ist kein Klasse COM.Word_Application, sondern <%s>!!!',mfilename,type,class(Word));
        error(tdum);
    end
   % Word.Application.Selection.TypeParagraph        
   Word.ActiveDocument.Tables.Add(Word.Application.Selection.Range,nrow,ncol,1,1);
   
   
    for r=1:nrow
        for c=1:ncol
            %write data into current cell
            Word.Application.Selection.TypeText(tabarray{r,c});            
            if(r*c==nrow*ncol)
                %we are done, leave the table
                Word.Application.Selection.MoveDown;
            else%move on to next cell 
                Word.Application.Selection.MoveRight;
            end            
        end
    end
   
end    
