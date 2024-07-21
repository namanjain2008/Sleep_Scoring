%input1 referes to the type of stimuli i.e. Auditory, Auditory + Startle
%and Startle
% input2 refers to the data obtained form sleep scoring

function [output] = classify (input1, input2)

data_times = input1.times;
Sleep_Wake_Code = input2;
outcome_classification = data_times(data_times(:,1) < 3600, :);

for ii = 1:length(outcome_classification)
    for jj = 1:length (Sleep_Wake_Code)-1
        if outcome_classification (ii) >= Sleep_Wake_Code(jj,2) && outcome_classification(ii) < Sleep_Wake_Code(jj+1,2)
           outcome_classification (ii,2) = Sleep_Wake_Code (jj,1);
        end
    end
end

output.classified_data = outcome_classification;

sdaw = 0;
sdqw = 0;
sds  = 0;

for k = 1:length(outcome_classification)
    if outcome_classification(k,2) == 0
        sdaw = sdaw+1;
    
    elseif outcome_classification(k,2) == 1
        sdqw = sdqw+1;
        
    elseif outcome_classification(k,2) == 2
        sds = sds+1;
    end
end
    
output.aw    = ((sdaw)/(sdaw + sdqw + sds));
output.qw    = ((sdqw)/(sdaw + sdqw + sds));
output.sleep = ((sds)/(sdaw + sdqw + sds));

end
