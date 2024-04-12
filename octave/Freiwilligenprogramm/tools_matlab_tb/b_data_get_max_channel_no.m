function maxchannel  = b_data_get_max_channel_no(b)
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
  maxchannel = 0;
  for i=1:length(b.time)
    if( b.channel(i) > maxchannel )
      maxchannel = b.channel(i);
    end
  end
end
