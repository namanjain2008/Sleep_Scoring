% input1 is the Values matrix
% input2 is the time_analysis matrix

function [output] = data_power (input1, input2, stage, fs)

clear Active_wake_val_1 frame_active Active_wake_val_zero

val = stage;

for ii = 1:length(input2)-1
    if input2(ii,1) == val
    frame_active = input1(floor(input2(ii,2)*fs)+1:floor(input2(ii+1,2)*fs));
    Active_wake_val_1(floor(input2(ii,2)*fs)+1:floor(input2(ii+1,2)*fs)) = frame_active;
    end
end

Active_wake_val_zero = Active_wake_val_1';
output      = Active_wake_val_zero (any(Active_wake_val_zero (:,1),2));

end
