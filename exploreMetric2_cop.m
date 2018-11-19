clear all
E = 0.1:0.1:100;
BG = 0.1:0.1:50;
for C = 1:40
    for i = 1:length(BG)
        SMI(:,i,C) = log10((E+C)./(BG(i)+C));      
    end
    figure (C)
    imagesc('YData', E, 'XData', BG, 'CData', SMI(:,:,C))
    set(gca, 'xscale', 'log')
    axis('tight')
    caxis([-1 1])
    colormap('jet')
    title(['SMI C = ', num2str(C)])
    colorbar
end

% Zi = Xi - Xm/ S
%     RMI(i,:) = (E-BG(i)+0.01)./(E+BG(i)+0.01);

for i = 1:40
    figure(i)
    pause (0.5)
end