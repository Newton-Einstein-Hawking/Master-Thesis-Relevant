% figure(1)是最终用来算OD的图，就是处理完的那个图
% figure(2)是probe beam的图
% figure(3)是absorption image的图
% figure(4)是background的图
% figure(5)是取了figure(1)中间的一部分，也就是
% 用来算OD的那部分，搭配上OD的曲线图

bg1 = imread('bg.png');
probe1 = imread('probe.png');
image1 = imread('absorption_7A.png');

% 选取中间的101*101个像素
a = 635; b = 735; c = 720; d = 820;

image = double(image1(a:b,c:d)); % image是吸收成像的图
probe = double(probe1(a:b,c:d)); % probe是dipole trap off时的probe的图
bg = double(bg1(a:b,c:d));

figure(1)
result1 = (image-bg)./(probe-bg);
result = result1/max(max(result1)); % 归一化一下
imagesc(result)
colorbar
xticks([0,50,100]);
yticks([0,50,100]);
% 用了xticks后，他坐标不显示0，只显示50和100
% 但是加上下面这句xlim之后就好了，不知道为什么
xlim([0,100]); 
ylim([0,100]); 
set(colorbar,'YTick',[0,0.5,1])
set(gca,'fontsize',22)
print('a_result','-dpng','-r300')

figure(2)
imagesc(probe/max(max(probe)))
colorbar
xticks([0,50,100]);
yticks([0,50,100]);
xlim([0,100]); 
ylim([0,100]); 
set(colorbar,'YTick',[0.4,0.7,1])
set(gca,'fontsize',22)
print('a_probe','-dpng','-r300')

figure(3)
imagesc(image/max(max(image)))
colorbar
xticks([0,50,100]);
yticks([0,50,100]);
xlim([0,100]); 
ylim([0,100]); 
set(colorbar,'YTick',[0.5,1])
set(gca,'fontsize',22)
print('a_absorption','-dpng','-r300')

figure(4)
imagesc(bg/max(max(bg)))
colorbar
xticks([0,50,100]);
yticks([0,50,100]);
xlim([0,100]); 
ylim([0,100]); 
set(colorbar,'YTick',[0.5,1])
set(gca,'fontsize',22)
print('a_background','-dpng','-r300')

% figure(5)是测OD的
% 这块是左边那个彩色的测量图
figure(5)
hold on
subplot(1,2,1)
result2 = result1(:,40:50); % 进一步截取figure(1)中的10个像素
result_for_OD = result2/max(max(result2)); % 归一化
imagesc(result_for_OD)
% colorbar
% set(colorbar,'YTick',[0,0.5,1.0],'fontsize',15)
% 下面这行是调整figure的窗口的尺寸，[]中的
% 四个参数分别是左边距，下边距，宽度，高度
% （挨个改改试试就知道了）
set(gca,'position',[0.4,0.14,0.1,0.79])
xticks([0,10]);
yticks([0,50,100]);
xlim([0,10]);
ylim([0,100]);
xlabel('Pixels')
ylabel('Pixels')
set(gca,'fontsize',18)
xtickangle(0)
% 下面这块是右边那个OD的曲线图
subplot(1,2,2)
% 画这个图的时候，一定记得：
% 先把image probe bg的数据求和，然后再做比
% 否则画出来的图是不对的
% 千万不要先做比再求和
x = (0:100) * 5.86 * 400/150;
image_OD = sum(image(:,40:50),2);
probe_OD = sum(probe(:,40:50),2);
bg_OD = sum(bg(:,40:50),2);
result_OD = (image_OD-bg_OD)./(probe_OD-bg_OD);
plot(-log(result_OD),x,'bo--','linewidth',1.5)
yticklabels('') % 这个是让y轴不显示
xlim([-0.2,2.5])
xticks([0,1,2])
xlabel('OD')
set(gca,'fontsize',18)
print('a_image with OD curve','-dpng','-r300')
hold off

figure(6)
hold on
plot(x,-log(result_OD),'ro','linewidth',1.5,'markerfacecolor','r')
plot(x,-log(result_OD),'r-','linewidth',1.5)
xticks([0,400,800,1200,1600])
xlabel('Relative position (μm)')
ylim([-0.2,2.5])
yticks([0,1,2])
ylabel('OD')
set(gca,'fontsize',20)
box on
print('dipole trap OD measurement','-dpng','-r300')
hold off