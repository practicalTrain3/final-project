clear;
clc;

file_path='..\ͼ��(������)\����_��خ����ɽ��';% ͼ���ļ���·��

%����ļ���file_path���������ļ���·��
p=genpath(file_path);
%�ַ���p�ĳ���
length_p=size(p,2);
%����һ����Ԫ���飬ÿ����Ԫ����һ���ļ�Ŀ¼
path={};
temp=[];
for i=1:length_p
    %Ѱ�ҷָ��';'
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
    %��ȡ���ļ���������jpg��ʽ��ͼ��
    img_path_list=dir(strcat(sub_file_path,'*.jpg'));
    %��ȡͼ��������
    img_num=length(img_path_list);
        
    if img_num>0
        for i=1:img_num
            image_first_name=img_path_list(i).name;% ͼ����
            image_first=imread(strcat(sub_file_path,image_first_name));
            for j=1:img_num %��һ��ȡͼ��
                image_second_name=img_path_list(i).name;% ͼ����
                image_second=imread(strcat(sub_file_path,image_second_name));
                %��ͼƬ���е�����ͼ������ƥ��
                [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)]=sift_mosaic(mainpic,image_second);
            end
        end
    end
    %�洢ÿ��ͼ���Ӧ��match�ٷֱ�
    save([sub_file_path,'match'],'match_rate');   
end

        

