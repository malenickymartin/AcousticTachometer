%% Load data and set-up
clear, clc, close all

file_name = "ford_custom_open_2014-4";
path_estim = "data/estimations/"+file_name+".mat";
video_path = "data/"+file_name+".MOV";
output_video_path = "data/videos_gauge/"+file_name+".mp4";
output_audio_video_path = "data/videos_gauge/"+file_name+"-audio-video.mp4";
output_audio_file = "data/videos_gauge/"+file_name+"-audio.wav";
[audio_data, fs] = audioread(video_path);
data = load(path_estim);
time_vector = data.t;
rpm_vector = data.rpms_save;

vidReader = VideoReader(video_path);
vidWriter = VideoWriter(output_video_path, 'MPEG-4');
open(vidWriter);

%% Crop and set up max and min RPM
first_frame = readFrame(vidReader);
fig = figure;
imshow(first_frame);
title('Select the tachometer area');
roi = drawrectangle('Label', 'Tachometer ROI', 'Color', 'r');
waitforbuttonpress;
cropRect = round(roi.Position);
min_rpm = input("Min RPM: ");
max_rpm = input("Max RPM: ");
major_rpm = input("Major tick: ");
minor_rpm = input("Minor tick: ");
start_time = input("Video start time: ");
vidReader.CurrentTime = start_time;
close(fig)

%% Gauge
fig = uifigure('Visible', 'off');
fig.Position = [100, 100, cropRect(3), cropRect(4)];
tach_gauge = uigauge(fig, 'circular', 'Limits', [min_rpm, max_rpm]);
tach_gauge.MajorTicks = min_rpm:major_rpm:max_rpm;
tach_gauge.MinorTicks = min_rpm:minor_rpm:max_rpm;
tach_gauge.FontSize = 24;
tach_gauge.Position = [10, 0, cropRect(3), cropRect(4)];
tach_gauge.Value = rpm_vector(1);

%% Animate
while hasFrame(vidReader)
    frame = readFrame(vidReader);
    frame = imcrop(frame, cropRect);

    [~, idx] = min(abs(time_vector - vidReader.CurrentTime));
    tach_gauge.Value = rpm_vector(idx);

    frame_gauge = getframe(fig);
    gauge_image = frame_gauge.cdata;
    gauge_size = [size(frame, 1), size(frame, 2)];
    gauge_image_resized = imresize(gauge_image, gauge_size);

    combined_frame = [frame, gauge_image_resized];

    writeVideo(vidWriter, combined_frame);

end

close(vidWriter);
close(fig);

%% Add audio

start_sample = round(start_time * fs);
cropped_audio = audio_data(start_sample:end, :);
amplified_audio = cropped_audio * (1/max(abs(max(cropped_audio)), abs(min(cropped_audio))));
amplified_audio = max(min(amplified_audio, 1), -1);
audiowrite(output_audio_file, amplified_audio, fs);
ffmpegCmd = sprintf('ffmpeg -i "%s" -i "%s" -c:v copy -c:a aac -strict experimental "%s"', ...
                    output_video_path, output_audio_file, output_audio_video_path);
status = system(ffmpegCmd);









