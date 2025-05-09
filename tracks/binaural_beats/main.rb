# Initial settings
use_bpm 60
use_debug false

# Initial parameters
base_freq = 180
delta_sequence = [14, 10, 8, 6, 4, 2] # From beta to theta
current_index = 0
duration = 32

# Binaural beat generation function
define :binaural_beat do |base, delta, amp=1.0|
  in_thread do
    use_synth :sine
    with_fx :reverb, room: 0.9 do
      with_fx :echo, phase: 0.75, decay: 4 do
        play base, pan: -1, amp: amp, attack: 2, release: 4
        play base + delta, pan: 1, amp: amp, attack: 2, release: 4
      end
    end
  end
end

# Binaural evolving loop
live_loop :evolving_binaural do
  delta = delta_sequence[current_index % delta_sequence.length]
  binaural_beat(base_freq, delta, 1.0)

  # Increase or decrease the base frequency for a sense of movement
  base_freq += rrand(-2.0, 2.0)
  base_freq = [[base_freq, 160].max, 220].min

  current_index += 1
  sleep duration
end

# Main ambient effect
live_loop :deep_ambience do
  use_synth :dark_ambience
  with_fx :ixi_techno, phase: 12, cutoff_max: 100 do
    play chord(:F3, :m7, num_octaves: 2), release: 12, amp: 0.7
    sleep 12
  end
end

# Soft harmonic rhythm
live_loop :ambient_rhythm do
  with_fx :echo, mix: 0.3, phase: 1.5 do
    sample :ambi_choir, rate: 0.6, amp: 0.5, attack: 2, release: 4
    sleep 16
  end
end

# Sub bass hits with a wavy feel
live_loop :sub_bass_wave do
  with_fx :wobble, phase: 4, invert_wave: one_in(2) ? 1 : 0 do
    use_synth :prophet
    play :D1, release: 6, cutoff: rrand(60, 90), amp: 0.5
    sleep 16
  end
end

# Spatialization and effects modulation
live_loop :spatial_modulation do
  with_fx :slicer, phase: rrand(0.25, 1), pulse_width: 0.8 do
    sample :ambi_glass_rub, amp: 0.35, rate: 0.5
    sleep 12
  end
end
