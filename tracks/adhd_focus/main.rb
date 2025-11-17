# ==============================================================================
# 🧠 ALGORITHMIC MUSIC LAB // ADHD PREDICTIVE FOCUS GRID (MAX STABILITY)
# ==============================================================================
#
# ARTIST/CHANNEL: Algorithmic Music Lab (@AlgorithmicMusicLab)
# PURPOSE: MAXIMIZE SUSTAINED ATTENTION (Engineered for ADHD & Deep Work)
#
# CODE FEATURES (Scientific Constraints Applied):
# - Total Determinism: All randomization (rrand, choose) has been removed.
# - Rhythmic Anchor: Fixed 4/4 Pulse (135 BPM) for grounding.
# - Structured Masking: Continuous Ambient and Noise Layers.
# - Ultra-Slow Evolution: Single sine-wave factor controls all non-rhythmic layers over 60 minutes.
# 
# ------------------------------------------------------------------------------
# 💻 Generative Code: Study the structure, tweak the synths, and run your own mix!
# ⚡ Subscribe & Find Scripts on GitHub!
# ==============================================================================

# Global Parameters
use_bpm 135
set_volume! 1.0 
set :bar_counter, 0
total_evolution_beats = 60 * 135 # 8100 beats for a 60-minute cycle (1 hour)

# ----------------------------------------------------------------------
# 1. Global Clock and Evolution Mechanism (Continuous Slow Ramp)
# ----------------------------------------------------------------------
# This loop calculates the focus_level (0.0 to 1.0) for slow, 1-hour modulation.

live_loop :global_clock do
  cue :bar_start
  
  set :bar_counter, (get(:bar_counter) + 1) % total_evolution_beats
  current_beat = get(:bar_counter)
  
  # Evolution Mechanism: Uses a slow sine wave for smooth, non-distracting modulation
  focus_level = 0.5 + 0.5 * Math.sin(current_beat * (2 * Math::PI / total_evolution_beats))
  set :focus_level, focus_level
  
  sleep 1 # Executes every beat
end

# ----------------------------------------------------------------------
# 2. Rhythmic Anchor (Stability Constraint)
# ----------------------------------------------------------------------
# Fixed, unchanging pulse. Bass boosted for sound immersion.

live_loop :rhythmic_anchor, sync: :bar_start do
  focus = get(:focus_level)
  
  # Kick on beats 1 and 3 (4/4 pulse) - BASS BOOSTED
  sample :bd_haus, amp: 2.5 + (focus * 0.5), cutoff: 100 # Max Amp 3.0
  sleep 1
  
  # Snare on beats 2 and 4 (Mid-Range Driver)
  sample :sn_dolf, amp: 0.8 + (focus * 0.1)
  sleep 1
  
  # Kick again - BASS BOOSTED
  sample :bd_haus, amp: 2.5 + (focus * 0.5), cutoff: 100 # Max Amp 3.0
  sleep 1
  
  # Snare again
  sample :sn_dolf, amp: 0.8 + (focus * 0.1)
  sleep 1
end

live_loop :hi_hat_driver, sync: :bar_start do
  # Fixed 1/8 rhythm for constant background energy (Masking)
  8.times do
    sample :drum_cymbal_closed, amp: 0.35, release: 0.05
    sleep 0.5
  end
end

# ----------------------------------------------------------------------
# 3. Predictive Arp Layers (Auditory Masking - Fixed Patterns)
# ----------------------------------------------------------------------

scale_pattern = scale :c3, :minor_pentatonic, num_octaves: 3
# Fixed transposition pattern - repeats every 16 bars (64 beats)
transposition_pattern = (ring 0, 5, 0, 7, 12, 5, 7, 0, 12, 7, 5, 0, 7, 5, 12, 0) 

live_loop :arp_1_high, sync: :bar_start do
  # Predictive_Arp_1 (High-Frequency Engagement)
  use_synth :fm
  
  focus = get(:focus_level)
  cutoff_mod = 85 + (focus * 45) # Range 85 to 130
  
  # Set the fixed, repeating transpose for 16 beats (4 bars)
  current_transpose = transposition_pattern.tick
  
  # Deterministic Panning: Slow, predictable LFO based on focus level
  # This replaces 'rrand' for stability.
  pan_val = 0.2 * Math.sin(focus * Math::PI)
  
  with_transpose current_transpose do 
    16.times do # 16 times * 0.25 sleep = 4 beats (1 bar)
      play scale_pattern.look, 
           release: 0.1, 
           amp: 0.7, 
           cutoff: cutoff_mod,
           pan: pan_val # Deterministic Pan
      sleep 0.25 # 1/4 beat speed
    end
    sleep 0.0
  end
end

live_loop :arp_2_bass, sync: :bar_start do
  # Predictive_Arp_2_Bass (Low-End Stability)
  use_synth :tb303
  
  focus = get(:focus_level)
  cutoff_mod = 40 + (focus * 40) # Range 40 to 80
  current_transpose = transposition_pattern.look # Synchronized with arp_1
  
  with_fx :reverb, room: 0.5, mix: 0.05 do # Very low Reverb
    4.times do # 4 times * 1 sleep = 4 beats (1 bar)
      play scale_pattern.look - 12, 
           release: 0.3, 
           amp: 1.8, # BASS BOOSTED
           cutoff: cutoff_mod,
           res: 0.5
      sleep 1 # 1 beat speed (slower)
    end
    sleep 0.0
  end
end

# ----------------------------------------------------------------------
# 4. Ambient Layers (Continuous Soundscape Masking)
# ----------------------------------------------------------------------

chord_prog = (ring :c, :g, :a, :f) # Fixed chord pattern

live_loop :ambient_pad, sync: :bar_start do
  # Ambient_Pad (Provides continuous harmonic background)
  use_synth :prophet 
  focus = get(:focus_level)
  
  reverb_mix = 0.05 + (focus * 0.15) # Max mix 0.2 
  cutoff_val = 70 + (focus * 20)
  
  with_fx :reverb, room: 0.8, mix: reverb_mix do
    with_fx :lpf, cutoff: cutoff_val, res: 0.1 do
      
      # Long sustained chord (sleep 16) with slow attack/release
      play_chord chord(chord_prog.tick, :m7), 
                 sustain: 16, 
                 release: 4, 
                 amp: 0.6 + (focus * 0.1),
                 attack: 4,
                 pan: 0 
    end
  end
  sleep 16 # Chord changes every 16 beats (4 bars)
end

live_loop :sub_melodic_anchor, sync: :bar_start do
  # NEW LAYER: Ultra-Slow Predictability - Changes only every 8 bars (32 beats)
  use_synth :dsaw
  focus = get(:focus_level)
  
  # Use the root note of the current pad chord for maximum stability
  current_root = chord_prog.look
  
  # Ensure the note is deep and non-distracting
  play current_root - 12, # Low C2, G2, etc.
       amp: 0.3 + (focus * 0.05), 
       sustain: 32, 
       release: 0.1, 
       attack: 0.5,
       cutoff: 60
       
  sleep 32 # Only changes every 32 beats (8 bars)
end

live_loop :static_masking, sync: :bar_start do
  # NEW LAYER: Controlled Noise Masking (Enhanced Auditory Masking)
  use_synth :noise
  focus = get(:focus_level)
  
  # Use a Low Pass Filter to convert harsh white noise into softer, brown/pink noise
  cutoff_mod = 30 + (focus * 15) # Low, non-hissing frequency range
  
  with_fx :lpf, cutoff: cutoff_mod, res: 0.0 do
    play :c5, # The note doesn't matter for noise, but convention is used
         amp: 0.15 + (focus * 0.1), # Very low amplitude (Max 0.25)
         sustain: 4, 
         release: 4
  end
  sleep 8 # Noise envelope refreshes every 8 beats
end