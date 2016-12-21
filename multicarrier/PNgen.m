function [x1] =PNgen(num_samples)

n=log2(num_samples);

switch n

    case 10

        PN=comm.PNSequence('Polynomial','z^10 + z^7 + 1', 'InitialConditions', [0 1 0 0 0 0 0 0 0 0],'SamplesPerFrame',2^n-1);

    case 9

        %511 samples

        PN=comm.PNSequence('Polynomial','z^9 + z^5 + 1', 'InitialConditions', [0 1 0 0 0 0 0 0 0 ],'SamplesPerFrame',2^9-1);

    case 11

        %2047 samples

        PN=comm.PNSequence('Polynomial','z^11 + z^9 + 1', 'InitialConditions', [0 1 0 0 0 0 0 0 0 0 0],'SamplesPerFrame',2^11-1);

    case 8

        %255 samples

        PN=comm.PNSequence('Polynomial','z^8 + z^6 + z^5 + z^4 + 1', 'InitialConditions', [0 1 0 0 0 0 0 0 ],'SamplesPerFrame',2^8-1);

end

x1=step(PN);

x1=((x1<1)*-1)+x1;

% x1=[x1(1:2^(n-1));0;x1(2^(n-1)+1:2^n-1)];

% test_signal = ifft(x1,2^n);

% max(abs(test_signal))/sqrt(mean(abs(test_signal).^2))

% test_signal_i=real(test_signal);

% max(abs(test_signal_i))/sqrt(mean(abs(test_signal_i).^2))

% test_signal_q=imag(test_signal);

% max(abs(test_signal_q))/sqrt(mean(abs(test_signal_q).^2))



% x1=zeros(1024,1);

% 

% 13/6 {0, 0, 1 + j, 0, 0, 0,?1 ? j, 0, 0, 0, 1 + j, 0, 0, 0,?1 ? j,

% 0, 0, 0,?1 ? j, 0, 0, 0, 1 + j, 0, 0, 0, 0, 0, 0, 0,?1 ? j,

% 0, 0, 0,?1 ? j, 0, 0, 0, 1 + j, 0, 0, 0, 1 + j, 0, 0, 0, 1 + j,