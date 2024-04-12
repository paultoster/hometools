function  [okay,c_dirname,s_prot,s_remote] = o_abfragen_dir_f(s_frage,s_prot,s_remote)
%
% [okay,c_dirname,s_prot,s_remote] = o_abfragen_dir_f(s_frage,s_prot,s_remote);
%
% Abfrage auf ein Verzeichnis mit gui
% s_frage.comment       % Kommentar
% s_frage.command       % Kommando fürs Protokoll
% s_frage.start_dir     % Start-Verzeichnis zum suchen
% s_frage.multi_dir     % 0 ein Verzeichnis auchen 1: beliebige
%                       % Unterverzeichnisse finden
%
% comment           enthält Kommentar für Abfrage
%
% s_prot        Enthält Struktur für Protokollausgabe
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%
%
okay = 1;
prot_flag = 1;
remote_flag = 1;
debug_fid = 0;
multi_dir = 0;
c_dirname = {};
if( nargin == 0 )
    prot_flag = 0;
    comment   = 'Wähle Verzeichnis aus';
    start_dir = '.';
else
    if( isstruct(s_frage) )
        if( ~isfield(s_frage,'command') )
            prot_flag = 0;
            remote_flag = 0;
        else
            command = s_frage.command;
        end
        if( ~isfield(s_frage,'comment') )
            comment = 'Wähle Verzeichnis aus';
        else
            comment = s_frage.comment;
        end
        if( ~isfield(s_frage,'start_dir') )
            start_dir = '.';
        else
            start_dir = s_frage.start_dir;
        end
        if( isfield(s_frage,'multi_dir') )
            multi_dir = s_frage.multi_dir;
        end
    else
     prot_flag = 0;
     comment   = 'Wähle Verzeichnis aus';
     start_dir = '.';
    end
end

if( nargin <= 1 )
    
    prot_flag = 0;
else
    if( ~strcmp(class(s_prot),'struct') )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid;
    end
end    
    
if( nargin <= 2 )
    
    remote_flag = 0;
else
    if( ~strcmp(class(s_remote),'struct') )
        remote_flag = 0;
    elseif( ~s_remote.run_flag )
        remote_flag = 0;
    end
end    


if( remote_flag )
    end_flag = 0;
    icount   = 0;

    while( ~end_flag )
        [ok_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
        if( ok_flag == 0 | (ok_flag == 2 & icount == 0 )  )
            remote_flag = 0;
            end_flag = 1;
        else
            if( (length(remote_command) == 0) )
                if( icount == 0 )
                    remote_flag = 0;
                end
                end_flag = 1;
                
            elseif( strcmp(c_type{1},'char') & strcmp(remote_command,command)  )
                icount = icount + 1;
                c_dirname{icount} = char(c_value{1});
            else
                [ok_flag,s_remote] = o_remote_f(s_remote,2);
                end_flag = 1;
            end
        end

%         if( icount == 0 & (~ok_flag | ~strcmp(c_type{1},'char')) )
%             remote_flag = 0;
%             end_flag = 1;
%         else
%             if( strcmp(remote_command,command)  )
%                 icount = icount + 1;
%                 c_dirname{icount} = c_value{1};
%             else
%                 [ok_flag,s_remote] = o_remote_f(s_remote,2);
%                 end_flag = 1;
%             end
%         end
    end
    
    if( icount == 0 )
        remote_flag = 0;
        a=sprintf('\no_abfragen_dir_f:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
        o_ausgabe_f(a,debug_fid);
        a=sprintf('entspricht nicht dem gesuchten command <%s>:\n',command);
        o_ausgabe_f(a,debug_fid);
    end
    
end

if( ~remote_flag )
        
    if( ~multi_dir )
        c_dirname{1} = uigetdir(start_dir,comment);
        if( ~strcmp(class(c_dirname{1}),'char') )
            okay = 0;
        end
    else
         % Startverzeichnis scannen
         root_dir = start_dir;
         if( root_dir(length(root_dir)) == '\' )
             root_dir = root_dir(1:length(root_dir)-1);
         end
         run_dir = 1;
         while( run_dir )
             
             c_liste = o_abfragen_dir_dir_f(root_dir);        
             [selection,okay] = o_abfragen_dir_listdlg_f('name','Verzeichnis wählen' ...
                                                        ,'PromptString',root_dir ...
                                                        ,'ListSize',[500 400] ...
                                                        ,'ListString',c_liste ...
                                                        ,'SelectionMode','multiple'...
                                                        );
             if( okay == 0 ) % Cancel
                 run_dir = 0;
                 
             elseif( okay == 1 ) % Ok              
                 if( length(selection) == 1 && strcmp(c_liste(selection(1)),'.') )
                     j = 0;
                     for i=1:length(c_liste)
                         if( strcmp(c_liste(i),'.') && strcmp(c_liste(i),'..') )
                            j = j+1;
                            c_dirname{j} = [root_dir,'\',c_liste{i}];
                        end
                     end
                 elseif( length(selection) == 1 && strcmp(c_liste(selection(1)),'..') )
                     c_dirname{1} = root_dir;
                 else
                     j = 0;
                     for i=1:length(selection)
                         k = selection(i);
                         if( ~strcmp(c_liste{k},'..') && ~strcmp(c_liste{k},'.') )
                             j = j+1;
                             c_dirname{j} =  [root_dir,'\',c_liste{k}];
                         end
                     end
                 end
                 if( ~isempty(c_dirname) )
                     run_dir = 0; % Beenden
                 end
             else % Verzeichnis wechseln
                 if( strcmp(c_liste{selection(1)},'.') )
                     root_dir = root_dir;
                 elseif( strcmp(c_liste{selection(1)},'..') )
                     nf = max(strfind(root_dir,'\'));
                     if( ~isempty(nf) )
                         root_dir = root_dir(1:nf-1);
                         if( root_dir(nf-1) == ':' )
                             root_dir = [root_dir,'\'];
                         end
                     end
                 elseif( strcmp(c_liste{selection(1)},'...') )
                     root_dir = '...';
                 elseif( strcmp(root_dir,'...') )
                     root_dir = c_liste{selection(1)};
                 else
                     root_dir = [root_dir,'\',c_liste{selection(1)}];
                 end
             end
         end
    end
end

if( prot_flag && okay )
    n = length(c_dirname);
    for i=1:n
        s_prot.command = command;
        s_prot.val     = c_dirname{i};
        s_prot         = o_protokoll_f(3,s_prot);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c_dir_liste = o_abfragen_dir_dir_f(root_dir)

if( strcmp(root_dir,'...') ) % oberste Ebene
    j = 0;
    for i = 'a':'z'
        if exist([i ':\']) == 7
            j = j+1;
            dirlist(j).name  = [i ':'];
            dirlist(j).isdir = 1;
        end
    end

else
    if( root_dir(length(root_dir)) == ':' )
        root_dir = [root_dir,'\'];
    end
    dirlist = dir(root_dir);
end
j = 0;
c_dir_liste = {};
for i=1:length(dirlist)
        
    if( dirlist(i).isdir == 1 & ~strcmp(dirlist(i).name,'.') )
            j = j+1;
            c_dir_liste{j} = dirlist(i).name;
    end
end
found_flag = 0;
for i=1:j
    if( strcmp(c_dir_liste{i},'..') )
        found_flag = 1;
    end
end
if( ~found_flag )
    j = j+1;
    for i=j:-1:2
        c_dir_liste{i} = c_dir_liste{i-1};
    end
    c_dir_liste{1} = '...';
end
    

function [selection,value] = o_abfragen_dir_listdlg_f(varargin)
%LISTDLG  List selection dialog box.
%   [SELECTION,OK] = LISTDLG('ListString',S) creates a modal dialog box 
%   which allows you to select a string or multiple strings from a list.
%   SELECTION is a vector of indices of the selected strings (length 1
%   in the single selection mode).  This will be [] when OK is 0.
%   OK is 1 if you push the OK button, or 0 if you push the Cancel 
%   button or close the figure.
%   Double-clicking on an item or pressing <CR> when multiple items are
%   selected has the same effect as clicking the OK button.
%
%   Inputs are in parameter,value pairs:
%
%   Parameter       Description
%   'ListString'    cell array of strings for the list box.
%   'SelectionMode' string; can be 'single' or 'multiple'; defaults to
%                   'multiple'.
%   'ListSize'      [width height] of listbox in pixels; defaults
%                   to [160 300].
%   'InitialValue'  vector of indices of which items of the list box
%                   are initially selected; defaults to the first item.
%   'Name'          String for the figure's title. Defaults to ''.
%   'PromptString'  string matrix or cell array of strings which appears 
%                   as text above the list box.  Defaults to {}.
%   'OKString'      string for the OK button; defaults to 'OK'.
%   'CancelString'  string for the Cancel button; defaults to 'Cancel'.
%   'uh'            uicontrol button height, in pixels; default = 18.
%   'fus'           frame/uicontrol spacing, in pixels; default = 8.
%   'ffs'           frame/figure spacing, in pixels; default = 8.
%
%   A 'Select all' button is provided in the multiple selection case.
%
%   Example:
%     d = dir;
%     str = {d.name};
%     [s,v] = listdlg('PromptString','Select a file:',...
%                     'SelectionMode','single',...
%                     'ListString',str)
 
%   T. Krauss, 12/7/95, P.N. Secakusuma, 6/10/97
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1 $  $Date: 31.03.05 16:09 $

% simple test:
%
% d = dir; [s,v] = listdlg('PromptString','Select a file:','ListString',{d.name});
% 
error(nargchk(1,inf,nargin))

figname = '';
smode = 2;   % (multiple)
promptstring = {};
liststring = [];
listsize = [160 300];
initialvalue = [];
okstring = 'Ok';
cancelstring = 'Cancel';
gotostring = 'goto';
fus = 8;
ffs = 8;
uh = 18;

if mod(length(varargin),2) ~= 0
    % input args have not com in pairs, woe is me
    error('Arguments to LISTDLG must come param/value in pairs.')
end
for i=1:2:length(varargin)
    switch lower(varargin{i})
     case 'name'
      figname = varargin{i+1};
     case 'promptstring'
      promptstring = varargin{i+1};
     case 'selectionmode'
      switch lower(varargin{i+1})
       case 'single'
        smode = 1;
       case 'multiple'
        smode = 2;
      end
     case 'listsize'
      listsize = varargin{i+1};
     case 'liststring'
      liststring = varargin{i+1};
     case 'initialvalue'
      initialvalue = varargin{i+1};
     case 'uh'
      uh = varargin{i+1};
     case 'fus'
      fus = varargin{i+1};
     case 'ffs'
      ffs = varargin{i+1};
     case 'okstring'
      okstring = varargin{i+1};
     case 'cancelstring'
      cancelstring = varargin{i+1};
     otherwise
      error(['Unknown parameter name passed to LISTDLG.  Name was ' varargin{i}])
    end
end

if isstr(promptstring)
    promptstring = cellstr(promptstring); 
end

if isempty(initialvalue)
    initialvalue = 1;
end

if isempty(liststring)
    error('ListString parameter is required.')
end

ex = get(0,'defaultuicontrolfontsize')*1.7;  % height extent per line of uicontrol text (approx)

fp = get(0,'defaultfigureposition');
w = 2*(fus+ffs)+listsize(1);
h = 2*ffs+6*fus+ex*length(promptstring)+listsize(2)+uh+(smode==2)*(fus+uh);
fp = [fp(1) fp(2)+fp(4)-h w h];  % keep upper left corner fixed

fig_props = { ...
    'name'                   figname ...
    'resize'                 'off' ...
    'numbertitle'            'off' ...
    'menubar'                'none' ...
    'windowstyle'            'modal' ...
    'visible'                'off' ...
    'createfcn'              ''    ...
    'position'               fp   ...
    'closerequestfcn'        'delete(gcbf)' ...
            };

liststring=cellstr(liststring);

fig = figure(fig_props{:});

uicontrol('style','frame',...
          'position',[0 0 fp([3 4])])
uicontrol('style','frame',...
          'position',[ffs ffs 2*fus+listsize(1) 2*fus+uh])
uicontrol('style','frame',...
          'position',[ffs ffs+3*fus+uh 2*fus+listsize(1) ...
                    listsize(2)+3*fus+ex*length(promptstring)+(uh+fus)*(smode==2)])

if length(promptstring)>0
    prompt_text = uicontrol('style','text','string',promptstring,...
                            'horizontalalignment','left','units','pixels',...
                            'position',[ffs+fus fp(4)-(ffs+fus+ex*length(promptstring)) ...
                    listsize(1) ex*length(promptstring)]);
end

%btn_wid = (fp(3)-2*(ffs+fus)-fus)/2;
btn_wid = (fp(3)-3*(ffs+fus)-fus)/3;

listbox = uicontrol('style','listbox',...
                    'position',[ffs+fus ffs+uh+4*fus+(smode==2)*(fus+uh) listsize],...
                    'string',liststring,...
                    'backgroundcolor','w',...
                    'max',smode,...
                    'tag','listbox',...
                    'value',initialvalue, ...
                    'callback', {@doListboxClick});

ok_btn = uicontrol('style','pushbutton',...
                   'string',okstring,...
                   'position',[ffs+fus ffs+fus btn_wid uh],...
                   'callback',{@doOK,listbox});

cancel_btn = uicontrol('style','pushbutton',...
                       'string',cancelstring,...
                       'position',[ffs+2*fus+btn_wid ffs+fus btn_wid uh],...
                       'callback',{@doCancel,listbox});
                   
goto_btn = uicontrol('style','pushbutton',...
                       'string',gotostring,...
                       'position',[ffs+3*fus+2*btn_wid ffs+fus btn_wid uh],...
                       'callback',{@doGoto,listbox});

if smode == 2
    selectall_btn = uicontrol('style','pushbutton',...
                              'string','Select all',...
                              'position',[ffs+fus 4*fus+ffs+uh listsize(1) uh],...
                              'tag','selectall_btn',...
                              'callback',{@doSelectAll, listbox});

    if length(initialvalue) == length(liststring)
        set(selectall_btn,'enable','off')
    end
    set(listbox,'callback',{@doListboxClick, selectall_btn})
end

try
    set(fig, 'visible','on');
    uiwait(fig);
catch
    if ishandle(fig)
        delete(fig)
    end
end

if isappdata(0,'ListDialogAppData')
    ad = getappdata(0,'ListDialogAppData');
    selection = ad.selection;
    value = ad.value;
    rmappdata(0,'ListDialogAppData')
else
    % figure was deleted
    selection = [];
    value = 0;
end

function doOK(ok_btn, evd, listbox)
ad.value = 1;
ad.selection = get(listbox,'value');
setappdata(0,'ListDialogAppData',ad)
delete(gcbf);

function doCancel(cancel_btn, evd, listbox)
ad.value = 0;
ad.selection = [];
setappdata(0,'ListDialogAppData',ad)
delete(gcbf);

function doGoto(goto_btn, evd, listbox)
ad.value = 2;
ad.selection = get(listbox,'value');
setappdata(0,'ListDialogAppData',ad)
delete(gcbf);

function doSelectAll(selectall_btn, evd, listbox)
set(selectall_btn,'enable','off')
set(listbox,'value',1:length(get(listbox,'string')));

function doListboxClick(listbox, evd, selectall_btn)
% if this is a doubleclick, doOK
if strcmp(get(gcbf,'SelectionType'),'open')
    doGoto([],[],listbox);
elseif nargin == 3
    if length(get(listbox,'string'))==length(get(listbox,'value'))
        set(selectall_btn,'enable','off')
    else
        set(selectall_btn,'enable','on')
    end
end
    