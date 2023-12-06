%imagePath = '/MATLAB Drive/laptop-backgrounds-nature-images-1920x1200-wallpaper-preview.jpg';
imagePath = fullfile('MATLAB Drive', 'laptop-backgrounds-nature-images-1920x1200-wallpaper-preview.jpg');
watermarkSize = 8; % Adjust the size as needed
blockBasedFragileWatermarking(imagePath, watermarkSize);
function blockBasedFragileWatermarking(imagePath, watermarkSize)
    % Read the image
    originalImage = imread(imagePath);

    % Convert the image to grayscale
    grayscaleImage = rgb2gray(originalImage);

    % Get image dimensions
    [rows, cols] = size(grayscaleImage);

    % Set block size
    blockSize = watermarkSize;

    % Generate a random watermark pattern
    %watermarkPattern = randi([0 1], watermarkSize, watermarkSize);
    watermarkPattern = uint8(randi([0 1], watermarkSize, watermarkSize));
    % Embed the watermark into each block using XOR
    %watermarkedImage = grayscaleImage;
    %for y = 1:blockSize:rows
        %for x = 1:blockSize:cols
            %block = grayscaleImage(y:y+blockSize-1, x:x+blockSize-1);
            %watermarkBlock = bitxor(block, watermarkPattern);
            %watermarkedImage(y:y+blockSize-1, x:x+blockSize-1) = watermarkBlock;
        %end
    %end

    % Embed the watermark into each block using XOR
    watermarkedImage = grayscaleImage;
    for y = 1:blockSize:rows
        for x = 1:blockSize:cols
            % Ensure that the block indices do not exceed image dimensions
            endRow = min(y+blockSize-1, rows);
            endCol = min(x+blockSize-1, cols);
            block = grayscaleImage(y:endRow, x:endCol);

            % Perform the XOR operation with watermarkPattern
            watermarkBlock = bitxor(block, watermarkPattern(1:endRow-y+1, 1:endCol-x+1));

            % Update the watermarkedImage with the XOR result
            watermarkedImage(y:endRow, x:endCol) = watermarkBlock;
        end
    end


    % Convert watermarkPattern to the same data type as block

   
    % Calculate and store checksum for each block
    %checksumRows = floor(rows/blockSize);
    %checksumCols = floor(cols/blockSize);
    %checksums = zeros(checksumRows, checksumCols);
    %for y = 1:blockSize:rows
        %for x = 1:blockSize:cols
            %block = watermarkedImage(y:y+blockSize-1, x:x+blockSize-1);
            %checksums((y-1)/blockSize+1, (x-1)/blockSize+1) = sum(block, 'all');
        %end
    %end
    % Calculate dimensions for the checksums matrix
checksumRows = floor(rows/blockSize);
checksumCols = floor(cols/blockSize);

% Initialize the checksums matrix
checksums = zeros(checksumRows, checksumCols);

% Iterate over blocks and calculate checksums
for y = 1:blockSize:rows
    for x = 1:blockSize:cols
        % Ensure that the block indices do not exceed image dimensions
        endRow = min(y+blockSize-1, rows);
        endCol = min(x+blockSize-1, cols);
        
        % Access the block from watermarkedImage
        block = watermarkedImage(y:endRow, x:endCol);
        
        % Calculate the checksum and update the matrix
        checksums((y-1)/blockSize+1, (x-1)/blockSize+1) = sum(block, 'all');
    end
end

    % Save the watermarked image
    %imwrite(watermarkedImage, 'watermarked_image.png');
    imwrite(watermarkedImage, '/MATLAB Drive/watermarkedImage.jpg');
    % Save the checksums for later verification
    save('checksums.mat', 'checksums');
end



