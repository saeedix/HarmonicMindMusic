# ADHD FOCUS — Track Development Guide

This README documents the advanced sonic and code structure of the ADHD FOCUS music track, engineered for maximum sustained attention and clarity, especially for those with ADHD and deep work needs.

## Overview
ADHD FOCUS is a scientifically constrained generative track where all musical randomization is removed—resulting in fully deterministic, predictable evolution and rhythmic/melodic stability. The algorithm is built for one hour (135 BPM, 8100 beats), fusing sustained ambient layers, steady pulse, deterministic arpeggios, fixed harmonic changes, and continuous sound-masking for optimal cognitive support.

## Video
[Watch the ADHD FOCUS Track Video](https://youtu.be/bTexskyh5SQ?si=LtgxafgXeAJ_qT9P)

## Development Steps
1. **Global Clock & Evolution**:
   - Uses a slow sine function to drive `:focus_level` (0–1) across a 60-minute cycle.
   - All layer parameters, filter cutoffs, and amplitudes are modulated only by this slow-evolving value.
2. **Steady Rhythmic Anchor**:
   - Four-on-the-floor 135 BPM kick and snare drive; no breaks or fills for maximum consistency.
   - Hi-hats provide constant 1/8-note mask.
3. **Predictive Arpeggios (No Randomness)**:
   - Deterministic, repeating scale and transposition patterns (rings) for both high and bass arps.
   - Predictable panning and dynamics based on `:focus_level`.
4. **Continuous Ambient & Bass Masking**:
   - Ambient `:prophet` pads play slow minor7 chords, modulated by the focus level.
   - Sub-melodic anchor layer (deep `:dsaw`) changes only every 8 bars for stability.
   - Masking noise (filtered) is continuous and low-pass shaped.
5. **No Random Functions**:
   - There is zero use of `rrand` or `choose`. All code is mathematically or ring-driven for 100% predictability.
6. **Session/Learning Friendly**:
   - Long sound cycles, ultra-slow timbral changes, and full rhythmic predictability make it ideal for extended sessions.
7. **Mix & Mastering**:
   - Amplitudes, spatial effects, and filter ranges programmed for maximum headroom and non-fatiguing background use.

## Contribution
- Fork, branch, and submit focused pull requests for deterministic improvements only.
- Please explain any structure or sound-design modification in your PR.

## License
This project is licensed under the main repository license.