% 该脚本用于绘制MTF的图
% 读入文件的方法可见场曲和畸变的脚本的注释
read_data_0mm
read_data_5mm
read_data_7mm
ziwu0mm = table2array(MTF0mm(:,2));
hushi0mm = table2array(MTF0mm(:,3));
ziwu5mm = table2array(MTF5mm(:,2));
hushi5mm = table2array(MTF5mm(:,3));
ziwu7mm = table2array(MTF7mm(:,2));
hushi7mm = table2array(MTF7mm(:,3));
x = 0:2:220;

figure(1)
hold on
plot(x,ziwu0mm)
plot(x,hushi0mm)
plot(x,ziwu5mm)
plot(x,hushi5mm)
plot(x,ziwu7mm)
plot(x,hushi7mm)
plot(x,ones(111)*0.5,'--','color',[0.8,0.8,0.8])
xlim([0,220])
xticks([0,50,100,150,200,220])
ylim([0,1])
yticks([0,0.25,0.5,0.75,1])
legend('0 mm - Tangential','0 mm - Sagittal','5 mm - Tangential',...
    '5 mm - Sagittal','7 mm - Tangential','7 mm - Sagittal','box','off')
xlabel('Spatial frequency（cycles/mm）')
ylabel('Modulus')
print('MTF','-djpeg','-r300')
