function z = mytest(x, y)
    z = xor(dec2bin(hex2dec(x), 16) == '1', dec2bin(hex2dec(y), 16) == '1')
    z = dec2hex(z * 2.^(15:-1:0).');
end