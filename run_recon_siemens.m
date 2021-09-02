function run_recon_siemens(slice,lambda,output_file)

K = 4;
TE = 0.00591;
n_iterations = 200;

load(['sampling_masks/masks_acc_6_ne_8_256_256_64.mat']);
load('sens_maps/sens_maps_256_256_64_16.mat');

nE = size(masks,4);

load('temporal_basis/temporal_basis_1e-1ms_2000ms_ETL_8.mat');

[Ny,Nx,Nz,nc] = size(sens);

teIms = single(zeros(Ny,Nx,Nz,nc,nE));
load('te_images/teims_siemens.mat');
teImages = single(im);
clear im;
ksp   = zeros(Ny,Nx,Nz,nc,nE);

smin = min(abs(sens(:)));
smax = max(abs(sens(:)));
sens = (sens - smin)/(smax - smin);

tmin = min(abs(teImages(:)));
tmax = max(abs(teImages(:)));
teImages = (teImages-tmin)/(tmax - tmin);

for ii = 1:nE
	   for jj = 1:nc
        
		      teIms(:,:,:,jj,ii) = teImages(:,:,:,ii).*sens(:,:,:,jj);
        
    end
end

    for kk = 1:Nx
	       for ii = 1:nE
			  for jj = 1:nc
            
				     ksp(:,kk,:,jj,ii)   = fftshift(fft2(squeeze(teIms(:,kk,:,jj,ii))));

            
        end
    end
end

	Phi = bas(:,1:K);

mask = double(masks);
clear masks;

im = zeros(Ny,Nx,Nz,nE);
%t2_star_hat = zeros(Ny,Nx,Nz);

tic;

for x = slice
  k = squeeze(ksp(:,x,:,:,:));
m = squeeze(mask(:,x,:,:));
s = squeeze(sens(:,x,:,:));
disp(['x = ',num2str(x)]);
[im_x,t2_star_hat_x] = t2_star_reconstruction(k,m,s,Phi,n_iterations,K,TE,lambda);
im(:,x,:,:) = im_x;
%t2_star_hat(:,x,:) = t2_star_hat_x;
end

t_total = toc;
disp(['Time: ',num2str(t_total)]);
save(output_file,'im');
%save(['recon_results/t2_star_hat_siemens_acc_',num2str(acc),'_lambda_',num2str(lambda),'_x_100.mat'],'t2_star_hat');

end
