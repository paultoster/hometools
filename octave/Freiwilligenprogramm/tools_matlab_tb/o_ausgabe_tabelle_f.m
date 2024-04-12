function okay = o_ausgabe_tabelle_f(varargin)
%
% okay = o_ausgabe_tabelle_f('vec_list',cvec ...
%                           ,'name_list',cnames ...
%                           ,'unit_list',cunits ...
%                           ,'title',title ...
%                           ,'debug_fid',debug_fid ...
%                           ,'screen_flag',screen_flag ...
%                           ,'excel_file',excel_file ...
%														,'m_file',m_file ....
%                           ,'frmt_list',cfrmt ...
%                           ;)
%
%                                   default
% 'vec_list'    cvec        cell    kein    Vektoren in Cell-Array geschrieben 
% 'name_list'   cnames      cell    {}      Vektornamen in Cell-Array geschrieben (Header) 
% 'unit_list'   cunits      cell    {}      Units in Cell-Array geschrieben (Header) 
% 'title'       title       char    ''      Überschrift
% 'debug_fid'   debug_fid   double  0       schreibt in Protokollfile, wenn gesetzt d.h > 0
% 'screen_flag' screen_flag double  0       nicht gesetzt(=0), dann keine Bildschirmausgabe
% 'excel_file'  excel_file  char    ''      Excelausgabe
% 'm_file'      m_file      char    ''      Ausgabe in ein M-File
% 'frmt_list'   cfrmt       cell    {}      Formatliste in Cell-Array geschrieben {'%10.3f',...}
%
% Beispiel:
%
% >> time = [0,2,4];
% >> vel  = [100,50,0];
% >> okay = o_ausgabe_tabelle_f('vec_list',{time,vel} ...
%                              ,'name_list',{'Zeit','Geschw.'} ...
%                              ,'unit_list',{'s','km/h'} ...
%                              ,'title','Geschw.-Tabelle' ...
%                              ,'debug_fid',0 ...
%                              ,'screen_flag',1 ...
%                              ,'excel_file','');
%
% --------------
% |Geschw.-Tabe|
% |    lle     |
% --------------
% |Zeit|Geschw.|
% --------------
% | s  | km/h  |
% --------------
% |  0 |  100  |
% |  2 |   50  |
% |  4 |    0  |
% --------------

okay        = 1;
irow_excel  = 0;

cvec        = {};
cname       = {};
cunit       = {};
tab_tit     = '';
debug_fid   = 0;
screen_flag = 1;
excel_file  = '';
m_file      = '';
cfrmt       = {};

i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'vec_list'
            cvec = varargin{i+1};
        case 'name_list'
            cname = varargin{i+1};
        case 'unit_list'
            cunit = varargin{i+1};
        case 'title'
            tab_tit = varargin{i+1};
        case 'debug_fid'
            debug_fid = varargin{i+1};
        case 'screen_flag'
            screen_flag = varargin{i+1};
        case 'excel_file'
            excel_file = varargin{i+1};
        case 'm_file'
            m_file = varargin{i+1};
        case 'frmt_list'
            cfrmt = varargin{i+1};
        otherwise
            if( ischar(varargin{i}) )
                tdum = sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i});
            elseif( isnumeric(varargin{i}) )
                tdum = sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i});
            else
                varargin{i}
                tdum = sprintf('%s: Attribut ist nicht okay',mfilename);
            end
            error(tdum)

    end
    i = i+2;
end

if( length(cvec) == 0 )
    error('Kein Vektor-Array als Parameter übergeben')
end
if( isnumeric(cvec) )
    cvec = {cvec};
end
if( ~iscell(cvec) )
   error('cvec (Der Parameter ''vec_list'' muss cellarray mit Vektoren oder CellArrays sein')
end
if( ~iscell(cname) || length(cname) == 0 )
    cname_flag = 0;
else
    cname_flag = 1;
    for i=1:length(cname)
        if( iscell(cname{i}) )
            cname{i} = cname{i}{1};
        end
        if( isnumeric(cname{i}) )
            cname{i} = num2str(cname{i}(1));
        end
        if( isstruct(cname{i}) )
             error('cname (Der Parameter ''name_list'' muss cellarray mit Character sein')
        end
    end
    for i=length(cname)+1:length(cvec)
        cname{i} = ''; 
    end
    
end
if( ~iscell(cunit) || length(cunit) == 0 )
    cunit_flag = 0;
else
    cunit_flag = 1;
    for i=1:length(cunit)
        if( iscell(cunit{i}) )
            cunit{i} = cunit{i}{1};
        end
        if( isnumeric(cunit{i}) )
            cunit{i} = num2str(cunit{i}(1));
        end
        if( isstruct(cunit{i}) )
             error('cunit (Der Parameter ''name_list'' muss cellarray mit Character sein')
        end
    end
    for i=length(cunit)+1:length(cvec)
        cunit{i} = ''; 
    end
    
end

if( ~ischar(tab_tit) )
    tab_tit_ '';
end
if( iscell(cfrmt) )
  nfrmt = length(cfrmt);
else
  nfrmt = 0;
end
% cname_flag = 0;
% cunit_flag = 0;
% cname = {};
% cunit = {};
% for i=1:length(header)
% 
%     if( ischar(header{i}) )
%         cname{i} = header{i};
%         cunit{i} = '';
%     elseif( iscell(header{i}) )
%         cname{i} = header{i}{1};
%         cunit{i} = header{i}{2};
%         if( ~ischar(cname{i}) || ~ischar(cunit{i}) )
%             header
%             error('Parameter header ist falsch definiert')
%         end
%     else
%         header
%         error('Parameter header ist falsch definiert')
%     end
%     
%     if( length(cname{i}) > 0 )
%         cname_flag =  1;
%     end
%     if( length(cunit{i}) > 0 )
%         cunit_flag =  1;
%     end
% end
        
if( ~exist('screen_flag','var') )
    screen_flag = 1;
end

% execl öffnen
%=============
if( ischar(excel_file) && ~isempty(excel_file) )
    
    excel_flag = 1;
    s_file = str_get_pfe_f(excel_file);
    [okay,s_e] = ausgabe_excel('init','path',s_file.dir,'name',excel_file,'visible',1);
    if( ~okay )
        return
    end
else
    excel_flag = 0;
end

% m-File öffnen
%==============
if( ischar(m_file) && ~isempty(m_file) )
    
    m_fid = fopen(m_file,'w');
    if( ~m_fid )
    		error('m-File %s konnte nicht geöffnet werden',m_file);
        return
    end
else
    m_fid = 0;
end



% Werte in stringswandeln
%========================
ccvec = {};
nmax = 0;
for i= 1:length(cvec)
    
    vec = cvec{i};
    if( isnumeric(vec) )
        [n,m] = size(vec);
        if( n == 1 ) % mache Spaltenvektor
            vec = vec';
            n   = m;
            m   = 1;
        end
        nmax = max(nmax,n);
        ctext = {};
        for im = 1:m
            if( i <= nfrmt )
              ctext{im} = num2str(vec(:,im),cfrmt{i});
            else
              ctext{im} = num2str(vec(:,im));
            end
        end
        ccvec{i}  = ctext; 
    elseif( iscell(vec) )
        
        n = length(vec);
        flag = 0;
        for ic=1:n
            if( ~ischar(vec{ic}) && ~isnumeric(vec{ic}) )
                flag = 1;
                break;
            end
            [nn,mm] = size(vec{ic});
            if( (nn > 1) && (mm > 1) )
              error('%i. Element von vec_list an der %i. Stelle im Eingangsvektor ist eine Matrix (n=%i x m=%i) anstatt eines einachen Strings',i,ic,nn,mm)
            end            
        end
        if( flag )
            error('Im Parametervektor soll in einem CellArray char oder numerisch sein')
        end
        for ic=1:n
            if( isnumeric(vec{ic}) )
                val = vec{ic};
                if( i <= nfrmt )
                  vec{ic} = num2str(val(1),cfrmt{i});
                else
                  vec{ic} = num2str(val(1));
                end
            end
        end
        
        ll = 0;
        for ic = 1:n
            ll = max(ll,length(vec{ic}));
        end
        vtext = [];
        for ic = 1:n
            try
            c = str_format(vec{ic},ll,'v','r');
            catch
              a = 0; % debuginput
            end
            vtext = [vtext;c{1}];
        end
        ctext{1} = vtext;
        ccvec{i}  = ctext;
        nmax = max(nmax,n);

    end
    
end

nccvec = length(ccvec);
% Breite
breite  = 1;
ebreite = [];
for i=1:nccvec
    
    cc = ccvec{i};
    m  = length(cc);
        
    ebreite(i) = 0;
    for im = 1:m
        [n,nn] = size(cc{im});
        breite = breite + nn+1;
        ebreite(i) = ebreite(i)+nn+1;
    end
    ebreite(i) = ebreite(i)-1;
    if( ~isempty(cname) && ~isempty(cunit) )
        ll = max(length(cname{i}),length(cunit{i}));
    elseif( ~isempty(cname)  )
        ll = length(cname{i});
    elseif( ~isempty(cunit)  )
        ll = length(cunit{i});
    else 
        ll = 0;
    end
    if( ebreite(i) < ll )
        breite = breite - ebreite(i);
        ebreite(i) = ll;
        breite = breite + ebreite(i);
    end
    
    if( ~isempty(cname) && ebreite(i) > length(cname{i}) )
        c         = str_format(cname{i},ebreite(i),'v','m');
        cname{i} = c{1};
    end
    if( ~isempty(cunit) && ebreite(i) > length(cunit{i}) )
        c         = str_format(cunit{i},ebreite(i),'v','m');
        cunit{i} = c{1};
    end
end

% Linie
linie = '';
for i=1:breite
    linie = [linie,'-'];
end

okay = o_ausgabe_f(linie,debug_fid,screen_flag,1);
if( ~okay ),return;end

% Titel anzeigen
if( length(tab_tit) > 0 )
    
    ctext = str_format(tab_tit,breite-2,'v','m');
    for i=1:length(ctext)
        texta = sprintf('|%s|',ctext{i});
        okay = o_ausgabe_f(texta,debug_fid,screen_flag,1);
        if( ~okay ),return;end
    end
    okay = o_ausgabe_f(linie,debug_fid,screen_flag,1);
    if( ~okay ),return;end
    
    
    if( excel_flag )
        irow_excel = 1;
        [okay,s_e] = ausgabe_excel('cat',s_e,'col',[1,nccvec],'row',irow_excel,'val',str_cut_ae_f(tab_tit,' '));
    end
    
    if( m_fid )
    
    	fprintf(m_fid,'%% %s',tab_tit);
    end
    	

end
% Header1 anzeigen
if( cname_flag )
    
    texta = '|';
    for i=1:length(cname)
        texta = [texta,cname{i},'|'];
    end
    okay = o_ausgabe_f(texta,debug_fid,screen_flag,1);
    if( ~okay ),return;end
    okay = o_ausgabe_f(linie,debug_fid,screen_flag,1);
    if( ~okay ),return;end
    
    if( excel_flag )
        irow_excel = irow_excel+1;
        for i=1:nccvec
            [okay,s_e] = ausgabe_excel('val',s_e,'col',i,'row',irow_excel,'val',str_cut_ae_f(cname{i},' '));
            if( ~okay ),return;end
        end
    end
    

end
% Header2 anzeigen
if( cunit_flag )
    
    texta = '|';
    for i=1:length(cunit)
        texta = [texta,cunit{i},'|'];
    end
    okay = o_ausgabe_f(texta,debug_fid,screen_flag,1);
    if( ~okay ),return;end
    okay = o_ausgabe_f(linie,debug_fid,screen_flag,1);
    if( ~okay ),return;end

    if( excel_flag )
        irow_excel = irow_excel+1;
        for i=1:nccvec
            [okay,s_e] = ausgabe_excel('val',s_e,'col',i,'row',irow_excel,'val',str_cut_ae_f(cunit{i},' '));
            if( ~okay ),return;end
        end
    end
end
% Tabelle
for in=1:nmax
    
    if( excel_flag )
        irow_excel = irow_excel+1;
    end
    textb = '';
    for ic=1:length(ccvec)

        texta = '';
        cc = ccvec{ic};
        m = length(cc);
        [n,nn] = size(cc{1});
                			        						
        if( n >= in )
            for im = 1:m
                texta = [texta,cc{im}(in,:),','];
            end
        else
            for i = 1:ebreite(ic)
                texta = [texta,' '];
            end
        end
        texta = texta(1:length(texta)-1);
        flip = 0;
        while( length(texta) < ebreite(ic) )
            if( flip )
                texta = [texta,' '];
                flip = 0;
            else
                texta = [' ',texta];
                flip = 1;
            end
        end
        textb = [textb,texta,'|'];
            
        if( excel_flag )
            dum = str2num(texta);
            if( length(dum) > 0 )
                [okay,s_e] = ausgabe_excel('val',s_e,'col',ic,'row',irow_excel,'val',dum);
            else
                [okay,s_e] = ausgabe_excel('val',s_e,'col',ic,'row',irow_excel,'val',str_cut_ae_f(texta,' '));
            end
            if( ~okay ),return;end
        end
    end
    textb = ['|',textb];
    okay = o_ausgabe_f(textb,debug_fid,screen_flag,1);
    if( ~okay ),return;end

end
okay = o_ausgabe_f(linie,debug_fid,screen_flag,1);
if( ~okay ),return;end

if( excel_flag )
    
    [okay,s_e] = ausgabe_excel('format',s_e,'col',[1:nccvec],'row',[1:irow_excel] ...
                              ,'col_width','auto','row_height','auto','border','all');
    if( ~okay ),return;end
                          
    [okay,s_e] = ausgabe_excel('save',s_e);
    if( ~okay ),return;end
    
end
    
if( m_fid ) 

    for ic=1:length(ccvec)
        % Header1
        if( cname_flag )    					
            if( ic <= length(cname) )
                    fprintf(m_fid,'%% %s\n',cname{ic});
            end
        end
        if( cunit_flag )    					
            if( ic <= length(cunit) )
                    fprintf(m_fid,'%% %s\n\n',cunit{ic});
            end
        end
        if( cname_flag && ic <= length(cname) )
                    fprintf(m_fid,'%s = ',cname{ic});
        else
                    fprintf(m_fid,'%s =',['vec',num2str(ic)]);
        end
        
        cc = ccvec{ic};
        m = length(cc);
        [n,nn] = size(cc{1});    
        
        for irow = 1:n

            if( irow == 1 && (n > 1 || m > 1) )        				
                fprintf(m_fid,'[');
            end


            for icol = m
                fprintf(m_fid,'%s',cc{icol}(irow,:));

                if( icol <m )
                        fprintf(m_fid,',');
                end
            end

            if( irow < n )    				
                fprintf(m_fid,';');
            end

        end
        if( n > 1 && nn > 1 )        				
            fprintf(m_fid,'];\n\n');
        else
            fprintf(m_fid,';\n\n');
        end

    end
    fclose(m_fid);
    m_fid = 0; 
    fprintf('\n\no_ausgabe_tabelle_f:  Daten im m-File-Format in Datei %s abgelegt\n\n',m_file);
end