function [A,B] = fitting(model,alpha,beta,I,GCA)

maxit = 1000;
m = 199;
sigma = 100;
Eold = rand();
alpha_old = alpha;
beta_old = beta;
% target image
T = imread('Capture.PNG');

disp(size(T));
[x,y,z]=size(I);
T = imresize(T,[x,y]);

for i = 1:maxit
    % compute delE = {sum(Iinp - Imodel)**2}/sigma**2
    E = norm(double(reshape(I,[],1,1)) - double(reshape(T,[],1,1)))^2;
    delE =  (E - Eold)/ sigma;
    delE = delE * delE;
    % update alpha
    if (norm(alpha - alpha_old) > 1e-6 )
        alpha = alpha + lambda(delE./(alpha - alpha_old) + 2*(alpha)./(model.shapeEV));
    else
        alpha = alpha + 2*(alpha)./(model.shapeEV);
    end    
    % update beta
    if (norm(beta - beta_old) > 1e-6)
        beta = beta + lambda(delE./(beta - beta_old) + 2*(beta)./(model.texEV));
    else
        beta = beta + 2*beta./(model.texEV);
    end
    % update render param
    % rp = rp + lambda(d/del + 2*aplha./model.shapeEV);
    % skip since we don't have enough info
    %update Eold and 
    Eold = E;
    % update I using alpha and beta
    %% todo
    I = get_update(model,alpha,beta,GCA);
    if((i > 5) || (norm(alpha-alpha_old)<1e-6 && norm(beta-beta_old)<1e-6))
        break;
    end    
end

A = alpha;
B = beta;