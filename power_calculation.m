
for ii=1:(num_frame_del)-1
  
% fe = fs_dwn*(0:(length(frame_delta)/2))/length(frame_delta);
    
    clear frame_delta obs_del_pks freq_del frame_theta obs_theta_pks freq_theta
      frame_delta        = sig_delta((ii-1)*frame_len_del+1:frame_len_del*ii);
      [obs_del_pks, ~]   = findpeaks(frame_delta,fs_dwn);
      obs_mean_delta     = mean(obs_del_pks);
      freq_del = fft(frame_delta);
      
      P2_d = abs(freq_del/length(frame_delta));
      P1_d = P2_d(1:length(frame_delta)/2+1);
      P1_d(2:end-1) = 2*P1_d(2:end-1);
      
      
      pxx = max(P1_d);
      pow_del = obs_mean_delta^2;
      pwe_dd = pwelch(frame_delta);
      pwe_d = max(pwe_dd);
      
%       frame_sigma        = sig_sigma((ii-1)*frame_len_del+1:frame_len_del*ii);
%       [obs_sigma_pks, ~] = findpeaks(frame_sigma,fs_dwn);
      
      frame_theta        = sig_theta((ii-1)*frame_len_del+1:frame_len_del*ii);
      [obs_theta_pks, ~] = findpeaks(frame_theta,fs_dwn);
       obs_mean_theta(ii)     = mean(obs_theta_pks);
       freq_theta = fft(frame_theta);
       
       P2_t = abs(freq_theta/length(frame_theta));
      P1_t = P2_t(1:length(frame_theta)/2+1);
      P1_t(2:end-1) = 2*P1_t(2:end-1);
       
      pxx_t = max(P1_t);
       pow_theta(ii) = (obs_mean_theta(ii))^2;
       pwe_tt(ii) = pwelch(frame_theta);
      pwe_t(ii) = max(pwe_tt);
       
       the_del_rat(ii,1) = pow_theta/pow_del;
       the_del_rat_1(ii,1) = pwe_t/pwe_d;
       the_del_rat_2(ii,1) = pxx_t/pxx;
%       
%       frame_emg          = sig_emg((ii-1)*frame_len_emg+1:frame_len_emg*ii);
%       [obs_emg_pks, ~]   = findpeaks(frame_emg,fs_emg/10);
%       
%       frame_rem          = rem((ii-1)*frame_len_emg+1:frame_len_emg*ii);
%       [obs_rem_pks, ~]   = findpeaks(frame_rem,fs_dwn);
      
% %       frame_alpha        = sig_alpha((ii-1)*frame_len_del+1:frame_len_del*ii);
% %       [obs_alpha_pks, ~] = findpeaks(frame_alpha,fs_dwn);
%       obs_mean_delta     = mean(obs_del_pks);
%       obs_mean_sigma     = mean(obs_sigma_pks);
%       obs_mean_theta     = mean(obs_theta_pks);
%       obs_mean_alpha     = mean(obs_alpha_pks);
%       obs_rms_emg        = rms(frame_emg);
%       obs_mean_emg       = mean(obs_rem_pks);
%       obs_rem            = mean (obs_rem_pks);
end