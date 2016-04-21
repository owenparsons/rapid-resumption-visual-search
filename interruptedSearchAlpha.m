function interrupted_search(ID_num, taskCondition)
try  
        


if nargin<2
    ID_num = input('Participant ID? ', 's');
    taskCondition = input('Task condition (1, 2, 3 or 4)? '); 
end

tstamp = clock;
savefile = fullfile(pwd, 'Results', [sprintf('interruptedSearch-%02d-%02d-%02d-%02d-%02d-task-%d-participant-%s', tstamp(1), tstamp(2), tstamp(3), tstamp(4), tstamp(5), taskCondition), ID_num, '.txt']);
savefilenodis = fullfile(pwd, 'Results', [sprintf('interruptedSearch-%02d-%02d-%02d-%02d-%02d-task-%d-participant-%s', tstamp(1), tstamp(2), tstamp(3), tstamp(4), tstamp(5), taskCondition), ID_num, '_NoDis.txt']);

savefilemat = fullfile(pwd, 'Results', [sprintf('interruptedSearch-%02d-%02d-%02d-%02d-%02d-task-%d-participant-%s', tstamp(1), tstamp(2), tstamp(3), tstamp(4), tstamp(5), taskCondition), ID_num, '.mat']);

fileID = fopen(savefile,'wt+');
noDisfileID = fopen(savefilenodis,'wt+');

fprintf(fileID,'Block\tTrial\tCR\tResponse\tPosition\tDirection\tSearchSize\tTime\tEpoch\n');
fprintf(noDisfileID,'Trial\tCR\tResponse\tPosition\tDirection\tTime\tEpoch\n');

%fprintf(fileID,'%d\t%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\n', blockLoop, loop, keyresponse, targetInfo, targetPos, targetDir, num_items, reactionTime, displayLoops);

% Screen('Preference', 'SkipSyncTests', 1);

%% Experiment Variables.
% save the script content
nosearchdata = struct;
data = struct;
data.scripts = savescripts;
data.task = taskCondition;
data.ID = ID_num;

scr_background = 127.5;
scr_no = 1;

white = WhiteIndex(scr_no);
black = BlackIndex(scr_no);


scr_dimensions = Screen('Rect', scr_no);

xcen = scr_dimensions(3)/2;
ycen = scr_dimensions(4)/2;
xfull = scr_dimensions(3);
yfull = scr_dimensions(4);

% Set up Keyboard
WaitSecs(1);
KbName('UnifyKeyNames');
left_key = KbName('LeftArrow');
right_key = KbName('RightArrow');
down_key = KbName('DownArrow');
esc_key = KbName('Escape');
space_key = KbName('space');
yes_key = KbName('y');
no_key = KbName('n');
keyList = zeros(1, 256);
keyList([yes_key, no_key, left_key, right_key, down_key, esc_key, space_key]) = 1;
KbQueueCreate([], keyList); clear keyList
RestrictKeysForKbCheck([]);

% Sound
InitializePsychSound;
pa = PsychPortAudio('Open', [], [], [], [], [], 256);
bp400 = PsychPortAudio('CreateBuffer', pa, [MakeBeep(400, 0.2); MakeBeep(400, 0.2)]);
PsychPortAudio('FillBuffer', pa, bp400);

% Open Window
scr = Screen('OpenWindow', scr_no, scr_background);
frameRate = 1/Screen('FrameRate', scr);
HideCursor;

Screen('BlendFunction', scr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextFont', scr, 'Ariel');
Screen('TextSize', scr, 40);

% Experiment Procedure
nBlocks = 10;
nTrials = 60;

Priority(1);


%% Instructions
if taskCondition == 1 || taskCondition == 3 || taskCondition == 4
    DrawFormattedText(scr, 'Welcome. This experiment is a visual search experiment.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'You will have to find a "T" in a range of "L"s.\n\nYou will then have to identify the colour of that "T".', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'The T and the Ls can be red or blue.\n\nIf the T is red, you will have to press the "Right" Arrow Key,\n\nand if it is blue, you will have to press the "Left" Arrow Key.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'The display will only be shown intermittently, with blank intervals in between.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'You have a total of 8 seconds to find the target in each trial.\n\nAfter each trial, you will be told if you got it correct or not.\n\nIf not, a beeping sound will indicate the error.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    [~, ny] = DrawFormattedText(scr, 'This is an example target.\n\nHere, the correct button would be the "Left" Arrow Key.', 'center', 'center', 0);
    display_object(8, 0, [xcen, ny + 100])
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    % Next, a full display
    DrawFormattedText(scr, 'This is an example of the full display. When you find the target,\n\npress "Right" if it is red,\n\nor "Left" if it is blue.', 'center', 20, 0);
    baseRect = [0 0 420 420];
    centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);
    Screen('FillRect', scr, white, centeredRect);
    [demoElements] = create_grid(3, 2, 2, 16, 1, 999);
    for demoObject = 1:16 
    demotype = cell2mat(demoElements(demoObject,1));
    democolour = cell2mat(demoElements(demoObject,2));
    demo_x = cell2mat(demoElements(demoObject,3));
    demo_y = cell2mat(demoElements(demoObject,4));
    display_object(demotype, democolour, [demo_x demo_y]);
    end
    Screen('Flip', scr);
    while 1
        [~, demokeys, ~] = KbStrokeWait;
        if demokeys(right_key)
            break
        else
            PsychPortAudio('Start', pa);
        end
    end
    
    DrawFormattedText(scr, 'Great. The aim is to complete the task\n\nas quickly as possible, but also get each answer right.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    
elseif taskCondition == 2
    
    DrawFormattedText(scr, 'Welcome. This experiment is a visual search experiment.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'You will have to find a "T" in a range of either blue or red "L"s.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'You will alternately be shown red and blue letters.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'If the T is in the red letters, you will have to press the "Right" key.\n\nIf it is in the blue letters, you will have to press the "Left" Key.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'On some trials, there will be no T - only Ls.\n\nIn that case, you will have to press the "Down" button.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'You have a total of 8 seconds to find the target in each trial.\n\nAfter each trial, you will be told if you got it correct or not.\n\nIf not, a beeping sound will indicate the error.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    [~, ny] = DrawFormattedText(scr, 'This is an example target.\n\nHere, the correct button would be the "Left" Arrow Key.', 'center', 'center', 0);
    display_object(8, 0, [xcen, ny + 100])
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'The aim is to complete the task\n\nas quickly as possible, but also get each answer right.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
end

%% Distractor free trials


DrawFormattedText(scr, 'Before starting the main experiment, you will do a short warm up task. \n\n\n\n This will be similar to the main task. \n\n However the T will appear on its own without any Ls.', 'center', 'center', 0);
DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
Screen('Flip', scr); KbStrokeWait;
DrawFormattedText(scr, 'Press the "Right" key if the T is red or the "Left" key if the T is blue.', 'center', 'center', 0);
DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
Screen('Flip', scr); KbStrokeWait;
DrawFormattedText(scr, 'When you are ready to start the warm up, press the "Space" key.', 'center', 'center', 0);
Screen('Flip', scr); KbStrokeWait;

blockLoop = '88';
taskA(30, 3, 2);




%% Practice trials

    training_demo(taskCondition);
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;

%% Main body

%create_display;

%display_object(1, [xcen+100 ycen-400]);


count_text = 'The task will start in';
countdown_pause(5, count_text);

if taskCondition == 2

   for blockLoop = 1:nBlocks 
    
   taskB(nTrials, 1);
   
   if blockLoop ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
   
elseif taskCondition == 3
    
    for blockLoop = 1:nBlocks 
    
   taskA(nTrials, 2, 1); 
   
   if blockLoop ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
    end
   
elseif taskCondition == 4
    
    for blockLoop = 1:nBlocks 
    
   taskA(nTrials, 4, 1); 
   
   if blockLoop ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
    
    
else
 
    for blockLoop = 1:nBlocks 
    
   taskA(nTrials, 1, 1); 
   
   if blockLoop ~= 10
   
   count_text = sprintf('Block %d of 10 is now complete. Pause for', blockLoop);
   countdown_pause(30, count_text);
   
   end
   
   end
    
end

count_text = 'The experiment will finish in';
countdown_pause(10, count_text);




%% Shutdown
fclose(fileID);
fclose(noDisfileID);
text_string = 'Thank you!';
DrawFormattedText(scr, text_string, 'center', 'center', 0);

Screen('Flip', scr);

WaitSecs(2);
KbQueueStop;
PsychPortAudio('Close');
sca;
save(savefilemat, 'data', 'nosearchdata');
Priority(0);
disp('All done!');
   
    
catch errMessage
    KbQueueStop;
    sca;
    savefilemat = fullfile(pwd, 'Results', 'Errors', [sprintf('interruptedSearch-%02d-%02d-%02d-%02d-%02d-task-%d-participant-%s', tstamp(1), tstamp(2), tstamp(3), tstamp(4), tstamp(5), taskCondition), ID_num, '_error.mat']);
    save(savefilemat, 'data', 'nosearchdata');
    rethrow(errMessage);
end



%% Subfunctions


%% Task A
function taskA(trialsNum, altSettings, writeFile) 

shortTrials = randsample(1:trialsNum, (trialsNum / 2));

redTargetTrials = randsample(1:trialsNum, (trialsNum / 2));

smallTrials = randsample(1:trialsNum, (trialsNum / 2));

trialCounter = 0;
seqLength = 12;
seqCount = 0;
    
for loop = 1:trialsNum
    
    
    
trialCounter = trialCounter + 1;
seqCount = seqCount + 1;

if seqCount == seqLength
    seqCount = 0;
    
end

if isempty(find(smallTrials == trialCounter))
    
    num_items = 32;
    
else
    
    num_items = 16;
    
end

if isempty(find(redTargetTrials == trialCounter))
    
    targetColour = 1;
    
else
    
    targetColour = 2;
    
end


fixation_cross;

WaitSecs(0.5);

if altSettings == 2
    
   if isempty(find(shortTrials == trialCounter)) 
      
       searchDuration = 0.5;
       blankDuration = 1.6;
       
   else
       
       searchDuration = 0.1;
       blankDuration = 2;
       
   end  
   
else
    
       searchDuration = 0.1;
       blankDuration = 0.9;
    
end    

if altSettings == 3
    
    distractorOn = 2;
    
else 
    
    distractorOn = 1;
    
end

if altSettings == 4
    
    determSeq = seqCount;
    
else 
    
    determSeq = 999;
    
end

[objectElements, targetInfo, targetPos, targetDir] = create_grid(3, 2, targetColour, num_items, distractorOn, determSeq);
blankStart = GetSecs-blankDuration + 0.05;
reactionTime = 0;

for displayLoops = 1:8
    
baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);
    
objectLoops = size(objectElements,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElements(displayObject,1));
            objectcolour = cell2mat(objectElements(displayObject,2));
            x_final = cell2mat(objectElements(displayObject,3));
            y_final = cell2mat(objectElements(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
 
startSecs = Screen('Flip', scr, blankStart + blankDuration - frameRate/2);
        
        if displayLoops == 1
        
        trialStart = startSecs;
                     
        end
 
 keyresponse = 'null';

 %startSecs = GetSecs;
 
KbQueueFlush(); 
 
KbQueueStart();
 
WaitSecs(searchDuration-0.05);
 
 [ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;   
        
        end

baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

blankStart = Screen('Flip', scr, startSecs+searchDuration - frameRate/2);

WaitSecs(blankDuration - 0.05);
 
 [ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;   
        
        end
 
  KbQueueStop;
%KbWait;

end
Screen('Flip', scr);

% Store data in txt file
if writeFile == 3
    
    disp('Not writing to output file!');

elseif writeFile == 2

    fprintf(noDisfileID,'%d\t%s\t%s\t%d\t%d\t%d\t%d\n', loop, keyresponse, targetInfo, targetPos, targetDir, reactionTime, displayLoops);

else
fprintf(fileID,'%d\t%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\n', blockLoop, loop, keyresponse, targetInfo, targetPos, targetDir, num_items, reactionTime, displayLoops);
end

WaitSecs(0.2);

% give participant feedback
if (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'left'))
    DrawFormattedText(scr, 'Correct.', 'center', 'center');
elseif (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'left')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'right'))
    DrawFormattedText(scr, 'Wrong.', 'center', 'center');
    PsychPortAudio('Start', pa);
elseif strcmp(keyresponse, 'null')
    DrawFormattedText(scr, 'Too slow.', 'center', 'center');
    PsychPortAudio('Start', pa);
end

% Store data in matlab structure
if isnumeric(blockLoop)
data.n = (blockLoop-1)*trialsNum + loop;
data.keyresponse{data.n} = keyresponse;
data.rt(data.n) = reactionTime;
data.correct(data.n) = (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'left'));
data.targetcolor{data.n} = targetInfo;
data.targetpos{data.n} = targetPos;
data.displaysize(data.n) = num_items;
data.epoch(data.n) = displayLoops;
elseif strcmp(blockLoop, '88')
nosearchdata.n = loop;
nosearchdata.keyresponse{nosearchdata.n} = keyresponse;
nosearchdata.rt(nosearchdata.n) = reactionTime;
nosearchdata.correct(nosearchdata.n) = (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'left'));
nosearchdata.targetcolor{nosearchdata.n} = targetInfo;
nosearchdata.targetpos{nosearchdata.n} = targetPos;
nosearchdata.displaysize(nosearchdata.n) = num_items;
nosearchdata.epoch(nosearchdata.n) = displayLoops;
end

Screen('Flip', scr);
WaitSecs(0.8);

end

end

%% Task B
function taskB(trialsNum, writeFile) 

trialCounter = 0;

downTrialsNumber = trialsNum / 5;
redTrialsNumber = (trialsNum - downTrialsNumber) / 2;
downTrials = randsample(1:trialsNum, downTrialsNumber);

emptyTrials = setdiff(1:trialsNum, downTrials);
redTrials = randsample(emptyTrials, redTrialsNumber);

smallTrials = randsample(1:trialsNum, (trialsNum / 2));


    
for loop = 1:trialsNum
    
trialCounter = trialCounter + 1;

if isempty(find(smallTrials == trialCounter))
    
    num_items = 32;
    
else
    
    num_items = 16;
    
end
    
fixation_cross;

WaitSecs(0.5);

if ~isempty(find(downTrials == trialCounter))
   
    targetOptionRed = 1;
    targetOptionBlue = 1;
    
elseif ~isempty(find(redTrials == trialCounter))
    
     targetOptionRed = 2;
    targetOptionBlue = 1;
    
else

        targetOptionRed = 1;
        targetOptionBlue = 2;
end



[objectElementsRed, targetInfoRed, targetPos, targetDir] = create_grid(1, targetOptionRed, 2, num_items, 1, 999);
[objectElementsBlue, targetInfoBlue, targetPos, targetDir] = create_grid(2, targetOptionBlue, 1, num_items, 1, 999);
targetInfo = strcat(targetInfoRed, targetInfoBlue);

searchDuration = 0.1;
blankDuration = 0.95;
blankStartB = GetSecs-blankDuration+0.02;
reactionTime = 0;

for displayLoops = 1:8
    
baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);    
    
objectLoops = size(objectElementsRed,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElementsRed(displayObject,1));
            objectcolour = cell2mat(objectElementsRed(displayObject,2));
            x_final = cell2mat(objectElementsRed(displayObject,3));
            y_final = cell2mat(objectElementsRed(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
        
  startSecsA = Screen('Flip', scr, blankStartB + blankDuration - frameRate/2);
  
  if displayLoops == 1
      
      trialStart = startSecsA;
      
  end
 
 keyresponse = 'null';
 %startSecs = GetSecs;
 
 KbQueueFlush();
 
 KbQueueStart();
 
 WaitSecs(searchDuration-0.02);
 
[ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;
        
        elseif ~isempty(timeSecs) && first_press(down_key)==timeSecs
            keyresponse = 'down';
            reactionTime = timeSecs - trialStart;
            
            break;
        
        end

baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

blankStartA = Screen('Flip', scr, startSecsA+searchDuration - frameRate/2);

 WaitSecs(blankDuration - 0.02);
 
  [ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;   
        
        elseif ~isempty(timeSecs) && first_press(down_key)==timeSecs
            keyresponse = 'down';
            reactionTime = timeSecs - trialStart;
            
            break; 
        
        end
        
 Screen('FillRect', scr, white, centeredRect);    
    
objectLoops = size(objectElementsBlue,1);
        
        for displayObject = 1:objectLoops 
            
            objecttype = cell2mat(objectElementsBlue(displayObject,1));
            objectcolour = cell2mat(objectElementsBlue(displayObject,2));
            x_final = cell2mat(objectElementsBlue(displayObject,3));
            y_final = cell2mat(objectElementsBlue(displayObject,4));
            
           
            
            display_object(objecttype, objectcolour, [x_final y_final]);
            
            
        end
        
 startSecsB = Screen('Flip', scr, blankStartA + blankDuration - frameRate/2);
 
 
 WaitSecs(searchDuration-0.02);
 
[ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;   
        
        elseif ~isempty(timeSecs) && first_press(down_key)==timeSecs
            keyresponse = 'down';
            reactionTime = timeSecs - trialStart;
            
            break; 
        
        end
        
        baseRect = [0 0 420 420];

centeredRect = CenterRectOnPointd(baseRect, xcen, ycen);

Screen('FillRect', scr, white, centeredRect);

 blankStartB = Screen('Flip', scr, startSecsB + searchDuration - frameRate/2);

 WaitSecs(blankDuration-0.02);
 
[ ~, first_press] = KbQueueCheck;
timeSecs = min(first_press(first_press~=0));
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif ~isempty(timeSecs) && first_press(left_key)==timeSecs
            keyresponse = 'left';
            reactionTime = timeSecs - trialStart;
            
            break;
        elseif ~isempty(timeSecs) && first_press(right_key)==timeSecs
            keyresponse = 'right';
            reactionTime = timeSecs - trialStart;
            
            break;   
        
        elseif ~isempty(timeSecs) && first_press(down_key)==timeSecs
            keyresponse = 'down';
            reactionTime = timeSecs - trialStart;
            
            break; 
        
        end
 
  KbQueueStop;
%KbWait;





end

if isempty(targetInfo)
    targetInfo = 'Blank';
end

if writeFile == 2
    
    disp('Not writing to output file!');
    
else
fprintf(fileID,'%d\t%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\n', blockLoop, loop, keyresponse, targetInfo, targetPos, targetDir, num_items, reactionTime, displayLoops);
end

    
WaitSecs(0.2);

% give participant feedback
if (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'left')) || (strcmp(targetInfo, 'Blank') && strcmp(keyresponse, 'down'))
    DrawFormattedText(scr, 'Correct.', 'center', 'center');
elseif (strcmp(targetInfo, 'Red') && ~strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && ~strcmp(keyresponse, 'left')) || (strcmp(targetInfo, 'Blank') && ~strcmp(keyresponse, 'down'))
    DrawFormattedText(scr, 'Wrong.', 'center', 'center');
    PsychPortAudio('Start', pa);
elseif strcmp(keyresponse, 'null')
    DrawFormattedText(scr, 'Too slow.', 'center', 'center');
    PsychPortAudio('Start', pa);
end
Screen('Flip', scr);
WaitSecs(0.8);

% Store data in matlab structure
if isnumeric(blockLoop)
data.n = (blockLoop-1)*trialsNum + loop;
data.keyresponse{data.n} = keyresponse;
data.rt(data.n) = reactionTime;
data.correct(data.n) = (strcmp(targetInfo, 'Red') && strcmp(keyresponse, 'right')) || (strcmp(targetInfo, 'Blue') && strcmp(keyresponse, 'left')) || (strcmp(targetInfo, 'Blank') && strcmp(keyresponse, 'down'));
data.targetcolor{data.n} = targetInfo;
data.targetpos{data.n} = targetPos;
data.displaysize(data.n) = num_items;
data.epoch(data.n) = displayLoops;
end

end

end

%% other subfunctions
function fixation_cross
        
        fixCrossDimPix = 10;

        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
        allCoords = [xCoords; yCoords];


        lineWidthPix = 4;

        Screen('DrawLines', scr, allCoords,lineWidthPix, black, [xcen ycen], 2);
        Screen('Flip', scr);

end

function display_object(objecttype, objectcolour, mid_coords)
    


%global scr_no xcen ycen scr;

%black = BlackIndex(scr_no);
    
fixCrossDimPix = 10;

if objecttype == 9

	xCoords = [0 0 0 0];
	yCoords = [0 0 0 0];


elseif objecttype == 8

	xCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 7

	xCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix 0 0];

elseif objecttype == 6

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix fixCrossDimPix fixCrossDimPix];

elseif objecttype == 5

	xCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix -fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];

elseif objecttype == 4

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 3

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 fixCrossDimPix fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 2

	xCoords = [-(fixCrossDimPix+2) fixCrossDimPix -fixCrossDimPix -fixCrossDimPix];
	yCoords = [-fixCrossDimPix -fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

elseif objecttype == 1

	xCoords = [-fixCrossDimPix fixCrossDimPix+2 -fixCrossDimPix -fixCrossDimPix];
	yCoords = [fixCrossDimPix fixCrossDimPix -fixCrossDimPix fixCrossDimPix+2];

else

	error('Object type not defined!');

end

            if objectcolour == 0
                
            objectcolourcode = [0 0 255];
            
            
            else
                
            objectcolourcode = [255 0 0];
           
            end

allCoords = [xCoords; yCoords];
lineWidthPix = 4;

% disp(objectcolour);
% disp(mid_coords);



Screen('DrawLines', scr, allCoords, lineWidthPix, objectcolourcode, mid_coords, 2);



end


function [objectElements, targetInfo, target, targetDir] = create_grid(colOption, targetOn, targetColour, num_items, distractorOn, determSeq)
safeCheck = 1;

while safeCheck == 1

targetDir = 0;        
loopcount = 0;
targetInfo = '';

%skip_items = [];

%for skip_row = 1:6
    
%skip_max = 6 * skip_row;
%skip_min = skip_max - 5;
    
%skip_col = randsample(skip_min:skip_max,2);

%skip_items = [skip_items, skip_col]

%end


    

%num_items = 16;

objectElements = [];

skip_items = randsample(1:36, (36 - num_items));

used_points = setdiff(1:36, skip_items);
                %target = randsample(used_points, 1);
                reditems = randsample(used_points, num_items/2);
                blueitems = setdiff(used_points, reditems);
                
if targetColour == 2
    
    target = randsample(reditems, 1);
    
else
    
    target = randsample(blueitems, 1);
    
end

if determSeq ~= 999

        seqOrder = read_mixed_csv('s_file.csv',',');
        
        quartVal = seqOrder{determSeq,1};
        quartNum = str2num(quartVal);
        disp(quartNum);
        
        quartArrayOne = [1 2 3 7 8 9 13 14 15];
        quartArrayTwo = [4 5 6 10 11 12 16 17 18];
        quartArrayThree = [19 20 21 25 26 27 31 32 33];
        quartArrayFour = [22 23 24 28 29 30 34 35 36];
        
        if quartNum == 1
            
            target = randsample(quartArrayOne, 1);
        
        elseif quartNum == 2
            
            target = randsample(quartArrayTwo, 1);
            
        elseif quartNum == 3
            
            target = randsample(quartArrayThree, 1);
            
        else   
            
            target = randsample(quartArrayFour, 1);
            
        end
    
    
    
end

if isempty(find(skip_items == target))
        
        for rows = 1:6
         
            
            for columns = 1:6
            
                loopcount = loopcount + 1;
            
            if isempty(find(skip_items == loopcount))
                
                
                
                
            
            x_value = ((((rows * 2) - 1)/6) * 210) + (xcen - 210);
            y_value = ((((columns * 2) - 1)/6) * 210) + (ycen - 210);
            x_jitter = randi([-8, 8]);
            y_jitter = randi([-8, 8]);
            x_final = x_value + x_jitter; 
            y_final = y_value + y_jitter; 
            
            if target == loopcount && targetOn == 2
                
                objecttype = randsample(5:8, 1);
                
                targetDir = objecttype;
                
            else
            
                if distractorOn == 2
                
                objecttype = 9;    
                
                else
                    
                objecttype = randi([1, 4]);
                
                end
            
            end
            
            
                if colOption == 2;
                
                objectcolour = 0;
                
                if target == loopcount && targetOn == 2
                    
                    targetInfo = 'Blue';
                    
                end
            
              elseif colOption == 1;
                
                objectcolour = 1;
                
                if target == loopcount && targetOn == 2
                    
                    targetInfo = 'Red';
                    
                end
                    
           
              else  
            
                    if isempty(find(reditems == loopcount))
                
                    objectcolour = 0;
                    
                    if target == loopcount && targetOn == 2
                    
                    targetInfo = 'Blue';
                    
                end
           
            
                    else
                
                    objectcolour = 1;
                    
                    if target == loopcount && targetOn == 2
                    
                    targetInfo = 'Red';
                    
                    end
            
                    end
                    
                end
            
             
            
            %display_object(objecttype, objectcolour, [x_final y_final]);
            
            
            
            newObject = {objecttype, objectcolour, x_final, y_final};
            
            
            
            objectElements = vertcat(objectElements, newObject);
            
            
            
            
            end
            
            end
        end
        
safeCheck = 0;        
        
end

   
        
end

end
    
function training_demo(taskType)

    blockLoop = '99';
    
    DrawFormattedText(scr, 'You will now do 10 practice trials before starting the main experiment', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    
    if taskType == 2

    DrawFormattedText(scr, 'Remember, If the T is in the red letters, you will have to press the "Right" key.\n\nIf it is in the blue letters, you will have to press the "Left" Key.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    taskB(10, 2);
    
    elseif taskType == 3
        
    DrawFormattedText(scr, 'Remember, The T and the Ls can be red or blue.\n\nIf the T is red, you will have to press the "Right" Arrow Key,\n\nand if it is blue, you will have to press the "Left" Arrow Key.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    taskA(10, 2, 3);
        
    else
    
     DrawFormattedText(scr, 'Remember, The T and the Ls can be red or blue.\n\nIf the T is red, you will have to press the "Right" Arrow Key,\n\nand if it is blue, you will have to press the "Left" Arrow Key.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to continue.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    
    DrawFormattedText(scr, 'If you have any questions\n\nask the examiner now.', 'center', 'center', 0);
    DrawFormattedText(scr, 'Press "Space" to start the experiment.', 'center', yfull-80, 0);
    Screen('Flip', scr); KbStrokeWait;
    taskA(10, 1, 3);
        
    end
    

    
    
    



    Line1 = 'Do you want to repeat the demo?';
    dottedline = '------------------------------';
    Line2 = '(y)es or (n)o?';
    text_string = sprintf('%s\n%s\n\n%s', Line1, dottedline, Line2);
    DrawFormattedText(scr, text_string, 'center', 'center', 0);
    Screen('Flip', scr);
    
    

    KbQueueStart();    
   
waitTime    = 30;        

startTime = GetSecs();
pass_var = 0;

while 1
    
    keyboard_response = 'null';
    RestrictKeysForKbCheck([yes_key, no_key]);
    [ ~, firstPress]=KbQueueCheck;
    
    if firstPress(yes_key)
        RestrictKeysForKbCheck([]);
        training_demo(taskType);
        
    elseif firstPress(no_key)
        RestrictKeysForKbCheck([]);
       break
           
    elseif GetSecs()-startTime > waitTime
        RestrictKeysForKbCheck([]);
       break
        
   end
       
end

end

function lineArray = read_mixed_csv(fileName,delimiter)
  fid = fopen(fileName,'r');   
  lineArray = cell(100,1);     
                               
  lineIndex = 1;               
  nextLine = fgetl(fid);       
  while ~isequal(nextLine,-1)         
    lineArray{lineIndex} = nextLine;  
    lineIndex = lineIndex+1;          
    nextLine = fgetl(fid);            
  end
  fclose(fid);                 
  lineArray = lineArray(1:lineIndex-1);  
  for iLine = 1:lineIndex-1              
    lineData = textscan(lineArray{iLine},'%s',...  
                        'Delimiter',delimiter);
    lineData = lineData{1};              
    if strcmp(lineArray{iLine}(end),delimiter)  
      lineData{end+1} = '';                     
    end
    lineArray(iLine,1:numel(lineData)) = lineData;  
  end
end  



function countdown_pause(time_loop, text_string)
    
    image = fullfile(pwd, 'Pictures', sprintf('%d.jpg', randi(50)));
    temp_image = imread(image, 'jpg');
    temp_texture = Screen('MakeTexture', scr, temp_image);
    
    KbQueueFlush();
    
    KbQueueStart;
    for h = 1:time_loop
        time_max = time_loop + 1;
    msg = sprintf('%s %d s', text_string, time_max-h);
    DrawFormattedText(scr, msg, 'center', 0, 0);
    Screen('DrawTexture', scr, temp_texture);
    Screen('Flip', scr);
    WaitSecs(1);
        [~, first_press] = KbQueueCheck;
        if first_press(esc_key)
            error('You interrupted the script by pressing Escape after exposure');
        elseif first_press(space_key)
            break
        end
    end

    Screen('Flip', scr);
    KbQueueStop;
    RestrictKeysForKbCheck([left_key, right_key, space_key]);
    WaitSecs(1);

end



end

