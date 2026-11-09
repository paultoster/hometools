function Berechne_Vektor_param_er60(x,y,ymin,ymax)
%
% Berechne_Vektor_param_er60(x,y)
%
% Es wird der Vektor für eine Tabelle in paramxx.c im er60 generiert
% In der Tabelle ist Offset und Gradient enthalten, anstatt die einzelnen
% Werte
% Beispiel im er60-Code
% const signed_int16_t TAB[11] = 
% {
%  0, 1000, 3, 3000, 10000, 0, 0, -664, 0, 0, 68, 
% /*   XY0:[0|0]  XY1:[3000|0]  XY2:[10000|0]  XY3:[25000|996]  */
% };
% 
% TAB[0] Minwert = 0
% TAB[1] Maxwert = 1000
% TAB[2] Anzahl der deltas = 3
% TAB[3] X1
% TAB[4] X2
% TAB[5] OFF0
% TAB[6] OFF1
% TAB[7] OFF2
% TAB[7] GRAD0
% TAB[8] GRAD1
% TAB[9] GRAD2
%

if( ~exist('x','var') )
    x = [0,3000,10000,25000];
    y = [0,0   ,0    ,996];
    ymax = 1000;
    ymin = 0;
end

if( ~exist('ymin','var') )
    ymin   = min(y);
end
if( ~exist('ymax','var') )
    ymax   = max(y);
end
n      = min(length(x),length(y));
nrange = n-1;

X = x(2:nrange);

for i=1:nrange
    
    GRAD(i) = (y(i+1)-y(i))/(x(i+1)-x(i));
    OFF(i)  = y(i) - GRAD(i)*x(i);
    GRAD(i) = GRAD(i)*1024;
end

ymin = round(ymin);
ymax = round(ymax);
X    = round(X);
OFF  = round(OFF);
GRAD = round(GRAD);


fid = fopen('dump.txt','w');

if( fid ~= -1 )
    
    fprintf(fid,'\n\nconst signed_int16_t TAB[%s] = \n{\n',num2str(3+length(X)+length(OFF)+length(GRAD)));
    fprintf(fid,' %s,',num2str(ymin));
    fprintf(fid,' %s,',num2str(ymax));
    fprintf(fid,' %s,',num2str(nrange));
    for i=1:length(X)
        fprintf(fid,' %s,',num2str(X(i)));
    end
    for i=1:length(OFF)
        fprintf(fid,' %s,',num2str(OFF(i)));
    end
    for i=1:length(GRAD)
        fprintf(fid,' %s,',num2str(GRAD(i)));
    end
    fprintf(fid,'\n/*   ');
    for i=1:n
        fprintf(fid,'XY%s:[%s|%s]  ',num2str(i-1),num2str(x(i)),num2str(y(i)));
    end
    fprintf(fid,'*/\n};\n');
    
    fclose(fid)
end

edit('dump.txt');
        
        


    

