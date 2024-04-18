b = importdata('D:\OneDrive - 南方科技大学/各种书面文件（培养方案里的）/master thesis/figures/1064 real focused beam/WinCamExcelData_6_28_2023_11_14_41.xlsx');

figure(1)
bmax = max(max(b.data.Sheet1))
pcolor(b.data.Sheet1/bmax)
shading flat
% title('Real focused beam')
colorbar
set(colorbar,'ticks',[0,0.5,1])
axis off
set(gca,'fontsize',18)
print('matlab画的','-dpng','-r300')
