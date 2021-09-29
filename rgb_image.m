function rgb = rgb_image(img,mask,cmap,null_color)

rgb = zeros(1,1,3);
rgb(1,1,:) = null_color;
rgb = repmat(rgb,size(img,1),size(img,2));
ind = find(mask>0);
vals = img(ind);
N = size(cmap,1);
m = (N-1)/(max(vals(:) - min(vals(:))));
b = 1 - m*min(vals(:));

for ii = 1:size(img,1)
    for jj = 1:size(img,2)
        if mask(ii,jj)>0
            rgb(ii,jj,:) = cmap(round(m*img(ii,jj)+b),:);
        end
    end
end

end