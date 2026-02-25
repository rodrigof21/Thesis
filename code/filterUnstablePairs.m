%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Filters unstable values for nu and zeta
%
% INPUTS:
%   - nu_v: vector containing nu values
%   - zeta_v: vectr containing zeta values
%
% OUTPUTS:
%   - stable_nu
%   - stable_zeta
%
% OUTPUT FOLDER: N/A
%==========================================================================

function [stable_nu, stable_zeta] = filterUnstablePairs(nu_v, zeta_v)
    % Initialize output vectors
    stable_nu = [];
    stable_zeta = [];
    
    % Use a meshgrid to test all possible combinations
    [NU, ZETA] = meshgrid(nu_v, zeta_v);
    
    % Loop through each pair
    for i = 1:numel(NU)
        a = NU(i);    % alpha in the theorem
        xi = ZETA(i); % xi in the theorem
        isStable = false;
        
        % Condition 1: 0 < alpha <= 1 and xi >= 0
        if (a > 0 && a <= 1) && (xi >= 0)
            isStable = true;
            
        % Condition 2: 0 < alpha < 1, xi < 0
        elseif (a > 0 && a < 1) && (xi < 0)
            term = (-2^(a+1)/cos(a*pi/2)) * (-xi * tan(a*pi/2))^a;
            if term < 1
                isStable = true;
            end
            
        % Condition 3: 1 < alpha < 2, xi > 0
        elseif (a > 1 && a < 2) && (xi > 0)
            % Defining wu as per the theorem (with wn = 1)
            wu = 2 * xi * tan((2-a)*pi/2);
            % Stability check formula from eq (20)
            check = (2*xi)^2 * wu^(2*a) + wu^(2*a+2) - 1; 
            if check > 0
                isStable = true;
            end
        end
        
        % If stable, collect the pair
        if isStable
            stable_nu(end+1) = a;
            stable_zeta(end+1) = xi;
        end
    end
end