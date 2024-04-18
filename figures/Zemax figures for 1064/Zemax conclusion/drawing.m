% 将路径设置为当前文件夹
currentFolder = pwd; % 获取当前文件夹路径
filePath = fullfile(currentFolder, 'POP_data.txt'); % 构建文件路径
a = importdata(filePath); % 使用importdata函数读取文件数据


% a b c 分别为singlet bestshape doublet的POP数据

% POP的每个数据都是256*256个格点，每个点是0.361um
% 画了中间的117*117个点（70:186）*（70:186）

figure(1)
amax = max(max(a.data));
a_data = a.data(70:186,70:186);
pcolor(a_data/amax)
shading flat
% title('Zemax simulation result')
xticks(linspace(0,118,5));
yticks(linspace(0,118,5));
xticklabels([-205,-10,0,10,205])
yticklabels([-205,-10,0,10,205])
ylim([1, size(a_data, 1)]);
colorbar
set(colorbar,'YTick',[0,0.5,1])
set(gca,'FontSize',20)
print('POP','-dpng','-r300')