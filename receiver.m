
%% TCP/IP Receiver

% Clear console and workspace
close all;
clear all;
clc;

% Configuration and connection
disp ('Receiver started');
tcpserver = tcpip('localhost',60001,...
                   'NetworkRole', 'server',...
                   'ByteOrder','BigEndian',...
                   'TransferDelay','off',...
                   'InputBufferSize',1000,...
                   'OutputBufferSize',1000,...
                   'Timeout',0.5,...
                   'UserData',[0]);
% Wait for connection
disp('Waiting for connection');
fopen(tcpserver);
disp('Connection OK');
data=fread(tcpserver,28)
%fase = str2num(data)

fclose(tcpserver);
delete(tcpserver);

