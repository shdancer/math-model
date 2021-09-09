filename = '附件1 近5年402家供应商的相关数据.xlsx';
ordersheet = '企业的订货量（m³）';
providesheet = '供应商的供货量（m³）';

%读入数据
order = xlsread(filename,ordersheet);
provide = xlsread(filename,providesheet);

%计算同步率方差和均值
meanratio = [];
varratio = [];
for i = 1:402
  campany = order(i,:);
  provider = provide(i,:);
  ratio = provider./campany;
  numberIndex = find(~isnan(ratio));
  ratio = ratio(numberIndex);
  meanratio = [meanratio, mean(ratio)];
  varratio = [varratio, var(ratio)];
end

%计算总供货量和和单次供货最大值
sumorder = sum(provide, 2);
maxorder = max(provide,[], 2);
xlswrite('指标.xlsx',[meanratio', varratio', sumorder, maxorder]);



%正向化归一化
meanratio = 1 - abs(meanratio - 1)/max(abs(meanratio - 1));
meanratio = unify(meanratio);
meanratio = handleZero(meanratio);

varratio = max(varratio) - varratio;
varratio = unify(varratio);
varratio = handleZero(varratio);

sumorder = unify(sumorder);
sumorder = handleZero(sumorder);

maxorder = unify(maxorder);
maxorder = handleZero(maxorder);

indexMatrix = [meanratio', varratio', sumorder, maxorder];
xlswrite('标准化矩阵和权重.xlsx',indexMatrix,'归一矩阵');

%计算信息熵
for i = 1:4
  line = indexMatrix(:,i);
  line = line ./ sum(line);
  indexMatrix(:,i) = line;
end

E = - (sum(indexMatrix .* log(indexMatrix)))/log(402);

%计算权重
w = (1 - E)/(4 - sum(E));
xlswrite('标准化矩阵和权重.xlsx',w,'权重');

%定义归一化函数
function ret = unify(array)
  ret = (array - min(array))/(max(array) - min(array));
end
function ret = handleZero(array)
  array(find(array == 0)) = 0.00001;
  ret = array;
end
