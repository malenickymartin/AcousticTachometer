% This script is for running the application on simulated input, e.g. 
% if you have pre-recorded audio sample of engine
% How to run: just enter the file_path on line 10 and run the application

clear, clc, close all

[~, ~, ~, C] = config();

% Only for simulation and logging
file_path = "data/ford_custom_open_2014-4.MOV";
[loaded_data, fs] = load_audio_from_file(file_path);
logging = [];

data = zeros(C.SAMPLE_TIME*fs, 1);
movavg_rpm = C.MIN_RPM;
movder_rpm = C.MAX_RPM;
rpm_cache = NaN(1, C.CACHE_LEN);
rpm_cache_raw = NaN(1, C.CACHE_LEN);
time = tic;
done = false;
while ~done
    tic
    [loaded_data, data, time, dt, done] = capture_audio_simulation(loaded_data, data, fs, time);
    [rpm, rpm_raw] = spectral_analysis_stft_sample(data, fs, movavg_rpm, movder_rpm, C);
    [movavg_rpm, movder_rpm, steady, rpm_cache, movavg_rpm_raw, rpm_cache_raw] = moving_avg_analysis(rpm_cache, rpm, rpm_cache_raw, rpm_raw, dt, C);
    logging = [logging; rpm rpm_raw dt movavg_rpm movder_rpm movavg_rpm_raw steady];
    while toc < 0.2
        pause(0.01);
    end
end

fig = figure;
t = cumsum(logging(:,3));
plot(t, logging(:,1), "LineWidth", 4)
hold on
plot(t, logging(:,2), ":", "LineWidth", 4)
plot(t, logging(:,4)+logging(:,5), "g--", "LineWidth", 3)
plot(t, logging(:,4)-logging(:,5), "g--", "LineWidth", 3)
plot(t, -(logging(:,7)-1)*500+500, "LineWidth", 4)
xlabel("čas [s]")
ylabel("RPM [ot/min]")
xlim([0, max(t)])
ylim([C.MIN_RPM, C.MAX_RPM])
legend("Odhad", "Odhad bez omezení intervalu", "Prohledávaný interval", "Detekce kolísání")
title("Odhad otáček na simulovaných datech")
fontsize(22,"points")
grid on
fig.PaperOrientation = "landscape";
fig.Position = [301 71.5000 1.3425e+03 771];