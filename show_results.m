r = run_recon_siemens();

load('/Users/charlesiglehart/Desktop/phase_cycling_reconstruction/te_images.mat');
im = squeeze(im(:,:,32,:));

img_m = zeros(256,256*4);
img_mr = zeros(256,256*4);
img_p = zeros(256,256*4);
img_pr = zeros(256,256*4);

k = 4;

img_m(1:256,1:256) = rot90(squeeze(abs(im(:,:,1+k))));
img_m(1:256,257:512) = rot90(squeeze(abs(im(:,:,2+k))));
img_m(1:256,513:768) = rot90(squeeze(abs(im(:,:,3+k))));
img_m(1:256,769:1024) = rot90(squeeze(abs(im(:,:,4+k))));

img_mr(1:256,1:256) = rot90(squeeze(abs(r(:,:,1+k))));
img_mr(1:256,257:512) = rot90(squeeze(abs(r(:,:,2+k))));
img_mr(1:256,513:768) = rot90(squeeze(abs(r(:,:,3+k))));
img_mr(1:256,769:1024) = rot90(squeeze(abs(r(:,:,4+k))));

img_p(1:256,1:256) = rot90(squeeze(angle(im(:,:,1+k))));
img_p(1:256,257:512) = rot90(squeeze(angle(im(:,:,2+k))));
img_p(1:256,513:768) = rot90(squeeze(angle(im(:,:,3+k))));
img_p(1:256,769:1024) = rot90(squeeze(angle(im(:,:,4+k))));

img_pr(1:256,1:256) = rot90(squeeze(angle(r(:,:,1+k))));
img_pr(1:256,257:512) = rot90(squeeze(angle(r(:,:,2+k))));
img_pr(1:256,513:768) = rot90(squeeze(angle(r(:,:,3+k))));
img_pr(1:256,769:1024) = rot90(squeeze(angle(r(:,:,4+k))));

imagesc(img_m);
axis equal;
axis off;
axis tight;
colormap(gray);

figure;
imagesc(img_mr);
axis equal;
axis off;
axis tight;
colormap(gray);

figure;
imagesc(img_p);
axis equal;
axis off;
axis tight;
colormap(gray);

figure;
imagesc(img_pr);
axis equal;
axis off;
axis tight;
colormap(gray);