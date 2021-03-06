%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% S. Memi?, S. Engino?lu, and U. Erkan, 2022. A New Classification Method 
% Using Soft Decision-Making Based on an Aggregation Operator of Fuzzy 
% Parameterized Fuzzy Soft Matrices, Turkish Journal of Electrical 
% Engineering and Computer Sciences, 30(3), 1165?1180.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abbreviation of Journal Title: Turk. J. Electr. Eng. Comput. Sci.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://doi.org/10.55730/1300-0632.3816
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.researchgate.net/profile/Samet_Memis2
% https://www.researchgate.net/profile/Serdar_Enginoglu2
% https://www.researchgate.net/profile/Ugur_Erkan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Demo: 
% clc;
% clear all;
% DM = importdata('Wine.mat');
% [x,y]=size(DM);
% 
% data=DM(:,1:end-1);
% class=DM(:,end);
% if prod(class)==0
%     class=class+1;
% end
% k_fold=5;
% cv = cvpartition(class,'KFold',k_fold);
%     for i=1:k_fold
%         test=data(cv.test(i),:);
%         train=data(~cv.test(i),:);
%         T=class(cv.test(i),:);
%         C=class(~cv.test(i),:);
%     
%         sFPFSAC=FPFSAC(train,C,test);
%         accuracy(i,:)=sum(sFPFSAC==T)/numel(T);
%     end
% mean_accuracy=mean(accuracy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PredictedClass=FPFSAC(train,C,test)
[em,en]=size(train);
[tm,n]=size(test);

  for j=1:en
      fw(1,j)=abs(corr(train(:,j),C,'Type','Pearson','Rows','complete'));
  end
  fw(isnan(fw))=0;

data=[train;test];
for j=1:n
    data(:,j)=normalise(data(:,j));
end
train=data(1:em,:);
test=data(em+1:end,:);

 for i=1:tm   
    clear cm dm;
    a=[fw ; test(i,:)];
    for j=1:em
        b=[fw ; train(j,:)];
        cm(j,1)=fpfss1(a,b);
        cm(j,2)=fpfss3(a,b);
        cm(j,3)=fpfss5(a,b);
        cm(j,4)=fpfss6(a,b,3);
        a1=test(i,:);
        a2=train(j,:);
        a1(a1==0)=0.0001;
        a2(a2==0)=0.0001;
        cm(j,5)=1-(2/pi)*atan(sum(abs(1-eig(diag(a1),diag(a2)))));
    end
    
    for jj=1:size(cm,2)
        sd(jj)=std(cm(:,jj));
    end
      wm(:)=1-normalise(sd);

     dm(:,:)=[ wm ; cm];

    [~,~,op]=CCE10(dm);
    PredictedClass(i,1)=C(op(1),1);  
    
 end

end

function na=normalise(a)
[m,n]=size(a);
    if max(a)~=min(a)
        na=(a-min(a))/(max(a)-min(a));
    else
        na=ones(m,n);
    end
end                                                                                                                                                                  

% Hamming pseudo similarity over fpfs-matrices
% 
% 
function X=fpfss1(a,b)
if size(a)~=size(b)
    
else
[m,n]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j)*a(i,j)-b(1,j)*b(i,j));
    end
  end
  X=1-(d/((m-1)*n));
end
end
% Chebyshev pseudo similarity over fpfs-matrices
% 
% 
function X=fpfss2(a,b)
if size(a)~=size(b)
    
else
[m,n]=size(a);

  for i=2:m
    for j=1:n
       d(j)=abs(a(1,j)*a(i,j)-b(1,j)*b(i,j));
    end
    e(i-1)=max(d);
  end
  X=1-max(e);
end
end
% Euclidean pseudo similarity over fpfs-matrices
% 
%
function X=fpfss3(a,b)
if size(a)~=size(b)
    
else
[m,n]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j)*a(i,j)-b(1,j)*b(i,j))^2;
    end
  end
  X=1-(sqrt(d)/(sqrt((m-1)*n)));
end
end
% Hamming-Hausdorff pseudo similarity over fpfs-matrices
% 
%
function X=fpfss5(a,b)
if size(a)~=size(b)
    
else
[m,n]=size(a);

  for i=2:m
    for j=1:n
       d(j)=abs(a(1,j)*a(i,j)-b(1,j)*b(i,j));
    end
    e(i-1)=max(d);
  end
  X=1-(sum(e)/(m-1));
end
end
% Generalized pseudo similarity over fpfs-matrices
% 
%
function X=fpfss6(a,b,p)
if size(a)~=size(b)
    
else
[m,n]=size(a);
d=0;
  for i=2:m
    for j=1:n
       d=d+abs(a(1,j)*a(i,j)-b(1,j)*b(i,j))^p;
    end
  end
  X=1-((d^(1/p))/(((m-1)*n)^(1/p)));
end
end