function im = run_recon_siemens()

lambda = 0.01;
K = 4;
TE = 0.00591;
n_iterations = 10;
Ny = 256;
Nx = 256;
nc = 8;
nE = 8;
slice = 32;

maps = [];
im = [];
mask = [];
bas = [];

load('../phase_reconstruction/mask_acc_4.mat');
load('../phase_reconstruction/sens_maps_256_256_8.mat');
load('temporal_basis_1e-1ms_2000ms_ETL_8.mat');
load('../../data/te_images.mat');

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
        
    end
end

for ii = 1:nE
    for jj = 1:nc
        
        coil_im = squeeze(teIms(:,:,jj,ii));
        k(:,:,jj,ii) = fft2c(coil_im);
        
    end
end

Phi = bas(:,1:K);

im = t2_star_reconstruction(k,m,s,Phi,n_iterations,K,TE,lambda);

end
