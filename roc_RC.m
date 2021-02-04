function [AUC,FPR,TPR] = roc_RC(x,target,subsample,display)

n = length(x);

P = nnz(target);
N = nnz(1-target);

thresholds=sort(unique(x));
thresholds=[thresholds(1:subsample:end);thresholds(end)];
n=length(thresholds);
tp = nan(1, n);
fp = nan(1, n);
for i=1:n
    t = thresholds(end-i+1);
    Rt = x > t; %
    tp(i) = nnz(Rt & target);
    fp(i) = nnz(Rt & ~target);
end
TPR = tp/P;
FPR = fp/N;

AUC = diff(FPR) * (TPR(1:end-1)+TPR(2:end))'/2;

if AUC <= 0.5
    target=~target;
    P = nnz(target);
    N = nnz(1-target);
    
    thresholds=sort(unique(x));
    thresholds=[thresholds(1:subsample:end);thresholds(end)];
    tp = nan(1, n);
    fp = nan(1, n);
    for i=1:n
        t = thresholds(end-i+1);
        Rt = x > t; %
        tp(i) = nnz(Rt & target);
        fp(i) = nnz(Rt & ~target);
    end
    TPR = tp/P;
    FPR = fp/N;
    
    AUC = diff(FPR) * (TPR(1:end-1)+TPR(2:end))'/2;
end


[YI,c] = max(TPR-FPR);


if display
    figure;
    plot(FPR, TPR) % ROC
    ylabel('Sensitivity (TPR)');
    xlabel('1-Specificity (FPR)');
    title(['AUC ',num2str(AUC)]);
    hold on;
    plot([0 1], [0 1],'--r');
    plot(FPR(c),TPR(c),'ro')
end

 
% cutoff = thresholds(c);
% Rt = x > cutoff;