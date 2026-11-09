function e = e_data_make_double(e)
%
% e = e_data_make_double(e)
%
% Wandelt alle e.(signame).time und e.(signame).vec in double
%

  cnames = fieldnames(e);
  n      = length(cnames);

  for i=1:n
    if( ~isa(e.(cnames{i}).time,'double') )
      e.(cnames{i}).time = double(e.(cnames{i}).time);
    end

    if( iscell(e.(cnames{i}).vec) )
      for j=1:length(e.(cnames{i}).vec)

        c = e.(cnames{i}).vec{j};
        if( ~isempty(c) && ~isa(c,'double') )
          e.(cnames{i}).vec{j} = double(c);
        end
      end
    else
      if( ~isa(e.(cnames{i}).vec,'double') )
        e.(cnames{i}).vec = double(e.(cnames{i}).vec);
      end
    end    
  end
end