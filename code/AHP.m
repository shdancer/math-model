filename = '标准化矩阵和权重.xlsx';
matrixsheet = '归一矩阵';
weightsheet = '权重';

matrix = xlsread(filename,matrixsheet);
weight = xlsread(filename,weightsheet);
zhi = xlsread('指标.xlsx');

score = weight * matrix';

[sortedScore, I] = sort(score);
top50 = flipud(I');
top50 = top50(1:50);
xlswrite('AHP结果.xlsx',[top50, zhi(top50,:),score(top50)']);
