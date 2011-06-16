% connection stuff
host = '192.168.4.117'; %'localhost';
port = 60001;

startplot = 0;

% init TCP connection
import java.net.Socket
import java.io.*

try
    % throws if unable to connect
    input_socket = Socket(host, port);

    % get a buffered data input stream from the socket
    input_stream   = input_socket.getInputStream;
    d_input_stream = DataInputStream(input_stream);

    fprintf(1, 'Connected to server %s\n', host);
catch
    if ~isempty(input_socket)
        input_socket.close;
    end
end

try
    while(1)
        % read data from the socket - wait a short time first
        pause(0.8);
        bytes_available = input_stream.available;
        fprintf(1, 'Reading %d bytes\n', bytes_available);

        if (bytes_available == 0)
            continue;
        end
        
        message = zeros(1, bytes_available, 'uint8');
        for i = 1:bytes_available
            message(i) = d_input_stream.readByte;
        end

        % pick-up the last
        idx = find(message == 127);
        if (size(idx,2) > 1)
            newdata = message(idx(end-1)+1:idx(end)-1);
        else
            newdata = message(1:idx(end)-1);
        end

        newdata
        
    end
catch Exp
    Exp.message
    disp('closing ...');
end

% cleanup
input_socket.close;
