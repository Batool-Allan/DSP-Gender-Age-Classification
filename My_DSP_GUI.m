function My_DSP_GUI()
    % Create figure
    fig = figure('Name', 'DSP Gender/Age Classifier', ...
                 'Position', [100 100 800 600], ...
                 'NumberTitle', 'off');
    
    % Title
    uicontrol('Style', 'text', ...
              'Position', [100 550 600 30], ...
              'String', 'DSP-Based Gender and Age Classification', ...
              'FontSize', 16, 'FontWeight', 'bold');
    
    % Upload button
    uicontrol('Style', 'pushbutton', ...
              'Position', [50 500 120 30], ...
              'String', 'Upload Audio', ...
              'Callback', @upload_callback);
    
    % File label
    file_label = uicontrol('Style', 'text', ...
                           'Position', [200 500 400 30], ...
                           'String', 'No file selected', ...
                           'BackgroundColor', [0.9 0.9 0.9]);
    
    % Axes
    ax1 = axes('Position', [0.1 0.35 0.35 0.15]);
    title('Waveform'); grid on;
    
    ax2 = axes('Position', [0.55 0.35 0.35 0.15]);
    title('Spectrogram');
    
    % Features display
    uicontrol('Style', 'text', 'Position', [50 300 200 20], ...
              'String', 'Features:', 'FontWeight', 'bold');
    
    pitch_text = uicontrol('Style', 'text', 'Position', [50 270 200 20], ...
                           'String', 'Pitch: -- Hz');
    
    centroid_text = uicontrol('Style', 'text', 'Position', [50 240 200 20], ...
                              'String', 'Centroid: -- Hz');
    
    energy_text = uicontrol('Style', 'text', 'Position', [50 210 200 20], ...
                            'String', 'Energy: --');
    
    % Results
    uicontrol('Style', 'text', 'Position', [400 300 200 20], ...
              'String', 'Results:', 'FontWeight', 'bold');
    
    gender_text = uicontrol('Style', 'text', 'Position', [400 270 200 20], ...
                            'String', 'Gender: --', 'FontSize', 14);
    
    age_text = uicontrol('Style', 'text', 'Position', [400 240 200 20], ...
                         'String', 'Age: --', 'FontSize', 14);
    
    % Classify button
    uicontrol('Style', 'pushbutton', ...
              'Position', [300 100 150 40], ...
              'String', 'Classify', ...
              'FontSize', 12, 'FontWeight', 'bold', ...
              'Callback', @classify_callback);
    
    % Reset button
    uicontrol('Style', 'pushbutton', ...
              'Position', [460 100 100 40], ...
              'String', 'Reset', ...
              'FontSize', 12, ...
              'Callback', @reset_callback);
    
    % Variables
    audio_data = [];
    fs = 16000;
    
    % Callback functions
    function upload_callback(~, ~)
        [file, path] = uigetfile('*.wav');
        if isequal(file, 0)
            return;
        end
        
        [audio_data, fs] = audioread(fullfile(path, file));
        if size(audio_data, 2) == 2
            audio_data = mean(audio_data, 2);
        end
        audio_data = audio_data / max(abs(audio_data));
        
        set(file_label, 'String', ['File: ', file]);
        
        plot(ax1, audio_data);
        spectrogram(audio_data, 256, 250, 256, fs, 'yaxis', 'Parent', ax2);
    end
    
    function classify_callback(~, ~)
        if isempty(audio_data)
            msgbox('Upload a file first!', 'Error', 'error');
            return;
        end
        
        features = extract_features(audio_data, fs);
        
        set(pitch_text, 'String', sprintf('Pitch: %.1f Hz', features.pitch));
        set(centroid_text, 'String', sprintf('Centroid: %.1f Hz', features.spectral_centroid));
        set(energy_text, 'String', sprintf('Energy: %.4f', features.energy));
        
        [gender, age] = classify_gender_age(features);
        
        set(gender_text, 'String', ['Gender: ', gender]);
        set(age_text, 'String', ['Age: ', age]);
        
        msgbox(sprintf('Rules applied:\nPitch=%.1fHz → %s\nCentroid=%.1fHz → %s', ...
                       features.pitch, gender, features.spectral_centroid, age), ...
               'Classification', 'help');
    end
    
    function reset_callback(~, ~)
        audio_data = [];
        cla(ax1);
        cla(ax2);
        set(file_label, 'String', 'No file selected');
        set(pitch_text, 'String', 'Pitch: -- Hz');
        set(centroid_text, 'String', 'Centroid: -- Hz');
        set(energy_text, 'String', 'Energy: --');
        set(gender_text, 'String', 'Gender: --');
        set(age_text, 'String', 'Age: --');
    end
end
