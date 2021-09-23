function [im] = t2_star_reconstruction(ksp,mask,sens1,Phi,n_iterations,K,TE,lambda)

addpath('/Users/charlesiglehart/Desktop/phase_cycling_reconstruction/te_images.mat');

[ny, nz, nc, nE] = size(ksp);

% permute mask
masks = permute(mask, [1 2 4 3]);

% normalize sensitivities
sens1_mag = reshape(vecnorm(reshape(sens1, [], nc).'), [ny, nz]);
sens = bsxfun(@rdivide, sens1, sens1_mag);
sens(isnan(sens)) = 0;

%% operators

% ESPIRiT maps operator applied to coefficient images
S_for = @(a) bsxfun(@times, sens, permute(a, [1, 2, 4, 3]));
S_adj = @(as) squeeze(sum(bsxfun(@times, conj(sens), as), 3));
SHS = @(a) S_adj(S_for(a));

% Temporal projection operator
T_for = @(a) temporal_forward(a, Phi);
T_adj = @(x) temporal_adjoint(x, Phi);

% Fourier transform
F_for = @(x) fft2c(x);
F_adj = @(y) ifft2c(y);

% Sampling mask
P_for = @(y) bsxfun(@times, y, masks);
%ksp = P_for(ksp);

%Apply sampling mask
ksp = P_for(ksp);

% Full forward model
A_for = @(a) P_for(T_for(F_for(S_for(a))));
A_adj = @(y) S_adj(F_adj(T_adj(P_for(y))));
AHA = @(a) S_adj(F_adj(T_adj(P_for(T_for(F_for(S_for(a))))))); % slightly faster

% Phase forward model
K_adj = @(a) phase_temporal_forward(a,nE);

%Phase unwrap operator 
U_adj = @(a) phase_unwrap(a);

%% scaling
tmp = dimnorm(ifft2c(bsxfun(@times, ksp, masks)), 3);
tmpnorm = dimnorm(tmp, 4);
tmpnorm2 = sort(tmpnorm(:), 'ascend');
% match convention used in BART
p100 = tmpnorm2(end);
p90 = tmpnorm2(round(.9 * length(tmpnorm2)));
p50 = tmpnorm2(round(.5 * length(tmpnorm2)));
if (p100 - p90) < 2 * (p90 - p50)
    scaling = p90;
else
    scaling = p100;
end

fprintf('\nScaling: %f\n\n', scaling);

ksp = ksp ./ scaling;
ksp_adj = A_adj(ksp);

%Unwrapped phase
Theta = U_adj(angle(S_adj(F_adj(P_for(ksp)))));

%% ADMM

iter_ops.max_iter = n_iterations;
iter_ops.rho = 0.5;
%iter_ops.objfun = @(a, sv, lam) 0.5*norm_mat(ksp - A_for(a))^2 + lam*sum(sv(:));
iter_ops.objfun = @(a, sv, lam) 0.5*norm_mat(Theta - K_adj(a))^2 + lam*sum(sv(:));

llr_ops.lambda = lambda;
llr_ops.block_dim = [8,2];

lsqr_ops.max_iter = 10;
lsqr_ops.tol = 1e-4;

alpha_ref = RefValue;
%alpha_ref.data = zeros(ny, nz, K);
alpha_ref.data = zeros(ny, nz, nE);

%history = iter_admm(alpha_ref, iter_ops, llr_ops, lsqr_ops, AHA, ksp_adj, @admm_callback);
history = iter_admm(alpha_ref, iter_ops, llr_ops, lsqr_ops, K_adj, Theta, @admm_callback);

disp(' ');

%% Project and re-scale
alpha = alpha_ref.data;
im = T_for(alpha);

disp('Rescaling...')
im = im * scaling;

end
