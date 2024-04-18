% 该文件用于画出Rb的饱和吸收谱线和error signal，
% figure(1)是瓦科的780，figure(2)是Toptica的780
% figure(3)是Toptica的795，我把figure(1)的代码
% 放在了最后是因为我把注释写在figure(2)那里了

figure(2)
% 用readmatrix可以读入csv文件，记得把表头删掉
b = readmatrix('780toptica.csv','Delimiter',';');
bx = b(:,1);
b1 = b(:,2);
b2 = b(:,3)*1000;
% 利用yyaxis left和yyaxis right来画双坐标轴的图
yyaxis left
% 下面这行代码是改坐标轴颜色的，set(gca)意为对
% 当前坐标区域进行操作
set(gca,'YColor','blue')
plot(bx,b1,'blue','linewidth',1)
% xlim是坐标轴显示的范围（若你的参数是[0,5]，
% 则xlim([2,3])为在图上只显示[2,3,]范围内的图像）
ylim([0,2])
% yticks用于指定y轴显示哪些刻度值
yticks([0,0.5,1,1.5,2])
ylabel('Transmission signal (V)')
yyaxis right
plot(bx,b2,'red','linewidth',1)
set(gca,'YColor','red')
xlim([59.4070,82])
% xticklabels和xticks搭配使用，先用xticks指定
% 有哪些刻度值需要显示，再用xticklabels给这些
% 显示出来的刻度值们起个名字
xticks(linspace(59.4070,82,10))
% 下面这行用的是({})，里面用{}而非[]，这是因为
% 我要让某些刻度不显示，用''空字符，那就不能用
% []了，因为[]是给数字用的，{}是给字符用的
xticklabels({0,'','',3,'','',6,'','',9})
ylim([-0.01,0.06]*1000)
yticks([-10,0,20,40,60])
xlabel('Frequency (GHz)')
ylabel('Error signal (mV)','color','red')
% legeng的参数：'location','northwest'是让legend
% 在左上角显示，'box','off'是去掉边框
legend('Transmission signal','Error signal',...
    'location','northwest','box','off')
set(gca,'fontsize',15)
% 用print函数将图像保存在当前路径，
% pring('filename','格式','分辨率')
% -djpeg是jpg格式，-dpng是png格式，
% -r300是分辨率300dpi
print('780toptica.jpg','-dpng','-r300')
% by the way, png的图片比jpg色彩更鲜艳，因为
% png是无损压缩的，有24位彩色，jpg是有损压缩
% 的，只有8位彩色

figure(3)
c = readmatrix('795toptica.csv','Delimiter',';');
cx = c(:,1);
c1 = c(:,2);
c2 = c(:,3)*1000;
yyaxis left
plot(cx,c1,'blue','linewidth',1)
set(gca,'YColor','blue')
xlim([38.5,62.2])
xticks(linspace(38.5,62.2,10))
xticklabels({0,'','',3,'','',6,'','',9})
ylim([0,0.4])
yticks([0,0.1,0.2,0.3,0.4])
ylabel('Transmission signal (V)')
yyaxis right
plot(cx,c2,'red','linewidth',1)
set(gca,'YColor','red')
ylim([-0.005,0.020]*1000)
yticks([-5,0,5,10,15,20])
xlabel('Frequency (GHz)')
ylabel('Error signal (mV)')
legend('Transmission signal','Error signal',...
    'location','northwest','box','off')
set(gca,'fontsize',15)
print('795toptica.jpg','-dpng','-r300')

% figure(1)
% a = csvread('780瓦科.csv');
% ax = a(:,1);
% a1 = flip(a(:,2));
% a2 = flip(a(:,3));
% plot(ax,a1)
% ylim([0,4])
% yyaxis right
% plot(ax,a2)
% ylim([-1,4])
% legend('Saturated absorption spectral line','Error signal')
