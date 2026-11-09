function filt_val = pt1_filter_online(unfilt_val,filt_old_val,sampling_time_ms,time_constant_ms,sc_fac)

filt_val = fix((floor(time_constant_ms*sc_fac)-floor(sampling_time_ms*sc_fac))/time_constant_ms);
filt_val = fix(filt_val*(filt_old_val - unfilt_val));
filt_val = fix(filt_val/sc_fac);
filt_val = fix(filt_val+unfilt_val);

