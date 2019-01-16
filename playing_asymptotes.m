

% figure;
% for x = 20%:4:40
%     surf(BG, E, squeeze(SMI(:,:,x)), 'Edgecolor', 'none'); xlabel('BG'); ylabel('E'); zlabel('SMI');
%     hold on
% end
% set(gca, 'xscale', 'log')


% for i = 1:length(C)
%     slope(:,i) = diff(log((E + C(i))./(C(i))));
% end
%
% for i = 1:length(C)
%     slope2(:,i) = diff(diff(log((E + C(i))./(C(i)))));
% end
%
% %% slope figures
% close all
% figure(1)
% hold on
% surf(C, E(1,2:end), slope, 'Edgecolor', 'none')
% xlabel('Constant'); ylabel('Evoked'); zlabel('slope');
% view(3)
%
% figure(2)
% hold on
% surf(C, E(1,3:end), slope2, 'Edgecolor', 'none')
% xlabel('Constant'); ylabel('Evoked'); zlabel('slope2');
% view(3)
%
% %% SMI figures
% colorcount = 0;
% colorline = {'b', 'g', 'r', 'k', 'y'};
% for i = [1 5 12 20 40]
%     colorcount = colorcount + 1;
%     for ii = [1 10 100 300 400]
%         figure(3)
%         plot(E, log((E+i)/(BG(ii)+i)), colorline{colorcount})
%         xlabel('Background'); ylabel('SMI');
%         hold on
%     end
% end
% set(gca, 'xscale', 'log')

%%
% Emax = 80;
% Estep = 5000;
% E = linspace(0, Emax, Estep);
% BG = linspace(0, Emax, Estep);
% C = [1, exp(1), 5, 10, 20];
%
%
% close all
% figure(4)
% colorcount = 0;
% colorline = {'b', 'g', 'r', 'k', 'y'};
%
% for i = C
%     colorcount = colorcount + 1;
%     for ii = [1 10 100 200 400]
%         SMI = log((E+i)./(BG(ii)+i));
%
%         subplot(5, 2, 1)
%         hold on
%         scatter(BG(ii), 0, 'k', 'filled')
%         plot(E, SMI, colorline{colorcount})
%         xlabel('Evoked'); ylabel('SMI')
%         %         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 2)
%         hold on
%         scatter(BG(ii), 0, 'k', 'filled')
%         plot(E, SMI, colorline{colorcount})
%         xlabel('Evoked'); ylabel('SMI')
%         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 3)
%         hold on
%         plot(E(:, 2:end), ...
%             diff(SMI)/(Emax/Estep), ...
%             colorline{colorcount})
%         xlabel('Evoked'); ylabel('Slope')
%         %         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 4)
%         hold on
%         plot(E(:, 2:end), ...
%             diff(SMI)/(Emax/Estep), ...
%             colorline{colorcount})
%         xlabel('Evoked'); ylabel('Slope')
%         set(gca, 'xscale', 'log')
%         set(gca, 'yscale', 'log')
%
%         subplot(5, 2, 5)
%         hold on
%         plot(E(:, 3:end), ...
%             diff(SMI,2)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope')
%         %         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 6)
%         hold on
%         plot(E(:, 3:end), ...
%             diff(SMI,2)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope')
%         set(gca, 'xscale', 'log')
%         set(gca, 'yscale', 'log')
%
%         subplot(5, 2, 7)
%         hold on
%         plot(E(:, 4:end), ...
%             diff(SMI,3)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope of slope')
%         %         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 8)
%         hold on
%         plot(E(:, 4:end), ...
%             diff(SMI,3)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope of slope')
%         set(gca, 'xscale', 'log')
%         set(gca, 'yscale', 'log')
%
%         subplot(5, 2, 9)
%         hold on
%         plot(E(:, 5:end), ...
%             diff(SMI,4)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope of slope of slope')
%         %         set(gca, 'xscale', 'log')
%
%         subplot(5, 2, 10)
%         hold on
%         plot(E(:, 5:end), ...
%             diff(SMI,4)/(Emax/Estep), ...
%             colorline{colorcount}, 'linewidth', 6-colorcount)
%         xlabel('Evoked'); ylabel('Slope of slope of slope of slope')
%         set(gca, 'xscale', 'log')
%         set(gca, 'yscale', 'log')
%     end
% end

Emax = 80;
Estep = 5000;
E = linspace(0, Emax, Estep);
BG = linspace(0, Emax, Estep);
C = [1, exp(1), 5, 10, 20];


close all
figure(4)
colorcount = 0;
colorline = {'b', 'g', 'r', 'k', 'y'};

for i = 20
    colorcount = colorcount + 1;
    for ii = [1 10 100 200 400]
        SMI_e = log((E+i)./(BG(ii)+i));
        SMI_10 = log10((E+i)./(BG(ii)+i));
        SMI_2 = log2((E+i)./(BG(ii)+i));
        
        figure(1)
        hold on
        plot(E, SMI_e, 'k')
        plot(E, SMI_2, 'b')
        plot(E, SMI_10, 'r')
        xlabel('Evoked'); ylabel('SMI')
        %         set(gca, 'xscale', 'log')
        
    end
end
