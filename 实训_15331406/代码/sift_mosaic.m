function [xmin,xmax,ymin,ymax,match_rate] = sift_mosaic(im1,im2)

if nargin==0
  im1=imread(fullfile(vl_root,'data','river1.jpg'));
  im2=imread(fullfile(vl_root,'data','river2.jpg'));
end

%��ͼ������ת��Ϊsingle����
im1=im2single(im1);
im2=im2single(im2);

%ת���ɻҶ�ͼ��
if size(im1,3)>1,im1g=rgb2gray(im1);
    else im1g=im1;
end
if size(im2,3)>1,im2g=rgb2gray(im2);
    else im2g=im2;
end

%SIFT matches
%��ȡ�����㣨���������꣬�����ӣ�
[f1,d1] = vl_sift(im1g) ;
[f2,d2] = vl_sift(im2g) ;
%����������ƥ�䣬Ĭ����ֵΪ1.5
[matches, scores] = vl_ubcmatch(d1,d2) ;
%��ȡƥ������
numMatches = size(matches,2) ;

%��ȡ����ͼ��ƥ��㼰��Ӧ������
X1=f1(1:2,matches(1,:));
X1(3,:)=1;
X2=f2(1:2,matches(2,:)); 
X2(3,:)=1 ;

% RANSAC with homography model����Ӧ�Ա任)
% 1.���������������ѡһ��RANSAC��������4��ƥ����
% 2.������4��ƥ���Լ���任����H
% 3.�������������任����H���������������������㵱ǰ�任�����һ�¼�,������һ�¼���Ԫ�ظ���
% 4.���ݵ�ǰһ�¼���Ԫ�ظ����ж��Ƿ�����(���)һ�¼�����������µ�ǰ����һ�¼�
% 5.���µ�ǰ�������p����p�����������С����������ظ�(1)��(4)����������ֱ����ǰ�������pС����С�������
clear H score ok ;
%����100�Σ�ѡ�����H
for t=1:100
  %��ѡƥ����
  subset=vl_colsubset(1:numMatches,4); %�����ȡ����
  A=[];
  for i=subset
    %�����������Kronecker��,���Ǿ���a�е�ÿ��Ԫ�ض����Ծ���b��
    A=cat(1,A,kron(X1(:,i)',vl_hat(X2(:,i)))); %vl_hatб�Գƾ���
  end
  %����ֵ�ֽ�
  [U,S,V] = svd(A);
  %�õ��任����
  H{t}=reshape(V(:,9),3,3) ;

  %���任��������Ӧ��
  X2_=H{t} * X1;
  du=X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:);
  dv=X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:);
  %�����С��20*20,����������
  ok{t}=(du.*du + dv.*dv) < 20*20;
  %��¼�������������
  score(t)=sum(ok{t});
end

[score,best] = max(score);
%ѡȡһ�¼�Ԫ�ظ������Ķ�Ӧ��H�任����
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
  %��һ���任����
  H = H/H(3,3);
  %ͨ��optimset���������Ż�����ѡ��opts
  opts=optimset('Display','none','TolFun',1e-8,'TolX',1e-8);
  %�Ż�����
  H(1:8)=fminsearch(@residual,H(1:8)',opts);
else
  warning('δ�ҵ�fminsearch!');
end

%��ʾ���
dh1=max(size(im2,1)-size(im1,1),0) ;
dh2=max(size(im1,1)-size(im2,1),0) ;

%��������ͼ��ֱ�Ϊim1��im2����ͼ��֮���ƥ����ò�ɫ������
%��ʾ����ƥ��㼰��ƥ���ϵ
figure(1) ; clf ;
%����vl_ubcmatch��ɸ���ƥ����
subplot(2,1,1) ;
imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
o=size(im1,2) ;
line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
     [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
title(sprintf('%d tentative matches', numMatches)) ;
axis image off ;

%�ٴ�ɸѡ����������ƥ���
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
%���㱣��ƥ���İٷֱ�
match_rate=100*sum(ok)/numMatches;

end