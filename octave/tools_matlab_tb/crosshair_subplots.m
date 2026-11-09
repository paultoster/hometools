%version 1 TBert/TZS/3052 20050126
function [Xpoint,Ypoint,XYhist] = crosshair_subplots(action)
%  CROSSHAIR:  A gui interface for reading (x,y) values from a plot.
%  
%  [Xpoint,Ypoint,XYhist] = crosshair_subplots(action);
%  
%  A set of mouse driven crosshairs is placed on the current axes,
%  and displays the current (x,y) values of the line plot.  There is an
%  option to provide data specific values or interpolated values.  The
%  resolution of the data specific values depends on both the data
%  resolution and the GUI interface (mainly mouse movement resolution).
%  The interpolated values appear to provide a more continuous function,
%  however they too depend on the GUI interface resolution.  There are 
%  no options for extrapolation.
%  
%  For multiple traces, plots with the same length(xdata) are
%  tracked. Each mouse click returns Xpoint,Ypoint values and selecting 
%  'done' will remove the GUI and restore the mouse buttons to previous 
%  values.  Selecting 'exit' will remove the GUI and close the figure.
%  
%  In this version (Dec 2002), the crosshairs can track multiple subplots
%  and there are new options to define functions of X/Y and monitor 
%  their results.  There is also a new STORE button that creates and 
%  updates an XYhist struct in the base workspace, which contains value 
%  labels and values.  This version has better controls of X/Y movements, 
%  including better interpolation movement options.  This version attempts 
%  to respond correctly to keyboard entries, including TAB between subplots,
%  RETURN to 'save', ESC for 'done' and all the arrow keys to move the
%  crosshairs.
%  
%  Some further help is given in the tool tips of the GUI.
%
%  Note: crosshair should always update the Xpoint,Ypoint in the base 
%  workspace. Here is an example of how to get return values within
%  a script/function after pressing the exit button of crosshair:
%       function [X,Y] = crosshair_returnXY
%		x = [1:10]; y(1,:) = sin(x); y(2,:) = cos(x);
%		figure; plot(x,y); crosshair;
%		uiwait
%		X = evalin('base','Xpoint');
%		Y = evalin('base','Ypoint');
%		return
%  Copy this text to a function .m file and then call it from the
%  base workspace with [X,Y] = crosshair_returnXY
%  
%  Useage:  wt=0:0.01:2.5*pi;
%           t=wt;
%           subplot(2,1,1),plot(t,1.0*sin(wt),t,1.0*sin(wt-110/180*pi),t,1.0*sin(wt-250/180*pi));
%           subplot(2,1,2), plot(t,sin(2*wt));
%           crosshair_subplots;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%  Licence:        GNU GPL, no express or implied warranties
%  History: 03/96, Richard G. Cobb <cobbr@plk.af.mil>
%           08/01, Darren.Weber@flinders.edu.au
%                  replaced obsolete 'table1' with 'interp1'; fixed bug
%                  with number of 'traces'; rationalized calculations into
%                  a common subfunction for x,y point calc in 'down','up', 
%                  & 'move' button functions; added option to turn on/off
%                  interpolation and the exit button; simplified updates 
%                  to graphics using global GUI handle structure.
%           11/01, Darren.Weber@flinders.edu.au
%                  added tooltips for several GUI handles
%                  added multiple interpolation methods
%                  added GUI for data matrix indices (given no interpolation)
%                  added option to select trace nearest to mouse click point
%                  reversed order of lines in data matrix to be consistent
%                    with the value returned from the nearest trace subfunction
%                  create crosshair lines after finding all plot lines to
%                    avoid confusing them with the plot lines
%           01/02, Darren.Weber@flinders.edu.au
%                  should now work across multiple plot figures, given
%                    that all gui handles and data are now stored in the
%                    plot figure 'userdata' handle.
%                  added functionality to move smoothly from interpolation
%                    back to the delimited data via the "next/previous" 
%                    buttons.
%           06/02, Darren.Weber@flinders.edu.au
%                  learned how to get values back to a script/function with
%                    evalin command and updated help above.
%           12/02, Darren.Weber@flinders.edu.au
%                  added Store uicontrol and associated XYhist variable 
%                   updates in base workspace to provide storage of 
%                   consecutive XY values (thanks to C.A.Swenne@lumc.nl &
%                   H.van_de_Vooren@lumc.nl for their suggestion/assistance).
%                  added keyboard controls to left/right arrow and return.
%                  added prev/next X interpolation interval.
%                  added handling of subplots in crosshair_subplots version.
%
%           04/10, Grotendorst, Thomas
%                   cursor/position in all subplots, 
%                   position as text, dotted cursor, colors
%                   unused functions deleted (interpolation, most buttons, value functions)
%           05/01, Berthold, Thomas
%                   set done_flag for all userdata of axes to initialize corecctly in get_data when 
%                   crosshair_subplot is called again with the same figure.
%                   If no line were ploted crosshair_subplots return without doing anything
%           09/08, Berthold, Thomas
%                   Xdata has not identical columns: 
%                   * So function [ xpoint, xindex, ypoint, yindex ] =
%                   NearestXYMatrixPoint( Xdata, Ydata, xpoint, ypoint ) is
%                   calculated different, according to different X-Data-Bases
%                   * In function function [ H ] = updateGUI( H ) the function NearestXYMatrixPoint()
%                   has to be used aswell, because xindex could vary, due to not identical x-columns
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('action','var') 
    action = 'init';
elseif isempty(action)
    action = 'init';
end

XHR = get_user_data_xhr(gcf);


if gca && ~isempty(XHR),
    if ~isequal(gca,XHR.axis),
        % Ensure we have the right axis data
        XHR.axis = gca;
        XHR.data = get_data;
    end
end


% Check for specific keys and assign reasonable actions
if strcmp(action, 'keypress'),
    
    CC = get(XHR.gui,'CurrentCharacter');
    cc = double(CC);
    if cc,
        switch cc,
        case  9, action = 'axes';       % TAB, switch axes, if possible
        case 27, action = 'done';       % ESC
        case 28, action = 'prevx';      % left
        case 29, action = 'nextx';      % right
        case 30, action = 'ygt';        % up
        case 31, action = 'ylt';        % down
        case 13, action = 'store';      % return/enter
        otherwise, action = 'up';       % all other keys
        end
    end
end


action = lower(action);

switch action,

case 'init',
    
    % Paint GUI
    XHR = INIT;
    
    if( isempty(XHR.data) )
        return
    end
    
    % Update and return values
    XHR = updateDATA(XHR);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
case 'axes',
    
    % TAB between axes in subplots of a figure
    ax = findobj(gcf,'type','axes');
    if length(ax) > 1,
        nax = find(ax == gca);
        if nax < length(ax),
            axes(ax(nax+1));
        else
            axes(ax(1));
        end
    end
    XHR.axis = gca;
    XHR.data = get_data;
    XHR = updateGUI(XHR);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    
% Mouse Click Down
case 'down',
    
    set(XHR.gui,'WindowButtonMotionFcn','crosshair_subplots(''move'');');
    set(XHR.gui,'WindowButtonUpFcn','[Xpoint,Ypoint] = crosshair_subplots(''up'');');
    
    XHR = updateDATA(XHR);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
% Mouse Drag Motion
case 'move',
    
    XHR = updateDATA(XHR);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
% Mouse Click Up
case 'up',
    
    set(XHR.gui,'WindowButtonMotionFcn',' ');
    set(XHR.gui,'WindowButtonUpFcn',' ');
    
    XHR = updateDATA(XHR);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
% Next or Previous X point
case {'nextx','prevx','changex','nexty','prevy','changey','ylt','ygt'}, % Change X/Y
    
    XHR = moveXY(XHR,action);
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
% Store XY values into a history array
case 'store',
    
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    updateXYhistory(XHR);
    
% Exit crosshairs GUI
case {'done','exit'},
    
    Xpoint = get(findobj(gcf,'tag',XHR.data.tagXVal),'Value');
    Ypoint = get(findobj(gcf,'tag',XHR.data.tagYVal),'Value');
    %updateXYhistory(Xpoint,Ypoint);
    
    handles = fieldnames(XHR);
    for i=1:length(handles),
        switch handles{i},
        case {'axis','datalines','gui','chs_set'},
        otherwise,
            h = getfield(XHR,handles{i});
            if ishandle(h), delete(h); end
        end
    end
    
    if strcmp(action,'exit');
        if ishandle(XHR.gui),
            close(XHR.gui);
        end
    else
        
        lines = findobj(gcf,'tag','XHR_XLINE');
        for l = 1:length(lines),
            line = lines(l);
            if ishandle(line), delete(line); end
        end
        lines = findobj(gcf,'tag','XHR_YLINE');
        for l = 1:length(lines),
            line = lines(l);
            if ishandle(line), delete(line); end
        end
        
        set(XHR.gui,'WindowButtonUpFcn','');
        set(XHR.gui,'WindowButtonMotionFcn','');
        set(XHR.gui,'WindowButtonDownFcn',' ');
        
        refresh(XHR.gui);
    end
    
    % TBert 25.01.05 for m-function chs()
    %
    if( isfield(XHR,'chs_set') )
        XHR.chs_set = 0;
        % set(gcf,'userdata',XHR);
        set_user_data_xhr(gcf,XHR);
    end
    
    % set(XHR.axis,'userdata',XHR.data);
    set_user_data_xhr(XHR.axis,XHR.data);
    clear XHR;
    % TBert 24.01.05 set done_flag for reinitialize
    %
    childs = get(gcf,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))

            % data = get(childs(ch),'userdata');
            data = get_user_data_xhr(childs(ch));
            data.done_flag = 1;
            % set(childs(ch),'userdata',data);
            set_user_data_xhr(childs(ch),data);
        end
    end

    return;
    
end

if ishandle(XHR.axis),
    % set(XHR.axis,'userdata',XHR.data);
    set_user_data_xhr(XHR.axis,XHR.data);
end

if ishandle(XHR.gui),
    % set(XHR.gui,'userdata',XHR);
    set_user_data_xhr(XHR.gui,XHR);
    figure(XHR.gui);
end

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updateXYhistory(H),
    
    %Ch = get(H.yindex,'Value');
    X       = get(findobj(gcf,'tag',H.data.tagXVal),'Value');
    Y       = get(findobj(gcf,'tag',H.data.tagYVal),'Value');
    Yind    = H.data.yindex;

    if evalin('base','exist(''XYhist'',''var'');'),
        XYhist = evalin('base','XYhist');
        XYhist(end+1,:) = [X,Y];
    else
        XYhist = [X,Y];
    end
    XYhist
    assignin('base','XYhist',XYhist);
    
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H] = moveXY(H,move)
    
    switch move,
    case 'nextx',
        % Increase current xindex by one
        H.data.xindex = H.data.xindex + 1;
    case 'prevx',
        % Decrease current xindex by one
        H.data.xindex = H.data.xindex - 1;
    case 'nexty', H.data.yindex = H.data.yindex + 1;
    case 'prevy', H.data.yindex = H.data.yindex - 1;
    case 'ygt',
        ydata = zeros(1,length(H.data.ydata));
        for i = 1:length(H.data.ydata)
            ydata(1,i) = H.data.ydata{i}(H.data.xindex);
        end
        % ydata = H.data.ydata(H.data.xindex,:);
        [ysort,yi] = sort(ydata);
        currYI = find(ysort == H.data.ypoint);
        currYI = currYI(1);
        if currYI < length(yi),
            H.data.yindex = yi(currYI+1);
        end
    case 'ylt',
        ydata = zeros(1,length(H.data.ydata));
        for i = 1:length(H.data.ydata)
            ydata(1,i) = H.data.ydata{i}(H.data.xindex);
        end
        % ydata = H.data.ydata(H.data.xindex,:);
        [ysort,yi] = sort(ydata);
        currYI = find(ysort == H.data.ypoint);
        currYI = currYI(1);
        if currYI > 1,
            H.data.yindex = yi(currYI-1);
        end
    otherwise
    end
    
    H = checkdatarange(H);
    
    % Get x/y value at new x/y index
    H.data.xpoint = H.data.xdata{H.data.yindex}(H.data.xindex);
    H.data.ypoint = H.data.ydata{H.data.yindex}(H.data.xindex);
    
    H = updateGUI(H);
    
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ H ] = checkdatarange(H)

    % Ensure that x/y index is within data range
    s = length(H.data.xdata{1});
    for i=2:length(H.data.xdata)
         s = min(s,length(H.data.xdata{i}));
    end
    % s = size(H.data.xdata,1);
    if( H.data.xindex < 1 ),
        H.data.xindex = 1;
    elseif( H.data.xindex >= s ),
        H.data.xindex = s;
    end
    s = length(H.data.ydata{1});
    for i=2:length(H.data.ydata)
         s = min(s,length(H.data.ydata{i}));
    end
    % s = size(H.data.ydata,2);
    if( H.data.yindex < 1 ),
        H.data.yindex = 1;
    elseif( H.data.yindex >= s ),
        H.data.yindex = s;
    end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ H ] = updateDATA( H )

    % Only update if mouse pointer is in the
    % axis limits
    set(H.gui,'units','normalized');
    axpos = get(H.axis,'position');
    figcp = get(H.gui,'Currentpoint');
    axlim = axpos(1) + axpos(3);
    aylim = axpos(2) + axpos(4);
    if or(figcp(1) > (axlim+.01), figcp(1) < (axpos(1)-.01)),
        return;
    elseif or(figcp(2) > (aylim+.01), figcp(2) < (axpos(2)-.01)),
        return;
    end

    CurrentPoint  = get(H.axis,'Currentpoint');
    H.data.xpoint = CurrentPoint(1,1);
    H.data.ypoint = CurrentPoint(1,2);
    
    if get(H.traceNearest,'Value'),
        
        % Get new yindex for nearest trace
        [ H.data.xpoint, ...
          H.data.xindex, ...
          H.data.ypoint, ...
          H.data.yindex ] = NearestXYMatrixPoint( H.data.xdata, H.data.ydata, H.data.xpoint, H.data.ypoint);
    end
    
    CurrentPoint  = get(H.axis,'Currentpoint');
    H.data.xpoint = CurrentPoint(1,1);
    H.data.ypoint = CurrentPoint(1,2);
    
    H = interpY(H);
    H = updateGUI(H);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ H ] = updateGUI( H )

    % Create the crosshair lines on the figure, crossing at the x,y point
    x_rng  = get(H.axis,'Xlim');
    y_rng  = get(H.axis,'Ylim');
    set(H.data.xline,'Xdata',[H.data.xpoint H.data.xpoint],'Ydata',y_rng);
    set(H.data.yline,'Ydata',[H.data.ypoint H.data.ypoint],'Xdata',x_rng);
    if (get(H.traceAllY,'Value') == 0)
        set(H.data.yline,'Visible','on');
    end
    
    % Update the x,y values displayed for the x,y point
    xstring = sprintf('%12.4f',H.data.xpoint);
    ystring = sprintf('%14.6f',H.data.ypoint);
    set(findobj(gcf,'tag',H.data.tagXVal),'String',xstring,'Value',H.data.xpoint);
    set(findobj(gcf,'tag',H.data.tagYVal),'String',ystring,'Value',H.data.ypoint);
    
    % Update xline on other subplots (yline is not updated so far)
    oldaxes = gca;
    axData = H;
    childs = get(gcf,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) & (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
            if (childs(ch) ~= oldaxes)
                set(gcf,'CurrentAxes',childs(ch));

                axData.axis = childs(ch);
                axData.data = get_data;

                % TBert: Punkt für andere subplot berechnenen, da x-Data
                % eventuell nicht gleich
                [ axData.data.xpoint, ...
                  axData.data.xindex, ...
                  axData.data.ypoint, ...
                  axData.data.yindex ] = NearestXYMatrixPoint( axData.data.xdata, axData.data.ydata, ...
                                                               H.data.xpoint, H.data.ypoint);

%                 axData.data.xindex = H.data.xindex;
%                 axData.data.xpoint = axData.data.xdata{axData.data.yindex}(axData.data.xindex);
%                 axData.data.ypoint = axData.data.ydata{axData.data.yindex}(axData.data.xindex);

                x_rng  = get(axData.axis,'Xlim');
                y_rng  = get(axData.axis,'Ylim');
                set(axData.data.xline,'Xdata',[axData.data.xpoint axData.data.xpoint],'Ydata',y_rng);
                if (get(H.traceAllY,'Value') == 1)
                    set(axData.data.yline,'Ydata',[axData.data.ypoint axData.data.ypoint],'Xdata',x_rng);
                    set(axData.data.yline,'Visible','on');
                else
                    set(axData.data.yline,'Visible','off');
                end

                % Update the x,y values displayed for the x,y point
                xstring = sprintf('%12.4f',axData.data.xpoint);
                ystring = sprintf('%14.6f',axData.data.ypoint);
                set(findobj(gcf,'tag',axData.data.tagXVal),'String',xstring,'Value',axData.data.xpoint);
                set(findobj(gcf,'tag',axData.data.tagYVal),'String',ystring,'Value',axData.data.ypoint);
            end
        end
    end
    set(gcf,'CurrentAxes',oldaxes);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ H ] = interpY( H )
    
    % In this function, xdata & ydata are arrays, not matrices
    xdata = H.data.xdata{H.data.yindex};
    ydata = H.data.ydata{H.data.yindex};
    
    if      H.data.xpoint >= max(xdata)                
            H.data.xpoint  = max(xdata);
            H.data.xindex  = find(xdata == max(xdata));
            H.data.ypoint  = ydata(H.data.xindex);
            return;
    elseif  H.data.xpoint <= min(xdata)
            H.data.xpoint  = min(xdata);
            H.data.xindex  = find(xdata == min(xdata));
            H.data.ypoint  = ydata(H.data.xindex);
            return;
    end
    
    % Given that xdata & ydata are the same length arrays,
    % we can find the ypoint given the nearest xpoint.
    [H.data.xindex, H.data.xpoint] = NearestXYArrayPoint( xdata, H.data.xpoint );
    H.data.ypoint = ydata(H.data.xindex);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ index, point ] = NearestXYArrayPoint( data_array, point)
    
    % In this function, input data_array is an array, not a matrix.
    % This function returns the data point in the array
    % that has the closest value to the value given (point).  In
    % the context of 'crosshair' the point is a mouse position.
    
    if      point >= max(data_array)
            point  = max(data_array);
            index  = find(data_array == point);
            index  = index(1);
            return;
    elseif  point <= min(data_array)
            point  = min(data_array);
            index  = find(data_array == point);
            index  = index(1);
            return;
    end
    
    data_sorted = sort(data_array);
    
    greater = find(data_sorted > point);
    greater_index = greater(1);
    
    lesser = find(data_sorted < point);
    lesser_index = lesser(length(lesser));
    
    greater_dif = data_sorted(greater_index) - point;
    lesser_dif  = point - data_sorted(lesser_index);
    
    if (greater_dif < lesser_dif)
        index = find(data_array == data_sorted(greater_index));
    else
        index = find(data_array == data_sorted(lesser_index));
    end
    index = index(1);

    point = data_array(index);
    
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ xpoint, xindex, ypoint, yindex ] = NearestXYMatrixPoint( Xdata, Ydata, xpoint, ypoint )

    % In this function, Xdata & Ydata are matrices of the same dimensions.
    % This function attempts to find the nearest values in Xdata & Ydata
    % to the mouse position (xpoint, ypoint).
    
    % It is assumed that Xdata has identical columns, so we only really
    % need the first column to find the nearest value to xpoint.
    % TBert Xdata has not identical columns:
    
    % Now, given the xpoint, we can select just that row of the
    % Ydata matrix corresponding to the xpoint.
    ydata = zeros(1,length(Ydata));
    xdata = zeros(1,length(Xdata));
    for i = 1:length(Ydata)
       [ xindex, xpoint ] = NearestXYArrayPoint( Xdata{i}, xpoint );
        xdata(1,i) = Xdata{i}(xindex);
        ydata(1,i) = Ydata{i}(xindex);
    end
    
    % The ydata array is searched in same manner as the xdata
    % array for the nearest value.
    [ xindex, xpoint ] = NearestXYArrayPoint( xdata, xpoint );
    [ yindex, ypoint ] = NearestXYArrayPoint( ydata, ypoint );
    
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ data ] = get_data(gid),

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get Line Data from Current Axes
    
    if gca,
        
        % see if we have stored any data in userdata already
        % data = get(gca,'userdata');
        data = get_user_data_xhr(gca);
                           
        if isfield(data,'lineobj'),
            %
            % TBert reinitialize corretly when done_flag is set
            if( isfield(data,'done_flag') && data.done_flag == 0 )
                if data.lineobj,
                    return;
                end
            end
        end
        
        data.ylim = get(gca,'ylim');
        
        % Get all the line objects from the current axis
        data.lineobj = findobj(gca,'Type','line');
        
        if data.lineobj,
            
            data.lines = length(data.lineobj);
            data.xdata = {};
            data.ydata = {};
            data.xpoint = [];
            data.ypoint = [];
            data.xindex = 1;
            data.yindex = 1;
            data.tagXVal = sprintf('XHR_XVALUE%d',round(gid));
            data.tagYVal = sprintf('XHR_YVALUE%d',round(gid));
            for i = data.lines:-1:1,
                
                % put line data into a columns of data
                data.xdata{i} = get(data.lineobj(i),'XData').';
                data.ydata{i} = get(data.lineobj(i),'YData').';
            end
            
            % Set X,Y cross hair lines
            % Do this after finding all the line axis children
            % to avoid confusing these lines with those of the
            % plot itself (counted above).
            x_rng = get(gca,'Xlim');
            y_rng = get(gca,'Ylim');
            data.xline = line(x_rng,[y_rng(1) y_rng(1)]);
            data.yline = line([x_rng(1) x_rng(1)],y_rng);
            set(data.xline,'Color','b','EraseMode','xor','tag','XHR_XLINE','LineStyle',':');
            set(data.yline,'Color','b','EraseMode','xor','tag','XHR_YLINE','LineStyle',':');
            
            data.done_flag = 0;
            
            % set(gca,'userdata',data);
            set_user_data_xhr(gca,data);
            
            
            
        else
            fprintf('No lines in current axes\n');
            data = [];
        end
        
    end
    
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H] = INIT

    H.gui  = gcf; % Get current figure handles
    H.axis = gca; % Get current axis handles
    
    H.data = get_data(H.axis);
    
    if( isempty(H.data) )
        return
    end
    
    old = get(gcf,'Units');
    set(gcf,'Units','characters');
    pos=get(gcf,'Position');
    set(gcf,'Units',old);
    WinSize=[pos(3)-pos(1) pos(4)-pos(2)];
    WinSize=[pos(3) pos(4)];

    
    % store current button fcn
    H.button = get(H.gui,'WindowButtonDownFcn');
    % set XHR button down fcn
    set(H.gui,'WindowButtonDownFcn','crosshair_subplots(''down'');');
    set(H.gui,'KeyPressFcn','crosshair_subplots(''keypress'');');
    set(H.gui,'ResizeFcn','crosshair_subplots(''init'');');

    
    % Match background figure colour
    bgcolor = get(H.gui,'Color');
    % Try to adapt the foreground colour a little
    black = find(bgcolor <= .6);
    if length(black)>2, 
        fgcolor    = [1 1 1]; % white text
        txtBgColor = [ .2 .2 .2];
        txtXColor  = [ 1.0 0.8 1.0];
        txtYColor  = [ 1.0 1.0 .7];
    else
        fgcolor    = [0 0 0]; % black text
        txtBgColor = [ .8 .8 .8];
        txtXColor  = [ .0 .2 .0];
        txtYColor  = [ .0 .0 .3];
    end
    
    
    Font.FontName   = 'Helvetica';
    Font.FontUnits  = 'Pixels';
    Font.FontSize   = 10;
    Font.FontWeight = 'normal';
    Font.FontAngle  = 'normal';
    
    % x/yvalues on each subplot
    oldaxes = gca;
    axData = H;
    childs = get(gcf,'children');
    for (ch=1:size(childs,1))
        if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))

            set(gcf,'CurrentAxes',childs(ch));

            axData.axis = childs(ch);
            axData.data = get_data(axData.axis);

            set(axData.axis,'Units','characters');
            pos = get(axData.axis,'Position');
            set(axData.axis,'Units','normalized');
            xpos = pos(1)+1;
            ypos = pos(2)+pos(4);

            if findobj(gcf,'tag',axData.data.tagXVal)
                hndl = findobj(gcf,'tag',axData.data.tagXVal);
                set( hndl, 'Position',[xpos ypos 13 1.0]);
            else
                hndl = uicontrol(H.gui,'tag',axData.data.tagXVal,'Style','text',...
                    'Units','characters',Font,...
                    'Position',[xpos ypos 13 1.0],...
                    'BackGroundColor',txtBgColor,'ForeGroundColor',txtXColor,...
                    'TooltipString','X value (Read Only)',...
                    'String',' ');
            end

            if findobj(gcf,'tag',axData.data.tagYVal),
                hndl = findobj(gcf,'tag',axData.data.tagYVal);
                set( hndl, 'Position',[xpos+13 ypos 17 1.0]);            
            else
                hndl = uicontrol(H.gui,'tag',axData.data.tagYVal,'Style','text',...
                    'Units','characters',Font,...
                    'Position',[xpos+13 ypos 17 1.0],...
                    'BackGroundColor',txtBgColor,'ForeGroundColor',txtYColor,...
                    'TooltipString','Y value (Read Only)',...
                    'String',' ');
            end
    
        end
    end
    set(gcf,'CurrentAxes',oldaxes);
    
    if (1)
        if findobj(gcf,'tag','XHR_GRID'),
            H.grid = findobj(gcf,'tag','XHR_GRID');
        else
%             H.grid = uicontrol(H.gui,'tag','XHR_GRID','Style','checkbox',...
%                 'Units','Normalized',Font,...
%                 'Position',[.00 .75 .08 .05],...
%                 'BackgroundColor',bgcolor,'ForegroundColor',fgcolor,...
%                 'TooltipString','Toggle plot grid on/off.', ...
%                 'String','grid',...
%                 'Callback',strcat('XHR = get(gcf,''userdata'');',...
%                 'grid(XHR.axis);',...
%                 'set(XHR.gui,''userdata'',XHR); figure(XHR.gui); clear XHR;'));
            H.grid = uicontrol(H.gui,'tag','XHR_GRID','Style','checkbox',...
                'Units','Normalized',Font,...
                'Position',[.00 .75 .08 .05],...
                'BackgroundColor',bgcolor,'ForegroundColor',fgcolor,...
                'TooltipString','Toggle plot grid on/off.', ...
                'String','grid',...
                'Callback',@crosshair_subplot_grid_cb);
        end
    end
    
    % store
    if findobj(gcf,'tag','XHR_STORE'),
        H.store = findobj(gcf,'tag','XHR_STORE');
        set( H.store, 'Position',[91 WinSize(2)-1.5 10 1.5]);            
    else
        H.store = uicontrol(H.gui,'tag','XHR_STORE','Style','Push',...
            'Units','characters',...
            'Position',[91 WinSize(2)-1.5 10 1.5],...
            'BackgroundColor',[.8 .5 0],...
            'ForegroundColor',[1 1 1],...
            'FontWeight','bold',...
            'String','Store',...
            'TooltipString','Store current Channel & XY values into base XYhist array.', ...
            'CallBack','crosshair_subplots(''store'');');
    end

    if findobj(gcf,'tag','XHR_DONE'),
        H.done = findobj(gcf,'tag','XHR_DONE');
        set( H.done, 'Position',[101 WinSize(2)-1.5 10 1.5]);            
    else
        H.done = uicontrol(H.gui,'tag','XHR_DONE','Style','Push',...
            'Units',' characters',...
            'Position',[101 WinSize(2)-1.5 10 1.5],...
            'BackgroundColor',[.8 .5 0],...
            'ForegroundColor',[1 1 1],...
            'FontWeight','bold',...
            'String','Done',...
            'TooltipString','Close crosshair', ...
            'CallBack','crosshair_subplots(''done'');');
    end

    if findobj(gcf,'tag','XHR_ZOOM'),
        H.zoom = findobj(gcf,'tag','XHR_ZOOM');
        set( H.zoom, 'Position',[47 WinSize(2)-1.5 10 1.5]);            
    else
        H.zoom = uicontrol(H.gui,'tag','XHR_ZOOM','Style','checkbox',...
            'Units','characters',Font,...
            'Position',[47 WinSize(2)-1.5 10 1.5],...
            'BackgroundColor',bgcolor,'ForegroundColor',fgcolor,...
            'TooltipString','Toggle zoom with mouse/cursor with mouse.', ...
            'String','zoom',...
            'Callback','zoom;');
    end

    % traceneauest
    if findobj(gcf,'tag','XHR_TRACENEAREST'),
        H.traceNearest = findobj(gcf,'tag','XHR_TRACENEAREST');
        set( H.traceNearest, 'Position',[57 WinSize(2)-1.5 18 1.5]);            
    else
        H.traceNearest = uicontrol(H.gui,'tag','XHR_TRACENEAREST','Style','checkbox',...
            'Units','characters',Font,...
            'Position',[57 WinSize(2)-1.5 18 1.5],...
            'BackgroundColor',bgcolor,'ForegroundColor',fgcolor,...
            'String','Nearest Trace','Value',1,...
            'TooltipString','Trace nearest to mouse click; switch off to keep trace constant.');
    end

    % allytrace
    if findobj(gcf,'tag','XHR_ALLYTRACE'),
        H.traceAllY = findobj(gcf,'tag','XHR_ALLYTRACE');
        set( H.traceAllY, 'Position',[76 WinSize(2)-1.5 14 1.5]);            
    else
        H.traceAllY = uicontrol(H.gui,'tag','XHR_ALLYTRACE','Style','checkbox',...
            'Units','characters',Font,...
            'Position',[76 WinSize(2)-1.5 14 1.5],...
            'BackgroundColor',bgcolor,'ForegroundColor',fgcolor,...
            'String','Y-TraceAll','Value',1,...
            'TooltipString','Trace "y-cursor in inactive subplots" on/off.');
    end

%     % Switch off||on Trace Selection GUI
%     Vis = 'Off';
%     if H.data.lines > 1,
%         Vis = 'On';
%     elseif H.data.lines == 0
%         error('No lines found in the current axes (gca)\n');
%     end
%     
%     % 'traces' string variable must be in ascending order
%     traces  = '';
%     i = 1;
%     while i <= lines;
%         if i < lines
%             tracelabel = sprintf('Column %4d|',i);            
%         else
%             tracelabel = sprintf('Column %4d',i);
%         end
%         traces = strcat(traces,tracelabel);
%         i = i + 1;
%     end
%     
%     % If more than one line, provide GUI for line selection
%     
%     
%     if findobj(gcf,'tag','XHR_TRACESWITCH'),
%         H.trace = findobj(gcf,'tag','XHR_TRACESWITCH');
%         set(H.trace,'String',traces);
%     else
%         H.trace = uicontrol(H.gui,'tag','XHR_TRACESWITCH','Style','Popup',...
%             'Units','Normalized',...
%             'Position',[.15 .00 .20 .05],...
%             'BackGroundColor','w','String',traces,...
%             'TooltipString','Select trace to follow with crosshairs.',...
%             'Visible',Vis,...
%             'CallBack','crosshair_subplots(''up'');');
%     end
    
    
    % set(H.axis,'userdata',H.data);
    % set(H.gui,'userdata',H);
    set_user_data_xhr(H.axis,H.data);
    set_user_data_xhr(H.gui,H);
    
return
function crosshair_subplot_grid_cb(hOject,event)

  XHR = get_user_data_xhr(gcf);
  grid(XHR.axis);
  set_user_data_xhr(XHR.gui,XHR);
  figure(XHR.gui); 
  clear XHR;

function XHR = get_user_data_xhr(fid)

  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,'xhr') )
    XHR = FH.xhr;
  else
    XHR = [];
  end
return
function set_user_data_xhr(fid,data)

  FH = get(fid,'userdata');
  
  FH.xhr = data;
  
  set(fid,'userdata',FH);
return
