figure(1)
% 用readmatrix可以读入csv文件，记得把表头删掉
b = readmatrix('780toptica.csv','Delimiter',';');
bx = b(:,1);
b1 = b(:,2);
b2 = b(:,3)*1000;
% 下面这行代码是改坐标轴颜色的，set(gca)意为对
% 当前坐标区域进行操作
set(gca,'YColor','blue')
plot(bx,b1,'blue','linewidth',3)
% xlim是坐标轴显示的范围（若你的参数是[0,5]，
% 则xlim([2,3])为在图上只显示[2,3,]范围内的图像）
ylim([1.2,1.6])
xlim([71,74.3])
axis off
% 用print函数将图像保存在当前路径，
% pring('filename','格式','分辨率')
% -djpeg是jpg格式，-dpng是png格式，
% -r300是分辨率300dpi
print('780toptica repump','-dpng','-r300')
% by the way, png的图片比jpg色彩更鲜艳，因为
% png是无损压缩的，有24位彩色，jpg是有损压缩
% 的，只有8位彩色

figure(2)
b = readmatrix('780toptica.csv','Delimiter',';');
bx = b(:,1);
b1 = b(:,2);
set(gca,'YColor','blue')
plot(bx,b1,'blue','linewidth',3)
ylim([0.8,1.6])
xlim([64,66.5])
axis off
print('780toptica trap','-dpng','-r300')


figure(3)
c = readmatrix('795toptica.csv','Delimiter',';');
cx = c(:,1);
c1 = c(:,2);
plot(cx,c1,'blue','linewidth',3)
set(gca,'YColor','blue')
xlim([50.4,56.2])
ylim([0.16,0.32])
axis off
print('795toptica probe','-dpng','-r300')