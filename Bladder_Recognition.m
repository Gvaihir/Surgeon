%%
%genrating objectDetectorTrainingData from ground truth
trainingData = objectDetectorTrainingData(gTruth);

%%
%object detector training
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);

%%
myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.dcm'));

for k=1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    info = dicominfo(fullFileName);
    dcmImg1(:,:,k) = (dicomread(info));
    
    %bboxes = detect(acfDetector,dcmImg1(:,:,k));
    [bboxes, scores] = detect(acfDetector,dcmImg1(:,:,k),'Threshold',1);
    
    [~,idx] = max(scores);
    annotation = acfDetector.ModelName;
    
    imshow(dcmImg1(:,:,k),'DisplayRange',[]);
    I = dcmImg1(:,:,k);
    hold on;
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);
    %I = insertObjectAnnotation(I,'rectangle',bboxes,annotation);
    figure 
    imshow(I);
    hold off;
end