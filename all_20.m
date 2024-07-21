all_20 = [];
state = [];
    
all_code_20 = Sleep_Wake_Code;
all_code_20(:,3) = all_code_20(:,2)./20
all_codes_20(:,3) = floor(all_codes_20(:,2)./20);


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
    all_20(:,2) = state(:,2).*20;
    
    for ii=1:length(state)
    if state(ii,1)==0
    all_20(ii,1) = 0;
    elseif state(ii,1)==1
        all_20(ii,1) = 1;
         elseif state(ii,1)==2
        all_20(ii,1) = 2;
         elseif state(ii,1)==3
        all_20(ii,1) = 3;
    else
        all_20(ii,1) = 999;
    end
    end
    

    