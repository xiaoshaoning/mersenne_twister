function random_number_list = mersenne_twister(seed, length_of_random_numbers)
% an implementation of mersenne twister in matlab.

f = 1812433253;
u = 11;
s = 7;
b = hex2dec('9D2C5680');
t = 15;
c = hex2dec('EFC60000');
l = 18;
index = 624;

state = zeros(1, 624);
state(1) = seed;

for jj = 1:623
    state(jj+1) = int_32(int64(f) * int64(bitxor(state(jj), bitshift(state(jj), -30))) + jj );
end

random_number_list = zeros(1, length_of_random_numbers);

for ii = 1:length_of_random_numbers
    if index >= 624
        [state, index] = twist(state);
    end

    y = state(index+1);
    y = bitxor(y, bitshift(y, -u));
    y = bitxor(y, bitand(bitshift(y, s), b));
    y = bitxor(y, bitand(bitshift(y, t), c));
    y = bitxor(y, bitshift(y, -l));
    
    index = index + 1;
    random_number_list(index) = int_32(y);
end

end

function [state, index] = twist(state)
lower_mask = 2^31-1;
upper_mask =  2^31;
m = 397;
for ii = 0:623
    temp = int_32(bitand(state(ii+1), upper_mask) + bitand(state(mod(ii+1, 624)+1), lower_mask));
    temp_shift = bitshift(temp, -1);

    if mod(temp, 2) ~= 0
        temp_shift = bitxor(temp_shift, hex2dec('9908b0df'));    
    end
    state(ii+1) = bitxor(state(mod(ii + m, 624)+1), temp_shift);
end

index = 0;

end

function result = int_32(number)
    result = bitand(2^32-1, number);
end