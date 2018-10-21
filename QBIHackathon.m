

clear all; close all; clc;

% for i=1:10
i=21;
a = dir(['Prostate_ADC/' num2str(i-1) '/*.dcm']);

% cd Prostate_ADC/0
newFolder = sprintf('Prostate_ADC/%d', i-1);
cd (newFolder);

for i = 1:size(a,1)
    ADC = dicominfo([a(i).name]);
    SL(i) = ADC.SliceLocation;
    I(:,:) = dicomread(ADC);
    IM(:,:,i) = I;
end

cd ../..

% reorder slices in order
[B,index] = sort(SL);
new_IM = IM(:,:,index);

% % show image slice by slice
figure;
for i=1:size(IM,3)
    if i == 10
        imagesc(new_IM(:,:,i)); colormap gray;
        hold on
        tumor = plot3(34,63,10,'Marker','o'); % only for #1
        tumor.Color = 'red';
        title(['Slice ' num2str(i)]);
        pause(0.5);
        hold off
    else
        imagesc(new_IM(:,:,i)); colormap gray;
        title(['Slice ' num2str(i)]);
        pause(0.1);
    end
end

% end


%% Get new order of ADC images for 3D recon
clear all; close all; clc;
order=[];
index=[];

for i=1:1
    a = dir(['Prostate_ADC/' num2str(i-1) '/*.dcm']);

%     cd Prostate_ADC/i
    newFolder = sprintf('Prostate_ADC/%d', i-1);
    cd (newFolder);

    for j = 1:19
        ADC = dicominfo([a(j).name]);
        SL(j) = ADC.SliceLocation;
        I(:,:) = dicomread(ADC);
        IM(:,:,j) = I;
    end

    cd ../..

    % reorder slices in order
    [B,index] = sort(SL);
    order(i,:) = index;
    
ADC_0 = IM(:,:,index);
figure;
v = VideoWriter('Users/AlexNguyen/Desktop/ADC_0.avi');
open(v);
for i=1:size(IM,3)
    imagesc(ADC_0(:,:,i)); colormap gray;
    title(['Slice ' num2str(i)]);
    pause(0.1);
    frame = getframe(gcf);
    writeVideo(v,frame);
end


close(v)

end

% movie2avi(F,'myavifile.avi','Compression','Cinepak')


% v = VideoWriter('peaks.avi');
% open(v);
% writeVideo(v,frame);
% close(v);

ordered=order-1;


%% Get new order of T2 images for 3D recon
% clear all; close all; clc;
order=[];
index=[];

for i=1:1
    b = dir(['Prostate_T2/' num2str(i-1) '/*.dcm']);

%     cd Prostate_ADC/i
    newFolder = sprintf('Prostate_T2/%d', i-1);
    cd (newFolder);

    for j = 1:19
        T2 = dicominfo([b(j).name]);
        SL(j) = T2.SliceLocation;
        I2(:,:) = dicomread(T2);
        IM2(:,:,j) = I2;
    end

    cd ../..

    % reorder slices in order
    [B,index] = sort(SL);
    order(i,:) = index;
    T2_0 = IM2(:,:,index);
    
    figure;
for i=1:size(IM2,3)
    imagesc(T2_0(:,:,i)); colormap gray;
    title(['Slice ' num2str(i)]);
    pause(0.1);
end
    
end

ordered=order-1;

%% Reorder ADC and T2 image volumes TEST


clear all; close all; clc;
ADC_order = cell2mat(struct2cell(load('ADC_index.mat')));
T2_order = cell2mat(struct2cell(load('T2_index_T2.mat')));
ADC_order = ADC_order+1;


%%
cd Prostate_ADC/1

i=2;
a = dir(['Prostate_ADC/' num2str(i-1) '/*.dcm']);


for i = 1:19
    ADC = dicominfo([a(i).name]);
    SL(i) = ADC.SliceLocation;
    I(:,:) = dicomread(ADC);
    IM(:,:,i) = I;
end

cd ../..

new_IM = IM(:,:,ADC_order(i,:));

% % show image slice by slice
figure;
for i=1:size(IM,3)
        imagesc(new_IM(:,:,i)); colormap gray;
        title(['Slice ' num2str(i)]);
        pause(0.5);
end





%% Register ADC and T2 images TEST
% clear all; close all; clc;

close all;

ADC_0 = imresize(ADC_0, 4, 'nearest');

moving = ADC_0(:,:,1);
fixed = T2_0(:,:,1);

[optimizer, metric] = imregconfig('multimodal');

% optimizer.InitialRadius = 0.002;
% optimizer.Epsilon = 1.5e-4;
% optimizer.GrowthFactor = 1.01;
% optimizer.MaximumIterations = 300;


movingRegistered = imregister(moving, fixed, 'affine', optimizer, metric);

figure
imshowpair(fixed, movingRegistered,'Scaling','joint')













%%










%%










