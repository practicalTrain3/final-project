function [rec]=drawRect(src,pt,wSize,lineSize,color)
%��飺
% %��ͼ��������ɫ�Ŀ�ͼ����������ǻҶ�ͼ����ת��Ϊ��ɫͼ���ٻ���ͼ
% ͼ�����
% ������������y
% ������������x
%----------------------------------------------------------------------
%���룺
% src��ԭʼͼ�񣬿���Ϊ�Ҷ�ͼ����Ϊ��ɫͼ
% pt�����Ͻ�����[x1,y1]
% wSize�������С[wx,wy]
% lineSize���߿�
% color����ɫ[r,g,b] 
%----------------------------------------------------------------------
%flag=1: ��ȱ�ڵĿ�
%flag=2: ��ȱ�ڵĿ�
flag = 1;
%�ж������������
if nargin < 5
    color = [255 255 0];
end

if nargin < 4
    lineSize = 1;
end

if nargin < 3
    disp('�����������');
    return;
end

%�жϿ�ı߽�����
[height,width,z]=size(src);
xmin=pt(1);
ymin=pt(2);
wx=wSize(1);
wy=wSize(2);
if  xmin>width || ...
        ymin>height||...
        (xmin+wx)>width||...
        (ymin+wy)>height
    disp('���򳬹�ͼ��');
    return;
end

%����ǵ�ͨ���ĻҶ�ͼ��ת��3ͨ����ͼ��
if 1==z
    rec(:,:,1)=src;
    rec(:,:,2)=src;
    rec(:,:,3)=src;
else
    rec=src;
end

%����
for dim=1:3
    for dl=1:lineSize
        d=dl-1;
        %��ȱ��
        if 1==flag
            %��������
            rec(ymin-d,xmin:(xmin+wx),dim)=color(dim);
            rec(ymin+wy+d,xmin:(xmin+wx),dim)=color(dim);
            rec(ymin:(ymin+wy),xmin-d,dim)=color(dim);
            rec(ymin:(ymin+wy),xmin+wx+d,dim)=color(dim);
        %��ȱ��
        elseif 2==flag
            rec(ymin-d,(xmin-d):(xmin+wx+d),dim)=color(dim);
            rec(ymin+wy+d,(xmin-d):(xmin+wx+d),dim)=color(dim);
            rec((ymin-d):(ymin+wy+d),xmin-d,dim)=color(dim);
            rec((ymin-d):(ymin+wy+d),xmin+wx+d,dim)=color(dim);
        end
    end    
end

end