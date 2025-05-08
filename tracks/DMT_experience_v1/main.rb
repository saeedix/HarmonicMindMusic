# Sonic Pi: Neurosonic DMT Experience v2.3
# Volume optimization while preserving quality

use_bpm 60
use_debug false

# 1. Tuning settings
use_tuning :equal, 432

# 2. Main parameters with increased amplitude
global_binaural_base = 200      # Base frequency for binaural beats
theta_diff = 7.0                # Frequency difference for theta waves
random_seed = 1                 # Seed for randomization

# 3. Main effects with controlled amplification
main_fx = with_fx :level, amp: 1.5 do # Increased from 1.0 to 1.5
  with_fx :reverb, mix: 0.3, room: 0.7 do # Slightly reduced reverb for more clarity
    
    # A. Enhanced theta binaural beats
    in_thread do
      loop do
        play global_binaural_base - (theta_diff/2), amp: 0.15, pan: -0.8, release: 6 # +87.5%
        play global_binaural_base + (theta_diff/2), amp: 0.15, pan: 0.8, release: 6
        sleep 6
      end
    end
    
    # B. Enhanced choral pad
    in_thread do
      use_synth :dark_ambience
      loop do
        play_chord chord(:D4, :add9), release: 16, amp: 0.4 # +33%
        sleep 16
        play_chord chord(:G4, :major7), release: 12, amp: 0.35 # +25%
        sleep 12
        play_chord chord(:A4, :sus4), release: 10, amp: 0.32 # +23%
        sleep 10
      end
    end
    
    # C. Arpeggio with higher amplitude
    in_thread do
      use_synth :pluck
      scale_notes = scale(:D4, :dorian, num_octaves: 2)
      loop do
        16.times do
          play scale_notes.choose, release: rrand(0.2,0.4), amp: 0.3, pan: rrand(-0.5,0.5) # +50%
          sleep choose([0.25,0.5,0.75])
        end
        scale_notes = scale(choose([:D, :E, :F, :G, :A]), :dorian, num_octaves: 2)
      end
    end
    
    # D. Stronger sub-bass
    in_thread do
      use_synth :fm
      loop do
        play :D2, release: 1, amp: 0.4, cutoff: 70 # +33% and filter
        sleep 1
      end
    end
    
    # E. Enhanced neural backgrounds
    in_thread do
      use_random_seed random_seed
      use_synth :hollow
      loop do
        n = scale(:e3, :hirajoshi, num_octaves: 2).choose
        play n, amp: 0.15, release: 0.4, pan: rrand(-0.5,0.5) # +87.5%
        sleep choose([0.25,0.5,0.75,1])
        random_seed += 1
      end
    end
    
    # F. Echo with higher volume
    in_thread do
      loop do
        with_fx :echo, phase: 1.618 * 0.5, mix: 0.25 do
          sample :ambi_glass_rub, rate: choose([0.75,1]), amp: 0.2 # +100%
        end
        sleep 1
      end
    end
    
  end
end

# 4. Fade-out with higher initial amplitude
in_thread do
  sleep 150
  30.times do |i|
    set :main_amp, 1.5 * (1 - (i / 30.0))
    sleep 0.5
  end
end

sleep 180