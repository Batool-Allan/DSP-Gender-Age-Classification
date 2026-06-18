# DSP-Based Gender and Age Classification from Audio Signals

## Project Description
This project implements a Digital Signal Processing (DSP) system to classify speaker **gender** (Male/Female) and **age** (Child/Adult/Elderly) from audio recordings using rule-based classification.

## Features Extracted
| Feature | Method | Purpose |
|---------|--------|---------|
| Pitch | Autocorrelation | Gender classification |
| Spectral Centroid | FFT magnitude | Age classification |
| Zero-Crossing Rate | Time-domain | Voice noisiness |
| Signal Energy | Mean squared | Voice intensity |
| Formant Frequencies | Spectral peaks | Voice quality |

## Classification Rules
