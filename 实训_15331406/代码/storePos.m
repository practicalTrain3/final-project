clear;
clc;

file_path='..\ͼ��(������)\����_��خ����ɽ��';% ͼ���ļ���·��

%����ļ���file_path���������ļ���·��
p=genpath(file_path);
length_p=size(p,2);
%����һ����Ԫ���飬ÿ����Ԫ����һ���ļ�Ŀ¼
path={};
temp=[];
for i=1:length_p
     %Ѱ�ҷָ��';'
    if p(i)~=';'
        temp=[temp p(i)];
    else 
         %��·���������� '\'
        temp=[temp '\'];
        path=[path ; temp];
        temp=[];
    end
end  
clear p length_p temp;

[file_num,dim]=size(path);
for m=1:file_num
    sub_file_path=path{m};
    %sub_file_path= '.\����_�¼���\�ݶ�\';
    %��ȡ�ļ���������jpg��ʽ��ͼ��
    img_path_list=dir(strcat(sub_file_path,'*.jpg'));
    %��ȡͼ��������
    img_num=length(img_path_list);
    mat_name='mainpic.mat';
    mainpic_mat=load(strcat(sub_file_path,mat_name));
    pic_index=mainpic_mat.index;
    mainpic_name=img_path_list(pic_index).name;
    %��ȡmainpic��������ͼ��
    mainpic=imread(strcat(sub_file_path,mainpic_name));    
       
    if img_num>0
        for i=1:img_num
            image_second_name = img_path_list(i).name;% ͼ����
            image_second =  imread(strcat(sub_file_path,image_second_name));
            %��ͼ���е�ÿһ��ͼ����������ͼ��ƥ��
            [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)] = sift_mosaic(mainpic,image_second);
        end
    end
    %�洢ƥ�����ݣ�����ƥ���������Сx,y�����
    save([sub_file_path, 'match_position'],'xmin','xmax','ymin','ymax','match_rate');
end

        

