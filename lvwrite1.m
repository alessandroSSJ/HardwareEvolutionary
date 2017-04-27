function [] = lvwrite1(x)

% Configuration and connection
tcpclient = tcpip('localhost',60002);

% Open socket and wait before sending data
fopen(tcpclient);
pause(0.1);


% Send data 
    B = x;
    DataToSend = mat2str(B);
    fwrite(tcpclient,DataToSend);
   % pause (0.1);


% Close and delete connection
fclose(tcpclient);
delete(tcpclient);


end

