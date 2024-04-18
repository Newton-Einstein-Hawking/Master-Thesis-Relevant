% 该脚本用于绘制三个波长的轴向相差
% i.e. longitudinal aberration

data = importdata('轴向像差zemax数据.txt')
% 他这个图的xy轴位置是颠倒的，所以我反过来画，
% 用参数值作为x轴，0到1（光瞳坐标）作为y轴
y = data.data(:,1);
% 下面三个分别是588nm, 656nm, 486nm的参数值
x588 = data.data(:,2);
x656 = data.data(:,3);
x486 = data.data(:,4);

hold on
plot(x486,y,'linewidth',1.5)
plot(x588,y,'linewidth',1.5)
plot(x656,y,'linewidth',1.5)

% 下面这个是中间那条坐标轴
xaxis = zeros(101);
yaxis = linspace(0,1,101);
plot(xaxis,yaxis,'black')

xlim([-0.02,0.02])
xticks([-0.02,-0.01,0,0.01,0.02])
yticks([0,0.2,0.4,0.6,0.8,1.0])
xlabel('Longitudinal aberration (mm)')
ylabel('Normalized pupil coordinates')
legend('486 nm','588 nm','656 nm',...
    'location','northwest','box','off','FontSize',15)

print('longitudinal aberration','-djpeg','-r300')