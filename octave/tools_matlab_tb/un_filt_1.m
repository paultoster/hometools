function [x_filt,xp_filt] = un_filt_1(x_input,g,dt,zero_phase)

  if( ~exist('zero_phase','var') )
    zero_phase = 0;
  end
  n  = length(x_input);
  g  = min(0.999,max(0.001,g));
  dt = abs(dt);

  a11 = g^2;
  a12 = dt*g^2;

  a21 = -(g-1)^2/dt;
  a22 = -g*(g-2);

  c1  = (-1)*(g-1)*(g+1);
  c2  = (g-1)^2/dt;

  % A = [a11,a12;a21,a22];
  % B = [c1;c2];
  % C = [1,0];
  % D = 0;
  % [num,denum] = ss2tf(A,B,C,D);
  % x_filt      = filter(num,denum,x_input,[x_input(1),-x_input(1)*(a11+c1)]);
  % x_filt_zp      = filtfilt(num,denum,x_input);
  % C = [0,1];
  % [num,denum] = ss2tf(A,B,C,D);
  % xp_filt      = filter(num,denum,x_input,[0,x_input(1)*(a12+c2)]);
  % xp_filt_zp      = filter(num,denum,x_input);
  % 
  % figure(1)
  % plot(x_filt,'k-')
  % hold on
  % plot(x_filt_zp,'g-')
  % hold off
  % figure(2)
  % plot(xp_filt,'k-')
  % hold on
  % plot(xp_filt_zp,'g-')
  % hold off



  x_filt  = x_input*0;
  xp_filt = x_input*0;

  x  = x_input(1);
  xp = 0;

  for i=1:n

      x0  = x;
      xp0 = xp;

      x = a11*x0 + a12*xp0 + c1*x_input(i);
      xp = a21*x0 + a22*xp0 + c2*x_input(i);

      x_filt(i)  = x;
      xp_filt(i) = xp;

  end
  % figure(1)
  % hold on
  % plot(x_filt,'r-')
  % hold off
  % figure(2)
  % hold on
  % plot(xp_filt,'r-')
  % hold off

%   figure(1)
%   plot(x_input,'k-')
%   hold on
%   plot(x_filt,'r-')
%   hold off
  if( zero_phase )

    [R0, lags0] = sxcorr(x_input);
    [R, lags]   = sxcorr(x_input,x_filt);

    [R0max,iR0max] = max(R0);
    [Rmax,iRmax]   = max(R);

    di            = iR0max - iRmax;

    if( di > 0 )

      for i=1:n-di
        x_filt(i)  = x_filt(i+di);
        xp_filt(i) = xp_filt(i+di);
      end

      x  = x_filt(n-di);
      xp = xp_filt(n-di);

      for i=n-di+1:n

        x0  = x;
        xp0 = xp;

        x  = a11*x0 + a12*xp0 + c1*x_input(n);
        xp = a21*x0 + a22*xp0 + c2*x_input(n);

        x_filt(i)  = x;
        xp_filt(i) = xp;

      end
    end
  end
%   figure(1)
%   hold on
%   plot(x_filt,'g-')
%   hold off
%   grid on   
end