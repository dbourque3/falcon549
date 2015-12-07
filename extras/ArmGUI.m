

function [] = ArmGUI()
   %% ARMGUI.m
        %GUI for a 2-DOF Arm controlled over AVR, function will
        % simulate the arm with the incoming real-time serial data of joint angles.
        % This GUI also enables the user to control the arm by defining joint
        % angles and transiting them over UART.
        
        %REQUIRES OperationBlockadeWave2()
        
        %Declare the serial object , open adn display it.
serialIn = serial('COM18', 'Baudrate', 115200, 'Terminator', 'LF/CR');
fopen(serialIn);
disp(serialIn);
GUIDo();
j =1;
theta1 = 0; % Initial values of the control mode.
theta2 = 0;
mode=1;
%to be able to refresh lines from every function
L1 = 0
L2 = 0;
    function [] = GUIDo()
        %% ARMGUI.m
        %GUI for a 2-DOF Arm controlled over AVR, function will
        % simulate the arm with the incoming real-time serial data of joint angles.
        % This GUI also enables the user to control the arm by defining joint
        % angles and transiting them over UART.
        
        %Declare the serial object , open adn display it.
        
        
        
        
        %% GUI elements
        S.fh = figure('units','pixels',...
            'position',[500 500 430 510],...
            'menubar','none',...
            'name','RBE3001: Final, Team',...
            'numbertitle','off',...
            'resize','off');
        S.ax = axes('units','pixels',...
            'position',[40 120 360 360],...
            'fontsize',8,...
            'nextplot','replacechildren');
        %'CreateFcn',{@ax_createfcn,S});
        
         
        S.ed1 = uicontrol('style','edit',...
            'units','pix',...
            'position',[50 60 65 30],...
            'string','Theta1');
        
        S.ed2 = uicontrol('style','edit',...
            'units','pix',...
            'position',[125 60 65 30],...
            'string','Theta2');
        
        S.pb_GO = uicontrol('style','pushbutton',...
            'units','pix',...
            'position',[50 20 140 30],...
            'string','GO!',...
            'Enable','off');
        
        S.pb_OFF = uicontrol('style','pushbutton',...
            'units','pix',...
            'position',[410 490 15 15],...
            'string','X');
        
        S.tb_AUTO = uicontrol('style','togglebutton',...
            'units','pix',...
            'position',[260 20 130 30],...
            'string','Automation');
        
        
        S.tb_CONT = uicontrol('style','togglebutton',...
            'units','pix',...
            'position',[260 60 130 30],...
            'string','Control');
        
        uicontrol(S.ed1);  % Make the editboxes active.
        uicontrol(S.ed2);
        %uiwait(S.fh);  % Prevent all other processes from starting until closed.
        %%set
        set(S.tb_AUTO,'callback',{@tb_auto_call,S}) %ButtonDownFcn?
        set(S.tb_CONT,'callback',{@tb_control_call,S})
        set(S.pb_GO,'callback',{@pb_go_call,S})
        set(S.pb_OFF,'callback',{@pb_close_call,S})
        
        %% axes handles
        set(S.ax,'XGrid','on');
        set(S.ax, 'YGrid','on');
        set(S.ax, 'XLim',[-35 35]);
        set(S.ax,'YLim',[0 70]);
        %set(S.ax, 'Title','RBE3001: 2DOF Arm simulation');
        
    end

%% Callback functions
    function [] = ax_createfcn
        %AX_CREATEFCN plots the arm simulation
        
        
        % buttondownfcn for axes.
        % Extract the calling handle and structure.
        
        
        
        %System Parameters
        %base position
        offsetX=0;
        offsetY=14;
        
        %%Draw constant objects
        baseV=line([offsetX offsetX], [0 offsetY] ,'Color','k','LineWidth',3);
        baseH=line([offsetX-2 offsetX+10], [0 0],'Color','k','LineWidth',3);
        
        
        N=10; %%1/plotting rate
        while(1)
            
            
            if (serialIn.BytesAvailable >= 17 )
                % Include error checking to avoid it crashing
                for i=1:N
                    try
                        
                        % Read the serial buffer, configure the input parsing as
                        % required for your data formatsdasd
                        
                        A =fscanf(serialIn,'%e,%e,%u,%e,%e,%u');
                        disp(A);
                      
                        if(i==N)
                            
                            pos= GetLinkPos( A(1), A(2));
                            L1=line([offsetX pos(1)],[offsetY pos(2)],'Color','r','LineWidth',2.8,'Marker','.','MarkerEdgeColor','k','MarkerSize',4);
                            L2=line([pos(1) pos(3)],[pos(2) pos(4)],'Color','r','LineWidth',3,'Marker','o','MarkerEdgeColor','k');
                            
                            
                            pause(0.01);
                            delete(L1);
                            delete(L2);
                            
                        end
                        
                         tx_command_data(A(3));
                    catch
                        disp('Serial Error');
                        pause(0.01);
                    end
                    
                end
            end
            
        end
    end








    function [] = tb_auto_call(varargin)
        % Callback for the pushbutton.
        S = varargin{3};
        
        
        
        set(S.pb_GO,'Enable','off');
        set(S.tb_CONT,'Value',0);
        set(S.tb_CONT,'Enable','on');
        set(S.tb_AUTO,'Enable','off');
        
        mode=1;
        
        
        
        switch j
            case 0
                delete(L1);
                delete(L2);
            case 1 %start simulation with first button toggle
                fprintf(serialIn,'%c',mode);
                ax_createfcn;
                j=0;
            otherwise
        end
        
        
    end

    function [] = tb_control_call(varargin)
        % Callback for the pushbutton.
        
        S = varargin{3};
        
        
        
        mode=2;
        
        set(S.pb_GO,'Enable','on')
        set(S.tb_AUTO,'Value',0);
        set(S.tb_AUTO,'Enable','on');
        set(S.tb_CONT,'Enable','off');
        
        
    end






    function [] = pb_go_call(varargin)
        % Callback for the pushbutton.
        S = varargin{3};
        
        rho1 = str2double(get(S.ed1,'string'));
        rho2 = str2double(get(S.ed2,'string'));
        if (isempty(rho1))
            set(S.ed1,'string','0');
            warndlg('Input must be numerical');
        end
        if ( isempty(rho2))
            set(S.ed2,'string','0');
            warndlg('Input must be numerical');
        else
            theta1=rho1;
            theta2=rho2;
            
            switch j
                case 0
                    delete(L1);
                    delete(L2);
                case 1 %start simulation with first button toggle
                    fprintf(serialIn,'%c',mode);
                    ax_createfcn;
                    
                    j=0;
                otherwise
                    
            end
        end
        
    end


    function [] = pb_close_call(varargin)
        S = varargin{3};
        
        close(S.fh);
        close all;
        fclose(serialIn);
        delete(serialIn);
        clear all;
        
        
    end
    function [ ] =tx_command_data(dataSelect)
        switch dataSelect
            case 1
                
                fprintf(serialIn,'%c',mode);
                fprintf(serialIn,'%c',1);
                disp(mode);
            case 2
                fprintf(serialIn,'%c',double(theta1));
                fprintf(serialIn,'%c',2);
                disp(theta1);
                
                
            case 3
                fprintf(serialIn,'%c',double(theta2));
                fprintf(serialIn,'%c',3);
                disp(theta2);
                
                
            otherwise
        end
    end
end