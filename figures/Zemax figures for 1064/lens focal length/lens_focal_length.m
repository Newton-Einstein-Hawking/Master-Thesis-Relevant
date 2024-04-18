% 以下为各个焦距的镜子焦点直径，单位是微米
% input beam diameter is 5 mm
% Zemax波长忘改了
f50 = 7.62;
f100 = 13.8;
f150 = 20.4;
f200 = 27.3;
f250 = 33.8;
f300 = 40.7;
f400 = 54.2;
f500 = 67.5;

y = [f50,f100,f150,f200,f250,f300,f400,f500];
x = [50,100,150,200,250,300,400,500];
plot(x,y,'b:','linewidth',2)
hold on
plot(x,y,'r*','linewidth',3)
xlim([0,550])
ylim([0,80])
xticks([0,100,200,300,400,500])
yticks([0,20,40,60,80])
xlabel('Lens focal length (mm)','Interpreter','latex')
ylabel('Focused beam waist at focal plane ($\mu$m)',...
    'Interpreter','latex')

set(gca,'fontsize',15)
print('lens focal length','-dpng','-r300')

