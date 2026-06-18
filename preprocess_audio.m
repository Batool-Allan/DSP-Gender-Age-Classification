function [y_processed, fs] = preprocess_audio(filename)
    % Read audio file
    [y, fs] = audioread(filename);
    
    % Convert stereo to mono
    if size(y, 2) == 2
        y = mean(y, 2);
    end
    
    % Normalize amplitude
    y = y / max(abs(y));
    
    % Remove silence
    frame_len = round(0.025 * fs);
    energy = buffer(y.^2, frame_len);
    mean_energy = mean(energy);
    threshold = 0.01 * max(mean_energy);
    
    voiced_frames = mean_energy > threshold;
    y_processed = [];
    
    for i = 1:length(voiced_frames)
        if voiced_frames(i)
            start_idx = (i-1)*frame_len + 1;
            end_idx = min(i*frame_len, length(y));
            y_processed = [y_processed; y(start_idx:end_idx)];
        end
    end
    
    if length(y_processed) < 0.3 * length(y)
        y_processed = y;
    end
end
