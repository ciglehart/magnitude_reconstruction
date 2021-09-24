function im = run_recon_siemens()

addpath('/home/iglehartc/Desktop/algorithm/t2shuffling-support/src/utils');

lambda = 0.001;
K = 4;
TE = 0.00591;
n_iterations = 20;
Ny = 256;
Nx = 256;
nc = 8;
nE = 8;
slice = 32;
nw = 16;

maps = [];
im = [];
mask = [];
bas = [];

addpath('/Users/charlesiglehart/Desktop/t2shuffling-support/src/utils');
load('../phase_reconstruction/mask_acc_8.mat');
load('../phase_reconstruction/sens_maps_256_256_8.mat');
load('temporal_basis_1e-1ms_2000ms_ETL_8.mat');
load('/home/iglehartc/Desktop/data/te_images.mat');

teIms = single(zeros(Ny,Nx,nc,nE));
teImages = single(im);
teImages = squeeze(teImages(:,:,slice,:));
clear im;

k = zeros(Ny,Nx,nc,nE);
m = mask;
s = maps;

smin = min(abs(maps(:)));
smax = max(abs(maps(:)));
maps = (maps - smin)/(smax - smin);

tmin = min(abs(teImages(:)));
tmax = max(abs(teImages(:)));
teImages = (teImages-tmin)/(tmax - tmin);

for ii = 1:nE
    for jj = 1:nc
        
        teIms(:,:,jj,ii) = teImages(:,:,ii).*maps(:,:,jj);
        k(:,:,jj,ii) = fft2c(squeeze(teIms(:,:,jj,ii)));
    end
end

Phi = bas(:,1:K);

im = t2_star_reconstruction(k,m,s,Phi,n_iterations,K,TE,lambda);

end
