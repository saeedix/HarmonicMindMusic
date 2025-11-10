# Festival Ultra Progressive — Track Development Guide

This README describes how the Festival Ultra Progressive track is structured and how to develop/extend it.

## Overview
A high-energy progressive festival track at 126 BPM with three drops, bridges, fills, layered bass, chords, pads, and DJ-style transition FX. The arrangement uses a bar-synced clock and a dynamic energy curve to drive timbre and intensity across sections.

## Video
[Watch the Festival Ultra Progressive Track Video](VIDEO_LINK)

## Development Steps
1. **Tempo & Sync**: Set `use_bpm 126`. Use a `:clock` live_loop to cue `:bar` and increment `:bar_count` for deterministic sync.
2. **Arrangement & Energy**:
   - Define bar lengths: `intro_bars`, `build_bars`, `bridge_bars`, `drop_bars`, `fill_bars`, `second_drop`, `third_drop`, `outro_bars`.
   - Implement `energy_level(bar)` to return a smooth energy factor over time.
   - Map energy to tone using `cutoff_from_energy(energy)`.
3. **Drums**:
   - **Kick (`:kick`)**: Four-on-the-floor with amp scaled by energy.
   - **Hats (`:hats`)**: Closed hats on 8ths; optionally add open hat at higher energy.
   - **Snare/Clap (`:snare`)**: Backbeat hits with energy-scaled amplitude.
4. **Bassline (`:bass`)**:
   - Use `:tb303` synth with a programmed note/rhythm ring.
   - Drive cutoff by energy with subtle randomization; add `:slicer` and `:flanger` layers for motion.
5. **Chords (`:chords`)**:
   - `:prophet` synth with a rotating chord progression.
   - Use `:slicer`, `:reverb`, and `:echo`; vary phase/probability and cutoff with energy.
6. **Bridge & Fill (`:bridge_fill`)**:
   - Bridge: simple sine melody during bridge bars.
   - Fills: short FM stabs between drops with quick timing and stereo movement.
7. **Pads (`:pad`)**:
   - Layered `:blade` pads with long sustain and evolving amp/cutoff tied to energy.
   - Secondary pad chord adds depth with contrasting pan/cutoff.
8. **DJ Transitions (`:dj_transition`)**:
   - Periodic sweeps using `:mod_sine` and filtered noise; gated to specific bar windows in the cycle.
9. **Outro (`:outro`)**:
   - Soft splash and echo events after the final drop section for a gentle fade.
10. **Mix & Master**: Balance amp across layers, keep headroom, and fine-tune FX mix/phase/decay for clarity at high energy.

## Contribution
- Fork the repository and create a feature branch per change.
- Describe arrangement or sound-design tweaks in your PR.

## License
This project follows the main repository license.