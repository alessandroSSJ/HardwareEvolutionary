function [fase] = lvreadser()
%% TCP/IP Receiver

% Configuration and connection
%disp ('Receiver started');
tcpserver = tcpip('localhost',60001,...
                   'NetworkRole', 'server',...
                   'ByteOrder','BigEndian',...
                   'TransferDelay','off',...
                   'InputBufferSize',1000,...
                   'OutputBufferSize',1000,...
                   'Timeout',0.2,...
                   'UserData',[0]);
% Wait for connection
%disp('Waiting for connection');
fopen(tcpserver);
pause(0.1);
%disp('Data O.K');
fase = str2num(fscanf(tcpserver));




fclose(tcpserver);
delete(tcpserver);





end

