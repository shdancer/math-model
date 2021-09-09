filename = '附件1 近5年402家供应商的相关数据.xlsx';
providesheet = '供应商的供货量（m³）';

[power, text] = xlsread(filename,providesheet);
text = text(2:403,2);

for i = 1:402
    divnum = 0;
    if char(text(i)) == 'A'
        divnum = 0.6;
    elseif char(text(i)) == 'B'
        divnum = 0.66;
    else
        divnum =0.72;
    end
    power(i,:) = power(i,:)./divnum;
end

xlswrite('转化产能表.xlsx',power);