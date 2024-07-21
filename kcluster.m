function [h1, output] = kcluster (input)

      % Kmeans clustering
fig = figure
plot(input(:,3),input(:,2),'.');
ylabel 'Correlation Coefficient', xlabel 'Time Difference'
hold on


% figure

output(:,1) = input(:,3);
output(:,2) = input(:,2);

output= rmmissing(output);

opts = statset('Display','final','MaxIter',10000000000000000);
[idx,C] = kmeans(output,2,'Distance','cityblock','Start','cluster',...
    'Replicates',10,'Options',opts);

h1 = plot(output(idx==1,1),output(idx==1,2),'r.','MarkerSize',10)
h2 = plot(output(idx==2,1),output(idx==2,2),'b.','MarkerSize',10)
cx = plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)

legend([h1 h2 cx],'Cluster 1','Cluster 2','Centroids','Location','NW')



ylabel 'correlation ', xlabel 'time lag'
title('Time lag vs Correlation (All clusters)');

% savefig(fig,strcat(Pathname,Filename,'_Cluster_SS'));

end