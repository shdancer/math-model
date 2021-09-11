filename = '附件2 近5年8家转运商的相关数据';
filename2 = '附件A 订购方案数据结果';

load = xlsread(filename2,'问题2的订购方案结果');
trans = xlsread(filename);

spaceTrans = [];
for i = 1:24
    spaceTrans = [spaceTrans, sum(trans(:,(i-1)*10+1:i*10),2)/10];
end

originLoad = load;
load = ceil(load);

result = [];
for i = 1:24
    transData = zeros(402,8);
    [~,bagIndex] = sort(spaceTrans(:,i));
    bagPush = 1;
    nonzero = find(load(1:402,i)');
    while true
        [~, t] = size(nonzero);
        if t == 0
            break
        end
        [res,index] = Dp(load(nonzero,i)',6000);
        for j = nonzero(index)
            transData( j ,bagIndex(bagPush) ) = originLoad(j,i);
        end
        nonzero(index) = [];
        bagPush = bagPush + 1;
    end
    result = [result, transData];
end
xlswrite('第2题 转运方案',result);


function [maxVolume, index] = Dp(weight, volume)
    [~, count] = size(weight);
    dp = zeros(count,volume + 1);
    ischosen = zeros(count,volume + 1);
    dp(1,1) = 1;
    ischosen(1,1) = 1;
    dp(1,weight(1) + 1) = 1;
    ischosen(1,weight(1) + 1) =1;
    for i = 2:count
        for j = 1:volume + 1
            dp(i,j) = dp(i-1,j);
            if j - weight(i)  < 1
                continue
            end
            dp(i,j) = dp(i-1,j) || dp(i-1,j-weight(i));
            if dp(i-1,j-weight(i)) && weight(i) ~= 0
                ischosen(i,j) = 1;
            end
        end
    end
    
    maxVolume = -1;
    for i = volume + 1:-1:1
        if dp(count,i)
            maxVolume = i-1;
            break
        end
    end
    
    
    index = search(count,maxVolume + 1, weight,ischosen);
end

function index = search(i,j,weight,ischosen)
    if i == 1
        index = [];
        if ischosen(i,j)
            index = [index, 1];
        end
        return;
    end
    
    if ischosen(i,j)
        ret = search(i-1,j - weight(i),weight,ischosen);
        index = [ret, i];
    else
        ret = search(i-1,j,weight,ischosen);
        index = ret;
    end
end
            

        
    