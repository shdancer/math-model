clear;
[orderdata,ordertext] =xlsread("����1 ��5��402�ҹ�Ӧ�̵��������","������");
givedata = xlsread("����1 ��5��402�ҹ�Ӧ�̵��������","��Ӧ��");
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

top50 = xlsread("�������");
kucun = 2*2.82e4;%�����Ϊ2������
%����̰���㷨 -- Ӧ��ѡȡ����Ҫ��ǰn�����ң�by default n=10
book=zeros(1,50);
n=10
while book(n)==0
    if n==49
        disp("overflow");
        break;
    end
    %��������  1-n
    topn_id = top50(1:n,1);
        %��ʼ�����
    kucun = 2*2.82e4;
    success =1;
    x=[];
    y=[];
    produce = 24289.2625;
    %%ģ��1-240�ܻ᲻�ᷭ��(���С��0)������ᷭ��book(n)=-1,n = n+1,��������,����ɹ�book(n)=1,n=n-1��
    for week =1:240%%���ͱ�׼��18000/week
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
legend("�Զ�������ֵ��Ϊ������������ʱ�Ŀ��䶯��");
xlabel("����/��");
ylabel("�����/������");
   
