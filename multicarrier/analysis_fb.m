% Analysis Filter Bank
%
% This is a function that implements a standard implementation of a 
% synthesis filter bank. The implementation is an IFFT followed by
% the synthesis polyphase network.
%
% Inputs:
%
% signal: A column vector containing the input signal to be analyzed. If
%         the signal is not a multiple of the FFT size (oversampling
%         factor), then the signal is zero padded. This should be avoided
%         if block processing is desired for continuous operation.
%
% prototype: The prototype filter to use. Typically this will be a
%       square root Nyquist filter for FBMC applications. If critical 
%       sampling is used, then it should be a square root Nyquist (N)
%       filter.
%
% N:    Indicates the FFT size to use. 
%
% fbstate (optional): This is a matrix that represents the state of the
%       delay lines. It is used to pass information from one iteration
%       to the next so that this function can be used for block processing.
%
% Outputs:
%
% fbouts: A matrix with dimensions Ns x N where Ns is the number of 
%         multicarrier symbol periods in the signal, and .
%
% fbstate: This is a matrix that represents the state of the delay lines
%       in the polyphase network. It is used to pass information from one
%       function call to the next so that the sequence may be continued
%       later on a block-by-block basis.
%
% function [fbouts, fbstate] = analysis_fb(signal, prototype, N, fbstate)

function [fbouts, fbstate] = analysis_fb(signal, prototype, N, fbstate)

    % Reshape the pulse shape to obtain the polyphase coefficients
    prototype = prototype(:);
    if (mod(length(prototype), N) ~= 0)
        prototype = [ 
            prototype(:);
            zeros(N - mod(length(prototype), N), 1)
        ];
    end
    prototype = conj(flipud(prototype));
    polyphase = reshape(prototype, N, []).';

    % Reshape the pulse shape to obtain the polyphase coefficients
    signal = signal(:);
    if (mod(length(signal), N) ~= 0)
        signal = [ 
            signal;
            zeros(N - mod(length(signal), N), 1)
        ];
    end
    signal = reshape(signal, N, []).';
    
    % Grab the number of symbol periods to process
    [Ns, ~] = size(signal);
    
    % Perform Polyphase Filtering
    ppouts = zeros(Ns, N);
    if nargin < 4
        fbstate = zeros(size(polyphase));
    end
    for index = 1:Ns
        % Rotate Delay Line
        fbstate(2:end, :) = fbstate(1:end-1, :);
        fbstate(1, :) = signal(index, end:-1:1);
        % Perform multiple accumulation operations
        ppouts(index, :) = sum(fbstate .* polyphase);
    end
    
    % Perform IFFT
    fbouts = N * ifft(ppouts, N, 2);
    
end
