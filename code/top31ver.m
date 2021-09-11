clear;

filename = '附件1 近5年402家供应商的相关数据.xlsx';
filename2 = '结果排名.xls';
providesheet = '供应量';

[power, text] = xlsread(filename,providesheet);
text = text(2:403,2);
ranki = xlsread(filename2);
top31 = ranki(1:31,1);
power = power(top31,:);
text = text(top31);
global text

for i = 1:31
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

global spacePower
spacePower = [];
for i = 1:24
  spacePower = [spacePower, sum(power(:,(i-1)*10+1:i*10),2)/10];
end

global Vt 
Vt = containers.Map('1', containers.Map('0',containers.Map('0',0)));
for i = 1:5
    Vt(num2str(i)) = containers.Map('KeyType','char','ValueType','any');
    Vtt = Vt(num2str(i));
    for j = 1:24
       Vtt(num2str(j)) = containers.Map;
    end
end

global rest path
rest = containers.Map;
path = containers.Map;

final = V(5,24,56000)
for i = path.values
    i
end
form = []
for i = path.values
   form = [form, cell2mat(i)']
end
form = [form zeros(31,1)] .* spacePower; 

xlswrite('data.xlsx',form);


function v = V(n, t, I)
  % temp = [n,t,I]
  global Vt spacePower text rest path;
  
  Vn = Vt(num2str(n));
  Vtt = Vn(num2str(t));
  
  Size = size(Vtt);
  closestKeys = -1;
  if Size(1) ~= 0
      for keys = str2num(string(Vtt.keys()))
        if closestKeys == -1
            closestKeys = keys;
            continue;
        end
        if abs(closestKeys - I) > abs(keys - I)
            closestKeys = keys;
        end
      end
      v = Vtt(num2str(closestKeys));
      return;
  end
  
  if t ~= 1
    plan = round(rand(1000,31));
    T = -1;
    minNum = 1e10;
    for plans = 1:1000
      T = I - plan(plans,:) * spacePower(:,t) + 2.82e4;
      if T < 0
        continue;
      end
      
      cost = 0;
      for i = 1:31
        price = 0;
        if char(text(i)) == 'A'
              price = 0.6;
        elseif char(text(i)) == 'B'
              price = 0.66;
        else
              price = 0.72;
        end
        cost = cost + price * plan(plans,i) * spacePower(i,t);
      end

      if n == 1
        minNum = min([minNum, V(n, t-1, T) + cost ]);
      else
          if minNum >  0.5 * (V(n, t-1, T) + cost ) + 0.5 * (V(n-1, t-1, T) + cost ) 
              minNum =  0.5 * (V(n, t-1, T) + cost ) + 0.5 * (V(n-1, t-1, T) + cost ) ;
              if n == 5
                rest(num2str(t -1)) = I;
                path(num2str(t -1)) = plan(plans,:);
              end
          end
      end
    end

    Vtt(num2str(T)) = minNum;
    v = minNum;
    return;
  else
    v = 0;
    return;
  end
end
