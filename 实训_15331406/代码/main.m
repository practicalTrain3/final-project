clear;
clc;

file_path='..\图像集(不完整)\岭南_番禺余荫山房';% 图像文件夹路径

%获得文件夹file_path下所有子文件的路径
p=genpath(file_path);
%字符串p的长度
length_p=size(p,2);
%建立一个单元数组，每个单元包含一个文件目录
path={};
temp=[];
for i=1:length_p
    %寻找分割符';'
    if p(i)~=';'
        temp=[temp p(i)];
    else 
        temp=[temp '\'];
        path=[path ; temp];
        temp=[];
    end
end  
clear p length_p temp;

[file_num,dim]=size(path);

for m=8:file_num
    sub_file_path=path{m};
    %获取该文件夹中所有jpg格式的图像
    img_path_list=dir(strcat(sub_file_path,'*.jpg'));
    %获取图像总数量
    img_num=length(img_path_list);
        
    if img_num>0
        for i=1:img_num
            image_first_name=img_path_list(i).name;% 图像名
            image_first=imread(strcat(sub_file_path,image_first_name));
            for j=1:img_num %逐一读取图像
                image_second_name=img_path_list(i).name;% 图像名
                image_second=imread(strcat(sub_file_path,image_second_name));
                %将图片集中的所有图像两两匹配
                [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)]=sift_mosaic(mainpic,image_second);
            end
        end
    end
    %存储每张图像对应的match百分比
    save([sub_file_path,'match'],'match_rate');   
end

        

