clear; clc;

[filename, filepath] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files (*.mp4, *.avi, *.mov)'; '*.*', 'All Files (*.*)'}, 'Select a Video File');
if isequal(filename, 0)
    disp('No file selected. Exiting.');
    return;
end
videoPath = fullfile(filepath, filename);
save_name_1 = string(split(filename, "."));
save_path = filepath + "annotation\" + save_name_1(1)+".mat";

videoObj = VideoReader(videoPath);

frameTimes = [];
userInputs = [];

while videoObj.CurrentTime + 0.5 <= videoObj.Duration
    currentTime = videoObj.CurrentTime;

    frame = readFrame(videoObj);
    imshow(frame);
    title(sprintf('Time: %.2f seconds', currentTime));

    inputNumber = input('Enter a number for this time: ');

    frameTimes = [frameTimes; currentTime];
    userInputs = [userInputs; inputNumber];

    % Skip to the next frame 0.5 seconds later
    videoObj.CurrentTime = currentTime + 0.5;
end

% Save results to a MAT file
save(save_path, 'frameTimes', 'userInputs');

disp('Frame times and user inputs have been saved');
