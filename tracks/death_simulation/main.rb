use_bpm 60
use_random_seed 42
use_debug false

transition_speed = 0.5 
life_pulse = 1.0 
pulse_min = 0.15 

live_loop :dynamic_changes do
  sleep 30 
  transition_speed = [0.3, 0.5, 0.7, 1.0].choose
  use_random_seed rand(1000)
end

live_loop :cardiac_rhythm do
  with_fx :reverb, room: 0.9 do
    sample :drum_heavy_kick,
      rate: [[life_pulse, pulse_min].max, 2.0].min, 
      amp: 1.5,
      attack: 0.1,
      release: 0.3,
      cutoff: 40 + (life_pulse * 40)
  end
  sleep 60.0 / (40 + (life_pulse * 20))
  life_pulse -= 0.005 * transition_speed
  life_pulse = [[life_pulse, pulse_min].max, 1.5].min 
end

live_loop :neural_cascade do
  sync :cardiac_rhythm
  with_fx :echo, phase: 0.75, decay: 8 do
    with_synth [:dark_ambience, :hollow].choose do
      play chord(:c2, [:dim7, :m7b5].choose).tick,
        amp: 0.8,
        attack: [1, 2, 3].choose,
        release: [3, 4, 5].choose,
        cutoff: 80 - (life_pulse * 40)
    end
  end
  sleep 4 / transition_speed
end

live_loop :memory_fragments do
  with_fx :bitcrusher, sample_rate: 44100 / (1 + (life_pulse * 10)) do
    current_rate = -0.5 + life_pulse
    limited_rate = [[current_rate, -1.0].max, 1.5].min
    
    sample [:loop_industrial, :loop_compus].choose,
      rate: limited_rate,
      amp: 1.2,
      pan: line(-1, 1, steps: 16).tick
  end
  sleep 8 * transition_speed
end

live_loop :cosmic_drift do
  with_fx :gverb, damp: [0.7, 0.8, 0.9].choose do
    with_synth :hollow do
      play scale(:e3, [:minor, :phrygian].choose).tick,
        amp: 0.6,
        attack: [3, 4, 5].choose,
        release: [6, 7, 8].choose,
        cutoff: 60 + rand_i(20)
    end
  end
  sleep 12 * transition_speed
end

live_loop :quantum_silence do
  sync :cosmic_drift
  density [1, 2].choose do
    with_fx [:distortion, :slicer].choose do
      sample :ambi_glass_rub,
        rate: [0.25, 0.5, 1.0].choose,
        amp: 1.0 - life_pulse,
        pan: rrand(-0.8, 0.8)
    end
  end
  sleep 6 * transition_speed
end

live_loop :evolving_textures do
  sync :cardiac_rhythm
  with_fx :flanger do
    with_synth :growl do
      play chord(:c4, :minor).choose,
        amp: 0.4,
        sustain: 2,
        release: 4,
        cutoff: 80 + rand(20)
    end
  end
  sleep 16
end