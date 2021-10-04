%% Generate frequency candidate set
% ORDER=5

function freqCand=genFreqCand(testIdx)
    FreqSet1=[5 7 11 13 17 19];
    FreqSet2=[6 8 9 12 16 18];
    FreqSet3=[7 9 14 15 18 19];
    FreqSet4=[5,10; 5,15; 6,12; 6,18; 7,14; 8,16; 9,18; 10,15;
              12,18; 8,12; 10,17; 11,18; 14,17; 16,19; 18,19];
    FreqSet5=[9,16; 14,15; 15,16; 5,18; 6,19; 8,15; 10,13; 11,12;
              11,18; 12,16; 12,17; 12,19; 13,14; 13,16; 17,18];
    FreqSet6=[7,8; 5,8; 5,6; 6,7; 5,9; 6,11; 7,10; 7,11;
             8,9; 5,7; 7,9; 6,13; 5,11; 5,13; 8,11];
    FreqSet7=[8,16; 5,8; 5,16; 5,19; 7,12; 8,9; 8,14; 9,10;
              16,17; 17,19; 5,17; 5,18; 7,8; 7,14; 10,14];
    
    allFreqCand=double.empty;
    
    allFreqCand(1,:,:)=genDualSequence(FreqSet1);
    allFreqCand(2,:,:)=genDualSequence(FreqSet2);
    allFreqCand(3,:,:)=genDualSequence(FreqSet3);
    allFreqCand(4,:,:)=FreqSet4;
    allFreqCand(5,:,:)=FreqSet5;
    allFreqCand(6,:,:)=FreqSet6;
    allFreqCand(7,:,:)=FreqSet7;
    
    freqCand=reshape(allFreqCand(testIdx,:,:),[15 2]);
end

%% generate dual frequency set
function freqComb=genDualSequence(freqCandidates)
    n=length(freqCandidates);
    freqComb=zeros(n*(n-1)/2,2);
    counter=0;

    for i=1:n-1
        for j=i+1:n
            counter=counter+1;
            freqComb(counter,1)=freqCandidates(i);
            freqComb(counter,2)=freqCandidates(j);
        end
    end
end
