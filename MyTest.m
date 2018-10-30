load config bs_coordinate snr snr_db M F_el;

cellNum = 7;
bsArr(1,cellNum) = BaseStation();  % 对象数组
for i = 1 : cellNum  % 七个小区
   bsArr(i) = BaseStation(bs_coordinate(2*i - 1), bs_coordinate(2*i)); 
end

for i = 1 : cellNum  % 计算用户分簇
   bsArr(i).calcUserClusters(4,4);
   bsArr(i).getTargetArr();
end

otherCellCell = cell(1, cellNum-1);
for i = 2 : cellNum  % 其他小区调度的用户
    otherCellCell{i-1} = bsArr(i).targetArr;
end
bsArr(1).otherCellArr = otherCellCell;
otherCellArr = bsArr(1).initOtherCellArr();  % 中心小区调度其他小区，所以其他小区的相对坐标角度要变换

% 获得其他小区用户的垂直协方差
sumR_el = zeros(M, M);
for i = 1 : length(otherCellArr)
    sumR_el = sumR_el + otherCellArr(i).R_el;
end
averageR_el = mean(sumR_el, 3);

% 计算零空间
[u, v, s] = svd(averageR_el);
eigMatrix = F_el' * averageR_el * F_el;  % 计算特征值的位置，找零空间
eig = diag(eigMatrix);
largeIndexArr = [];
for i = 1 : length(eig)
    if eig(i) > 50
        largeIndexArr = [largeIndexArr i];
    end
end 
newU = u;
for index = largeIndexArr
   newU(:,index) = u(:, end);
end
null_space = newU;
% null_index = sum(diag(v)>50) + 1; % 索引从下一个开始，零空间有多大，diag(v)>30 这个值越大越好 
% null_space = u(:,null_index:length(u)); 


% 计算多层预编码的和速率
rate_multiLayer = bsArr(1).calcSumRate(snr, null_space);

% 有多小区干扰的和速率
cellInterference = bsArr(1).clacCellInterference();
rate_withInterference = bsArr(1).calcRateWithCellInterference(snr, cellInterference);

% 没有干扰的和速率
rate_singleCell = bsArr(1).calcSumRate(snr);

% 单小区迫零预编码
rate_ZF_1 = bsArr(1).calcRateWithZF(snr, 3/4);
rate_ZF_2 = bsArr(1).calcRateWithZF(snr, 1/2);

% 单小区等效信道迫零预编码
rate_ZF_nullSpace = bsArr(1).calcRateWithZF(snr, 0, null_space);
rate_ZF_nullSpace_2 = bsArr(1).calcRateWithZF(snr, 1/6, null_space);
rate_ZF_nullSpace_3 = bsArr(1).calcRateWithZF(snr, 1/2, null_space);


figure;
plot(snr_db, rate_withInterference, '-*r','LineWidth',0.5);
hold on;
plot(snr_db, rate_multiLayer, '-sr','LineWidth',0.5);
hold on;
plot(snr_db, rate_singleCell, '-or','LineWidth',0.5);

hold on;
plot(snr_db, rate_ZF_1, '-*b','LineWidth',0.5);
hold on;
plot(snr_db, rate_ZF_2, '-ob','LineWidth',0.5);
hold on;
plot(snr_db, rate_ZF_nullSpace, '-sk','LineWidth',0.5);
hold on;
plot(snr_db, rate_ZF_nullSpace_2, '-dk','LineWidth',0.5);
hold on;
plot(snr_db, rate_ZF_nullSpace_3, '-^k','LineWidth',0.5);
legend('有干扰','多层预编码','单小区', '迫零,误差系数3/4','迫零,误差系数1/2','等效信道迫零', '等效信道迫零，误差系数1/6', '等效信道迫零，误差系数1/2');












% a = BaseStation();
% aa = a.calcUserClusters(4,4);
% snr_db = (-10:1:20);
% snr = 10.^(snr_db/10);
% cc = a.calcSumRate(snr);
% d1 = a.calcRateWithZF(snr, 3/4);
% d2 = a.calcRateWithZF(snr, 1/2);
% d3 = a.calcRateWithZF(snr, 1/3);
% d4 = a.calcRateWithZF(snr, 1/4);
% d5 = a.calcRateWithZF(snr, 1/5);
% d6 = a.calcRateWithZF(snr, 1/6);
% d7 = a.calcRateWithZF(snr, 1/7);
% d8 = a.calcRateWithZF(snr, 1/8);
% % disp(cc);
% figure;
% plot(snr_db,cc, '-*r');
% hold on;
% plot(snr_db,d1, '-sr');
% hold on;
% plot(snr_db,d2, '-sb');
% hold on;
% plot(snr_db,d3);
% hold on;
% plot(snr_db,d4, '-sb');
% hold on;
% plot(snr_db,d5);
% hold on;
% plot(snr_db,d6);
% hold on;
% plot(snr_db,d7);
% hold on;
% plot(snr_db,d8);



% for i = 1 : 100
% arr_az(i) = a.userArr(i).angle_az;
% arr_el(i) = a.userArr(i).angle_el;
% end
% for i = 1:100
% elArr(i) = unifrnd(-60,60);
% azArr(i) = unifrnd(-90, 90);
% end
% figure;
% subplot(2,2,1);plot(arr_az);
% subplot(2,2,2);plot(arr_el);
% subplot(2,2,3);plot(azArr);
% subplot(2,2,4);plot(elArr);



