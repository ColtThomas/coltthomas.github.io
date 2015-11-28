%close all
%clc
%clean all
%recObj = audiorecorder(96000, 24, 1);
%disp('Start speaking.')
%recordblocking(recObj, 5);
%disp('End of Recording.');
%this will play back the sound
%play(recObj);

%this saves the sound recording to a plottable variable
%myRecording = getaudiodata(recObj);

%plottage hardcore
%plot(myRecording);

%player = audioplayer(myRecording, 120000); % 2nd param plays back at 96,000 samples/s
%playblocking(player);
%impulse_echo(1) = 1; %first impulse at 0 seconds
%impulse_echo(48000) = .5; %at .5 seconds 
%impulse_echo(96000) = .25; %at 1 second

%player = audioplayer(impulse_echo, 10000); % 2nd param plays back at 96,000 samples/s
%playblocking(player);
%impulse_great_hall = wavread('great_hall.wav');



%impulse_great_hall = wavread('great_hall.wav');
%impulse_octagon = wavread('octagon.wav');
%impulse_classroom = wavread('classroom.wav');

%convolve each of them
%myRecording_octagon = conv(myRecording, impulse_octagon);
%myRecording_greatH = conv(myRecording, impulse_great_hall);
%myRecording_classroom = conv(myRecording, impulse_classroom);
%myRecording_trash = conv(myRecording, impulse_trash);
%disp('Done Convolving.');

%Play each of them after giving them each an object -------------------
%greatH = audioplayer(myRecording_greatH, 96000);
%playblocking(greatH)
%octagon = audioplayer(myRecording_octagon, 96000);
%playblocking(octagon)
%classroom = audioplayer(myRecording_classroom, 96000);
%playblocking(classroom)
%trash = audioplayer(myRecording_trash, 96000);
%playblocking(trash)
%-------------------------------------------------------------------------
%playblocking(player_gh)
%player_0 = audioplayer(impulse_octagon, 96000);
%playblocking(player_0)
%playblocking(player_c)


%player = audioplayer(myRecording_echo, 96000);
%playblocking(player)

%figure;
%subplot(3,1,1);
%plot(impulse_great_hall);
%subplot(3,1,2);
%plot(impulse_octagon);
%subplot(3,1,3);
%plot(impulse_classroom);


%************************TASK 2*******************************
% recObj = audiorecorder(48000, 24, 1);
% disp('Start speaking.')
% recordblocking(recObj, 5);
% disp('End of Recording.');
% %this will play back the sound
% play(recObj);
% 
% %this saves the sound recording to a plottable variable
% my48kHzRecording = getaudiodata(recObj);
% % player = audioplayer(my48kHzRecording, 8000); % 2nd param plays back at 96,000 samples/s
% % playblocking(player);
% 
% my8kHzRecording = my48kHzRecording(1:6:length(my48kHzRecording));
% player1 = audioplayer(my8kHzRecording, 8000); % 2nd param plays back at 96,000 samples/s
% playblocking(player1);


%-------------------For part 3---------------------------
% recObj1 = audiorecorder(48000, 24, 1);
% disp('Start speaking.')
% recordblocking(recObj1, 5);
% disp('End of Recording.');
% %this will play back the sound
% %play(recObj);
% 
% %this saves the sound recording to a plottable variable
% my48kHzRecording1 = getaudiodata(recObj1);
% player2 = audioplayer(my48kHzRecording1, 8000); % 2nd param plays back at 96,000 samples/s
% playblocking(player2);
% 
% my8kHzRecording1 = my48kHzRecording1(1:6:length(my48kHzRecording1));
% player3 = audioplayer(my8kHzRecording1, 8000); % 2nd param plays back at 96,000 samples/s
% playblocking(player3);

recObj2 = audiorecorder(48000, 24, 1);
disp('Start speaking.')
recordblocking(recObj2, 5);
disp('End of Recording.');
%this will play back the sound
%play(recObj);

%this saves the sound recording to a plottable variable
my48kHzRecording2 = getaudiodata(recObj2);
%player4 = audioplayer(my48kHzRecording2, 4000); % 2nd param plays back at 96,000 samples/s
%playblocking(player4);

my8kHzRecording2 = my48kHzRecording2(1:6:length(my48kHzRecording2));
player5 = audioplayer(my8kHzRecording2, 8000); % 2nd param plays back at 96,000 samples/s
playblocking(player5);