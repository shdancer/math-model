%W,P 需要导入w(4X1)p(402X4)两个矩阵
clear;
p = xlsread("标准化矩阵和权重 (1)","归一矩阵");
w = xlsread("标准化矩阵和权重 (1)","权重");
index = xlsread("指标 (1)","sheet1");
Z = zeros(402,4);
for i =1:402
    for j =1:4
        Z(i,j) = p(i,j)*w(j);
    end
end
 %读取p的行和列
best =[0,0,0,0];
worst=[1,1,1,1];
[r,c] = size(p);
for j =1:c
    for i =1:r
        if Z(i,j)>best(j)
            best(j) = Z(i,j);
        end
        if Z(i,j)<worst(j)
            worst(j) = Z(i,j);
        end
    end
end

%先求和 再开方
[r,c] = size(Z);
Dplus = zeros(402,1);
Dsub = zeros(402,1);
for i = 1:r
    for j = 1:c
        Dplus(i) = Dplus(i)+ (Z(i,j)-best(j))^2;
        Dsub(i) = Dsub(i)+(Z(i,j)-worst(j))^2;
    end
end
for i =1:r
        Dplus(i) = sqrt(Dplus(i));
        Dsub(i) =sqrt(Dsub(i));      
end
C = zeros(402,1);
for i = 1:402
    %% 
    C(i) = Dsub(i)/(Dplus(i) + Dsub(i));
end
%postinon是位置表
[A,postion] = sort(C);
temp = flipud(postion);
paiming =temp(1:50);

temp = [paiming,index(paiming,:),C(paiming,:)];
xlswrite("结果排名",temp,"sheet1");

