clear;
clc;

%��ʾƥ����ο�

% sub_file_path= '.\ͼ��(������)\����_�¼���\�ݶ�\';
% sub_file_path= '.\ͼ��(������)\����_��خ����ɽ��\����\';
sub_file_path= '..\ͼ��(������)\����_��خ����ɽ��\ɳ�����鹬\';

%����������ͼ��ƥ����Ϣ
mat_path = strcat(sub_file_path,'match_position.mat');
mat = load(mat_path);
xmin_mat=mat.xmin;
xmax_mat=mat.xmax;
ymin_mat=mat.ymin;
ymax_mat=mat.ymax;
[m,n]=size(xmax_mat);

%��ȡ���ļ���������jpg��ʽ��ͼ��
img_path_list = dir(strcat(sub_file_path,'*.jpg'));
%��ȡͼ��������
img_num = length(img_path_list);
mat_name='mainpic.mat';
%��ȡ������ͼ��ƥ���λ����Ϣ
mainpic_mat = load(strcat(sub_file_path,mat_name));
pic_index=mainpic_mat.index;
%��ȡ������ͼ��
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
    
    %��ʾ������ͼ��
    figure;
    imshow(mainpic);
    color=[255 255 0];
    %����ƥ��������ο�
    [rec]=drawRect(mainpic,pt,wSize,lineSize,color);

    subplot(1,2,1);
    imshow(matchpic);
    subplot(1,2,2);
    imshow(rec);
    end
end


