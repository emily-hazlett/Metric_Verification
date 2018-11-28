clear all
close all

E = linspace(0.01, 100, 500);
BG = linspace(0.01, 50, 300);
Cvector = 1:40;
SMIlim = 0.05;

%% Calculate RMI and Z Score
for i = 1:length(BG)
    RMI(:,i) = (E-BG(i))./(E+BG(i));
end

coeff = linspace(0.4634, 0.4917, length(Cvector));
for CI = 1: length(Cvector)
    for i = 1:length(BG)
        ZS(:,i,CI) = (E - BG(i))/ (BG(i)^coeff(CI));
    end
end

for C = Cvector(1): Cvector(end)
    for i = 1:length(BG)
        SMI(:,i,C) = log10((E+C)./(BG(i)+C));
    end
end

%% Plot metric spaces

figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
plotcount = 0;

for p = 1:6
    C = floor(length(Cvector)/6) *p - 5;
    plotcount = plotcount + 1;
    
    subplot(3, 4, plotcount)
    hold on
    surf(BG, E, SMI(:,:,Cvector(C)), 'EdgeColor', 'none'); view(2)
    line(BG, (10^SMIlim).*BG + ((10^SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    line(BG, (10^-SMIlim).*BG + ((10^-SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    text(0.1, 50, 200, ['-- SMI = +-', num2str(SMIlim)])
    set(gca, 'xscale', 'log');
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C+Cvector(1)-1), ')'])
    axis('tight'); colormap('jet'); colorbar; %caxis([-1 1]);
    set(gca, 'ylim', [0 100])
    
    plotcount = plotcount + 1;
    subplot(3, 4, plotcount)
    hold on
    surf(BG, E, SMI(:,:,Cvector(C)), 'EdgeColor', 'none'); view(2)
    line(BG, (10^SMIlim).*BG + ((10^SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    line(BG, (10^-SMIlim).*BG + ((10^-SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    text(10, 50, 200, ['-- SMI = +-', num2str(SMIlim)])
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C+Cvector(1)-1), ')'])
    axis('tight'); colormap('jet'); colorbar; %caxis([-1 1]);
    set(gca, 'ylim', [0 100])
end


for C = 20% 1:5:length(Cvector)
    figure(C)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    
    subplot(3, 2, 1)
    surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
    set(gca, 'xscale', 'log');
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log view - RMI')
    axis('tight'); caxis([-1 1]); colormap('jet'); colorbar
    
    subplot(3, 2, 2)
    surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Linear view - RMI')
    axis('tight'); caxis([-1 1]); colormap('jet'); colorbar
    
    subplot(3, 2, 3)
    surf(BG, E, ZS(:,:,C), 'EdgeColor', 'none'); view(2)
    set(gca, 'xscale', 'log');
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log view - Z-Score (M and SD modeled on Marie data)')
    axis('tight'); colormap('jet'); colorbar; caxis([-100 100]);
    
    subplot(3, 2, 4)
    surf(BG, E, ZS(:,:,C), 'EdgeColor', 'none'); view(2)
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Linear view - Z-Score (M and SD modeled on Marie data)')
    axis('tight'); colormap('jet'); colorbar; caxis([-10 10]);
    
    subplot(3, 2, 5)
    hold on
    surf(BG, E, SMI(:,:,Cvector(C)), 'EdgeColor', 'none'); view(2)
    line(BG, (10^SMIlim).*BG + ((10^SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    line(BG, (10^-SMIlim).*BG + ((10^-SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    text(0.1, 50, 200, ['-- SMI = +-', num2str(SMIlim)])
    set(gca, 'xscale', 'log');
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C+Cvector(1)-1), ')'])
    axis('tight'); colormap('jet'); colorbar; %caxis([-1 1]);
    set(gca, 'ylim', [0 100])
    
    subplot(3, 2, 6)
    hold on
    surf(BG, E, SMI(:,:,Cvector(C)), 'EdgeColor', 'none'); view(2)
    line(BG, (10^SMIlim).*BG + ((10^SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    line(BG, (10^-SMIlim).*BG + ((10^-SMIlim)*Cvector(C)-Cvector(C)), repmat(200, 1, length(BG)), 'linewidth', 2)
    text(10, 50, 200, ['-- SMI = +-', num2str(SMIlim)])
    xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C+Cvector(1)-1), ')'])
    axis('tight'); colormap('jet'); colorbar; %caxis([-1 1]);
    set(gca, 'ylim', [0 100])
end