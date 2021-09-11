clear;
[orderdata,ordertext] =xlsread("附件1 近5年402家供应商的相关数据","订货量");
givedata = xlsread("附件1 近5年402家供应商的相关数据","供应量");
for i = 2:403
    div =0;
    if ordertext{i,2} =='A'
        div = 0.6;
    elseif ordertext{i,2} == 'B'
        div =0.66;
    else
        div = 0.72;
    end
        givedata(i-1,:) = givedata(i-1,:)/div;
        orderdata(i-1,:) = orderdata(i-1,:)/div;
end

orderhe = sum(orderdata);
givehe = sum(givedata);

top50 = xlsread("结果排名");
kucun = 2*2.82e4;%库存量为2倍产能
%按照贪心算法 -- 应当选取最重要的前n个厂家，by default n=10
book=zeros(1,50);
n=10
while book(n)==0
    if n==49
        disp("overflow");
        break;
    end
    %载入名册  1-n
    topn_id = top50(1:n,1);
        %初始化库存
    kucun = 2*2.82e4;
    success =1;
    x=[];
    y=[];
    produce = 24289.2625;
    %%模拟1-240周会不会翻车(库存小于0)（如果会翻车book(n)=-1,n = n+1,继续测试,如果成功book(n)=1,n=n-1）
    for week =1:240%%降低标准至18000/week
        x = [x week];
        y = [y kucun];
        cangive = sum(givedata(topn_id,week));
        kucun = kucun +cangive -produce;
        if(kucun<0)
            success=0;
            disp("fail "+n+"in week:"+week);
            break;
        end
    end
    
    if success ==0
        book(n) = -1;
        n = n+1;
    else
        book(n) = 1;
        n=n-1;
    end
     disp(n)

end
plot(x,y)
legend("以订货量均值作为保障生产需求时的库存变动量");
xlabel("周数/周");
ylabel("库存量/立方米");
   
