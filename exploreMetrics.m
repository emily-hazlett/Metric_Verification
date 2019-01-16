clear all
close all

E = logspace(-2, 2, 500);
BG = logspace(-2, 2, 500);

BGmin = 5; % Hz change that is significant response in super low BG neurons
percBGexc = 1.53; % percent increase in BG firing needed to be significantly excited (calculates SMI value for significance)
percBGsupp = 0.51; % percent change in BG firing needed to be significantly suppressed
SMIexc_target = round(log10(percBGexc), 2);
SMIsupp_target = round(log10(percBGsupp), 2);

%% Calculate RS RMI Z Score and SMI
for i = 1:length(BG)
    RS(:,i) = log10(E./BG(i));
end

for i = 1:length(BG)
    RMI(:,i) = (E-BG(i))./(E+BG(i));
end

for i = 1:length(BG)
    ZS(:,i) = (E - BG(i))/ sqrt(BG(i));
end

C = round(BGmin/(percBGexc-1));
C = 8;
for i = 1:length(BG)
    SMI(:,i) = log10((E+C)./(BG(i)+C));
end

%% Plot metric spaces

figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.5 1]);

% RS
subplot(4, 3, 1)
hold on
surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log-log view - RS')
caxis([-2 2]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 2)
hold on
surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log view - RS')
caxis([-2 2]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 3)
hold on
surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Linear view - RS')
caxis([-2 2]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

%RMI
subplot(4, 3, 4)
hold on
surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log');  set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log-log view - RMI')
caxis([-1 1]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 5)
hold on
surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log view - RMI')
caxis([-1 1]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 6)
hold on
surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Linear view - RMI')
caxis([-1 1]); colormap('jet'); colorbar
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

%Z-score
subplot(4, 3, 7)
hold on
surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)),'.')
scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)),'.')
set(gca, 'xscale', 'log');  set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log-log view - Z-Score')
colormap('jet'); colorbar; caxis([-10 10]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 8)
hold on
surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Log view - Z-Score')
colormap('jet'); colorbar; caxis([-10 10]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 9)
hold on
surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title('Linear view - Z-Score')
colormap('jet'); colorbar; caxis([-10 10]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

%SMI
subplot(4, 3, 10)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log-log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar; %caxis([-1 1]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 11)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar; %caxis([-1 1]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(4, 3, 12)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar; %caxis([-1 1]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
