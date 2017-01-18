% function x = resampled_ofdm(t, s, T, Tcp, N)
%
% t is a vector of time indices for the resampled signal
% s is a vector of constellation symbols to be modulated
% T is the funcamental period of the subcarriers
% Tcp is the length of the cyclic prefix
% N is the number of subcarriers
function x = resampled_ofdm(t, s, T, Tcp, N)

    if (nargin < 5) 
        error('Not enough arguments. Usage: resampled_ofdm(t, s, T, Tcp, N)')
    end

    if (round(N) ~= N) 
        error('N must be an even integer')
    end
    
    if (mod(N, 2) ~= 0)
        error('N must be an even integer')
    end
    
    % Flatten the input symbol vector s
    s = s(:);
    
    if (mod(length(s), N) ~= 0)
        error('For now, the function requires a symbol length that is a multiple of N.')
    end
    
    % Flatten the time index vector t
    t = t(:);
      
    % Preallocate space for x
    x = zeros(size(t));

    m = 1;
    for index = 1:length(t)
        % Calculate which symbol interval we are at
        t_sym = t(index) / (T + Tcp);
        n = round(t_sym);
        % Calculate the time starting with -Tcp at the beginning of the interval
        t_frac = (T + Tcp) * (t_sym - n) - Tcp;
        % Sum of sine waves
        if (n >= 0) && (n < length(s) / N)
            for k = 0:N/2-1
                x(m) = x(m) + s(N*n + 1 + k) * exp(2j*pi*k*t_frac/T);
            end
            for k = N-N/2:N-1
                k1 = k-N;
                x(m) = x(m) + s(N*n + 1 + k) * exp(2j*pi*k1*t_frac/T);
            end
        end
        % Normalize the power
        x = x / sqrt(N);
        % Increment output index
        m = m + 1;
    end
end