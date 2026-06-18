function features = extract_features(y, fs)
    % FEATURE 1: Energy
    features.energy = mean(y.^2);
    
    % FEATURE 2: Zero-Crossing Rate
    features.zcr = sum(abs(diff(sign(y)))) / (2 * length(y));
    
    % FEATURE 3: Pitch (Fundamental Frequency)
    r = xcorr(y);
    r = r(length(y):end);
    [peaks, locs] = findpeaks(r(round(0.002*fs):end));
    if ~isempty(peaks)
        [~, idx] = max(peaks);
        period = locs(idx) + round(0.002*fs) - 1;
        features.pitch = fs / period;
    else
        features.pitch = 0;
    end
    
    % FEATURE 4: Spectral Centroid
    N = length(y);
    Y = abs(fft(y));
    Y = Y(1:floor(N/2));
    f = (0:length(Y)-1)' * fs / N;
    features.spectral_centroid = sum(f .* Y) / sum(Y);
    
    % FEATURE 5: Formants (F1, F2)
    [peaks, locs] = findpeaks(Y, 'SortStr', 'descend', 'NPeaks', 3);
    f_vals = f(locs);
    if length(f_vals) >= 2
        features.F1 = f_vals(1);
        features.F2 = f_vals(2);
    else
        features.F1 = 0;
        features.F2 = 0;
    end
end
