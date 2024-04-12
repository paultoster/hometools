function s = proto_buf_read_file(filename)
%
% s = proto_buf_read_file(filename)
% read protobuf-File
%
% s.comment{}       firts comments in file
% s.import{}        import files
% s.nmessage           numebr of messages
% s.message{i}.name    proto-buf name
% s.message{i}.nenum
% s.message{i}.enum{}
% s.message{i}.enum{i}.name
% s.message{i}.enum{i}.var{}.name
% s.message{i}.enum{i}.var{}.num
% s.message{i}.enum{i}.var{}.comment
% s.message{i}.nvar
% s.message{i}.var{}.name
% s.message{i}.var{}.type               'optional','repeated'
% s.message{i}.var{}.format             'double',...
% s.message{i}.var{}.num
% s.message{i}.var{}.commment
% s.message{i}.var{}.unit
% s.message{i}.var{}.default             decfault value
%
 
DEF_START_COMMENT1 = 1;
DEF_START_COMMENT2 = 2;
DEF_START_SYNTAX   = 3;
DEF_START_PACKAGE  = 4;
DEF_START_IMPORT   = 5;
DEF_START_MESSAGE  = 6;

csuch_start = {'//','/*','syntax','package','import','message'};

DEF_MESSAGE_COMMENT1 = 1;
DEF_MESSAGE_COMMENT2 = 2;
DEF_MESSAGE_ENUM     = 3;
DEF_MESSAGE_OPTIONAL = 4;
DEF_MESSAGE_REPEATED = 5;

csuch_message = {'//','/*','enum','optional','repeated'};

DEF_VAR_DEFAULT     = 1;
DEF_VAR_END         = 2;

csuch_var = {'[',';'};
 
s.comment   = {};
s.import    = {};
s.message   = {};

 
 STATUS_START            = 1;
 STATUS_START_COMMENT2   = 2;
 STATUS_MESSAGE          = 3;
 STATUS_MESSAGE_COMMENT2 = 4;
 STATUS_ENUM              = 5;
 STATUS_ENUMVAR           = 6;
 STATUS_FORMAT            = 7;
 STATUS_VARNAME           = 8;
 STATUS_VARNUM            = 9;
 STATUS_VARDEFAULT        = 10;
 STATUS_VARCOMMENT        = 11;
 
 [ okay,c,~ ] =  read_ascii_file(filename);
 
 if( ~okay )   
   error('read_ascii_file(%s)',filename);
 end
 
 status = STATUS_START;
 
 istr   = 1;
 ic     = 1;
 t      = c{ic};
 nstr   = length(t);
 
 while(istr <= nstr)
 
   
   switch(status)
     %---------------------------------------------------------------------
     %
     % STATUS_START
     %
     %---------------------------------------------------------------------
     case STATUS_START
       
       [istr,icsuch] = proto_buf_read_file_find_next_item(t,istr,csuch_start);
       
       if( ~istr )
         
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         
       %---------------------------------------------------------------------
       % DEF_START_COMMENT1
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_COMMENT1 )
         
         s.comment = cell_add(s.comment,t(istr:end));
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         
       %---------------------------------------------------------------------
       % DEF_START_COMMENT2
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_COMMENT2 )
         
         ifound = str_find_f(t(istr:end),'*/','vs'); 
         if( ~ifound ) % leer
           
           s.comment = cell_add(s.comment,t(istr:end));
           % next line
           [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
           % update status
           status = STATUS_START_COMMENT2;
           
         elseif( ifound+1 == nstr ) % ende
           
           s.comment = cell_add(s.comment,t(istr:end));
           % next line
           [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         else % mittel drinn
           
           s.comment = cell_add(s.comment,t(istr:ifound+1));
           % next string
           istr = ifound+2;
         end
         
       %---------------------------------------------------------------------
       % DEF_START_SYNTAX
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_SYNTAX )
         
         ifound = str_find_f(t(istr:end),';','vs');
         if( ~ifound )
           s.comment = cell_add(s.comment,t(istr:end));
         else
          s.comment = cell_add(s.comment,t(istr:ifound));
           % next string
           istr = ifound+1;
         end
         
       %---------------------------------------------------------------------
       % DEF_START_PACKAGE
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_PACKAGE )
         
         ifound = str_find_f(t(istr:end),';','vs');
         if( ~ifound )
           s.comment = cell_add(s.comment,t(istr:end));
         else
          s.comment = cell_add(s.comment,t(istr:ifound));
           % next string
           istr = ifound+1;
         end
         
       %---------------------------------------------------------------------
       % DEF_START_IMPORT
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_IMPORT )
         
         ifound = str_find_f(t(istr:end),';','vs');
         if( ~ifound )
           s.import = cell_add(s.import,t(istr:end));
         else
          s.import = cell_add(s.import,t(istr:ifound));
           % next string
           istr = ifound+1;
         end
         
       %---------------------------------------------------------------------
       % DEF_START_MESSAGE
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_START_MESSAGE )
         
         istr = istr + length(csuch_start{DEF_START_MESSAGE});
         
         [word,index] = str_find_next_item_f(t(istr:end),1,'v');
                  
         if( ~index )
           error('DEF_START_MESSAGE: next item nicht gefunden')
         else
          message.name  = word;
          message.enum  = {};
          message.nenum = 0;
          message.var   = {};
          message.nvar  = 0;
          s.message  = cell_add(s.message,message);
          s.nmessage = length(s.message);
          
          % next string
          istr = istr + index+ length(word);
          
          % find beginn '}'
          [jcell,jpos,~] = cell_find_nearest_from_ipos(c,ic,istr,{'{'},'for');
          
          if( jcell == 0 )
            
            error('message beginn konnte nicht gefunden werden')
          else
            t    = c{jcell};
            ic   = jcell;
            istr = jpos+1;
            nstr = length(t);
          end
          % update status
          status = STATUS_MESSAGE;
         end
         
       end
       
     %---------------------------------------------------------------------
     %
     % STATUS_START_COMMENT2
     %
     %---------------------------------------------------------------------
     case STATUS_START_COMMENT2
       
       ifound = str_find_f(t(istr:end),'*/','vs'); 

       if( ~ifound ) % leer
         if( ~isempty(t(istr:end)) )
           s.comment = cell_add(s.comment,t(istr:end));
         end
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         % update status
         status = STATUS_START_COMMENT2;

       elseif( ifound+1 == nstr ) % ende

         s.comment = cell_add(s.comment,t(istr:end));
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         % update status
         status = STATUS_START;
       else % mittel drinn

         s.comment = cell_add(s.comment,t(istr:ifound+1));
         % next string
         istr = ifound+2;
         % update status
         status = STATUS_START;
       end
       
     %---------------------------------------------------------------------
     %
     % STATUS_MESSAGE
     %
     %---------------------------------------------------------------------
     case STATUS_MESSAGE
       
       [istr,icsuch] = proto_buf_read_file_find_next_item(t,istr,csuch_message);
       
       if( ~istr )
         
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         
       %---------------------------------------------------------------------
       % DEF_MESSAGE_COMMENT1
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_MESSAGE_COMMENT1 )
         
         s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:end));
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         
       %---------------------------------------------------------------------
       % DEF_START_COMMENT2
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_MESSAGE_COMMENT2 )
         
         ifound = str_find_f(t(istr:end),'*/','vs'); 
         if( ~ifound ) % leer
                      
           s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:end));
           % next line
           [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
           % update status
           status = STATUS_MESSAGE_COMMENT2;
           
         elseif( ifound+1 == nstr ) % ende
           
           s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:end));
           % next line
           [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         else % mittel drinn
           
           s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:ifound+1));
           % next string
           istr = ifound+2;
         end
         
       %---------------------------------------------------------------------
       % DEF_MESSAGE_ENUM
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_MESSAGE_ENUM )
         
         istr = istr + length(csuch_message{DEF_MESSAGE_ENUM});
         
         [word,index] = str_find_next_item_f(t(istr:end),1,'v');
                  
         if( ~index )
           error('DEF_MESSAGE_ENUM: next item nicht gefunden')
         else
          enum.name = word;
          enum.var  = {};
          enum.nvar = 0;
          s.message{s.nmessage}.enum = cell_add(s.message{s.nmessage}.enum,enum);
          s.message{s.nmessage}.nenum  = length(s.message{s.nmessage}.enum);
          
          % next string
          istr = istr + index+ length(word);
          
          % find beginn '{'
          [jcell,jpos,~] = cell_find_nearest_from_ipos(c,ic,istr,{'{'},'for');
          
          if( jcell == 0 )
            
            error('enum beginn konnte nicht gefunden werden')
          else
            t    = c{jcell};
            ic   = jcell;
            istr = jpos+1;
            nstr = length(t);
          end
          % update status
          status = STATUS_ENUM;
         end
         
       %---------------------------------------------------------------------
       % DEF_MESSAGE_OPTIONAL
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_MESSAGE_OPTIONAL )

          var.name     = '';
          var.type     = 'optional';
          var.format   = '';
          var.num      = '';
          var.commment = '';
          var.unit     = '';
          var.default  = '';
          
          s.message{s.nmessage}.var  = cell_add(s.message{s.nmessage}.var,var);
          s.message{s.nmessage}.nvar = length(s.message{s.nmessage}.var);
          
          % next string
          istr = istr+ length(csuch_message{DEF_MESSAGE_OPTIONAL});
          % update status
          status = STATUS_FORMAT;

       %---------------------------------------------------------------------
       % DEF_MESSAGE_REPEATED
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_MESSAGE_REPEATED )
         

          var.name     = '';
          var.type     = 'repeated';
          var.format   = '';
          var.num      = '';
          var.commment = '';
          var.unit     = '';
          var.default  = '';
          
          s.message{s.nmessage}.var  = cell_add(s.message{s.nmessage}.var,var);
          s.message{s.nmessage}.nvar = length(s.message{s.nmessage}.var);
          
          % next string
          istr = istr+ length(csuch_message{DEF_MESSAGE_REPEATED});
          % update status
          status = STATUS_FORMAT;
        
       end % if ( icsuch )
       
     %---------------------------------------------------------------------
     %
     % STATUS_MESSAGE_COMMENT2
     %
     %---------------------------------------------------------------------
     case STATUS_MESSAGE_COMMENT2
       
       ifound = str_find_f(t(istr:end),'*/','vs'); 

       if( ~ifound ) % leer
         if( ~isempty(t(istr:end)) )           
           s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:end));
         end
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         % update status
         status = STATUS_MESSAGE_COMMENT2;

       elseif( ifound+1 == nstr ) % ende

         s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:end));
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         % update status
         status = STATUS_MESSAGE;
       else % mittel drinn

         s.message{s.nmessage}.comment = cell_add(s.message{s.nmessage}.comment,t(istr:ifound+1));
         % next string
         istr = ifound+2;
         % update status
         status = STATUS_MESSAGE;
       end
       
     %---------------------------------------------------------------------
     %
     % STATUS_ENUM
     %
     %---------------------------------------------------------------------
     case STATUS_ENUM
       
        % search '='       
       [istr,icsuch] = proto_buf_read_file_find_next_item(t,istr,{'//','}'});
       [word,index] = str_find_next_item_f(t(istr:end),1,'v');
       
       if( ~icsuch && ~index )
         
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
         
       elseif( ~icsuch )
         
         var.name    = word;
         var.num     = 0;
         var.comment = {};
         
         s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.var = cell_add(s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.var,var);
         s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.nvar = length(s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.var);
         
         % next string
         istr = str+index+length(word);

         % update status
         status = STATUS_ENUMVAR;
       else % icsuch
         
         if( icsuch == 1 )
           
           % next line
           [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
            
         else % icsuch == 2 ende
           
           % next string
           istr = istr + 1;
           
           % update status
           status = STATUS_MESSAGE;
         end
       end
     %---------------------------------------------------------------------
     %
     % STATUS_ENUMVAR
     %
     %---------------------------------------------------------------------
     case STATUS_ENUMVAR
              
       % search '='
       ifound = str_find_f(t(istr:end),'=','vs');
      
       if( ~ifound )
         
         % next line
         error('ENUMVAR: ''='' konnte nicht gefunden werden')
         
       else 
         
         istr = istr+ifound;
         
         [word,index] = str_find_next_item_f(t(istr:end),1,'v');
         
         % varname eintragen
         s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.var{s.message{s.nmessage}.enum{s.message{s.nmessage}.nenum}.nvar} = ...           
         	str2double(word);
        
         istr = istr+index;
        
         ifound = str_find_f(t(istr:end),';','vs');
           
         if( ~ifound )
           
           error('ENUMVAR: ende '';'' konnte nicht gefudnen werden')
            
         else
           % next string
           istr = istr + ifound;
          
           % update status
           status = STATUS_ENUM;
         end
       end       
       
     %---------------------------------------------------------------------
     %
     % STATUS_FORMAT
     %
     %---------------------------------------------------------------------
     case STATUS_FORMAT
       
       [word,index] = str_find_next_item_f(t(istr:end),1,'v');
  
       if( ~index )
         
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);  
         
       else 
         
         % format eintragen
         s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.format = word;
         
         % next string
         istr = istr + index+ length(word);
          
         % update status
         status = STATUS_VARNAME;
       end % if
       
     %---------------------------------------------------------------------
     %
     % STATUS_VARNAME
     %
     %---------------------------------------------------------------------
     case STATUS_VARNAME
       
       [word,index] = str_find_next_item_f(t(istr:end),1,'v');
  
       if( ~index )
         
         % next line
         [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);  
         
       else 
         
         % varname eintragen
         s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.name = word;
         
         % next string
         istr = istr + index+ length(word);
          
         % update status
         status = STATUS_VARNUM;
         
       end
       
     %---------------------------------------------------------------------
     %
     % STATUS_VARNUM
     %
     %---------------------------------------------------------------------
     case STATUS_VARNUM
       
       % search '='
       ifound = str_find_f(t(istr:end),'=','vs');
      
       if( ~ifound )
         
         % next line
         error(' ''='' konnte nicht gefunden werden')
         
       else 
         
         istr = istr+ifound;
         
         [word,index] = str_find_next_item_f(t(istr:end),1,'v');
         
         % varname eintragen
         s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.num = str2double(word);
         
         % next string
         istr = istr + index+ length(word);
          
         % update status
         status = STATUS_VARDEFAULT;
         
       end
       
       
     %---------------------------------------------------------------------
     %
     % STATUS_VARDEFAULT
     %
     %---------------------------------------------------------------------
     case STATUS_VARDEFAULT
       
       [istr,icsuch] = proto_buf_read_file_find_next_item(t,istr,csuch_var);
       
       if( ~icsuch )
         
       %---------------------------------------------------------------------
       % DEF_VAR_DEFAULT
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_VAR_DEFAULT )
         
         ifound = str_find_f(t(istr:end),']','vs');
         
         if( ~ifound )
           
           error('default ende '']'' konnte nicht gefudnen werden')
           
         else
           
           tt = t(istr:istr+ifound-1);
           
           ctt = str_split(tt,'=');
           
           if( length(ctt) < 2 )
             
             error('kein default gefunden')
           else
             s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.default = str_cut_ae_wspace(ctt{2});
           end
           
           istr = istr+ifound;
           ifound = str_find_f(t(istr:end),';','vs');
           
           if( ~ifound )
           
            error('ende '';'' konnte nicht gefudnen werden')
            
           else
              % next string
              istr = istr + ifound;
          
              % update status
              status = STATUS_VARCOMMENT;
           end
                     
         end
         
         
       %---------------------------------------------------------------------
       % DEF_VAR_END
       %---------------------------------------------------------------------
       elseif( icsuch == DEF_VAR_END )
          
         % next string
         istr = istr + 1;
          
         % update status
         status = STATUS_VARCOMMENT;
                
       end
       
     %---------------------------------------------------------------------
     %
     % STATUS_VARCOMMENT
     %
     %---------------------------------------------------------------------
     case STATUS_VARCOMMENT
       
       ifound = str_find_f(t(istr:end),'//','vs');
       
       if( ~ifound )
         
         % update status
         status = STATUS_MESSAGE;
         
       else
         
         tt = t(istr+ifound-1:end);
         ctt = str_get_quot_f(tt,'[',']','i');
         
         if( ~isempty(ctt) )
          s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.unit = str_cut_ae_wspace(ctt{1});
         end
         
         s.message{s.nmessage}.var{s.message{s.nmessage}.nvar}.comment = str_cut_ae_f(tt,'/');
         
         % update status
         status = STATUS_VARCOMMENT;
       end
   end % end switch
       
   if( istr > nstr )
     % next line
     [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic);
   end
   
 end % end while
end
function [istr,icsuch] = proto_buf_read_file_find_next_item(t,i0,csuch_start)
%
% search from t(i0:end) next item
%
  t = t(i0:end);
  [istr,icsuch] = str_find_multiple_search_text(t,csuch_start,'first');
  
  if( istr )
    istr = istr - 1 + i0;
  end
end
function [t,ic,istr,nstr] = proto_buf_read_file_find_next_line(c,ic)

  if( ic < length(c) )
    ic   = ic + 1;
    t    = c{ic};
    istr = 1;
    nstr = length(t);
  else
    ic   = length(c) + 1;
    t    = '';
    istr = 0;
    nstr = 0;
  end
    
end