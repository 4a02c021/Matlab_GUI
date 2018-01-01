function[Output] = Decode_Package(packet,element,bin_code,EEG_channel)
 switch element
             case 1  % Time
                     packet(element) = bin2dec([bin_code(1,3:8),bin_code(2,1:3)]); % Time, 9bit
                     %fprintf('Time= %d \n', packet(i));
             case 2  %A0
                     packet(element) = bin2dec([bin_code(3,1:8),bin_code(4,1:2)]);
                     %fprintf('Time= %d \n', packet(i));
             case 3  %A1
                     packet(element) = bin2dec([bin_code(4,3:8),bin_code(5,1:4)]);
                     %fprintf('Time= %d \n', packet(i));
             case 4  %A2
                     packet(element) = bin2dec([bin_code(5,5:8),bin_code(6,1:6)]);  
                     %fprintf('Time= %d \n', packet(i))
             case 5  %A3
                     packet(element) = bin2dec([bin_code(6,7:8),bin_code(7,1:8)]); 
                     %fprintf('Time= %d \n', packet(i))
             case 6  %A4
                     packet(element) = bin2dec([bin_code(8,1:8),bin_code(9,1:2)]);   
                    % fprintf('Time= %d \n', packet(i))
             case 7  %A5
                     packet(element) = bin2dec([bin_code(9,3:8),bin_code(10,1:4)]);     
                     %fprintf('Time= %d \n', packet(i))
             case 8  %6
                     packet(element) = bin2dec([bin_code(10,5:8),bin_code(11,1:6)]);  
                     %fprintf('Time= %d \n', packet(i))
             case 9  %A7
                     packet(element) = bin2dec([bin_code(11,7:8),bin_code(12,1:8)]);  
                     %fprintf('Time= %d \n', packet(i))
             case EEG_channel   % channel 10
                     packet(element) = bin2dec(bin_code(2,4:8)); % 5 bit 
 end
 Output = packet(element);