function Ssig = proofSsig(Ssig)
%
% Ssig = proofSsig(Ssig)
%   Ssig(i).name_in      = 'signal name';
%   Ssig(i).unit_in      = 'dbc unit';              (default '')
%   Ssig(i).lin_in       = 0/1;                     (default 0)
%   Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%   Ssig(i).name_out     = 'output signal name';    (default name_in)
%   Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%   Ssig(i).comment      = 'description';           (default '')
%
%   Wenn Teile fehlen (mit default gekennzeichnet) werden die default-Werte
%   benutzt (bei Ssig(i).unit_out = 'unit_in' heisst die Einheit aus
%   unit_in wird verwendet

  nsig = length(Ssig);
  if( ~isfield(Ssig,'name_in') )
    error('%s_error: Ssig.name_in muss vorhanden sein',mfilename)
  end
  if( ~isfield(Ssig,'unit_in') ),      Ssig(1).unit_in = [];      end
  if( ~isfield(Ssig,'lin_in') ),       Ssig(1).lin_in = [];       end
  if( ~isfield(Ssig,'name_sign_in') ), Ssig(1).name_sign_in = []; end
  if( ~isfield(Ssig,'name_out') ),     Ssig(1).name_out = [];     end
  if( ~isfield(Ssig,'unit_out') ),     Ssig(1).unit_out = [];     end
  if( ~isfield(Ssig,'comment') ),      Ssig(1).comment = [];      end
  for isig = 1:nsig
    
%     if( strcmp(Ssig(isig).name_in,'ACC_MODE') )
%       a = 1;
%     end
    
    if( isempty(Ssig(isig).name_in) )
      error('%s_error: Ssig(%i).name_in ist leer, muss einen Input Signalnamen haben',mfilename,isig)
    end
    if( ~ischar(Ssig(isig).unit_in) && isempty(Ssig(isig).unit_in) )
      Ssig(isig).unit_in = '';
    end
    if( isempty(Ssig(isig).lin_in) )
      Ssig(isig).lin_in = 0;
    end
    if( ~ischar(Ssig(isig).name_sign_in) && isempty(Ssig(isig).name_sign_in) )
      Ssig(isig).name_sign_in = '';
    end
    if( isempty(Ssig(isig).name_out) )
      Ssig(isig).name_out = Ssig(isig).name_in;
    end
    if( ~ischar(Ssig(isig).comment) && isempty(Ssig(isig).comment) )
      Ssig(isig).comment = '';
    end
    if( isempty(Ssig(isig).unit_out) )
      Ssig(isig).unit_out = Ssig(isig).unit_in;
    end
  end
end
