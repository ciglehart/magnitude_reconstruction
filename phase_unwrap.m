function output = phase_unwrap(a)

output = zeros(size(a));

for ii = 1:size(a,3)
   output(:,:,ii) = unwrap_phase(squeeze(a(:,:,ii)));
end

end