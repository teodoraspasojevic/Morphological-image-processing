%% Domaci zadatak br. 2

clear;
close all;
clc;

%% Ucitavanje i prikaz slike

img = imread('slika 216.jpg');

figure, imshow(img), title('Pocetna slika')

%% Segmentacija slike koriscenjem proizvoljnog praga sjajnosti

figure, imhist(img), title('Histogram sjajnosti pocetne slike')

T = 125;
img_bin = img >= T;
figure, imshow(img_bin), title('Binarizaovana slika')
imwrite(img_bin, 'Binarizovana slika.jpg');

%% Razdvajanje spojenih objekata

img_bin_neg = imcomplement(img_bin);
figure, imshow(img_bin_neg), title('Negativ binarizovane slike')

se = strel('disk', 10);
img_separated_beans_neg = imerode(img_bin_neg, se);
figure, imshow(img_separated_beans_neg), title('Slika posle erozije')

se = strel('disk', 8);
img_separated_beans_neg = imdilate(img_separated_beans_neg, se);
figure, imshow(img_separated_beans_neg), title('Slika posle erozije i dilatacije')

img_separated_beans = imcomplement(img_separated_beans_neg);
figure, imshow(img_separated_beans), title('Slika sa razdvojenim zrnima')
imwrite(img_separated_beans, 'Slika sa razdvojenim zrnima.jpg');


%% Uklanjanje ivicnih objekata iz slike

img_no_border_beans_neg = imclearborder(img_separated_beans_neg);
img_no_border_beans = imcomplement(img_no_border_beans_neg);
figure, imshow(img_no_border_beans), title('Slika bez ivicnih zrna')
imwrite(img_no_border_beans, 'Slika bez ivicnih zrna.jpg');


img_final_neg = img_no_border_beans_neg;
img_final = img_no_border_beans;

%% Racunanje srednje vrednosti povrsine zrna

[L, num] = bwlabel(img_final_neg);

total_surface = 0;

for k=1:num
    
    current_surface = 0;
    object = find(L == k);
    curr_surface = length(object);
    text = ['Povrsina ', num2str(k), '. oblika je ', num2str(curr_surface), ' piksela.'];
    disp(text);
    total_surface = total_surface + curr_surface;
    
end

total_surface = total_surface/num;
text = ['Prosecna povrsina oblika je ', num2str(total_surface), ' piksela.'];
disp(text);
%% Izdvajanje natprosecno velikih zrna

se = strel('disk', 13);

img_find_biggest_beans = imerode(img_final_neg, se);
figure, imshow(img_find_biggest_beans), title('Pozicije najvecih zrna')

img_biggest_beans_neg = imreconstruct(img_find_biggest_beans, img_final_neg);
img_biggest_beans = imcomplement(img_biggest_beans_neg);
figure, imshow(img_biggest_beans), title('Slika sa najvecim zrnima')
imwrite(img_biggest_beans, 'Slika sa najvecim zrnima.jpg');
%% Nalazenje i crtanje centroida zrna

figure, imshow(img_final);
hold on

[L, num] = bwlabel(img_final_neg);

for k=1:num
   
    [r, c] = find(L == k);
    rbar = mean(r);
    cbar = mean(c);
    plot(cbar, rbar, 'Marker', 'o', 'MarkerEdgeColor', 'w', ...
        'MarkerFaceColor', 'w', 'MarkerSize', 10)
    plot(cbar, rbar, 'Marker', '*', 'MarkerEdgeColor', 'k')
    
end

title('Slika zrna sa pozicijama njihovih centroida')
hold off
