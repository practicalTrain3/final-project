function [xmin,xmax,ymin,ymax,match_rate] = sift_mosaic(im1,im2)

if nargin==0
  im1=imread(fullfile(vl_root,'data','river1.jpg'));
  im2=imread(fullfile(vl_root,'data','river2.jpg'));
end

%将图像数据转换为single类型
im1=im2single(im1);
im2=im2single(im2);

%转换成灰度图像
if size(im1,3)>1,im1g=rgb2gray(im1);
    else im1g=im1;
end
if size(im2,3)>1,im2g=rgb2gray(im2);
    else im2g=im2;
end

%SIFT matches
%提取特征点（特征点坐标，描述子）
[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;
%根据特征点匹配，默认阈值为1.5
[matches, scores] = vl_ubcmatch(d1,d2) ;
%获取匹配点个数
numMatches = size(matches,2) ;

%获取两幅图的匹配点及对应描述子
X1=f1(1:2,matches(1,:));
X1(3,:)=1;
X2=f2(1:2,matches(2,:)); 
X2(3,:)=1 ;

% RANSAC with homography model（单应性变换)
% 1.从样本集中随机抽选一个RANSAC样本，即4个匹配点对
% 2.根据这4个匹配点对计算变换矩阵H
% 3.根据样本集，变换矩阵H，和误差度量函数计算满足当前变换矩阵的一致集,并返回一致集中元素个数
% 4.根据当前一致集中元素个数判断是否最优(最大)一致集，若是则更新当前最优一致集
% 5.更新当前错误概率p，若p大于允许的最小错误概率则重复(1)至(4)继续迭代，直到当前错误概率p小于最小错误概率
clear H score ok ;
%迭代100次，选择最佳H
for t=1:100
  %抽选匹配点对
  subset=vl_colsubset(1:numMatches,4); %随机抽取四列
  A=[];
  for i=subset
    %求两个矩阵的Kronecker积,就是矩阵a中的每个元素都乘以矩阵b。
    A=cat(1,A,kron(X1(:,i)',vl_hat(X2(:,i)))); %vl_hat斜对称矩阵
  end
  %奇异值分解
  [U,S,V] = svd(A);
  %得到变换矩阵
  H{t}=reshape(V(:,9),3,3) ;

  %经变换矩阵计算对应点
  X2_=H{t} * X1;
  du=X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:);
  dv=X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:);
  %若误差小于20*20,则保留特征点
  ok{t}=(du.*du + dv.*dv) < 20*20;
  %记录保留特征点个数
  score(t)=sum(ok{t});
end

[score,best] = max(score);
%选取一致集元素个数最大的对应的H变换矩阵
H=H{best};
ok=ok{best};

function err=residual(H)
 u=H(1)*X1(1,ok)+H(4)*X1(2,ok)+H(7);
 v=H(2)*X1(1,ok)+H(5)*X1(2,ok)+H(8);
 d=H(3)*X1(1,ok)+H(6)*X1(2,ok)+1;
 du=X2(1,ok)- u./d;
 dv=X2(2,ok)-v./d;
 err=sum(du.*du+dv.*dv);
end

xmin=min(f1(1,matches(1,ok)));
xmax=max(f1(1,matches(1,ok)));
ymin=min(f1(2,matches(1,ok)));
ymax=max(f1(2,matches(1,ok)));

if exist('fminsearch')==2
  %归一化变换矩阵
  H = H/H(3,3);
  %通过optimset函数设置优化参数选项opts
  opts=optimset('Display','none','TolFun',1e-8,'TolX',1e-8);
  %优化参数
  H(1:8)=fminsearch(@residual,H(1:8)',opts);
else
  warning('未找到fminsearch!');
end

%显示配对
dh1=max(size(im2,1)-size(im1,1),0) ;
dh2=max(size(im1,1)-size(im2,1),0) ;

%左右两边图像分别为im1和im2，两图像之间的匹配点用彩色线相连
%显示所有匹配点及其匹配关系
figure(1) ; clf ;
%经由vl_ubcmatch初筛后的匹配结果
subplot(2,1,1) ;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o=size(im1,2) ;
line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
     [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
title(sprintf('%d tentative matches', numMatches)) ;
axis image off ;

%再次筛选后保留下来的匹配点
subplot(2,1,2) ;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o=size(im1,2) ;
line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
     [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
              sum(ok), ...
              100*sum(ok)/numMatches, ...
              numMatches));
axis image off ;

drawnow ;
%计算保留匹配点的百分比
match_rate=100*sum(ok)/numMatches;

end