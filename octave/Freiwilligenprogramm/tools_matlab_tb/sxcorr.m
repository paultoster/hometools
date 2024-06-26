% Copyright (C) 1999-2001 Paul Kienzle
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; If not, see <http://www.gnu.org/licenses/>.
% usage: [R, lag] = xcorr (X [, Y] [, maxlag] [, scale])
%
% Estimate the cross correlation R_xy(k) of vector arguments X and Y
% or, if Y is omitted, estimate autocorrelation R_xx(k) of vector X,
% for a range of lags k specified by  argument 'maxlag'.  If X is a
% matrix, each column of X is correlated with itself and every other
% column.
%
% The cross-correlation estimate between vectors 'x' and 'y' (of
% length N) for lag 'k' is given by 
%    R_xy(k) = sum_{i=1}^{N}{x_{i+k} conj(y_i),
% where data not provided (for example x(-1), y(N+1)) is zero.
%
% ARGUMENTS
%  X       [non-empty; real or complex; vector or matrix] data
%
%  Y       [real or complex vector] data
%          If X is a matrix (not a vector), Y must be omitted.
%          Y may be omitted if X is a vector; in this case xcorr
%          estimates the autocorrelation of X.
%
%  maxlag  [integer scalar] maximum correlation lag
%          If omitted, the default value is N-1, where N is the
%          greater of the lengths of X and Y or, if X is a matrix,
%          the number of rows in X.
%
%  scale   [character string] specifies the type of scaling applied
%          to the correlation vector (or matrix). is one of:
%    'none'      return the unscaled correlation, R,
%    'biased'    return the biased average, R/N, 
%    'unbiased'  return the unbiassed average, R(k)/(N-|k|), 
%    'coeff'     return the correlation coefficient, R/(rms(x).rms(y)),
%          where 'k' is the lag, and 'N' is the length of X.
%          If omitted, the default value is 'none'.
%          If Y is supplied but does not have the ame length as X,
%          scale must be 'none'.
%          
% RETURNED VARIABLES
%  R       array of correlation estimates
%  lag     row vector of correlation lags [-maxlag:maxlag]
%
%  The array of correlation estimates has one of the following forms.
%    (1) Cross-correlation estimate if X and Y are vectors.
%    (2) Autocorrelation estimate if is a vector and Y is omitted,
%    (3) If X is a matrix, R is an matrix containing the cross-
%        correlation estimate of each column with every other column.
%        Lag varies with the first index so that R has 2*maxlag+1
%        rows and P^2 columns where P is the number of columns in X.
%        If Rij(k) is the correlation between columns i and j of X
%             R(k+maxlag+1,P*(i-1)+j) == Rij(k)
%        for lag k in [-maxlag:maxlag], or
%             R(:,P*(i-1)+j) == xcorr(X(:,i),X(:,j)).
%        'reshape(R(k,:),P,P)' is the cross-correlation matrix for X(k,:).
%
% The cross-correlation estimate is calculated by a 'spectral' method
% in which the FFT of the first vector is multiplied element-by-element
% with the FFT of second vector.  The computational effort depends on
% the length N of the vectors and is independent of the number of lags
% requested.  If you only need a few lags, the 'direct sum' method may
% be faster:
%
% Ref: Stearns, SD and David, RA (1988). Signal Processing Algorithms.
%      New Jersey: Prentice-Hall.
% unbiased:
%  ( hankel(x(1:k),[x(k:N); zeros(k-1,1)]) * y ) ./ [N:-1:N-k+1](:)
% biased:
%  ( hankel(x(1:k),[x(k:N); zeros(k-1,1)]) * y ) ./ N
%
% If length(x) == length(y) + k, then you can use the simpler
%    ( hankel(x(1:k),x(k:N-k)) * y ) ./ N
%
% 2010-04  Peter Lanspeary, <peter.lanspeary@.adelaide.edu.au>
%       1) Fix failure to pad result with zeros when excess lags required.
%       2) Improve documentation string.
%       3) Fix argument checks.
% 2008-11-12  Peter Lanspeary, <pvl@mecheng.adelaide.edu.au>
%       1) fix incorrectly shifted return value (when X and Y vectors have
%          unequal length) - bug reported by <stephane.brunner@gmail.com>.
%       2) scale='coeff' should give R=raw/(rms(x).rms(y)); fixed.
%       3) restore use of autocorrelation code when isempty(Y).
%       4) imaginary part of cross correlation had wrong sign; fixed.
%       5) use R.' rather than R' to correct the shape of the result
% 2004-05 asbjorn dot sabo at broadpark dot no
%     - Changed definition of cross correlation from 
%       sum{x(i)y(y+k)} to sum(x(i)y(i-k)}  (Note sign change.)
%       Results are now returned in reverse order of before.
%       The function is now compatible with Matlab (and with f.i.
%       'Digital Signal Processing' by Proakis and Manolakis).
% 2000-03 pkienzle@kienzle.powernet.co.uk
%     - use fft instead of brute force to compute correlations
%     - allow row or column vectors as input, returning same
%     - compute cross-correlations on columns of matrix X
%     - compute complex correlations consitently with matlab
% 2000-04 pkienzle@kienzle.powernet.co.uk
%     - fix test for real return value
% 2001-02-24 Paul Kienzle
%     - remove all but one loop
% 2001-10-30 Paul Kienzle <pkienzle@users.sf.net>
%     - fix arg parsing for 3 args
% 2001-12-05 Paul Kienzle <pkienzle@users.sf.net>
%     - return lags as vector rather than range

function [R, lags] = sxcorr (X, Y, maxlag, scale)
  
  if (nargin < 1 || nargin > 4)
    usage ('[c, lags] = xcorr(x [, y] [, h] [, scale])');
  end

  % assign arguments that are missing from the list
  % or reassign (right shift) them according to data type
  if nargin==1
    Y=[]; maxlag=[]; scale=[];
  elseif nargin==2
    maxlag=[]; scale=[];
    if ischar(Y), scale=Y; Y=[];
    elseif isscalar(Y), maxlag=Y; Y=[];
    end
  elseif nargin==3
    scale=[];
    if ischar(maxlag), scale=maxlag; maxlag=[]; end
    if isscalar(Y), maxlag=Y; Y=[]; end
  end

  % assign defaults to missing arguments
  if isvector(X) 
    % if isempty(Y), Y=X; end  % this line disables code for autocorr'n
    N = max(length(X),length(Y));
  else
    N = rows(X);
  end
  if isempty(maxlag), maxlag=N-1; end
  if isempty(scale), scale='coeff'; end

  % check argument values
  if isempty(X) || isscalar(X) || ischar(Y) || ~isnumeric(X)
    error('xcorr: X must be a vector or matrix'); 
  end
  if isscalar(Y) || ischar(Y) || (~isempty(Y) && ~isvector(Y))
    error('xcorr: Y must be a vector');
  end
  if ~isempty(Y) && ~isvector(X)
    error('xcorr: X must be a vector if Y is specified');
  end
  if ~isscalar(maxlag) || ~isreal(maxlag) || maxlag<0 || fix(maxlag)~=maxlag
    error('xcorr: maxlag must be a single non-negative integer'); 
  end
  %
  % sanity check on number of requested lags
  %   Correlations for lags in excess of +/-(N-1)
  %    (a) are not calculated by the FFT algorithm,
  %    (b) are all zero; so provide them by padding
  %        the results (with zeros) before returning.
  if (maxlag > N-1)
    pad_result = maxlag - (N - 1);
    maxlag = N - 1;
    %error('xcorr: maxlag must be less than length(X)'); 
  else
    pad_result = 0;
  end
  if isvector(X) && isvector(Y) && length(X) ~= length(Y) && ...
  ~strcmp(scale,'none')
    error('xcorr: scale must be ''none'' if length(X) ~= length(Y)')
  end
    
  [P0,P] = size(X);
  M = 2^nextpow2(N + maxlag);
  if ~isvector(X) 
    % For matrix X, correlate each column 'i' with all other 'j' columns
    R = zeros(2*maxlag+1,P^2);

    % do FFTs of padded column vectors
    pre = fft (postpad (prepad (X, N+maxlag), M) ); 
    post = conj (fft (postpad (X, M)));

    % do autocorrelations (each column with itself)
    %  -- if result R is reshaped to 3D matrix (i.e. R=reshape(R,M,P,P))
    %     the autocorrelations are on leading diagonal columns of R,
    %     where i==j in R(:,i,j)
    cor = ifft (post .* pre);
    R(:, 1:P+1:P^2) = cor (1:2*maxlag+1,:);

    % do the cross correlations
    %   -- these are the off-diagonal colummn of the reshaped 3D result
    %      matrix -- i~=j in R(:,i,j)
    for i=1:P-1
      j = i+1:P;
      cor = ifft( pre(:,i*ones(length(j),1)) .* post(:,j) );
      R(:,(i-1)*P+j) = cor(1:2*maxlag+1,:);
      R(:,(j-1)*P+i) = conj( flipud( cor(1:2*maxlag+1,:) ) );
    end
  elseif isempty(Y)
    % compute autocorrelation of a single vector
    post = fft( postpad(X(:),M) );
    cor = ifft( post .* conj(post) );
    R = [ conj(cor(maxlag+1:-1:2)) ; cor(1:maxlag+1) ];
  else 
    % compute cross-correlation of X and Y
    %  If one of X & Y is a row vector, the other can be a column vector.
    pre  = fft( postpad( prepad( X(:), length(X)+maxlag ), M) );
    post = fft( postpad( Y(:), M ) );
    cor = ifft( pre .* conj(post) );
    R = cor(1:2*maxlag+1);
  end

  % if inputs are real, outputs should be real, so ignore the
  % insignificant complex portion left over from the FFT
  if isreal(X) && (isempty(Y) || isreal(Y))
    R=real(R); 
  end

  % correct for bias
  if strcmp(scale, 'biased')
    R = R ./ N;
  elseif strcmp(scale, 'unbiased')
    R = R ./ ( [ N-maxlag:N-1, N, N-1:-1:N-maxlag ]' * ones(1,columns(R)) );
  elseif strcmp(scale, 'coeff')
    % R = R ./ R(maxlag+1) works only for autocorrelation
    % For cross correlation coeff, divide by rms(X)*rms(Y).
    if ~isvector(X)
      % for matrix (more than 1 column) X
      rms = sqrt( sumsq(X) );
      R = R ./ ( ones(rows(R),1) * reshape(rms.'*rms,1,[]) );
    elseif isempty(Y)
      %  for autocorrelation, R(zero-lag) is the mean square.
      R = R / R(maxlag+1);
    else
      %  for vectors X and Y
      R = R / sqrt( sumsq(X)*sumsq(Y) );
    end
  elseif ~strcmp(scale, 'none')
    error('xcorr: scale must be ''biased'', ''unbiased'', ''coeff'' or ''none''');
  end
    
  % Pad result if necessary
  %  (most likely is not required, use 'if' to avoid uncessary code)
  % At this point, lag varies with the first index in R;
  %  so pad **before** the transpose.
  if pad_result
    R_pad = zeros(pad_result,columns(R));
    R = [R_pad; R; R_pad];
  end
  % Correct the shape (transpose) so it is the same as the first input vector
  if isvector(X) && P > 1
    R = R.'; 
  end

  % return the lag indices if desired
  if nargout == 2
    maxlag = maxlag + pad_result;
    lags = [-maxlag:maxlag];
  end

end

%------------ Use brute force to compute the correlation -------
%if ~isvector(X) 
%  % For matrix X, compute cross-correlation of all columns
%  R = zeros(2*maxlag+1,P^2);
%  for i=1:P
%    for j=i:P
%      idx = (i-1)*P+j;
%      R(maxlag+1,idx) = X(i)*X(j)';
%      for k = 1:maxlag
%  	    R(maxlag+1-k,idx) = X(k+1:N,i) * X(1:N-k,j)';
%  	    R(maxlag+1+k,idx) = X(k:N-k,i) * X(k+1:N,j)';
%      end
%	if (i~=j), R(:,(j-1)*P+i) = conj(flipud(R(:,idx))); end
%    end
%  end
%elseif isempty(Y)
%  % reshape X so that dot product comes out right
%  X = reshape(X, 1, N);
%    
%  % compute autocorrelation for 0:maxlag
%  R = zeros (2*maxlag + 1, 1);
%  for k=0:maxlag
%  	R(maxlag+1+k) = X(1:N-k) * X(k+1:N)';
%  end
%
%  % use symmetry for -maxlag:-1
%  R(1:maxlag) = conj(R(2*maxlag+1:-1:maxlag+2));
%else
%  % reshape and pad so X and Y are the same length
%  X = reshape(postpad(X,N), 1, N);
%  Y = reshape(postpad(Y,N), 1, N)';
%  
%  % compute cross-correlation
%  R = zeros (2*maxlag + 1, 1);
%  R(maxlag+1) = X*Y;
%  for k=1:maxlag
%  	R(maxlag+1-k) = X(k+1:N) * Y(1:N-k);
%  	R(maxlag+1+k) = X(k:N-k) * Y(k+1:N);
%  end
%end
%--------------------------------------------------------------

function y = postpad(x,l,c)

% postpad(x,l)
% Appends zeros to the vector x until it is of length l.
% postpad(x,l,c) appends the constant c instead of zero.
%
% If length(x) > l, elements from the end of x are removed
% until a vector of length l is obtained.

% Author:
%  Tony Richardson
%  amr@mpl.ucsd.edu
%  June 1994

  if(nargin == 2)
    c = 0;
  elseif(nargin<2 || nargin>3)
    usage ('postpad(x,l) or postpad(x,l,c)');
  end

  if(is_matrix(x))
    error('first argument must be a vector');
  elseif(~is_scalar(l))
    error('second argument must be a scaler');
  end

  if(l<0)
    error('second argument must be non-negative');
  end

  lx = length(x);

  if(lx >= l)
    y = x(1:l);
  else
    if(rows(x)>1)
      y = [ x; c*ones(l-lx,1) ];
    else
      y = [ x c*ones(1,l-lx) ];
    end
  end

end

function y = prepad(x,l,c)
%prepad(x,l)
%Prepends zeros to the vector x until it is of length l.
%prepad(x,l,c) prepends the constant c instead of zero.
%
%If length(x) > l, elements from the beginning of x are removed
%until a vector of length l is obtained.

% Author:
%  Tony Richardson
%  amr@mpl.ucsd.edu
%  June 1994


  if(nargin == 2)
    c = 0;
  elseif(nargin<2 || nargin>3)
    usage ('prepad(x,l) or prepad(x,l,c)');
  end

  [nx,mx] = size(x);
  nl      = length(l);
  if( (nx > 1) && (mx > 1))
    error('first argument must be a vector');
  elseif(nl > 1)
    error('second argument must be a scaler');
  end

  if(l<0)
    error('second argument must be non-negative');
  end

  lx = length(x);

  if(lx >= l)
    y = x(lx-l+1:lx);
  else
    if(rows(x)>1)
      y = [ c*ones(l-lx,1); x ];
    else
      y = [ c*ones(1,l-lx) x ];
    end
  end

end
function nrow = rows(x)

 [nrow,ncol] = size(x);
 
end
function flag = is_matrix(x)

  [nrow,ncol] = size(x);
 
  if( nrow > 1 && ncol > 1 )
    flag = 1;
  else
    flag = 0;
  end
end
function flag = is_scalar(x)

  [nrow,ncol] = size(x);
 
  if( nrow == 1 && ncol == 1 )
    flag = 1;
  else
    flag = 0;
  end
end
function sum = sumsq(x)

  [n,m] = size(x);
  if( m > n )
    x = x';
    a = m;
    m = n;
    n = a;
  end
  sum = 0.;
  for i=1:m
    sum = sum + x(:,i)' * x(:,i);
  end
  sum = sqrt(sum);
end