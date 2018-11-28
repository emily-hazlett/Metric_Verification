clearvars -except ZSo*

Xdata = ZSoutputter(:,1) +0.01;
Ydata = ZSoutputter(:,2)+0.01;
Cdata = ZSoutputter(:,3);

fittedX = linspace(min(Xdata), max(Xdata), 200);
for i = 1:length(fittedX)
    % Coefficient values found using cftool on log transformed x and y data
    % log10(y) log10(x) => f(x) = 0.4776x + 0.000364
    % CI bounds 0.4634- 0.4917 and -0.008155-0.01003
    % ignores Inf values
    fittedY(i) = fittedX(i)^0.4776;% +1.519;
end

figure;
subplot(1,2,1)
hold on
scatter(Xdata, Ydata, 10, Cdata, 'filled');
ylabel('SD'); xlabel('Mean'); zlabel('Background Firing');
colorbar
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
set(gca,'colorscale','log')
title('relationship between SD and mean for maries data')
plot(fittedX, fittedY, 'r', 'Linewidth', 2);
legend('Data', '(f(x) =X^0^.^4^7^7^6', 'Location', 'SouthEast')


subplot(1,2,2)
hold on
scatter(Xdata, Ydata, 10, Cdata, 'filled');
ylabel('SD'); xlabel('Mean'); zlabel('Background Firing');
colorbar
% set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
set(gca,'colorscale','log')
title('relationship between SD and mean for maries data')
plot(fittedX, fittedY, 'r', 'Linewidth', 2);
legend('Data', '(f(x) = X^0^.^4^7^7^6', 'Location', 'SouthEast')


% [coeffs, S] = polyfit(Xdata, Ydata, 2);
% % Get fitted values
% fittedX = linspace(min(Xdata), max(Ydata), 200);
% [fittedY, delta] = polyval(coeffs, fittedX, S);
% % Plot the fitted line
% hold on;
% plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
% plot(fittedX, fittedX+2*delta,'m--', fittedX, fittedY-2*delta,'m--')
% legend('Data', 'Linear fit', '95% Prediction Interval')