function [fase] = lvread()
warning off
% Configuration and connection
tcpclient = tcpip('localhost',60001,...
                   'NetworkRole', 'client',...
                   'ByteOrder','BigEndian',...
                   'TransferDelay','off',...
                   'InputBufferSize',1000,...
                   'OutputBufferSize',1000,...
                   'Timeout',0.1,...
                   'UserData',[0]);

% Open socket and wait before sending data
fopen(tcpclient);
pause(0.1);


% Send data every 500ms
   a = fscanf(tcpclient);
   fase = str2num(a);

   % pause (0.1);


% Close and delete connection
fclose(tcpclient);
delete(tcpclient);


end

