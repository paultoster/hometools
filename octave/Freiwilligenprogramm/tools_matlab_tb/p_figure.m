function handle_out = p_figure(fig_num,dina4,short_name,flag_close)
%
% handle_out = p_figure(fig_num)
% handle_out = p_figure(fig_num,dina4)
% handle_out = p_figure(fig_num,dina4,short_name)
% handle_out = p_figure(fig_num,dina4,short_name,flag_close)
%
%   Ersetzt den Befehl figure()
%   parameter:
%   fig_num       ganzzahlig	Nummer des Plots, wenn automatisch dann fig_num = 0 setzen
%   dina4         ganzzahlig	= 1 Plottet Dina 4 längs
%                               = 2 Plottet Dina 4 quer
%                                   ansonsten Matlabeinstellung
%   short_name    string		Kurzname in der Titelleiste
%   flag_close    enum        1: schliesst zuvor figure

  wurz2 = sqrt(2);
	if( nargin == 0 ) 
		fig_num = 0;
		dina4   = 0;
		short_name ='';
    flag_close = 0; 
	elseif( nargin ==  1 )
		dina4 = 0;
		short_name = '';
    flag_close = 0; 
	elseif( nargin ==  2 )
		short_name = '';
    flag_close = 0; 
	elseif( nargin ==  3 )
    flag_close = 0; 
  end
  
		
	if( fig_num > 0 )
    if( flag_close )
      close_figure(fig_num);
    end
    handle = figure(fig_num);
  else
    handle = figure;
	end
	%------------------------------------------------------------------
	if( length(short_name) > 0 )
        	set(handle,'Name',short_name);
	end
	%------------------------------------------------------------------
    old_unit = get(0,'Units');
    unit_flag = 0;
    if( old_unit ~= 'pixels' )        
        set(0,'Units','pixels');
        unit_flag = 1;
    end
    scs=get(0,'ScreenSize');
    scx =scs(3);
    scy =scs(4);
    dxleft = 10;
    dxright = 20;
    dybot = 50;
    dytop = 100;
    
    dscx = scx - dxleft - dxright;
    dscy = scy - dytop  - dybot;
    
	if( dina4 == 1 )
        set(handle,'PaperType','A4');
        set(handle,'PaperOrientation','portrait');
        set(handle,'PaperPositionMode','manual');
        set(handle,'PaperUnit','centimeters');
        set(handle,'PaperPosition',[0.63452 0.63452 19.715 28.408]);
        
        dfy = dscy;
        dfx = min(dscx,dfy/wurz2*1.2);
        dfy = dfx * wurz2 / 1.2;
        xp  = scx - dxright - dfx;
        yp  = scy - dytop - dfy;
        
        set(handle,'Position',[xp, yp, dfx, dfy]);
	elseif( dina4 == 2 )
        set(handle,'PaperType','A4');
        set(handle,'PaperOrientation','landscape');
        set(handle,'PaperPositionMode','manual');
        set(handle,'PaperUnit','centimeters');
        set(handle,'PaperPosition',[0.63452 0.63452 28.408 19.715]);
        
        dfx = dscx;
        dfy = min(dscy,dfx/wurz2);
        dfx = dfy*wurz2;
        xp  = scx - dxright - dfx;
        yp  = scy - dytop - dfy;
        
        set(handle,'Position',[xp, yp, dfx, dfy]);
    end
    if( unit_flag )
        set(0,'Units',old_unit);
    end
        
    if( nargout > 0 )
      if( isa(handle,'numeric') )
        handle_out = handle;
      elseif( isa(handle,'matlab.ui.Figure') )
        handle_out = handle.Number;
      else
        error('%s: handle has not typ ''numeric'' or ''matlab.ui.Figure''',mfilename)
      end
    end
