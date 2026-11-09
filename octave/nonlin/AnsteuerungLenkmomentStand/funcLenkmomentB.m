function [ee,res] = funcLenkmoment(x)

  global p d
    
  p.JzSteer = x(1);
  p.C0      = x(2);
  p.D0      = x(3);
  p.T0      = x(4);
  p.Sigma   = x(5);
  p.TR0  = x(6);
  
  if( x(7) > 1.e-6 )
    p.phipR0 = x(7);
  elseif( x(7) >= 0.0 )
    p.phipR0 = 1.e-10;
  elseif( x(7) < -1.e6 )
    p.phipR0 = x(7);
  else
    p.phipR0 = -1.e-10;
  end      
  
   
  p.Tsteer  = 0.05;
  
  ee  = 0.0;
  ifig = 0;
  for iliste = 1:p.nmessfile_liste

    %fprintf('Messdatei: %s\n',p.messfile_liste{iliste});
    p.Pcount = p.Pcount+1;
    if( p.Pcount > 100 )
        fprintf('\n');
        p.Pcount = 1;
    end
    fprintf('.');
    % Messwerte
    [okay,d] = d_data_read_mat(p.messfile_liste{iliste});
    
    n     = length(d.time);
    p.phi0  = d.deltaStWhl(1);
    p.phip0 = d.deltapStWhl(1);
    
    Tspan = [d.time(1) d.time(n)]; % Solve from t=1 to t=5
    mdl_name = 'simulink_LenkmomentB';
%     load_system(mdl_name)
%     set_param([mdl_name,'/table_deltaStWhl'], 'InputValues','[1,2,3,4,5]')
%     close_system(mdl_name,1)
%     tic
    sim(mdl_name,Tspan);
    wandel_vektor_in_struct
%     Y = [res.yawpVeh,res.yawpVeh];
%     T = res.time;
%     [T Y] = ode45(@(t,y) einspurmodell_COG_linear(t,y,p,d),Tspan,IC); % Solve ODE
%     toc
    
    if( p.plot_flag )
      ifig = ifig+1;
      figure(ifig)
      subplot(4,1,1)
      plot(d.time,d.IPAS_Soll_Lenkmoment,'-k')
      hold on
      plot(res.time,res.TRef,'-r')
      plot(res.time,res.reset,'-b')
      hold off
      grid on
      title(p.messfile_liste{iliste})
      legend('IPAS_Soll_Lenkmoment','TRef','reset')
      subplot(4,1,2)
      plot(d.time,d.deltaStWhl*180/pi,'-k')
      hold on
      plot(res.time,res.phi*180/pi,'-r')
      hold off
      grid on
      legend('deltaStWhl','phi')
      subplot(4,1,3)
      plot(d.time,d.deltapStWhl*180/pi,'-k')
      hold on
      plot(res.time,res.phip*180/pi,'-r')
      hold off
      grid on
      legend('deltapStWhl','phip')
      subplot(4,1,4)
      
      plot(res.time,res.phipp*180/pi,'-r')
      legend('phipp')
      grid on
      
      
      ifig = ifig+1;
      figure(ifig)
      plot(res.time,res.TAct,'-k')
      hold on
      plot(res.time,res.T1,'-b')
      plot(res.time,res.TC0,'-g')
      plot(res.time,res.TD0,'-r')
      hold off
      grid on
      title(p.messfile_liste{iliste})
      legend('TAct','T1','TC0','TD0')
      
      ifig = ifig+1;
      figure(ifig)
      plot(d.deltaStWhl*180/pi,d.IPAS_Soll_Lenkmoment,'-k')
      hold on
      plot(res.phi*180/pi,res.TRef,'-r')
      hold off
      grid on
      xlabel('phi [deg]')
      ylabel('T [Nm]')
      title(p.messfile_liste{iliste})
      legend('mess','sim')
    end
    try
     flag = 1;
      if( sum(isnan(res.phi)) )
        e = 1e30;
      elseif(flag)
        phi_sim = interp1(res.time,res.phi,d.time,'linear','extrap');
        delta = d.deltaStWhl - phi_sim;

        % figure,plot(d.time,d.yawpVeh,'k-',res2.time,res2.yawpVeh,'g-',res.time,res.yawpVeh,'r-'),grid on
        e  = sqrt((delta'*delta));
      end
    catch
     % getReport(ME)
     e    = 1e30;
     flag = 0;
    end
    

    % Fehler gesamt
    ee = ee+e*p.gewichtung(iliste);
  end
  ee = ee/p.nmessfile_liste;
  if( isinf(ee) ),ee=1e31;end
  % fprintf('ee  = %f\n\n',ee);
end
