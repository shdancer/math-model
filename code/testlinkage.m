rng('default')
X = xlsread('标准化矩阵和权重','归一矩阵');
paiming = xlsread('结果排名');
Z = linkage(X, 'ward');
c = cluster(Z, 'Maxclust', 3);
large = ones(402,1) * 10;
large(paiming(:,1)) = 300;
scatter3(X(:,1),X(:,2),X(:,3),large,c)