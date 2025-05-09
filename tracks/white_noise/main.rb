use_bpm 60
use_random_seed 42 # To keep the random pattern consistent

# Main parameters (you can change these during runtime)
set(:cutoff_base, 70)  # Base frequency for the filter
set(:resonance, 0.2)   # Filter resonance
set(:master_amp, 0.4)  # Master volume
set(:ambient_mix, 0.4) # Volume for ambient sounds

# Advanced parameters
noise_types = [0, 1, 2]  # Types of noise: white, pink, brown
filter_mod_depth = 10    # Depth of filter modulation
rhythm_rate = 0.25       # Base rhythm speed

live_loop :main_noise do
  use_synth :noise
  with_fx :reverb, room: 0.8, mix: 0.4 do
    with_fx :lpf, cutoff: get(:cutoff_base) + Math.sin(tick) * filter_mod_depth, res: get(:resonance) do
      play noise: choose(noise_types),
        amp: get(:master_amp) * 1.2,
        attack: 5, sustain: 6, release: 5,
        pan: rrand(-0.3, 0.3)
      sleep 8
    end
  end
end

live_loop :ambient_pads do
  use_synth :hollow
  with_fx :hpf, cutoff: 40 do
    play chord(:d2, :m7).choose,
      amp: get(:ambient_mix) * 0.6,
      release: 8,
      cutoff: 60,
      pan: line(-0.5, 0.5, step: 0.25).tick
  end
  sleep 8
end

live_loop :nature_rhythm do
  with_fx :distortion, distort: 0.1 do
    sample :ambi_soft_buzz,
      rate: rhythm_rate,
      amp: get(:master_amp) * 0.7,
      attack: 0.5,
      release: 1.5,
      pan: [-1, 1].choose
  end
  sleep [2, 4, 1].choose * rhythm_rate
end

live_loop :dynamic_filter do
  control get(:lpf),
    cutoff: get(:cutoff_base) + Math.sin(tick * 0.5) * 15,
    res: get(:resonance) + Math.cos(tick * 0.2) * 0.1
  sleep 0.25
end

live_loop :volume_control do
  set :master_amp, (range 0.3, 0.6, 0.05).tick  # Automatic volume change
  sleep 8
end

# For manual control during runtime (change parameters as needed):
# set :cutoff_base, 90
# set :ambient_mix, 0.7
# set :resonance, 0.3