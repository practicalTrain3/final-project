function [rec]=drawRect(src,pt,wSize,lineSize,color)
%简介：
% %将图像画上有颜色的框图，如果输入是灰度图，先转换为彩色图像，再画框图
% 图像矩阵
% 行向量方向是y
% 列向量方向是x
%----------------------------------------------------------------------
%输入：
% src：原始图像，可以为灰度图，可为彩色图
% pt：左上角坐标[x1,y1]
% wSize：画框大小[wx,wy]
% lineSize：线宽
% color：颜色[r,g,b] 
%----------------------------------------------------------------------
%flag=1: 有缺口的框
%flag=2: 无缺口的框
flag = 1;
%判断输入参数个数
if nargin < 5
    color = [255 255 0];
end

if nargin < 4
    lineSize = 1;
end

if nargin < 3
    disp('输入参数不够');
    return;
end

%判断框的边界问题
[height,width,z]=size(src);
xmin=pt(1);
ymin=pt(2);
wx=wSize(1);
wy=wSize(2);
if  xmin>width || ...
        ymin>height||...
        (xmin+wx)>width||...
        (ymin+wy)>height
    disp('画框超过图像');
    return;
end

%如果是单通道的灰度图，转成3通道的图像
if 1==z
    rec(:,:,1)=src;
    rec(:,:,2)=src;
    rec(:,:,3)=src;
else
    rec=src;
end

%画框
for dim=1:3
    for dl=1:lineSize
        d=dl-1;
        %有缺口
        if 1==flag
            %画框线条
            rec(ymin-d,xmin:(xmin+wx),dim)=color(dim);
            rec(ymin+wy+d,xmin:(xmin+wx),dim)=color(dim);
            rec(ymin:(ymin+wy),xmin-d,dim)=color(dim);
            rec(ymin:(ymin+wy),xmin+wx+d,dim)=color(dim);
        %无缺口
        elseif 2==flag
            rec(ymin-d,(xmin-d):(xmin+wx+d),dim)=color(dim);
            rec(ymin+wy+d,(xmin-d):(xmin+wx+d),dim)=color(dim);
            rec((ymin-d):(ymin+wy+d),xmin-d,dim)=color(dim);
            rec((ymin-d):(ymin+wy+d),xmin+wx+d,dim)=color(dim);
        end
    end    
end

end