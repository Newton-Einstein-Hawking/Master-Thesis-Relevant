% 将路径设置为当前文件夹
currentFolder = pwd; % 获取当前文件夹路径
filePath1 = fullfile(currentFolder, 'singlet_POP.txt'); % 构建文件路径
filePath2 = fullfile(currentFolder, 'bestshape_POP.txt');
filePath3 = fullfile(currentFolder, 'doublet_POP.txt');
a = importdata(filePath1); % 使用importdata函数读取文件数据
b = importdata(filePath2);
c = importdata(filePath3);

% a b c 分别为singlet bestshape doublet的POP数据

% POP的每个数据都是256*256个格点，每个点是4.27um
% POP的每张图都是画了中间的97*97个点（80:176）*（80:176）

% 平凸透镜的POP数据
figure(1)
amax = max(max(a.data));
a_data = a.data(80:176,80:176);
pcolor(a_data/amax)
shading flat
% title('Zemax simulation result')
xticks(linspace(0,100,5));
yticks(linspace(0,100,5));
% 不知道为什么，刻度的第一个和最后一个不显示
xticklabels([-205,-100,0,100,205])
yticklabels([-205,-100,0,100,205])
ylim([1, size(a_data, 1)]);
colorbar
set(colorbar,'YTick',[0,0.5,1])
set(gca,'FontSize',20)
print('singlet POP','-dpng','-r300')

% best shape lens的POP数据
figure(2)
bmax = max(max(b.data));
b_data = b.data(80:176,80:176);
pcolor(b_data/bmax)
shading flat
% title('Zemax simulation result')
xticks(linspace(0,100,5));
yticks(linspace(0,100,5));
xticklabels([-205,-100,0,100,205])
yticklabels([-205,-100,0,100,205])
ylim([1, size(b_data, 1)]);
colorbar
set(colorbar,'YTick',[0,0.5,1])
set(gca,'FontSize',20)
print('best shape POP','-dpng','-r300')

% doublet的POP数据
figure(3)
cmax = max(max(c.data));
c_data = c.data(80:176,80:176);
pcolor(c_data/cmax)
shading flat
% title('Zemax simulation result')
xticks(linspace(0,100,5));
yticks(linspace(0,100,5));
xticklabels([-205,-100,0,100,205])
yticklabels([-205,-100,0,100,205])
ylim([1, size(c_data, 1)]);
colorbar
set(colorbar,'YTick',[0,0.5,1])
set(gca,'FontSize',20)
print('doublet POP','-dpng','-r300')