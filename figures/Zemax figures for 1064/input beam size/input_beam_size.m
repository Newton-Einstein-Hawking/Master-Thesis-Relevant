% 全都是beam waist，入射和出射
in2 = 34;
in3 = 22.9;
in4 = 17.6;
in5 = 14.7;
in6 = 13.1;
in7 = 12.4;
in8 = 12.1;
in9 = 12.5;
in10 = 13.1;
in11 = 14;

x = [2,3,4,5,6,7,8,9,10,11];
y = [in2,in3,in4,in5,in6,in7,in8,in9,in10,in11];

plot(x,y,'b:','linewidth',2)
hold on
plot(x,y,'r*','linewidth',3)

xticks([0,2,4,6,8,10,12])
xlabel('Input beam waist (mm)','Interpreter','latex')
ylabel('Focused beam waist at focal plane ($\mu$m)',...
    'Interpreter','latex')
xlim([1,12])
set(gca,'fontsize',15)
print('input beam size','-dpng','-r300')