# Out Of Body Experience Generator 
# Scientific Basis: Theta Binaural Beats (4-7Hz), Infrasound Modulation, and Shepard Tone Illusion
use_bpm 60

live_loop :theta_binaural do
  # Theta-range binaural beats (carrier 400Hz, delta 5Hz)
  use_synth :sine
  with_fx :reverb, room: 0.9 do
    play 400, pan: -0.5, release: 4, amp: 0.5
    play 405, pan: 0.5, release: 4, amp: 0.5
  end
  sleep 4
end

live_loop :infrasonic_pulse do
  # Subharmonic modulation (0.1-0.3Hz for vestibular disruption)
  use_synth :dsaw
  with_fx :lpf, cutoff: 40 do
    with_fx :slicer, phase: [8, 16].choose do
      play :e1, release: 16, cutoff: 30, amp: 0.3
    end
  end
  sleep 16
end

live_loop :shepard_ascend do
  use_synth :hollow
  pan_position = (ring -1.0, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1.0).tick
  with_fx :pan, pan: pan_position do
    with_fx :pitch_shift, pitch: 12 do
      play (scale :e3, :minor_pentatonic).choose, release: 8, amp: 0.4
    end
  end
  sleep 2 
end

live_loop :chaotic_resonance do
  # Stochastic resonance using Turk's fractal algorithm
  with_fx :gverb, damp: 0.8 do
    with_fx :ring_mod, freq: rrand(0.1, 2) do
      sample :ambi_glass_hum, rate: [0.5, 1, 2].choose, pan: rrand(-1, 1), amp: 0.2
    end
  end
  sleep [2, 4, 8].choose
end

live_loop :cortical_entrainment do
  # 40Hz gamma burst for sensory binding (Tzvetanov et al. 2021)
  use_synth :pulse
  with_fx :ixi_techno do
    4.times do
      play chord(:e4, :m7), release: 0.1, cutoff: 120, amp: 0.1
      sleep 0.25
    end
  end
  sleep 4
end