function [S,okay,errtext] = osm_data_read(filename)
%
% S = read_osm_data(filename)
%
% Liest Open-Streetmap Daten aus Datei
% auf http://www.openstreetmap.org/
% läßt sich eine xml-Datei map.osm % exportieren
% Diese wird hier eingelesen und ausgewertet
% output:
% S.node(i).id                Identifier
% S.node(i).Latitude          [deg] 
% S.node(i).Longitude         [deg]
% S.node(i).tag{j} = {'schlüsselwort','textwert'}
% S.way(i).id                 Identifier
% S.way(i).ref(j)             Liste node-Id zu diesem Stück Weg
% S.way(i).tag{j} = {'schlüsselwort','textwert'}
%                             z.B.
%                             {'name','Straßenname'}
%                             {'ref','Straßenbezeichnung'}
%                             {'highway','track'},{'highway','secondary'},.
%                             ..
%                             
% 
  S = [];
  okay = 1;
  errtext = '';

  if( ~exist(filename,'file') )
    okay = 0;
    errtext = sprintf('datei: <%s> konnte nicht gefunden werden',filename);
    return
  end

  try
    xDoc = xmlread(filename);
  catch
    okay = 0;
    errtext = sprintf('datei: <%s> konnte nicht gelesen werden',filename);
    return
  end  

  %================================================
  % node einlesen
  %================================================

  % Find a deep list of all listitem elements.
  allListItems = xDoc.getElementsByTagName('node');

  % Note that the item list index is zero-based.
  inode = 0;
  node  = [];
  for i = 0:allListItems.getLength-1

    item    = allListItems.item(i); 
    attList = item.getAttributes;
    inode   = inode + 1;
    flag    = 0;
    for j = 0:attList.getLength-1

        att = attList.item(j);
        switch( char(att.getName) )
          case 'id';
            node(inode).id = str2num(char(att.getTextContent));
            flag           = 1;
          case 'lat';
            node(inode).Latitude = str2double(att.getTextContent);
            flag                 = 1;
          case 'lon';
            node(inode).Longitude = str2double(att.getTextContent);
            flag                  = 1;
        end  
    end
    if( ~flag )
      inode = inode - 1;
    else
      node(inode).tag = read_osm_data_get_tag(item);
    end
    
  end
  
  S.node = node;


  %================================================
  % way einlesen
  %================================================

  % Find a deep list of all listitem elements.
  allListItems = xDoc.getElementsByTagName('way');

  % Note that the item list index is zero-based.
  iway = 0;
  way  = [];
  for i = 0:allListItems.getLength-1

    item    = allListItems.item(i); 
    attList = item.getAttributes;
    iway   = iway + 1;

    % Attribute-Liste
    %================
    flag    = 0;
    for j = 0:attList.getLength-1

        att = attList.item(j);
        switch( char(att.getName) )
          case 'id';
            way(iway).id = str2num(char(att.getTextContent));
            flag           = 1;
            break
        end  
    end
    if( ~flag )
      iway = iway - 1;
    else
      way(iway).ref  = read_osm_data_get_ref(item);
      way(iway).tag = read_osm_data_get_tag(item);
    end
  end

  S.way = way;

end
function ref = read_osm_data_get_ref(item)
%
  childNode = item.getFirstChild;
  iref      = 0;
  ref       = [];
  while ~isempty(childNode)

    %Filter out text, comments, and processing instructions.
    if childNode.getNodeType == childNode.ELEMENT_NODE

      switch char(childNode.getTagName)
        case 'nd';
          attList = childNode.getAttributes;
          for j = 0:attList.getLength-1
            att = attList.item(j);
            switch( char(att.getName) )
            case 'ref';
              iref                = iref+1;
              ref(iref) = str2num(char(att.getTextContent));
              break
            end
          end
      end
    end  % End IF
    childNode = childNode.getNextSibling;
  end  % End WHILE
end
function tag = read_osm_data_get_tag(item)
%
  childNode = item.getFirstChild;
  itag      = 0;
  tag       = {};
  while ~isempty(childNode)

    %Filter out text, comments, and processing instructions.
    if childNode.getNodeType == childNode.ELEMENT_NODE

      switch char(childNode.getTagName)
        case 'tag';
          kval = '';
          vval = '';
          attList = childNode.getAttributes;
          for j = 0:attList.getLength-1
            att = attList.item(j);
            switch( char(att.getName) )
            case 'k';
              kval = char(att.getTextContent);
            case 'v';
              vval = char(att.getTextContent);
            end
          end
          if( ~isempty(kval) && ~isempty(vval) )
            itag      = itag + 1;
            tag{itag} = {kval,vval};
          end
      end
    end  % End IF
    childNode = childNode.getNextSibling;
  end  % End WHILE
end
