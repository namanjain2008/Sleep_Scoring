% input is the matrix from sleep scoring

function [output] = epochs_combined (input, combined_dur)

output = [];
state = [];
    

all_codes_20 = input.sw_code;
all_codes_20(:,3) = floor(all_codes_20(:,2)./combined_dur);

 
    for jj = 1: all_codes_20(end,3)
    kk=1;
    temp = [];
    
for ii =1 :length(all_codes_20)
    if all_codes_20(ii,3) == jj
        temp(kk,1) = all_codes_20(ii,1);
        kk = kk+1;
    end
end
state(jj,1) = (mode(temp));
state(jj,2) = jj-1;

    end
    output(:,2) = state(:,2).*combined_dur;
    
    for ii=1:length(state)
    if state(ii,1)==0
    output(ii,1) = 0;
    elseif state(ii,1)==1
        output(ii,1) = 1;
         elseif state(ii,1)==2
        output(ii,1) = 2;
         elseif state(ii,1)==3
        output(ii,1) = 3;
    else
        output(ii,1) = 999;
    end
    end
end