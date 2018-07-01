clear;
clc;

file_path='..\图像集(不完整)\岭南_陈家祠';% 图像文件夹路径

%获得文件夹file_path下所有子文件的路径
p=genpath(file_path);
length_p=size(p,2);
%建立一个单元数组，每个单元包含一个文件目录
path={};
temp=[];
for i=1:length_p
    %寻找分割符';'
    if p(i)~=';'
        temp=[temp p(i)];
    else 
        %在路径的最后加入 '\'
        temp=[temp '\'];
        path=[path ; temp];
        temp=[];
    end
end  
clear p length_p temp;

[file_num,dim]=size(path);

for m=1:file_num
    sub_file_path=path{m};
    %获取该文件夹中所有jpg格式的图像
    img_path_list = dir(strcat(sub_file_path,'*.jpg'));
    %获取图像总数量
    img_num = length(img_path_list);

    mat_path = dir(strcat(sub_file_path,'*.mat'));
    mat_name = mat_path(1).name;
    mat = load(strcat(sub_file_path,mat_name));
    match_matrix=mat.match_rate;
    [row,col]=size(match_matrix);
    sum_row=sum(match_matrix,2)';
    %求出每张图像对应的平均匹配度
    average_percent=(sum_row-100)./(row-1);
    %取平均匹配度最大的图像作为主建筑图像
    [result,index]=max(average_percent);
    %存储主建筑图像索引
    save([sub_file_path, 'mainpic'],'result','index');
end