% Synthesis Filter Bank
%
% This is a function that implements a standard implementation of a 
% synthesis filter bank. The implementation is an IFFT followed by
% the synthesis polyphase network.
%
% Inputs:
%
% symbols: This should be a matrix of Ns rows and N columns where Ns
%       is the number of multicarrier symbols (with each multicarrier
%       symbol aggregating a number of subcarriers) and N is the 
%       oversampling factor (also equal to the size of the FFT). 
%       Alternatively, symbols can be a row or column vector containing
%       the symbols, and in that case it is zero padded and reshaped to 
%       accomodate the computation.
%
% prototype: The prototype filter to use. Typically this will be a
%       square root Nyquist filter for FBMC applications. If critical 
%       sampling is used, then it should be a square root Nyquist (N)
%       filter.
%
% N (optional): Indicates the FFT size to use. If this does not match
%       the dimensions of symbols, then an error is thrown (unless
%       symbols is a vector). Note that if fbstate is used to continue
%       calculating a previously terminated sequence, then N must be
%       supplied.
%
% fbstate (optional): This is a matrix that represents the state of the
%       delay lines. It is used to pass information from one iteration
%       to the next so that this function can be used for block processing.
%
% Outputs:
%
% fbout: A column vector containing the samples of the synthesized signal.
%
% fbstate: This is a matrix that represents the state of the delay lines
%       in the polyphase network. It is used to pass information from one
%       function call to the next so that the sequence may be continued
%       later on a block-by-block basis.
%
% function [fbout, fbstate] = synthesis_fb(symbols, prototype, N, fbstate)

function [fbout, fbstate] = synthesis_fb(symbols, prototype, N, fbstate)

    % Grab size of of input
    [Ns, Nfft] = size(symbols);
    
    % Reshape the input if necessary
    if Ns == 1
        % Error check
        if nargin <= 2
            fprintf(2, 'Error: Must specify N if symbols is a vector.')
            fbout = [];
            return
        end
        % Input is a row vector, convert to a matrix
        if mod(Nfft, N) ~= 0
            symbols = [ symbols, zeros(1, N - mod(Nfft, N)) ];
        end
        symbols = reshape(symbols, N, []).';
    elseif Nfft == 1
        % Error check
        if nargin <= 2
            fprintf(2, 'Error: Must specify N if symbols is a vector.')
            fbout = [];
            return
        end
        % Input is a column vector, convert to a matrix
        if mod(Ns, N) ~= 0
            symbols = [ 
                symbols; 
                zeros(N - mod(Ns, N), 1) 
            ];
        end
        symbols = reshape(symbols, N, []).';
    end
    
    % Grab size again in case we reshaped
    [Ns, Nfft] = size(symbols);
    
    % Error check
    if nargin > 2
        if N ~= Nfft
            fprintf(2, 'Error: Input argument N must match dimensions of symbols matrix.')
            fbout = [];
            return
        end
    end

    % Compute the IFFT of the input symbols
    fftout = Nfft * ifft(symbols, Nfft, 2);
    
    % Reshape the pulse shape to obtain the polyphase coefficients
    if (mod(length(prototype), Nfft) ~= 0)
        prototype = [ 
            prototype(:);
            zeros(Nfft - mod(length(prototype), Nfft), 1)
        ];
    end
    polyphase = reshape(prototype, Nfft, []).';
    
    % Pre-allocate the output buffer
    fbout = zeros(size(fftout));
    if nargin < 4
        fbstate = zeros(size(polyphase));
    end

    % Perform polyphase filtering
    for index = 1:Ns
        % Rotate delay line
        fbstate(2:end, :) = fbstate(1:end-1, :);
        fbstate(1, :) = fftout(index, :);
        % Perform multiply accumulate operations
        fbout(index, :) = sum(fbstate .* polyphase);
    end
    
    % Reshape output sequence
    fbout = reshape(fbout.', numel(fbout), 1);
end
