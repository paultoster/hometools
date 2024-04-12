function vec_filt = lbf_filter(vec_in,CutOffFreq,SampleFreq,zero_phase)

  if( ~exist('zero_phase','var') )
    zero_phase = 0;
  end
  
[n,m] = size(vec_in);

if( m > n )
    vec_in = vec_in';
    n      = m;
end
vec_in = vec_in(:,1);
vec_filt = zeros(n,1);

SampleFreq = abs(SampleFreq);
if( SampleFreq < 0.000000001)
    
    error('lbf_filter_error: SampleFreq is zero');
end
 %
%  Lowpass Butterworth Filter (lbf)
%
wb = tan(pi*CutOffFreq / SampleFreq );
ab = wb*wb;
bb = 2*(ab-1);
cb = ab-sqrt(2)*wb+1;
db = ab+sqrt(2)*wb+1;
nb(7) = ab;
nb(8) = bb;
nb(9) = cb;
if( abs(db) < 0.0000001 )
    nb(10) = 0.0000001;
else
    nb(10) = db;
end
            
            
nb(1) = vec_in(1);
nb(2) = vec_in(1);
nb(3) = vec_in(1);
nb(4) = vec_in(1);
nb(5) = vec_in(1);
nb(6) = vec_in(1);

for m = 2:length(vec_filt)
    
    nb(6) = nb(5);
    nb(5) = nb(4);
    nb(4) = vec_in(m);
    nb(3) = nb(2);
    nb(2) = nb(1);
    nb(1) = (nb(7)*(nb(4)+2*nb(5)+nb(6)) - nb(8)*nb(2) - nb(9)*nb(3))/nb(10);
    
    vec_filt(m) = nb(1);
end

  if( zero_phase )

    [R0, lags0] = sxcorr(vec_in);
    [R, lags]   = sxcorr(vec_in,vec_filt);

    [R0max,iR0max] = max(R0);
    [Rmax,iRmax]   = max(R);

    di            = iR0max - iRmax;

    if( di > 0 )

      for i=1:n-di
        vec_filt(i)  = vec_filt(i+di);
      end

      nb(1) = vec_in(n-di);
      nb(2) = vec_in(n-di);
      nb(3) = vec_in(n-di);
      nb(4) = vec_in(n-di);
      nb(5) = vec_in(n-di);
      nb(6) = vec_in(n-di);
      for i=n-di+1:n
        nb(6) = nb(5);
        nb(5) = nb(4);
        nb(4) = vec_in(i);
        nb(3) = nb(2);
        nb(2) = nb(1);
        nb(1) = (nb(7)*(nb(4)+2*nb(5)+nb(6)) - nb(8)*nb(2) - nb(9)*nb(3))/nb(10);
        vec_filt(i) = nb(1);
      end
    end
  end
