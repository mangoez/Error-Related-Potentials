
function onset=findOnset(data,channel,threshold)
    Fs=512;
%     Fs=250;
    
    counter=0;
    lastCall=0;
    for i=1:length(data)
        if i-lastCall<Fs
%         if i-lastCall<1000*24
            continue    % skip 1 second of recording after each detection
        end
        if data(channel,i)>threshold
           counter=counter+1;
           onset(counter)=i;
           lastCall=i;
        end
       
    end
end