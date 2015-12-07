serialIn = serial('COM66', 'Baudrate', 115200, 'Terminator', 'LF/CR');
fopen(serialIn);
disp(serialIn);
serialIn.BytesAvailable
while(1)
A =fscanf(serialIn,'%e,%e,%c');
disp(A);

end