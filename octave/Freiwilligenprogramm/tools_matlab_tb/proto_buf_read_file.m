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
 
 [ okay,in.c,~ ] =  read_ascii_file(filename);
 
 if( ~okay )   
   error('read_ascii_file(%s)',filename);
 end
 
 
 in = proto_buf_read_file_extract_comment_text(in);
 
 
 
end
function in = proto_buf_read_file_extract_comment_text(in)
%
% extract Comment and text and substitude with letter like 
% @#i Comment i=1,2,3,4
% @*i Text i=1,2,3,4
%
% in.comment = {comment1,comment2,...}
% in.ncomment
% in.text    = {text1,text2, ...}
% in.ntext
% in.comsign
% in.textsign
 
 DEF_COMMENT1 = 1;
 DEF_COMMENT2 = 2;
 % DEF_TEXT     = 3;
 
 csuch = {'//','/*','"'};
 
 in.STATUS_SEARCH          = 0;
 in.STATUS_SEARCH_COMMENT2 = 1;
 in.STATUS_SEARCH_TEXT     = 2;
 
 in.status = in.STATUS_SEARCH;
 
 %-------------------------------------------------------------------------
 % check comment sign
 %------------------------------------------------------------------------- 
 comsign = '@#';
 while(1)
   
  if( isempty(cell_find_f(in.c,comsign,'n')) )
    break;
  else
    comsign = sprintf('%s%s',comsign,'#');
    
  end
 end
 in.comsign = comsign;
 
 %-------------------------------------------------------------------------
 % check text sign
 %------------------------------------------------------------------------- 
 textsign = '@*';
 while(1)
   
  if( isempty(cell_find_f(in.c,textsign,'n')) )
    break;
  else
    textsign = sprintf('%s%s',textsign,'*');
  end
 end
 in.textsign = textsign;
 
 in.comment  = {};
 in.ncomment = 0;
 in.text     = {};
 in.ntext    = 0;

 in = proto_buf_read_file_find_init_line_counter(in);
 
 %-------------------------------------------------------------------------
 % while loop to detect Comment1,Comment2,Text
 %------------------------------------------------------------------------- 

 while( (in.istr <= in.nstr) && (in.ic <= in.nc) )
   
%    in.t
%    in.istr
   
  [istr,icsuch] = proto_buf_read_file_find_next_item(in.t,in.istr,csuch);

  if( istr == 0 )

    % switch next line
    in = proto_buf_read_file_find_next_line(in);

  %---------------------------------------------------------------------
  % DEF_COMMENT1
  %---------------------------------------------------------------------
  elseif( icsuch == DEF_COMMENT1 )

     in.istr = in.istr + istr + 1;
     % store comment
     if( length(in.t) >= in.istr+2)
      in.comment  = cell_add(in.comment,in.t(in.istr:end));
      in.ncomment = length(in.comment);
     end

     % reset comment
     tt = [in.comsign,num2str(in.ncomment,'%5.5i')];

     if( in.istr > 3 )
       tt = sprintf('%s%s',in.t(1:in.istr-3),tt);
     end

     %substitute line
     in = proto_buf_read_file_subst_line(in,tt);

     % next line
     in = proto_buf_read_file_find_next_line(in);                  

  %---------------------------------------------------------------------
  % DEF_COMMENT2
  %---------------------------------------------------------------------
  elseif( icsuch == DEF_COMMENT2 )
    
    in.istr = in.istr + istr + 1;
    in = proto_buf_read_file_find_check_line_counter(in);
   
    in.status = in.STATUS_SEARCH_COMMENT2;
    
    [in] = proto_buf_read_file_extract_comment_text_comment2(in);

  %---------------------------------------------------------------------
  % DEF_TEXT
  %---------------------------------------------------------------------
  else
    in.istr = in.istr + istr;
    in = proto_buf_read_file_find_check_line_counter(in);
    
    in.status = in.STATUS_SEARCH_TEXT;
    
    [in] = proto_buf_read_file_extract_comment_text_text(in);
                  
  end
  if( in.istr > in.nstr )
     % next line
     in = proto_buf_read_file_find_next_line(in);
  end

 end
 
 if( in.status == in.STATUS_SEARCH_COMMENT2 )
   error('Could not find end sign for comment ''*/''')
 elseif(in.status == in.STATUS_SEARCH_TEXT )
   error('Could not find end sign for text ''"''')
 end
end
function [in] = proto_buf_read_file_extract_comment_text_comment2(in)

  comment = '';
  ic0     = in.ic;
  istr0   = in.istr;
  while(1)

  ifound = str_find_f(in.t(in.istr:end),'*/','vs'); 

  if( ~ifound ) % leer

   % add comment
   if( isempty(comment) )
     comment = in.t(in.istr:end);
   else
    comment = sprintf('%s\n%s',comment,in.t(in.istr:end));
   end
   % next line
   in = proto_buf_read_file_find_next_line(in);



  else % gefunden
    
   in.status = in.STATUS_SEARCH;

   % add comment
   if( ifound > 1 )
     comm = in.t(in.istr:in.istr+ifound-2);
   else
     comm = '';
   end
   if( ~isempty(comment) )
     comment = sprintf('%s\n%s',comment,comm);           
   else
     comment = comm;
   end
   
   % store comment
   in.comment  = cell_add(in.comment,comment);
   in.ncomment = length(in.comment);

   % reset comment
   tt = [in.comsign,num2str(in.ncomment,'%5.5i')];

    if( in.ic ~= ic0 )

      ic1 = in.ic;
      if( ifound+2 <= in.nstr )
        ttrest = in.t(ifound+2:end);
      else
        ttrest = '';
      end
      
      % set position
      in = proto_buf_read_file_set_line(in,ic0,istr0);

      if( istr0 > 3 )
        tt = sprintf('%s%s',in.t(1:istr0-3),tt);
      end

      
      tt = sprintf('%s%s',tt,ttrest);
      

      %substitute line
      in = proto_buf_read_file_subst_line(in,tt);
      % delete lines
      in = proto_buf_read_file_delete_lines(in,ic0+1,ic1);
    else


      if( istr0 > 3 )
        tt = sprintf('%s%s',in.t(1:istr0-3),tt);
      end

      if( in.istr+ifound+1 <= in.nstr )
        ttt = sprintf('%s%s',tt,in.t(in.istr+ifound+1:in.nstr));
      else
        ttt = tt;
      end

      %substitute line
      in = proto_buf_read_file_subst_line(in,ttt);

      % next string
      ifound = str_find_f(in.t,tt,'vs');
      in.istr = ifound+length(tt);
    end

    % ende
    break;
   end
  end
end
function [in] = proto_buf_read_file_extract_comment_text_text(in)

  ttext   = '';
  ic0     = in.ic;
  istr0   = in.istr;

  while(1)

  ifound = str_find_f(in.t(in.istr:end),'"','vs'); 

  if( ~ifound ) % leer

   % add comment
   ttext = sprintf('%s\n%s',ttext,in.t(in.istr:end));
   % next line
   in = proto_buf_read_file_find_next_line(in);

  else % gefunden

   in.status = in.STATUS_SEARCH;
    
   % add text
   if( ~isempty(ttext) )     
     ttext = sprintf('%s\n%s',ttext,in.t(in.istr:in.istr+ifound-2));   
   else
     ttext = in.t(in.istr:in.istr+ifound-2);
   end
   % store text
   in.text  = cell_add(in.text,ttext);
   in.ntext = length(in.text);

   % reset comment
   tt = [in.textsign,num2str(in.ntext,'%5.5i')];

   if( in.ic ~= ic0 )

      ic1 = in.ic;
      % set position
      in = proto_buf_read_file_set_line(in,ic0,istr0);

      if( in.istr > 1 )
        tt = sprintf('%s%s',in.t(1:in.istr-1),tt);
      end

      if( ifound < in.nstr )
        tt = sprintf('%s%s',tt,in.t(ifound+1:end));
      end

      %substitute line
      in = proto_buf_read_file_subst_line(in,tt);
      % delete lines
      in = proto_buf_read_file_delete_lines(in,ic0+1,ic1);
    else


      if( istr0 > 2 )
        tt = sprintf('%s%s',in.t(1:istr0-2),tt);
      end

      if( in.istr+ifound <= in.nstr )
        ttt = sprintf('%s%s',tt,in.t(in.istr+ifound:in.nstr));
      else
        ttt = tt;
      end

      %substitute line
      in = proto_buf_read_file_subst_line(in,ttt);

      % next string
      ifound = str_find_f(in.t,tt,'vs');
      in.istr = ifound+length(tt);
    end

    % ende
    break;
   end
  end
end
function in = proto_buf_read_file_find_init_line_counter(in)
 in.istr   = 1;
 in.ic     = 1;
 in.nc     = length(in.c);
 in.t      = in.c{in.ic};
 in.nstr   = length(in.t);
end    
function in = proto_buf_read_file_find_check_line_counter(in)
 if( in.istr   > in.nstr)
   in = proto_buf_read_file_find_next_line(in);
 end
end
function in = proto_buf_read_file_find_next_line(in)

  in.nc = length(in.c);
  flag = 0;
  while( ~flag )
  
    if( in.ic < in.nc )
      in.ic   = in.ic + 1;
      in.t    = in.c{in.ic};
      in.istr = 1;
      in.nstr = length(in.t);
      flag = in.nstr;
    else
      in.ic   = in.nc + 1;
      in.t    = '';
      in.istr = 0;
      in.nstr = 0;
      break;
    end
  end
  
  
end
function in = proto_buf_read_file_subst_line(in,tt)
  in.c{in.ic} = tt;
  in.istr     = 1;
  in.nc       = length(in.c);
  in.t        = in.c{in.ic};
  in.nstr     = length(in.t);
end 
function in = proto_buf_read_file_delete_lines(in,ic0,ic1)
% delete lines
 
  in.c  = cell_cut(in.c,ic0,ic1);
  in.nc  = length(in.c);
  if( in.ic >= ic1 )
    in.ic       = in.ic - (ic1-ic0+1);
  elseif( in.ic >= ic0 )
    in.ic       = ic0;
    in.istr     = 1;
    in.t        = in.c{in.ic};
    in.nstr     = length(in.t);
  end
    
end
function in = proto_buf_read_file_set_line(in,ic,istr)

  in.ic   = ic;
  in.istr = istr;
  if( in.nc >= in.ic )
    in.t    = in.c{in.ic};
    in.nstr = length(in.t);
  end
  in = proto_buf_read_file_find_check_line_counter(in);
  
  
end

function [istr,icsuch] = proto_buf_read_file_find_next_item(t,i0,csuch_start)
%
% search from t(i0:end) next item
%
try
  t = t(i0:end);
  
catch
  t = '';
  
end
  [istr,icsuch] = str_find_multiple_search_text(t,csuch_start,'first');
  
  if( istr )
    istr = istr - 1 + i0;
  end

end


