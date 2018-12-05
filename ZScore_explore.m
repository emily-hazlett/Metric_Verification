clearvars -except ZSo*

% Xdata = log10(ZSoutputter(:,1));
% Ydata = log10(ZSoutputter(:,2));
Xdata = ZSoutputter(:,1);
Ydata = ZSoutputter(:,2);
Cdata = ZSoutputter(:,3);

fittedX = linspace(min(Xdata), max(Xdata), 200);
m = 0.4731;
b = -0.0211;
for i = 1:length(fittedX)
    % Coefficient values found using cftool on log transformed x and y data
    % log10(y) log10(x) => f(x) = 0.4731x - 0.0211
    % CI bounds (0.4587, 0.4874) and (-0.03039, -0.0118)
    % ignores Inf values
    % Goodness of fit:
    %   SSE: 14.92
    %   R-square: 0.8328
    %   Adjusted R-square: 0.8326
    %   RMSE: 0.1334
    
    fittedY(i) = (10^b)*fittedX(i)^m;
end

figure;
subplot(1,2,1)
hold on
scatter(Xdata, Ydata, 10, Cdata, 'filled');
ylabel('SD'); xlabel('Mean'); zlabel('Background Firing');
colorbar
set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
set(gca,'colorscale','log')
set(gca, 'xlim', [0.1 50])
set(gca, 'ylim', [0.1 9])
title('relationship between SD and mean for maries data')
plot(fittedX, fittedY, 'r', 'Linewidth', 2);
legend('Data', '(f(x) = 10^-^0^.^0^2^1^1 * X^0^.^4^7^3^1', 'Location', 'SouthEast')


subplot(1,2,2)
hold on
scatter(Xdata, Ydata, 10, Cdata, 'filled');
ylabel('SD'); xlabel('Mean'); zlabel('Background Firing');
colorbar
% set(gca, 'xscale', 'log'); set(gca, 'yscale', 'log');
set(gca,'colorscale','log')
set(gca, 'xlim', [-5 50])
set(gca, 'ylim', [-1 9])
title('relationship between SD and mean for maries data')
plot(fittedX, fittedY, 'r', 'Linewidth', 2);
legend('Data', '(f(x) = 10^-^0^.^0^2^1^1 * X^0^.^4^7^3^1', 'Location', 'SouthEast')


% [coeffs, S] = polyfit(Xdata, Ydata, 2);
% % Get fitted values
% fittedX = linspace(min(Xdata), max(Ydata), 200);
% [fittedY, delta] = polyval(coeffs, fittedX, S);
% % Plot the fitted line
% hold on;
% plot(fittedX, fittedY, 'r-', 'LineWidth', 3);
% plot(fittedX, fittedX+2*delta,'m--', fittedX, fittedY-2*delta,'m--')
% legend('Data', 'Linear fit', '95% Prediction Interval')