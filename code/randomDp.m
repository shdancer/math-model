clear;

filename = '附件1 近5年402家供应商的相关数据.xlsx';
filename2 = '结果排名.xls';
providesheet = '供应商的供货量（m³）';
odersheet = '企业的订货量（m³）';

[power, text] = xlsread(filename,providesheet);
order = xlsread(filename, odersheet);
text = text(2:403,2);
ranki = xlsread(filename2);
top50 = ranki(:,1);
power = power(top50,:);
order = order(top50,:);
text = text(top50);
global text

for i = 1:50
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

global spacePower spaceOrder
spacePower = [];
spaceOrder = [];
for i = 1:24
  spacePower = [spacePower, sum(power(:,(i-1)*10+1:i*10),2)/10];
  spaceOrder = [spaceOrder, sum(order(:,(i-1)*10+1:i*10),2)/10];
end
spaceOrder = sum(spaceOrder,1);

global Vt 
Vt = containers.Map('1', containers.Map('0',containers.Map('0',0)));
for i = 1:10
    Vt(num2str(i)) = containers.Map('KeyType','char','ValueType','any');
    Vtt = Vt(num2str(i));
    for j = 1:24
       Vtt(num2str(j)) = containers.Map;
    end
end

global rest path
rest = containers.Map;
path = containers.Map;

final = V(10,24,520000)
for i = path.values
    i
end
function v = V(n, t, I)
  global Vt spacePower text rest path spaceOrder;
 
  Vn = Vt(num2str(n));
  Vtt = Vn(num2str(t));
  
  closestKeys = -1;
  if Vtt.Count ~= 0
      for keys = str2double(string(Vtt.keys()))
        if closestKeys == -1
            closestKeys = keys;
            continue;
        end
        if abs(closestKeys - I) > abs(keys - I)
            closestKeys = keys;
        end
      end
      if abs(closestKeys - I) <= 1e3
          v = Vtt(num2str(closestKeys));
          return;
      end
  end
  
  if t ~= 1
    plan = round(rand(10,50));
    T = -1;
    minNum = 1e10;
    for plans = 1:10
      %in = plan(plans,:) * spacePower(:,t)
      %out = spaceOrder(t)
      T = I - plan(plans,:) * spacePower(:,t) + 2.82e2;
      %if T < 0
      %  continue;
      %end
      
      cost = 0;
      for i = 1:50
        price = 0;
        if char(text(i)) == 'A'
              price = 0.6*1.2;
        elseif char(text(i)) == 'B'
              price = 0.66*1.1;
        else
              price = 0.72;
        end
        cost = cost + price * plan(plans,i) * spacePower(i,t);
      end

      if n == 1
        minNum = min([minNum, V(n, t-1, T) + cost ]);
      else
          if minNum >  0.7 * (V(n, t-1, T) + cost ) + 0.3 * (V(n-1, t-1, T) + cost ) 
              minNum =  0.7 * (V(n, t-1, T) + cost ) + 0.3 * (V(n-1, t-1, T) + cost ) ;
              if n == 5
                rest(num2str(t -1)) = I;
                path(num2str(t -1)) = plan(plans,:);
              end
          end
      end
    end

    Vtt(num2str(I)) = minNum;
    v = minNum;
    return;
  else
    Vtt(num2str(I)) = 1e10;
    v = 1e10;
    return;
  end
end
