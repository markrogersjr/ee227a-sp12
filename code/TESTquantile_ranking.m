load CEPconvexInterval
figure;imagesc(X);title('X');axis square;colorbar;
figure;imagesc(S);title('S');axis square;colorbar;
[X Y S] = quantile_ranking(X,Y,S);
figure;imagesc(X);title('X normalized');axis square;colorbar;
figure;imagesc(S);title('S normalized');axis square;colorbar;
