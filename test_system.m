% TEST SYSTEM - Run this script to test your classifier
clear; clc;

% Get all wav files in current folder
files = dir('*.wav');

if isempty(files)
    fprintf('No .wav files found!\n');
    fprintf('Please put some .wav files in this folder.\n');
    return;
end

fprintf('========== DSP GENDER/AGE CLASSIFIER ==========\n\n');

for i = 1:min(length(files), 10) % Test up to 10 files
    % Process file
    [y, fs] = preprocess_audio(files(i).name);
    features = extract_features(y, fs);
    [gender, age] = classify_gender_age(features);
    
    % Display results
    fprintf('File %d: %s\n', i, files(i).name);
    fprintf('  Pitch: %.1f Hz\n', features.pitch);
    fprintf('  Spectral Centroid: %.1f Hz\n', features.spectral_centroid);
    fprintf('  Energy: %.4f\n', features.energy);
    fprintf('  ZCR: %.4f\n', features.zcr);
    fprintf('  Predicted: %s, %s\n\n', gender, age);
end

fprintf('========== TEST COMPLETE ==========\n');
