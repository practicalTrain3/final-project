clear;
clc;

file_path='..\ͼ��(������)\����_�¼���';% ͼ���ļ���·��

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
    %��ȡ���ļ���������jpg��ʽ��ͼ��
    img_path_list = dir(strcat(sub_file_path,'*.jpg'));
    %��ȡͼ��������
    img_num = length(img_path_list);

    mat_path = dir(strcat(sub_file_path,'*.mat'));
    mat_name = mat_path(1).name;
    mat = load(strcat(sub_file_path,mat_name));
    match_matrix=mat.match_rate;
    [row,col]=size(match_matrix);
    sum_row=sum(match_matrix,2)';
    %���ÿ��ͼ���Ӧ��ƽ��ƥ���
    average_percent=(sum_row-100)./(row-1);
    %ȡƽ��ƥ�������ͼ����Ϊ������ͼ��
    [result,index]=max(average_percent);
    %�洢������ͼ������
    save([sub_file_path, 'mainpic'],'result','index');
end