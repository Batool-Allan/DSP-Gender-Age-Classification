function [gender, age] = classify_gender_age(features)
    % GENDER CLASSIFICATION
    if features.pitch > 180
        gender = 'Female';
    else
        gender = 'Male';
    end
    
    % AGE CLASSIFICATION
    if features.pitch > 250
        age = 'Child';
    elseif features.spectral_centroid > 1200
        age = 'Adult';
    else
        age = 'Elderly';
    end
end
