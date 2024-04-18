% 注释见saturated absorption spectroscopy那个
% 文件夹里的文件

figure(1)
% 用readmatrix可以读入csv文件，记得把表头删掉
b = readmatrix('780toptica.csv','Delimiter',';');
bx = b(:,1);
b1 = b(:,2);
b2 = b(:,3)*1000;

plot(bx,b1,'black','linewidth',2)
ylim([0.4,1.9])
xticks([])
yticks([])
ylabel('Transmission')
xlim([59.4070,82])
xlabel('Relative frequency')
print('780toptica.jpg','-dpng','-r300')