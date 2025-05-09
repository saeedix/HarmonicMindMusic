use_bpm 58
use_random_seed 42
use_debug false

# Parameters
alpha_range = (8..12)
breath_cycle = 5.5

# The sound of flowing water
live_loop :stream_water do
  sample :loop_compus,
    rate: 0.4,
    amp: 0.6,
    attack: 2,
    release: 4,
    pan: -0.2,
    cutoff: 80
  sleep 16
end

# Random bird sounds
live_loop :birds do
  sync :stream_water
  with_fx :reverb, room: 0.6 do
    sample :ambi_glass_rub,
      rate: rand(0.8..1.2),
      amp: rand(0.3..0.5),
      pan: rand(-0.5..0.5),
      cutoff: 100 + rand(20)
  end
  sleep rand(3..6)
end

live_loop :alpha_waves do
  with_fx :gverb, room: 1 do 
    with_synth :sine do
      play :c0, 
        amp: 0.4,
        attack: breath_cycle/2,
        release: breath_cycle/2,
        cutoff: 70
    end
  end
  sleep breath_cycle
end

live_loop :nature_soundscape do
  sync :alpha_waves
  with_fx :pan, pan: -0.3 do
    sample :ambi_soft_buzz,
      rate: 0.4,
      amp: 0.7,
      attack: 3,
      release: 5
  end
  with_fx :pan, pan: 0.3 do
    sample :ambi_soft_buzz,
      rate: 0.45,
      amp: 0.7,
      attack: 3,
      release: 5
  end
  sleep breath_cycle * 1.5
end

live_loop :calm_melody do
  sync :nature_soundscape
  use_synth :hollow
  play_pattern_timed scale(:c4, :major).shuffle.take(5),
    [1.5, 0.75, 2],
    amp: 0.6,
    pan: line(-0.5, 0.5, steps: 8).tick,
    release: 2
end

live_loop :breathing_guide do
  with_fx :reverb, room: 0.7 do
    sample :ambi_dark_woosh,
      rate: (line 0.3, 0.7, steps: breath_cycle*2).mirror.tick,
      amp: 0.5,
      pan: 0
  end
  sleep breath_cycle
end

live_loop :soft_pads do
  with_fx :echo, phase: 2 do
    with_synth :piano do
      play chord(:c3, :M7),
        amp: 0.3,
        attack: 4,
        release: 8,
        cutoff: 90
    end
  end
  sleep 8
end