function [okay,errtext,tt] = rtas_build_io_input_single(type,nspace,input,ivar)
  tt = '';
  okay = 1;
  errtext = '';

  switch(type)
    case 'h'   % Header
      for i=1:nspace
        tt = [tt,' '];
      end
      defname = upper([input.cstructname,'_',input.var(ivar).cname]);
      t1 = sprintf('#define %s %s\n' ...
         , defname ...
         , num2str(input.var(ivar).length) ...
         );
      tt = [tt,t1];
      for i=1:nspace
        tt = [tt,' '];
      end
      t1 = sprintf('%s %s; /* #RTAS: ''%s.%s'': [i: on, n: %s ] */\n' ...
         , 'int' ...
         , [input.var(ivar).cname,'_mBufferCnt'] ...
         , input.cstructname ...
         , [input.var(ivar).cname,'_mBufferCnt'] ...
         , [input.var(ivar).name,'_mBufferCnt'] ...
         );
      tt = [tt,t1,'\n'];
   
      for ivec = 1:length(input.var(ivar).vecnames)
        
        for i=1:nspace
          tt = [tt,' '];
        end
        vecname = [input.var(ivar).cname,'_',input.var(ivar).vecnames{ivec}];
        t1 = sprintf('%s %s[%s]; /* #RTAS: \n' ...
           , input.var(ivar).cformat ...
           , vecname ...
           , defname ...
           );
        tt = [tt,t1];
        for isig = 1:input.var(ivar).length
          for i=1:nspace
            tt = [tt,' '];
          end
          rtasname = [input.var(ivar).name,'_mBuffer_',num2str(isig-1),'_',input.var(ivar).vecnames{ivec}];
          t1 = sprintf('                             ''%s.%s[%s]'': [i: on, n: %s' ...
             , input.cstructname ...
             , vecname ...
             , num2str(isig-1) ...
             , rtasname ...
             );
          if( isig < input.var(ivar).length )
            t1 = sprintf('%s ],\n',t1);
          else
            t1 = sprintf('%s ] */\n',t1);
          end
          tt = [tt,t1];
        end
        t2 = sprintf('	                                             /* %s       %s */\n' ...
           , input.var(ivar).cunit{ivec} ...
           , input.var(ivar).comment ...
           );
        tt = [tt,t2];
      end
    case 'u'   % unitconvert

      mCntName = [input.var(ivar).cname,'_mBufferCnt'];
      for ivec = 1:length(input.var(ivar).vecnames)
      
        [fac,offset] = get_unit_convert_fac_offset(input.var(ivar).unit{ivec} ,input.var(ivar).cunit{ivec});
        if( (fac ~= 1.0)  || (offset ~= 0.0) )
          
          for i=1:nspace
            tt = [tt,' '];
          end
          t1 = sprintf('for(i=0;i<%s;i++)\n', mCntName );
          tt = [tt,t1]
          for i=1:nspace
            tt = [tt,' '];
          end
          t1 = sprintf('{\n', mCntName );
          tt = [tt,t1]
          for i=1:nspace+2
            tt = [tt,' '];
          end
          
          t1 = sprintf('%s.%s[i] = %s.%s[i] * %ff + %ff;\n' ...
             , input.cstructname ...
             , input.var(ivar).cname ...
             , input.cstructname ...
             , input.var(ivar).cname ...
             , fac ...
             , offset ...
             );
          tt = [tt,t1];
          for i=1:nspace
            tt = [tt,' '];
          end
          t1 = sprintf('}\n', mCntName );
          tt = [tt,t1];
        end
      end
  end
end    