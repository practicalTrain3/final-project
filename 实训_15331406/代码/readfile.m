clear;
clc;

p = genpath('..\����_�¼���');% ����ļ���data���������ļ���·������Щ·�������ַ���p�У���';'�ָ�
length_p = size(p,2);%�ַ���p�ĳ���
path = {};%����һ����Ԫ���飬�����ÿ����Ԫ�а���һ��Ŀ¼
temp = [];
for i = 1:length_p %Ѱ�ҷָ��';'��һ���ҵ�����·��tempд��path������
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; %��·���������� '\'
        path = [path ; temp];
        temp = [];
    end
end  
clear p length_p temp;