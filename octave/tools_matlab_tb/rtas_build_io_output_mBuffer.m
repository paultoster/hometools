function [okay,errtext,tt] = rtas_build_io_output_mBuffer(type,nspace,output,ivar)
  tt = '';
  okay = 1;
  errtext = '';

  switch(type)
    case 'h'   % Header
      for i=1:nspace
        tt = [tt,' '];
      end
      defname = upper([output.cstructname,'_',output.var(ivar).cname]);
      t1 = sprintf('#define %s %s\n' ...
         , defname ...
         , num2str(output.var(ivar).length) ...
         );
      tt = [tt,t1];
      for i=1:nspace
        tt = [tt,' '];
      end
      t1 = sprintf('%s %s; /* #RTAS: ''%s.%s'': [o: on, n: %s, u: %s ] */\n' ...
         , 'int' ...
         , [output.var(ivar).cname,'_mBufferCnt'] ...
         , output.cstructname ...
         , [output.var(ivar).cname,'_mBufferCnt'] ...
         , [output.var(ivar).name,'_mBufferCnt'] ...
         , 'enum' ...
         );
      tt = [tt,t1,'\n'];
   
      for ivec = 1:length(output.var(ivar).vecnames)
        
        for i=1:nspace
          tt = [tt,' '];
        end
        vecname = [output.var(ivar).cname,'_',output.var(ivar).vecnames{ivec}];
        t1 = sprintf('%s %s[%s]; /* #RTAS: \n' ...
           , output.var(ivar).cformat ...
           , vecname ...
           , defname ...
           );
        tt = [tt,t1];
        for isig = 1:output.var(ivar).length
          for i=1:nspace
            tt = [tt,' '];
          end
          rtasname = [output.var(ivar).name,'_mBuffer_',num2str(isig-1),'_',output.var(ivar).vecnames{ivec}];
          t1 = sprintf('                             ''%s.%s[%s]'': [o: on, n: %s, u: %s' ...
             , output.cstructname ...
             , vecname ...
             , num2str(isig-1) ...
             , rtasname ...
             , output.var(ivar).unit{ivec} ...
             );
          if( isig < output.var(ivar).length )
            t1 = sprintf('%s ],\n',t1);
          else
            t1 = sprintf('%s ] */\n',t1);
          end
          tt = [tt,t1];
        end
        t2 = sprintf('	                                             /* %s       %s */\n' ...
           , output.var(ivar).cunit{ivec} ...
           , output.var(ivar).comment ...
           );
        tt = [tt,t2];
      end
    case 'u'   % unitconvert

      mCntName = [output.var(ivar).cname,'_mBufferCnt'];
      for ivec = 1:length(output.var(ivar).vecnames)
      
        [fac,offset] = get_unit_convert_fac_offset(output.var(ivar).cunit{ivec} ,output.var(ivar).unit{ivec});
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
             , output.cstructname ...
             , output.var(ivar).cname ...
             , output.cstructname ...
             , output.var(ivar).cname ...
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
    case 'mu'   % Matlab unit setzen
      for i=1:nspace
        tt = [tt,' '];
      end
      mCntName = [output.var(ivar).name,'_mBufferCnt'];
      t1 = sprintf('u.%s = ''%s'';\n' ...
       , mCntName ...
       , 'enum' ...
       );
      tt = [tt,t1];
      for ivec = 1:length(output.var(ivar).vecnames)
        for isig = 1:output.var(ivar).length
          for i=1:nspace
            tt = [tt,' '];
          end
          rtasname = [output.var(ivar).name,'_mBuffer_',num2str(isig-1),'_',output.var(ivar).vecnames{ivec}];
          t1 = sprintf('u.%s = ''%s'';\n' ...
             , rtasname ...
             , output.var(ivar).unit{ivec} ...
             );
          tt = [tt,t1];
        end
      end       
  end
end    