s_duh_ectrl.new = 1;
s_duh_ectrl.old = 0;

ip = 0;
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.lbf_filter';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_read.mat';
ip = ip+1;s_duh_ectrl.remote{ip} = 'mat_data_file = D:\messungen\sba\LAV029\dspa_LAV029012.mat';
ip = ip+1;s_duh_ectrl.remote{ip} = 'mat_data_file = D:\messungen\sba\LAV030\dspa_LAV030009.mat';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.lbf_filter';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = [1,2]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'signal = [Pedalweg,TrBP1Raw]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'cutoff_freq = 10';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.lbf_filter';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = [1,2]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'signal = [Pedalkraft,Pedalweg]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'cutoff_freq = 10';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.lbf_filter';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = [1,2]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'signal = [Pedalkraft,Pedalweg]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'cutoff_freq = 10';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.end';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_organize.delete_data_set';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = 2';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_organize.copy_data_set';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = 1';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_calc.lbf_filter';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = 2';
ip = ip+1;s_duh_ectrl.remote{ip} = 'signal = TrBP1Raw';
ip = ip+1;s_duh_ectrl.remote{ip} = 'cutoff_freq = 10';
ip = ip+1;s_duh_ectrl.remote{ip} = '.data_plot.simple';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_set = [dspa_LAV029012,dspa_LAV029012C]';
ip = ip+1;s_duh_ectrl.remote{ip} = 'data_names = TrBP1Raw';
ip = ip+1;s_duh_ectrl.remote{ip} = '.end';
