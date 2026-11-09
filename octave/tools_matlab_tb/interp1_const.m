function y = interp1_const(xdata,ydata,x,ystart)
%
% y   = interp1_const(xdata,ydata,x[,ystart]);
%
% Inetrpoliert auf den Konstantwert. dh. ein x(i), was zwischen xdata(j)
% und xdata(j+1) liegt hat y(i) den wert von ydata(j)
% ystart      der Wert wird für den Anfang verwendet, wenn x(i) < xdata(1)
%             wenn nicht vorhanden, wird ydata(1) verwendet

  if( ~is_monoton_steigend(xdata) )

      error('der Eingangsvektor xdata ist nicht monoton steigend')
  end
  if( ~is_monoton_steigend(x) )

      error('der Eingangsvektor x ist nicht monoton steigend')
  end

  if( iscell(ydata) ) % cell array mit Vektoren
    if( ~exist('ystart','var') )
      ystart = ydata{1};
    end
    y = interp1_const_cell(xdata,ydata,x,ystart);
  else

    if( ~exist('ystart','var') )
      ystart = ydata(1);
    end


    y      = x;
    nx     = length(x);
    nxdata = length(xdata);
    j = 1;
    for i = 1:nx
        if( x(i) < xdata(j) )
          if( j == 1 )
            y(i) = ystart;
          else
            y(i) = ydata(j);
          end
        elseif( x(i) >= xdata(nxdata) )
          y(i) = ydata(nxdata);
        else
          while( x(i) >= xdata(j) )
            j = j+1;
            if( j >= nxdata )
              j = nxdata;
              break;
            end
          end
          y(i) = ydata(j);
        end
    end
  end
end
function y = interp1_const_cell(xdata,ydata,x,ystart)

  nx     = length(x);
  nxdata = length(xdata);
  y      = cell(nx,1);
  
  j = 1;
  for i = 1:nx
      if( x(i) < xdata(j) )
        if( j == 1 )
          y{i} = ystart;
        else
          y{i} = ydata{j};
        end
      elseif( x(i) >= xdata(nxdata) )
        y{i} = ydata{nxdata};
      else
        while( x(i) >= xdata(j) )
          j = j+1;
          if( j >= nxdata )
            j = nxdata;
            break;
          end
        end
        y{i} = ydata{j};
      end
  end
end
% for j=1:1:nxdata-1
%     
%     for i = 1:1:nx
% 
%      % try
%         if( x(i) >= xdata(j) && x(i) < xdata(j+1) )
%             
%             y(i) = ydata(j);
%         end
%      % catch
%      %   warning('Problem mit NaN\n')
%      %   i,j,j+1
%      % end
%     end
% end
        
        
    
        
        