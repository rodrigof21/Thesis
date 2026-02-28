%==========================================================================
% THESIS PROJECT: Time-Domain Identification of Second-Species Systems
% AUTHOR: Rodrigo Fonseca
% DATE: 2026
% TYPE: FUNCTION
% STATUS: IN PROGRESS
%
% PROGRAM DESCRIPTION: 
% Checks if a (nu, zeta) pair is stable or unstable
%
% INPUTS:
%   - nu
%   - zeta
%
% OUTPUTS:
%   - boolean isStable
%
%==========================================================================

function isStable = checkStability(nu, zeta)

    a = nu;
    xi = zeta;
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
end