clear all;
close all;
clc;

load('te_images');
load('brain_mask');
slice = 32;
nE = 8;
echo = 8;
threshold = 0.01;

Psi_adj = @(a) phase_temporal_adjoint(a);
Psi_for = @(a) phase_temporal_forward(a,nE);
U = @(a) phase_unwrap(a);

phase = U(squeeze(angle(im(:,:,slice,:))));
beta = Psi_adj(phase);
phase_model = Psi_for(beta);

err = 1-cos(phase_model-phase);
err(abs(err)>threshold) = threshold;

figure;
img = zeros(256,2048);

for i = 1:nE
    img(:,((i-1)*256 + 1):256*i) = rot90(mask.*err(:,:,echo));
end

imagesc(img);
axis equal;
%axis tight;
axis off;