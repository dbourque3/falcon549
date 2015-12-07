clear all; close all
%Siulation of the arm with the data read from serial COM port
%REQUIRES PrintArmAngles()

% Configure the serial port, set the com port and baud rate here
% Use the serial doc to help find the appropriate parameters
serialIn = serial('COM68', 'Baudrate', 115200, 'Terminator', 'LF/CR');

% Open the serial port. Be sure to close it later or you may have trouble
% re-opening


% You can also call this to remove the initialized post
fopen(serialIn);

% Check the serial configuration if you want
disp (serialIn);


global offsetX offsetY;
global length1 length2;

%System Parameters
%base position
offsetX=0;
offsetY=14;

%arm lengths
length1=6;
length2=6;


figure(1);
grid on;
axis([-35 35 0 +56]);
xlabel('x');
ylabel('y');
title('2-Link Arm Figure');

%%Draw constant objects
baseV=line([offsetX offsetX], [0 offsetY] ,'Color','k','LineWidth',3);
baseH=line([offsetX-2 offsetX+10], [0 0],'Color','k','LineWidth',3);

%     %Get IK
%     A = (fscanf(serialIn,'%f,%f'));
%     pos = GetLinkPos( A(1), A(2) );

N=5;
while(1)
    
    % a = (fscanf(serialIn,'%f,%f'))';
    if (serialIn.BytesAvailable >= 17 )
        % Include error checking to avoid it crashing
        for i=1:N
            try
                % Read the serial buffer, configure the input parsing as
                % required for your data formats
                A =fscanf(serialIn,'%e,%e')
                
                % Show the received and parsed data array
                if(i==N)
                    pos= GetLinkPos( A(1), A(2) );
                    L1=line([offsetX pos(1)],[offsetY pos(2)],'Color','r','LineWidth',2.8,'Marker','.','MarkerEdgeColor','k','MarkerSize',4);
                    L2=line([pos(1) pos(3)],[pos(2) pos(4)],'Color','r','LineWidth',3,'Marker','o','MarkerEdgeColor','k');
                    
                    %                          refreshdata(L2)
                    %                          refreshdata(L1)
                    %                          drawnow('udate')
                    %                          drawnow('expose')
                    %                          pause(0.01);
                    
                    pause(0.01);
                    delete(L1);
                    delete(L2);
                end
                
            catch
                %                 disp('Serial Error');
                pause(0.005);
            end
        end
    end
    
    
end


% To disconnect the serial port object from the serial port.
% This will nto happen automaatically in this sample because of the inifinite loop
fclose(serialIn);

% You can also call this to remove the initialized post
delete (serialIn);

