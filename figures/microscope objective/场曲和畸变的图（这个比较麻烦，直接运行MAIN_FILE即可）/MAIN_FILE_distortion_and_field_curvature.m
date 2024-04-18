% 该文件用于绘制场曲和畸变的图
% figure(1)为子午和弧矢方向的场曲（三个波长）
% figure(2)为畸变（三个波长）
% 代码从第47行开始看就行了

% 这个文件每行是以空格开始以%结束的，没法读，
% 所以我用matlab的工具栏-主页-导入数据的功能
% 生成了三个脚本分别读入三个波长的数据
% 即为下面这三个文件
read_distortion_486nm
read_distortion_588nm
read_distortion_656nm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%下面以486nm的数据为例，读入每个参数
ax486nm = distortionandfieldcurvature486nm(:,1);
aziwu486nm = distortionandfieldcurvature486nm(:,2);
ahushi486nm = distortionandfieldcurvature486nm(:,3);
ajibian486nm = distortionandfieldcurvature486nm(:,6);
% 由于它这个脚本读出来的数据都是table格式，需要
% 将之转成array格式才能画图，于是有了下面的代码
x486nm = table2array(ax486nm);
ziwu486nm = table2array(aziwu486nm);
hushi486nm = table2array(ahushi486nm);
jibian486nm = table2array(ajibian486nm);

%接下来再分别读入588nm和656nm的数据：
ax588nm = distortionandfieldcurvature588nm(:,1);
aziwu588nm = distortionandfieldcurvature588nm(:,2);
ahushi588nm = distortionandfieldcurvature588nm(:,3);
ajibian588nm = distortionandfieldcurvature588nm(:,6);
x588nm = table2array(ax588nm);
ziwu588nm = table2array(aziwu588nm);
hushi588nm = table2array(ahushi588nm);
jibian588nm = table2array(ajibian588nm);
ax656nm = distortionandfieldcurvature656nm(:,1);
aziwu656nm = distortionandfieldcurvature656nm(:,2);
ahushi656nm = distortionandfieldcurvature656nm(:,3);
ajibian656nm = distortionandfieldcurvature656nm(:,6);
x656nm = table2array(ax656nm);
ziwu656nm = table2array(aziwu656nm);
hushi656nm = table2array(ahushi656nm);
jibian656nm = table2array(ajibian656nm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 至此，数据读入完成
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 接下来可以开始画图了：
figure(1)
hold on
plot(ziwu486nm,x486nm,'linewidth',1)
plot(ziwu588nm,x588nm,'linewidth',1)
plot(ziwu656nm,x656nm,'linewidth',1)
plot(hushi486nm,x486nm,'linewidth',1)
plot(hushi588nm,x588nm,'linewidth',1)
plot(hushi656nm,x656nm,'linewidth',1)
% 下面这行画的是x=0处那根竖线
plot(zeros(101),x486nm,'black')
xlim([-0.02,0.02])
xticks([-0.02,-0.01,0,0.01,0.02])
xticklabels([-20,-10,0,10,20])
yticks([0,5,7])
xlabel('Field curvature（μm）')
ylabel('Field height（mm）')
legend('486 nm - Tangential',...
    '588 nm - Tangential','656 nm - Tangential',...
    '486 nm - Segittal',...
    '588 nm - Segittal','656 nm - Segittal',...
    'location',...
    'northwest','box','off','FontSize',12)
print('field curvature','-djpeg','-r300')

figure(2)
hold on
plot(jibian486nm,x486nm,'linewidth',1)
plot(jibian588nm,x588nm,'linewidth',1)
plot(jibian656nm,x656nm,'linewidth',1)
plot(zeros(101),x486nm,'black') % 这是那根竖着的黑线
xlim([-0.5,0.5])
xticks([-0.5,0,0.5])
yticks([0,5,7])
xlabel('Distortion（%）')
ylabel('Field height（mm）')
legend('486 nm','588 nm','656 nm','location',...
    'northwest','box','off','FontSize',12)
print('distortion','-djpeg','-r300')
hold off



