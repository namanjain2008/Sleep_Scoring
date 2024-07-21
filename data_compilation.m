% input1 = Percentage_and_Duration
% input2 = startle_data
% input3 = audpre_data
% input4 = audpre_S_data
% input5 = fl.re
% 

function [output] = data_compilation (input1, input2, input3, input4, input5, Filename)

output = strings(5,35);

%%Data Entry for percentage and Duration of each stage%%
output (2,1)  = 'File Name';
output (4,1)  = Filename;
output (1,4)  = 'Percentage and Duration';
output (2,3)  = 'Active Wake';
output (2,4)  = 'Quiet Wake';
output (2,5)  = 'Sleep';

output (4,3)  = input1(4,3);
output (5,3)  = input1(4,4);
output (4,4)  = input1(5,3);
output (5,4)  = input1(5,4);
output (4,5)  = input1(6,3);
output (5,5)  = input1(6,4);

%%Data entry for Startle repsonse%%
output (1,8)  = 'Startle';
output (2,7)  = 'Active Wake';
output (2,8)  = 'Quiet Wake';
output (2,9)  = 'Sleep';

output (4,7)  = (input2.aw)*100;
output (4,8)  = (input2.qw)*100;
output (4,9)  = (input2.sleep)*100;

 
%%Data entry for Audtory response%%
output (1,12)  = 'Auditory';
output (2,11)  = 'Active Wake';
output (2,12)  = 'Quiet Wake';
output (2,13)  = 'Sleep';

output (4,11)  = (input3.aw)*100;
output (4,12)  = (input3.qw)*100;
output (4,13)  = (input3.sleep)*100;

%%Data entry for Auditory + Startle response%% 
output (1,16)  = 'Auditory + Startle';
output (2,15)  = 'Active Wake';
output (2,16)  = 'Quiet Wake';
output (2,17)  = 'Sleep';

output (4,15)  = (input4.aw)*100;
output (4,16)  = (input4.qw)*100;
output (4,17)  = (input4.sleep)*100; 
 
%%Data entry for floor response%%
output (1,20)  = 'Floor Res - Startle';
output (2,19)  = 'Active Wake';
output (2,20)  = 'Quiet Wake';
output (2,21)  = 'Sleep';

output (1,24)  = 'Floor Res - Auditory';
output (2,23)  = 'Active Wake';
output (2,24)  = 'Quiet Wake';
output (2,25)  = 'Sleep';

output (1,28)  = 'Floor Res - Auditory + Startle';
output (2,27)  = 'Active Wake';
output (2,28)  = 'Quiet Wake';
output (2,29)  = 'Sleep'; 
  
output (4,19)= input5.min_rs_mn(1,1);
output (4,20)= input5.min_rs_mn(1,2);
output (4,21)= input5.min_rs_mn(1,3);
output (4,23)= input5.min_rs_mn(1,4);
output (4,24)= input5.min_rs_mn(1,5);
output (4,25)= input5.min_rs_mn(1,6);
output (4,27)= input5.min_rs_mn(1,7);
output (4,28)= input5.min_rs_mn(1,8);
output (4,29)= input5.min_rs_mn(1,9);

%%Calculating PPI Index%%
output (1,32)  = 'PPI Index';
output (2,31)  = 'Active Wake';
output (2,32)  = 'Quiet Wake';
output (2,33)  = 'Sleep';

output (4,31) = 1-(abs(input5.min_rs_mn(1,7))/(abs(input5.min_rs_mn(1,1))));
output (4,32) = 1-(abs(input5.min_rs_mn(1,8))/(abs(input5.min_rs_mn(1,2))));
output (4,33) = 1-(abs(input5.min_rs_mn(1,9))/(abs(input5.min_rs_mn(1,3))));

end
