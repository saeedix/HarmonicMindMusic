# Third Eye Activation System 

use_bpm 66
use_debug false
set_volume! 2.7

# ————————————— Introduction: Soft Opening with 432Hz —————————————
live_loop :intro_pad do
  stop if tick > 8
  with_fx :reverb, room: 1.0, mix: 0.6 do
    use_synth :hollow
    play_chord chord(:c, :minor), release: 8, amp: 0.4, cutoff: rrand(70, 100)
  end
  sleep 8
end

# ————————————— Main Resonance: 963Hz + 432Hz Harmonics —————————————
live_loop :third_eye_resonance, sync: :intro_pad do
  with_fx :reverb, room: 0.8, mix: 0.5 do
    with_fx :octaver, super_amp: 0.3 do
      use_synth :sine
      play_harmony 963, 6, 0.3, :sine, [-0.6, 0.6]    
      play_harmony 432, 4, 0.25, :sine, [-0.4, 0.4]
    end
  end
  sleep 8
end

# ————————————— Binaural Theta/Delta Matrix (+automation) —————————————
live_loop :theta_binaural_matrix, sync: :third_eye_resonance do
  with_fx :flanger, wave: 3, mix: 0.4, phase: 1.0 do |fl|
    create_binaural(144, 150, :sine, 0.03)
    
    control fl,
      mix:  (line 0.2, 0.7, steps: 32).mirror.look,
      phase: (line 1,   7,   steps: 32).tick
  end
  
  sleep 7.236
end


# ————————————— Sacred Geometry Patterns —————————————
live_loop :neuro_sacred_geometry, sync: :third_eye_resonance do
  use_random_seed [1,2,3,5,8,13].tick(:seed)
  with_fx :gverb, damp: 0.8, room: 1.5 do
    use_synth :hollow
    scale_notes = scale(:e3, :phrygian, num_octaves: 2).ring
    play scale_notes.choose, release: 1.618, amp: rand(0.25..0.5), pan: random_pan(0.8)
  end
  sleep [0.618, 1.618, 2.618].choose
end

# ————————————— PSI Pulses with Evolving Texture —————————————
live_loop :psi_pulses, sync: :third_eye_resonance do
  with_fx :ixi_techno, phase: 13, mix: 0.5 do
    sample :ambi_glass_rub, rate: [0.318,0.618,1.618].choose,
      attack: 2, release: 6, pan: line(-1,1,steps:8).tick
  end
  sleep [3,5,8,13].choose
end

# ————————————— Quantum Entanglement Chords + Movement —————————————
live_loop :quantum_entanglement, sync: :third_eye_resonance do
  with_fx :pitch_shift, mix: 0.6 do
    with_fx :vowel, voice: 3, mix: 0.5 do
      use_synth :dark_ambience
      chord_sequence = ring(chord(:c, :major7), chord(:g, :minor))
      play_chord chord_sequence.tick, attack: 5, decay: 6, sustain_level: 0.3, release: 13, cutoff: rrand(60, 100)
    end
  end
  sleep 21
end

# ————————————— Breakdown: Wide Drone + Silence —————————————
live_loop :breakdown, sync: :quantum_entanglement do
  stop if tick > 4
  with_fx :reverb, room: 1.0, mix: 0.7 do
    use_synth :saw
    play 96, release: 12, amp: 0.2, pan: 0
  end
  sleep 16
end

# ————————————— Outro: Gentle Return to Silence —————————————
live_loop :outro_pad do
  sync :breakdown
  with_fx :reverb, room: 1.0, mix: 0.5 do
    use_synth :prophet
    play_chord chord(:c, :minor), release: 12, amp: 0.3, cutoff: 80
  end
  sleep 16
  stop
end

# ————————————— Helper Functions —————————————
define :play_harmony do |freq, harmonics, amp, synth_type, pan_list|
  harmonics.times do |n|
    use_synth synth_type
    play freq * (n+1),
      pan: pan_list.choose,
      amp: amp/(n+1),
      attack: 0.7, release: 4, cutoff: 80 + (n * 15)
  end
end

define :create_binaural do |left, right, synth, amp|
  use_synth synth
  play left,  pan: -1, amp: amp, release: 8
  play right, pan:  1, amp: amp, release: 8
end

define :random_pan do |range|
  rand(-range..range)
end