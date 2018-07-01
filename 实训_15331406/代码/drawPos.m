clear;
clc;

%显示匹配矩形框

% sub_file_path= '.\图像集(不完整)\岭南_陈家祠\屋顶\';
% sub_file_path= '.\图像集(不完整)\岭南_番禺余荫山房\灯笼\';
sub_file_path= '..\图像集(不完整)\岭南_番禺余荫山房\沙湾玉虚宫\';

%加载主建筑图像匹配信息
mat_path = strcat(sub_file_path,'match_position.mat');
mat = load(mat_path);
xmin_mat=mat.xmin;
xmax_mat=mat.xmax;
ymin_mat=mat.ymin;
ymax_mat=mat.ymax;
[m,n]=size(xmax_mat);

%获取该文件夹中所有jpg格式的图像
img_path_list = dir(strcat(sub_file_path,'*.jpg'));
%获取图像总数量
img_num = length(img_path_list);
mat_name='mainpic.mat';
%获取主建筑图像匹配点位置信息
mainpic_mat = load(strcat(sub_file_path,mat_name));
pic_index=mainpic_mat.index;
%获取主建筑图像
mainpic_name=img_path_list(pic_index).name;
mainpic=imread(strcat(sub_file_path,mainpic_name));
    
for i=1:n
    if i~=pic_index
    pt=[round(xmin_mat(i)),round(ymin_mat(i))];
    wx=round(ymax_mat(i))-round(ymin_mat(i));
    wy=round(xmax_mat(i))-round(xmin_mat(i));
    wSize=[wy, wx];
    lineSize=5;
    match_pic_name=img_path_list(i).name;
    matchpic=imread(strcat(sub_file_path,match_pic_name));
    
    %显示主建筑图像
    figure;
    imshow(mainpic);
    color=[255 255 0];
    %绘制匹配区域矩形框
    [rec]=drawRect(mainpic,pt,wSize,lineSize,color);

    subplot(1,2,1);
    imshow(matchpic);
    subplot(1,2,2);
    imshow(rec);
    end
end


