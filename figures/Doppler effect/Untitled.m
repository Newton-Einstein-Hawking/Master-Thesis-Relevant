mu = 0; % 均值
sigma = 1; % 标准差
x = -6:.1:6; % 自变量取值范围
y = -(1./(sigma.*sqrt(2*pi)))*exp(-((x-mu).^2)./(2*sigma^2)); % 计算对应的y值
plot(x, y,'black','linewidth',2); % 绘制曲线图
ylim([-0.5,0.1])
xticks(0)
xticklabels('')
yticks(1)