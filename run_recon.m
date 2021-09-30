clear all;
close all;
clc;

im = run_recon_siemens(0.001,10,'mask_acc_1','recon_lambda_1e-3_acc_1.mat');
im = run_recon_siemens(0.001,10,'mask_acc_2','recon_lambda_1e-3_acc_2.mat');
im = run_recon_siemens(0.001,10,'mask_acc_4','recon_lambda_1e-3_acc_4.mat');
im = run_recon_siemens(0.001,10,'mask_acc_6','recon_lambda_1e-3_acc_6.mat');
im = run_recon_siemens(0.001,10,'mask_acc_8','recon_lambda_1e-3_acc_8.mat');
