figure(1)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.5 0.85]);

% % RS
% surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
% caxis([-2 2]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log');
% caxis([-2 2]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, RS, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% caxis([-2 2]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % RMI
% % surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log');  set(gca, 'yscale', 'log');
% caxis([-1 1]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log');
% caxis([-1 1]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, RMI, 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.53*BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.65*BG), repmat(200, 1, length(BG)), '.')
% caxis([-1 1]); colormap('jet');
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % Z-score
% % surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)),'.')
% hold on; view(2)
% scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)),'.')
% set(gca, 'xscale', 'log');  set(gca, 'yscale', 'log');
% colormap('jet'); caxis([-10 10]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log');
% colormap('jet'); caxis([-10 10]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, ZS(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (-2*sqrt(BG)+BG), repmat(200, 1, length(BG)), '.')
% colormap('jet'); caxis([-10 10]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % SMI
% % surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
% colormap('jet'); %caxis([-1 1]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
% set(gca, 'xscale', 'log');
% colormap('jet'); %caxis([-1 1]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')
% 
% % surf(BG, E, SMI(:,:), 'EdgeColor', 'none'); view(2)
% scatter3(BG, (1.61*BG+8), repmat(200, 1, length(BG)), '.')
% hold on; view(2)
% scatter3(BG, (0.62*BG-8), repmat(200, 1, length(BG)), '.')
% colormap('jet'); %caxis([-1 1]);
% set(gca, 'ylim', [0.01 100]); set(gca, 'xlim', [0.01 100])
% set(gca, 'XTickLabel', ''); set(gca, 'YTickLabel', '')




