clear;
clc;

%����ƥ�亯��
sub_file_path= '..\ͼ��(������)\����_�¼���\�ݶ�\';
% sub_file_path= '..\ͼ��(������)\����_��خ����ɽ��\����\';
% sub_file_path= '..\ͼ��(������)\����_��خ����ɽ��\ɳ�����鹬\';

%��ȡ���ļ���������jpg��ʽ��ͼ��
img_path_list = dir(strcat(sub_file_path,'*.jpg'));
%��ȡͼ��������
img_num=length(img_path_list);
mat_name='mainpic.mat';
%��ȡ������ͼ��ƥ���λ����Ϣ
mainpic_mat=load(strcat(sub_file_path,mat_name));
pic_index=mainpic_mat.index;
%��ȡ������ͼ��
mainpic_name=img_path_list(pic_index).name;
mainpic=imread(strcat(sub_file_path,mainpic_name));
    
% for i=1:img_num
%     if i~=pic_index
    image_second_name = img_path_list(2).name;% ͼ����
    image_second=imread(strcat(sub_file_path,image_second_name));
    %��ͼ���е�ÿһ��ͼ����������ͼ��ƥ��
%     [xmin(i),xmax(i),ymin(i),ymax(i),match_rate(i)] = sift_mosaic(mainpic,image_second);
    [xmin,xmax,ymin,ymax,match_rate] = sift_mosaic(mainpic,image_second);
%     end
% end