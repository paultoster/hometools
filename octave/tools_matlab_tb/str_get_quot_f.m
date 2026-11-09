function  [c_text,iposvec] = str_get_quot_f(text_string,quot1,quot2,regel)
%
% c_text = str_get_quot_f(text_string,quot1,quot2,regel)
% [c_text,iposvec] = str_get_quot_f(text_string,quot1,quot2,regel)
%
% Sucht Text nach regel zwischen den quots (quot1,quot2) und 
% gibt es in einem cell-array zurück
%
% wenn iposvec start position in text_string als vektor der gleichen länge
%
% regel = 'i' innerhalb der quots
% regel = 'a' aussehalb der quots

  if( ~exist('regel','var') ) 

      regel = 'i';
  end

  if( regel(1) == 'i' | regel(1) == 'I' )

      % Innerhalb der quots
      %====================
      go_on = 1;
      icount = 0;
      c_text = {};
      iposvec = [];
      l1 = length(quot1);
      l2 = length(quot2);
      istring     = 1;

      while( go_on )

          i1 = min(strfind(text_string,quot1));

          if( length(i1) == 0 ) % nicht gefunden
              go_on = 0;
          else
              if( i1+l1-1 >= length(text_string) ) 
                  text_string = '';
                  istring     = 0;
              else
                  text_string = text_string(i1+l1:length(text_string));
                  istring     = istring + i1+l1-1;

              end
              i2 = min(strfind(text_string,quot2));

              if( length(i2) == 0 ) % nicht gefunden
                  go_on = 0;
              else
                  icount = icount + 1;
                  if( i2 == 1 )
                      c_text{icount}  = '';
                      iposvec(icount) = istring;
                  else
                      c_text{icount}  = text_string(1:i2-1);
                      iposvec(icount) = istring;
                  end
                  if( i2+l2-1 >= length(text_string) )
                      text_string = '';
                  else
                      text_string = text_string(i2+l2:length(text_string));
                      istring     = istring + i2+l2-1;
                  end
              end
          end
      end
  else

      % Ausserhalb der quots
      %=====================

      go_on = 1;
      icount = 0;
      c_text = {};
      l1 = length(quot1);
      l2 = length(quot2);
      istring     = 1;

      while( go_on )

          i1 = min(strfind(text_string,quot1));

          if( isempty(i1) ) % nicht gefunden
              go_on = 0;
              icount = icount+1;
              c_text{icount} = text_string;
              iposvec(icount) = istring;
          else
              if( i1+l1-1 >= length(text_string) ) 
                  text_string = '';
                  istring = 0;
              else
                  if( i1-1 > 0 )
                      icount = icount+1;
                      c_text{icount} = text_string(1:i1-1);
                      iposvec(icount) = istring;
                  end
                  text_string = text_string(i1+l1:length(text_string));
                  istring     = istring + i1+l1-1;
              end
              i2 = min(strfind(text_string,quot2));

              if( isempty(i2) ) % nicht gefunden
                  go_on = 0;
              else
                  if( i2+l2-1 >= length(text_string) )
                      text_string = '';
                      istring = 0;
                  else
                      text_string = text_string(i2+l2:length(text_string));
                      istring     = istring + i2+l2-1;
                  end
              end
          end
      end
  end
  if( ~isempty(iposvec) )
    iposvec = iposvec';
  end
end
