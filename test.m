%%
myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.dcm'));

for k=1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    info = dicominfo(fullFileName);
    dcmImg(:,:,k) = im2uint8(dicomread(info));
    
    % the name for your image after convertion.
   if isempty(strfind(fullFileName, '.dcm'))
        new_name = strcat(full_file, '.jpg');
    else
        [pathname, name, ext] = fileparts(fullFileName);
        name = strcat(name, '.jpg');
        new_name = fullfile(pathname, name);
    end
    % save the image as .jpg format.
    if isa(dcmImg(:,:,k), 'int16')
        imwrite(dcmImg(:,:,k),new_name,'jpg','Bitdepth',16,'Mode','lossless');
    elseif isa(dcmImg(:,:,k), 'uint8')
        imwrite(dcmImg(:,:,k),new_name,'jpg','Mode','lossless');
    end
end
%%

%%
for k=1:19
    imshow(dcmImg(:,:,k),'DisplayRange',[]);
end
%%
%%
    mask = zeros(size(dcmImg(:,:,10)));
    mask(35:end-75,25:end-25) = 1;
    figure
    imshow(mask)
    title('Initial Contour Location');
for k=1:19
    %imshow(dcmImg(:,:,k),'DisplayRange',[]);
    %dcmBImg(:,:,k)= imbinarize(dcmImg(:,:,k),'adaptive','ForegroundPolarity','bright');
    dcmBImg(:,:,k) = activecontour(dcmImg(:,:,k),mask,300);
end
%%
for k=1:19
    imshowpair(dcmImg(:,:,k),dcmBImg(:,:,k),'montage');
end

% %
% bladderDetect = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames', 19,'MinimumBackgroundRatio', 0.6);
% imgNum = 1;
% while imgNum < 19
%     imgNum = imgNum+1;
%     mask(:,:,imgNum) = im2uint8(bladderDetect.step(dcmImg(:,:,imgNum)));
% end
% %
%%
for k=1:19
    imshow(mask(:,:,k),'DisplayRange',[]);
end            
%%
for k=1:19
    %dcmBImg(:,:,k) = activecontour(dcmImg(:,:,k),mask,300);
    stats = regionprops('table',dcmBImg(:,:,k),'Centroid',...
    'MajorAxisLength','MinorAxisLength')
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    hold on
    figure
    viscircles(centers,radii);
    hold off
end
%%
%genrating objectDetectorTrainingData from ground truth
trainingData = objectDetectorTrainingData(gTruth);


%%
%object detector training
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);

%%
%%
myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.dcm'));

for k=1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    info = dicominfo(fullFileName);
    dcmImg1(:,:,k) = im2uint8(dicomread(info));
    
    %bboxes = detect(acfDetector,dcmImg1(:,:,k));
    [bboxes, scores] = detect(acfDetector,dcmImg1(:,:,k),'Threshold',1);
    [~,idx] = max(scores);
    annotation = acfDetector.ModelName;
    
    imshow(dcmImg1(:,:,k),'DisplayRange',[]);
    I = dcmImg1(:,:,k);
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);
    %I = insertObjectAnnotation(I,'rectangle',bboxes,annotation);
    figure 
    imshow(I);

end

%%
load('gTruthUB.mat');
dlmwrite('myFile.txt', gTruthUB, 'delimiter','\t','newline','pc');

%%
