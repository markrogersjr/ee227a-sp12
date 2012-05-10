% simulating data
whichData = 4; % choose the data you want to fit
randn('seed',227);
if whichData == 1
  % 2d data for visualization
  % negative Beta0 and Beta
  xPlus = normrnd(-5,2,2,10);
  yPlus = repmat(1,1,10);
  xMinus = normrnd(5,2,2,8);
  yMinus = repmat(-1,1,8);
  x = [xPlus xMinus];
  y = [yPlus yMinus];
  [m,n] = size(x);
  % Sigma matrix with equal columns: 2-dim, for visualization purpose only:
  Sigma = repmat([1,0.7]',1,n);
  rho = 1;
end;
if whichData == 2
  xPlus = [normrnd(-5,2,1,10);normrnd(0,2,1,10)];
  yPlus = repmat(1,1,10);
  xMinus = [normrnd(5,2,1,8);normrnd(0,2,1,8)];
  yMinus = repmat(-1,1,8);
  x = [xPlus xMinus];
  y = [yPlus yMinus];
  [m,n] = size(x);
  Sigma = repmat([1,0.7]',1,n);
  rho = 1;
end;
if whichData == 3
  % 5 dimension example
  xPlus = normrnd(0,1,5,10) ;
  yPlus = repmat(1,1,10);
  xMinus = normrnd(0,1,5,8) - 1;
  yMinus = repmat(-1,1,8);
  x = [xPlus xMinus];
  y = [yPlus yMinus];
  [m,n] = size(x);
  Sigma = abs(normrnd(0.1,0.1,m,n));
  rho = 1;
end;
if whichData == 4
  % 5 dimension example
  xPlus = normrnd(0,1,5,10) ;
  yPlus = repmat(1,1,10);
  xMinus = normrnd(0,1,5,8) - 0.5;
  yMinus = repmat(-1,1,8);
  x = [xPlus xMinus];
  y = [yPlus yMinus];
  [m,n] = size(x);
  Sigma = abs(normrnd(0.1,0.1,m,n));
  rho = 1;
end;

C =0.0001:0.01:3
p = length(C);
Beta0 = zeros(1,p);
Beta = zeros(m,p);
Alpha = zeros(n,p);
V = zeros(m,p);
U = zeros(m,p);
CC = zeros(m,p);
T = zeros(m,p);

for i = 1:p

  [beta0,beta,error,t,alpha,gamma,c,v,u,margin,obj_val] = svmInterval(x,y,Sigma,1,C(i));
  Beta0(i) = beta0;
  Beta(:,i) = beta;
  Alpha(:,i) = alpha;

  V(:,i) = v;
  U(:,i) = u;
  CC(:,i) = c;
  T(:,i) = t;
end

figure; plot(C,Beta0);title('\beta_0');
figure; plot(C,Beta');title('\beta');
figure; plot(C,Alpha');title('\alpha');
figure; plot(C,V');title('\nu');
figure; plot(C,U');title('\mu');
