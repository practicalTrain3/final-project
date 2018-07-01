clear;
clc;

%测试匹配函数
sub_file_path= '..\图像集(不完整)\岭南_陈家祠\屋顶\';
% sub_file_path= '..\图像集(不完整)\岭南_番禺余荫山房\灯笼\';
% sub_file_path= '..\图像集(不完整)\岭南_番禺余荫山房\沙湾玉虚宫\';

%获取该文件夹中所有jpg格式的图像
img_path_list = dir(strcat(sub_file_path,'*.jpg'));
%获取图像总数量
img_num=length(img_path_list);
mat_name='mainpic.mat';
%获取主建筑图像匹配点位置信息
mainpic_mat=load(strcat(sub_file_path,mat_name));
pic_index=mainpic_mat.index;
%获取主建筑图像
mainpic_name=img_path_list(pic_index).name;
mainpic=imread(strcat(sub_file_path,mainpic_name));
    
% for i=1:img_num
%     if i~=pic_index
    image_second_name = img_path_list(2).name;% 图像名
    image_second=imread(strcat(sub_file_path,image_second_name));
    %将图像集中的每一张图像与主建筑图像匹配
%     [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)] = sift_mosaic(mainpic,image_second);
    [xmin,xmax,ymin,ymax,match_rate] = sift_mosaic(mainpic,image_second);
%     end
% end