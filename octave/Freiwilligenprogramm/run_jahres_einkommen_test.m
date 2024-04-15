
brutto = [1:1000:500000]';

lsteuer = brutto*0.0;

for i=1:length(lsteuer)

  [lsteuer(i),~,~] = jahres_steuer(brutto(i));

end


mbrutto1 = 8100;
mbrutto2 = 194400;
jbrutto  = 11*mbrutto1 + mbrutto2;


[jlsteuer,~,~] = jahres_steuer(jbrutto);
[lsteuer2,~,~] = jahres_steuer(brutto2);

figure(1)
subplot(2,1,1)
plot(brutto,lsteuer)
hold on
plot(brutto1,lsteuer1,'ro')
plot(brutto2,lsteuer2,'bo')
hold off
xlabel('EUR')
ylabel('EUR')
grid on
subplot(2,1,2)
plot(brutto,lsteuer./brutto*100)
hold on
plot(brutto1,lsteuer1./brutto1*100,'ro')
plot(brutto2,lsteuer2./brutto2*100,'bo')
hold off
ylabel('%')
grid on

