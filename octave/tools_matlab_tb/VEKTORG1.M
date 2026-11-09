%vektorg1.m

% TZB/BFR Berthold 3052 11.08.95

disp(' ')
disp(' Utility zur Dateneingabe über Mouse ' )
disp(' Es wird ein Achsenkreuz aufgespannt,')
disp(' indem mit mouse-klick der Wert eingegeben wird.')
disp(' Abbruch mit keyboardtaste, wobei der dadurch')
disp(' letzte entstandene Wert nicht gescpeichert wird ')
disp(' ')
%
% Gewünschte Achsenskalierung
%
disp('gewünschte Achsenskalierung :')
disp(' ')
xmin=input('xmin = ');
xmax=input('xmax = ');
ymin=input('ymin = ');
ymax=input('ymax = ');
 
clf reset
axis([xmin xmax ymin ymax]);grid on 
hold on
%view(0,90)
%clc
%echo on

% This demonstration illustrates the use of the GINPUT function,
% which obtains graphic positional input via a mouse or cursor,
% and the SPLINE function, which interpolates data with a cubic spline.  
% The demonstration does NOT use the Spline Toolbox, which is a
% complete set of functions for B-splines and other piecewise polynomials
% of any degree.
%
% Press any key to continue after pauses.
%pause

clc

% Here is code which uses the left mouse button to pick a sequence of
% points and the return key to pick the last point.
% Initially, the list of points is empty and its length is 0.

% Please use the left mouse button or the cursor to select several points.
% Use the return key (or right mouse button) to select the final point.
disp(' ')
disp(' ')
disp('- Mouse in das Diagramm führen !            ')
disp('- Mit linker Mousetase Punkt auswählen      ')
disp('- Mit rechter Mousetaste oder keyboardtaste beenden,')
disp('  wobei Cursor im Diagramm sein muß')

x = [];
y = [];
n = 0;
% Loop, picking up the points.
but = 1;
while but == 1
   [xi,yi,but] = ginput(1);
   if but == 1
     plot(xi,yi,'go','era','back') % doesn't matter what erase mode is
                                % used so long as its not NORMAL
     n = n + 1;
     text(xi,yi,[' ' int2str(n)],'era','back');
     x = [x; xi];
     y = [y; yi];
   end  
end
disp('End of data entry')

%pause

%clc

% Interpolate the points with two splines, evaluated with a finer spacing.

%t = 1:n;
%ts = 1:1/10:n;
%xs = spline(t,x,ts);
%ys = spline(t,y,ts);

%pause

% Plot the interpolated curve with a cyan colored line.

%plot(xs,ys,'c-');
disp('pause');pause
echo off
hold off
close
disp(' ')
but = 3;
while ~(but == 0 | but == 1)
      disp(' ')
      but=input('Sollen die Werte abgespeichert werden (0=nein/1=ja) :');
      disp(' ')
end

if but == 1

   datname=input('Name der Datei Matrixx-ASCII-Format (z.B. test.saa) :','s');
   disp(' ')
   [fid, message] = fopen(datname,'w');
   if fid <= 2
      disp(message)
   else
      namex=input('Name für X-Vektor (z.B. xgraf) :','s');
      disp(' ')
      matsav(fid,namex,x);
      namey=input('Name für Y-Vektor (z.B. ygraf) :','s');
      disp(' ')
      matsav(fid,namey,y);
   end   
   fclose(fid);
end   
   
disp('End')
