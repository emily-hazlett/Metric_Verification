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
C = 0.01;
for i = 1:length(BG)
    SMI(:,i) = log10((E+C)./(BG(i)+C));
end

figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.5 0.8]);

% SMI
subplot(3, 3, 1)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log-log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 2)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 3)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

%%
C = 8;
for i = 1:length(BG)
    SMI(:,i) = log10((E+C)./(BG(i)+C));
end

figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.5 0.8]);

% SMI
subplot(3, 3, 4)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log-log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 5)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 6)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

%%
C = 50;
for i = 1:length(BG)
    SMI(:,i) = log10((E+C)./(BG(i)+C));
end

figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.5 0.8]);

% SMI
subplot(3, 3, 7)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log-log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 8)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
set(gca, 'xscale', 'log');
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Log view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])

subplot(3, 3, 9)
hold on
surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
xlabel('Background Firing'); ylabel('Evoked Firing'); zlabel('Metric Value'); title(['Linear view - SMI (C = ', num2str(C), ')'])
colormap('jet'); colorbar;
caxis([-1.1298 1.1298]);
set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
