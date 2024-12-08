close all
fs = 44100; % Sampling frequency
t1 = 0:1/fs:10-1/fs; % Time vector for the first 10 seconds
t2 = 0:1/fs:10-1/fs; % Time vector for the next 10 seconds
t3 = 0:1/fs:15-1/fs; % Time vector for the last 15 seconds

% First 10 seconds: 33 Hz sine wave with a 0.2 sec 66 Hz burst at 5 sec
signal1 = sin(2 * pi * 33 * t1);
burst_t = (5:1/fs:5.2-1/fs);
burst_signal = sin(2 * pi * 66 * burst_t);
signal1((4*fs+1):(4.2*fs)) = burst_signal;
signal1((6*fs+1):(6.2*fs)) = burst_signal;

% Next 10 seconds: 33 Hz to 66 Hz ramp in 2 sec, then stay at 66 Hz
ramp_signal = chirp(0:1/fs:2-1/fs, 33, 2, 66);
steady_signal = sin(2 * pi * 66 * (2:1/fs:10-1/fs));
signal2 = [ramp_signal, steady_signal];

% Last 15 seconds: Sum of two sine waves
% One sine wave ramps from 66 Hz to 99 Hz in 2 seconds
signal3_part1 = 1.25*chirp(0:1/fs:2-1/fs, 66, 2, 99);
signal3_part2 = sin(2 * pi * 99 * (2:1/fs:7-1/fs));
signal3_part3 = 0.1*sin(2 * pi * 99 * (7:1/fs:15-1/fs));
wave1 = [signal3_part1, signal3_part2, signal3_part3];

% Another sine wave jumps from 66 Hz to 33 Hz at the start
wave2 = [sin(2 * pi * 33 * t3(1:fs*2)), sin(2 * pi * 33 * t3(fs*2+1:end))];

signal3 = wave1 + wave2;

% Concatenate all the signals
final_signal = [signal1, signal2, signal3];

samples_duration = ceil(fs*0.5);
overlap = round(samples_duration/2);
f = linspace(0, 120, samples_duration/2);
[s,f,t] = spectrogram(final_signal, samples_duration, overlap, f, fs);

figure
plot_s = abs(s);
plot_s(plot_s < min(20*log10(max(plot_s)))) = 0.9*min(20*log10(max(plot_s)));
imagesc(t, f, plot_s)
colormap jet
axis xy
xlabel("time [s]")
ylabel("frequency [Hz]")
title("Spectrogram")
c=colorbar;
c.Label.String="20\cdot log_{10}(|X|) [dB]";

% Uncomment below to save the signal
% audiowrite('data/custom_signal-4.wav', final_signal, fs);
