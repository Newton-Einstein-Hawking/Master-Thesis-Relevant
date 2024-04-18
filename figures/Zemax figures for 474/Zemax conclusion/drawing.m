% 将路径设置为当前文件夹
currentFolder = pwd; % 获取当前文件夹路径
filePath = fullfile(currentFolder, 'POP_data.txt'); % 构建文件路径
a = importdata(filePath); % 使用importdata函数读取文件数据

% POP的每个数据都是256*256个格点，每个点是0.226um
% 画了中间的111*111个点（73:183）*（73:183）

figure(1)
amax = max(max(a.data));
a_data = a.data(73:183,73:183);
pcolor(a_data/amax)
shading flat
% title('Zemax simulation result')
xticks(linspace(0,112,5));
yticks(linspace(0,112,5));
xticklabels([-205,-5,0,5,205])
yticklabels([-205,-5,0,5,205])
colorbar
set(colorbar,'YTick',[0,0.5,1])
set(gca,'FontSize',20)
print('POP','-dpng','-r300')