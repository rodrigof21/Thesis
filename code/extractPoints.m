%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: FINISHED
%
% PROGRAM DESCRIPTION: 
% Extracts t02, t05, t08, Mp from a given system. Must have F_nu and F_zeta
% in the workspace from [[idModel_test.]]
%
% INPUTS:
%   - nu, zeta
%
% OUTPUTS:
%   - t02, t05, t08, Mp
%
% OUTPUT FOLDER:
%==========================================================================

function [t02, t05, t08, t09, t95] = extractPoints(nu, zeta, wn)

    % stable = checkStability(nu, zeta);
    % if stable, fprintf('Stable\n')
    % else, fprintf('Unstable\n'), return
    % end

    %wn = 1;
    G = @(s) 1 ./ (1 + 2.*zeta.*(s/wn).^nu + (s/wn).^(nu+1));
    
    u = @(s) 1./s;

    tfinal = 60;
    ts = 0.05;

    [t, y] = invFourierTrapz(G, u, tfinal, ts);

    % % Mp tp Overshoot
    % [pks, locs] = findpeaks(y, t, 'MinPeakHeight', 1.05);
    % if ~isempty(pks) & pks(1) - 1 > 0.05
    %     Mp = pks(1) - 1; 
    %     tp = locs(1);
    % else
    %     Mp = 0;
    %     tp = NaN;
    % end

    % t_0.5
    idx_50 = find(y >= 0.5, 1);
    if isempty(idx_50)
        t05 = NaN; 
    else
        t05 = t(idx_50); 
    end

    % t_0.2
    idx_20 = find(y >= 0.2, 1);
    if isempty(idx_20)
        t02 = NaN; 
    else
        t02 = t(idx_20); 
    end

    % t_0.8
    idx_80 = find(y >= 0.8, 1);
    if isempty(idx_80)
        t08 = NaN; 
    else
        t08 = t(idx_80); 
    end

    % t_0.9
    idx_90 = find(y >= 0.9, 1);
    if isempty(idx_90)
        t09 = NaN; 
    else
        t09 = t(idx_90); 
    end

    % t_0.95
    idx_95 = find(y >= 0.95, 1);
    if isempty(idx_95)
        t95 = NaN; 
    else
        t95 = t(idx_95); 
    end

end
