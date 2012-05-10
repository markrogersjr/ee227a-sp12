function [Lambda_l,Beta0_l,Beta_l] = svmIntervalFindNext(x,y,rho,Sigma,iPlus,iMinus,iter_max)

% This function finds the regularization path of an interval SVM
% Inputs:
% x: transposed design matrix, rows represent features, column observations
% y: 1 by n row vector
% Sigma: the precision matrix of x, of the same dim of x
% rho: the precision weight
% iPlus, iMinus: the +1 and -1 index set
% iter_max: maximum break points

% Outputs:
% Lambda_l: the break points at which an event occurs
% Beta0_l, Beta_l: the parameter values at those break points

[p,n] = size(x);
% beginning of the initialization step
% modify this so it works for arbitrary starting point
  [alphaS,nuS,muS] = svmIntervalInit(x,y,rho,Sigma,iPlus,iMinus);
  [lambda_l,beta0_l,beta_l,alpha_l,nu_l,mu_l] = svmIntervalFindNext0(x,y,rho,Sigma,alphaS,nuS,muS,iPlus,iMinus);

% Storing the results
  Beta0_l = beta0_l;
  Beta_l = beta_l;
  Alpha_l = alpha_l;
  Nu_l = nu_l;
  Mu_l = mu_l;
  Lambda_l = lambda_l;
% end of the init step

  alpha0_l = lambda_l*beta0_l;


  % initialize the sets
  l = y.*(beta0_l+beta_l'*x);
  r = 1 + rho*(abs(beta_l)'*Sigma);
  diff = l - r;
  Elbow = find( abs(diff)<=1e-4); 
  Left =  find( diff < -1e-4);
  Right =  find( diff > 1e-4);

  sizeOfElbow = length(Elbow);

  VPlus = find(beta_l>1e-5); % index set for positive coef
  VMinus = find(beta_l<-1e-5); % index set for negative coef
  Z = find(abs(beta_l)<=1e-5); % index set for zero coef

%Elbow = [56,362]

% some global data computation
Y = repmat(y,p,1); % p by n matrix
XY = x.*Y; % p by n matrix 
w = XY - rho*Sigma; % p by n matrix
z = XY + rho*Sigma; % p by n matrix
 
% Now, enter the iteration...
m = length(beta_l); % dimension of the problem
for iter = 1:iter_max
  
  if length(Left) == 0 | lambda_l< 1e-6
    % if the set Left becomes empty, that means the data points are separable.
    % we simply terminate the iteration as the current lambda is the best.
    % when lambda is small, the algorithm becomes extremely unstable.
    break;
  end
    
  if sizeOfElbow > 0

    xElbow = x(:,Elbow);
    yElbow = y(:,Elbow);
    YElbow = Y(:,Elbow); 
    zElbow = z(:,Elbow);  
  
    SigmaWPlus = (w(VPlus,:)'*Sigma(VPlus,:))';
    SigmaWMinus = (z(VMinus,:)'*Sigma(VMinus,:))';
    H = SigmaWPlus - SigmaWMinus;
    h = H(Elbow,Elbow);
    
    
    xSigmaPlus = (Sigma(VPlus,Elbow)'*x(VPlus,:))';
    
    xSigmaMinus = x(1,:)'*Sigma(1,Elbow);
    xSigmaMinus = (Sigma(VMinus,Elbow)'*x(VMinus,:))';

    YxxZ = x(Z,:)'*XY(Z,Elbow);
    G = rho*xSigmaMinus - rho*xSigmaPlus - YxxZ;
    g = G(Elbow,:);

    K = XY(:,Elbow)'*XY(:,Elbow) + g.*(repmat(y(Elbow),sizeOfElbow,1)') - rho*h;
    A = [0,yElbow;yElbow',K];
    oneA = [0,ones(1,sizeOfElbow)]';
    bA = inv(A)*oneA;
    bA0 = bA(1);
    bAR = bA(2:(sizeOfElbow+1));
   
    xLeft = x(:,Left);
    yLeft = y(:,Left);
    YLeft = repmat(y(Left),m,1);
    zLeft = z(:,Left);
    sizeOfLeft = length(Left);

    % finding the point where the next event occurs...

    % CASE I: corresponding to (i) in p14
    lambdaNextCandidates1 = ((lambda_l*bAR-alpha_l(Elbow))./bAR)';
    lambdaNextCandidates2 = ((1+lambda_l*bAR-alpha_l(Elbow))./bAR)';

    % CASE II: corresponding to (ii) in p14:
    fLeft_l = beta0_l + beta_l'*xLeft;
    xYxL = x(:,Left)'*XY(:,Elbow);
    hLeft_l = ((xYxL+G(Left,:))*bAR +bA0)';
    xRight = x(:,Right);
    fRight_l = beta0_l + beta_l'*xRight;

    xYxR = x(:,Right)'*XY(:,Elbow);
    hRight_l = ((xYxR+G(Right,:))*bAR +bA0)';
  
    numTemp = zElbow*((alpha_l(Elbow)-lambda_l*bAR))+ zLeft*ones(sizeOfLeft,1);
    demTemp = zElbow*bAR;
  
    yRight = y(:,Right);
    YRight = repmat(yRight,m,1);
  
    numTemp2 = sum(H(Left,Left),2) + H(Left,Elbow)*alpha_l(Elbow) - lambda_l*(H(Left,Elbow)*bAR); 
    numLeft = lambda_l*(fLeft_l-hLeft_l) - yLeft.*numTemp2';

    demLeft = yLeft - hLeft_l + yLeft.*((H(Left,Elbow)*bAR)');
  
    lambdaNextCandidatesLeft = numLeft./demLeft;

   numTemp3 = sum(H(Right,Left),2) + H(Right,Elbow)*alpha_l(Elbow) - lambda_l*(H(Right,Elbow)*bAR) ;
 
    numRight = lambda_l*(fRight_l-hRight_l) - yRight.*numTemp3';

    demRight = yRight - hRight_l + yRight.*((H(Right,Elbow)*bAR)');    
    lambdaNextCandidatesRight = numRight./demRight;


    % Case III a nonzero component of beta becomes zero
    tempCommon = lambda_l*bAR - alpha_l(Elbow); 

    % 1) enter zero from positive
    tempPosNum = w(VPlus,Elbow)*tempCommon- sum(w(VPlus,Left),2);
    tempPosDem = w(VPlus,Elbow)*bAR;
    lambdaNextCandidatesPos2Zero = (tempPosNum./tempPosDem)';

    % 2) enter zero from negative
    tempNegNum = z(VMinus,Elbow)*tempCommon - sum(z(VMinus,Left),2);
    tempNegDem = z(VMinus,Elbow)*bAR;
    lambdaNextCandidatesNeg2Zero = (tempNegNum./tempNegDem)';

    % Case IV a zero component of beta becomes nonzero  
    % 1) becomes positive
    tempPosNum = w(Z,Elbow)*tempCommon - sum(w(Z,Left),2);
    tempPosDem = w(Z,Elbow)*bAR;
    lambdaNextCandidatesZero2Pos = (tempPosNum./tempPosDem)'; 
    % 2) becomes negative
    tempNegNum = z(Z,Elbow)*tempCommon - sum(z(Z,Left),2);
    tempNegDem = z(Z,Elbow)*bAR;
    lambdaNextCandidatesZero2Neg = (tempNegNum./tempNegDem)';    

    index1 = find(lambdaNextCandidates1<lambda_l - 10e-6);
    index2 = find(lambdaNextCandidates2<lambda_l - 10e-6 );


    if iter == 1
      indexLeft = find(lambdaNextCandidatesLeft<lambda_l- 10e-6);
      indexRight = find(lambdaNextCandidatesRight<lambda_l- 10e-6);   
    else
      indexTemp = [];
      if length(leavingElbowForLeft) >0
	indexTemp = find(Left == leavingElbowForLeft(1))
      end
      indexLeft = setdiff(find(lambdaNextCandidatesLeft<lambda_l- 10e-6),indexTemp);
      indexTemp = [];
      if length(leavingElbowForRight) >0
	indexTemp = find(Right == leavingElbowForRight(1));
      end 
      indexRight = setdiff(find(lambdaNextCandidatesRight<lambda_l- 10e-6),indexTemp);
    end

    indexP2Z = find(lambdaNextCandidatesPos2Zero<lambda_l- 10e-6);
    indexN2Z = find(lambdaNextCandidatesNeg2Zero<lambda_l- 10e-6);

    indexZ2P = find(lambdaNextCandidatesZero2Pos<lambda_l- 10e-6);
    indexZ2N = find(lambdaNextCandidatesZero2Neg<lambda_l- 10e-6);


    lambdaNext = max([lambdaNextCandidates1(index1),lambdaNextCandidates2(index2), lambdaNextCandidatesLeft(indexLeft), lambdaNextCandidatesRight(indexRight),lambdaNextCandidatesPos2Zero(indexP2Z),lambdaNextCandidatesNeg2Zero(indexN2Z),lambdaNextCandidatesZero2Pos(indexZ2P),lambdaNextCandidatesZero2Neg(indexZ2N)]);
    
    % data points sets
    leavingElbowForRight = Elbow(find(abs(lambdaNextCandidates1-lambdaNext)<1.0e-4));
    leavingElbowForLeft = Elbow(find(abs(lambdaNextCandidates2-lambdaNext)<1.0e-4));
    enterFromLeft = Left(find(abs(lambdaNextCandidatesLeft-lambdaNext)<1.0e-4));
    enterFromRight = Right(find(abs(lambdaNextCandidatesRight-lambdaNext)<1.0e-4));

    % parameter index set
    Pos2Zero =  VPlus(find(abs(lambdaNextCandidatesPos2Zero-lambdaNext)<1.0e-4));
    Neg2Zero =  VMinus(find(abs(lambdaNextCandidatesNeg2Zero-lambdaNext)<1.0e-4));
    Zero2Pos =  Z(find(abs(lambdaNextCandidatesZero2Pos-lambdaNext)<1.0e-4));
    Zero2Neg =  Z(find(abs(lambdaNextCandidatesZero2Neg-lambdaNext)<1.0e-4));

    % finding the point where the next event occurs...
    alpha0_l = alpha0_l - (lambda_l - lambdaNext)*bA0;
    alpha_l(Elbow) = alpha_l(Elbow) - (lambda_l - lambdaNext)*bAR;
    beta0_l = alpha0_l/lambdaNext;

    mu_l(VPlus) = rho*(Sigma(VPlus,:)*alpha_l); 
    mu_l(VMinus) = 0;
    nu_l(VMinus) = rho*(Sigma(VMinus,:)*alpha_l); 
    nu_l(VPlus) = 0;

    % make sure nu - mu = sum(alpha*y*x)
    nu_l(Z) = - XY(Z,:)*alpha_l;
    mu_l(Z) = 0;


    NZ = union(VPlus,VMinus);
    beta_l(NZ) = (XY(NZ,:)*alpha_l+nu_l(NZ)-mu_l(NZ))/lambdaNext;
    beta_l(Z) = 0;
    lambda_l = lambdaNext;

    %update the sets
    l = y.*(beta0_l+beta_l'*x);
    r = 1 + rho*(abs(beta_l)'*Sigma);
    diff = l - r;
    Elbow = union(setdiff(find( abs(diff)<=1e-4),union(leavingElbowForLeft,leavingElbowForRight)),find(alpha_l>1e-4 & alpha_l < 1 - 1e-4));
    Left =  union(find( diff < -1e-4),leavingElbowForLeft);
    Right =  union(find( diff > 1e-4),leavingElbowForRight);
    sizeOfElbow = length(Elbow);
  
    VPlus = union(find(beta_l>1e-5),Zero2Pos);
    VMinus = union(find(beta_l<-1e-5),Zero2Neg);
    Z = setdiff(find(abs(beta_l)<=1e-5),union(Zero2Pos,Zero2Neg));

  elseif sizeOfElbow == 0
    % call the routine for find the first event point 
    % as in the init step:    
    beta1Intercept = 0 ;
    [lambda_l,beta0_l,beta_l,alpha_l,nu_l,mu_l] = svmIntervalFindNext0(x,y,rho,Sigma,alpha_l,nu_l,mu_l,iPlus,iMinus); 
    alpha0_l = lambda_l*beta0_l;    
    l = y.*(beta0_l+beta_l'*x);
    r = 1 + rho*(abs(beta_l)'*Sigma);
    diff = l - r;
    Elbow = find( abs(diff)<=1e-4);
    Left =  find( diff < -1e-4);
    Right =  find( diff > 1e-4);
    sizeOfElbow = length(Elbow);
    leavingElbowForRight = [];
    leavingElbowForLeft = [];
  end

  Beta0_l = [Beta0_l,beta0_l];
  Beta_l = [Beta_l,beta_l];
  Alpha_l = [Alpha_l,alpha_l];
  Nu_l = [Nu_l,nu_l];
  Mu_l = [Mu_l,mu_l];
  Lambda_l = [Lambda_l,lambda_l];

end
