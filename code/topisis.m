%W,P ��Ҫ����w(4X1)p(402X4)��������
clear;
p = xlsread("��׼�������Ȩ�� (1)","��һ����");
w = xlsread("��׼�������Ȩ�� (1)","Ȩ��");
index = xlsread("ָ�� (1)","sheet1");
Z = zeros(402,4);
for i =1:402
    for j =1:4
        Z(i,j) = p(i,j)*w(j);
    end
end
 %��ȡp���к���
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

%����� �ٿ���
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
%postinon��λ�ñ�
[A,postion] = sort(C);
temp = flipud(postion);
paiming =temp(1:50);

temp = [paiming,index(paiming,:),C(paiming,:)];
xlswrite("�������",temp,"sheet1");

