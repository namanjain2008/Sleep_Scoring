function [output1,output2] = episode(input)

new_data = input(input(:,2) < 3602, :);

data_det = new_data(:,1);
time_det = new_data(:,2);

dff_dat = (diff(data_det)~=0);
time_out = [];
output1 = [];
output1(1,1) = data_det(1,1);

for ii =1: size(dff_dat,1)
    if dff_dat(ii,1)~=0
        time_out(ii,1) = time_det(ii,1);
        output1(ii+1,1) = data_det(ii+1);
        output1(ii+1,3) = time_det(ii+1,1);
        output1(ii+1,4) = 1;
    end
end

output1(1,2) = output1(1,3);
output1(1,4) = 1;
output1 = output1(any(output1(:,4),2),:);



for ii = 1: size(output1,1) - 1
output1(ii,2) = output1(ii+1,3)-output1(ii,3);   


end
output1(end,2) = time_det(end)-time_det(end-1);   

% Find the unique minutes
Sleep_state = ceil(floor(output1(:,1)));

[n_vals, ~, n_inds] = unique(Sleep_state, 'rows');
output2 = [];

for ii = 4:size(output1,2)
    for jj = 1:size(n_vals,1)
        kk = n_vals(jj);
        x = output1(find(Sleep_state == kk),ii);
        output2(jj,ii)  = sum(x);
    end
end

output2(:,1) = n_vals;
output2(:,2:3)=[];

end

