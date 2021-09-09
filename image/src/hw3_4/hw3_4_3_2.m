clear all; close all; clc;
img_org = imread('testimg/eesast.bmp');

enable1 = false;
enable2 = false;
enable3 = true;

if enable1
    figure(1);
    strike = [3, 3];
    test_size = [8, 8];
    Ks = [0.58; 0.68; 0.78]

    L = 3;
    properties = get_all_properties(L);

    img = img_org;
    img = check_face(img, properties, L, Ks(1), strike, test_size);
    subplot(3, 3, 1);
    imshow(img);
    title("k=" + Ks(1));
    ylabel('L=3');

    img = img_org;
    img = check_face(img, properties, L, Ks(2), strike, test_size);
    subplot(3, 3, 2);
    imshow(img);
    title("k=" + Ks(2));

    img = img_org;
    img = check_face(img, properties, L, Ks(3), strike, test_size);
    subplot(3, 3, 3);
    imshow(img);
    title("k=" + Ks(3));

    L = 4;
    properties = get_all_properties(L);

    img = img_org;
    img = check_face(img, properties, L, Ks(1), strike, test_size);
    subplot(3, 3, 4);
    imshow(img);
    ylabel('L=4');

    img = img_org;
    img = check_face(img, properties, L, Ks(2), strike, test_size);
    subplot(3, 3, 5);
    imshow(img);

    img = img_org;
    img = check_face(img, properties, L, Ks(3), strike, test_size);
    subplot(3, 3, 6);
    imshow(img);

    L = 5;
    properties = get_all_properties(L);

    img = img_org;
    img = check_face(img, properties, L, Ks(1), strike, test_size);
    subplot(3, 3, 7);
    imshow(img);
    ylabel('L=5');

    img = img_org;
    img = check_face(img, properties, L, Ks(2), strike, test_size);
    subplot(3, 3, 8);
    imshow(img);

    img = img_org;
    img = check_face(img, properties, L, Ks(3), strike, test_size);
    subplot(3, 3, 9);
    imshow(img);
    
end

if enable2
    figure(2);
    L = 4;
    properties = get_all_properties(L);
    img = img_org;
    img = check_face(img, properties, L, 0.685, [2, 4], [10, 8]);
    imshow(img);
end

if enable3
    figure(3);
    L = 4;
    properties = get_all_properties(L);
    img = imread('testimg/gls.bmp');
    img = check_face(img, properties, L, 0.7, [20, 20], [50, 50]);
    imshow(img);
end
