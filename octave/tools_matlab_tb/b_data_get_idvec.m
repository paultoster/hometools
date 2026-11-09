function [idvec,chanvec]  = b_data_get_idvec(b,channel)
%
% idvec           = b_data_get_idvec(b,channel)
% [idvec,chanvec]  = b_data_get_idvec(b,channel)
%
% Gebe idvec (vector mit ids) von dem entsprechenden channel zurück
% chanvec         vektor gleicher Länge idvec mit channel
%
  if( ~data_is_bstruct_format_f(b) )
    error('%s: b hat nicht das richtige Datenformat b.time(i), b.id(i), b.channel(i), b.len(i), b.byte0(i), ...  b.byte7(i), d.receive(i)',mfilename);
  end
  if( ~exist('channel','var') )
    error('%s_error: channel fehlt',mfilename);
  end
  idvec = [];
  for i=1:length(b.time)

    if( b.channel(i) == channel )
      index_liste = find_val_in_vec(idvec,b.id(i),0.1);
      if( isempty(index_liste) )
        idvec = [idvec,b.id(i)];
      end
    end
  end
  chanvec = idvec*0 + channel;
end
