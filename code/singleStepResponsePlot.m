%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: SCRIPT
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% Plot a single step response with respective interest points
%
% OUTPUT FOLDER: N/A
%==========================================================================


nu = 1.3;
zeta = 1.8;
wn = 1;

u = @(s) 1./s;
G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));

[t02, t05, t08] = extractPoints(nu, zeta);

tfinal = 30;
[y, t] = invFourierTrapz(G, u, tfinal, 0.01);

h = zeros(4, 1);

figure
h(1) = plot(y, t, 'DisplayName','Step Resp. Curve');
hold on
h(2) = plot(t02, 0.2, 'ro','MarkerFaceColor', 'r', 'DisplayName','t_{0,2}');
h(3) = plot(t05, 0.5, 'go','MarkerFaceColor', 'g', 'DisplayName','t_{0,5}');
h(4) = plot(t08, 0.8, 'ko','MarkerFaceColor', 'k', 'DisplayName','t_{0,8}');
%h(5) = plot(tp, Mp+1, 'b^','MarkerFaceColor', 'b', 'DisplayName','M_p');
yline(1, '--', 'DisplayName','SS value')
title('Step Response with \nu = 1.3 and \zeta = 1.8')
legend(h, 'Location','southeast')
axis([0 tfinal 0 1.4])
xlabel('Time (s)')
ylabel('Amplitude')