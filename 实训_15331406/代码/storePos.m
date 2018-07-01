clear;
clc;

file_path='..\图像集(不完整)\岭南_番禺余荫山房';% 图像文件夹路径

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
    %sub_file_path= '.\岭南_陈家祠\屋顶\';
    %获取文件夹中所有jpg格式的图像
    img_path_list=dir(strcat(sub_file_path,'*.jpg'));
    %获取图像总数量
    img_num=length(img_path_list);
    mat_name='mainpic.mat';
    mainpic_mat=load(strcat(sub_file_path,mat_name));
    pic_index=mainpic_mat.index;
    mainpic_name=img_path_list(pic_index).name;
    %读取mainpic（主建筑图像）
    mainpic=imread(strcat(sub_file_path,mainpic_name));    
       
    if img_num>0
        for i=1:img_num
            image_second_name = img_path_list(i).name;% 图像名
            image_second =  imread(strcat(sub_file_path,image_second_name));
            %将图像集中的每一张图像与主建筑图像匹配
            [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)] = sift_mosaic(mainpic,image_second);
        end
    end
    %存储匹配数据，包括匹配区域的最小x,y坐标等
    save([sub_file_path, 'match_position'],'xmin','xmax','ymin','ymax','match_rate');
end

        

