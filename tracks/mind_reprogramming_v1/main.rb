use_bpm 50 
srand(Time.now.to_i) 

# Evolution stage parameter, changes over time
set :evolution_stage, 0

# Controls the evolution stage, incrementing every 60 seconds
live_loop :evolution_control do
  tick 
  set :evolution_stage, look
  puts "Evolution Stage: #{look}"
  sleep 60
end

# Deep drone layer, harmonically evolving with the stage
live_loop :deep_drone do
  stage = get[:evolution_stage] 
  
  # Selects a chord based on the current stage, using Aeolian mode
  base_chord = (chord_degree (stage % 4) + 1, :c2, :aeolian, 5)
  
  with_fx :reverb, room: 0.8, mix: 0.6 do
    with_fx :panslicer, phase: 16, mix: rrand(0.3, 0.6) do 
      synth :dark_ambience, note: base_chord, attack: 8, sustain: 8, release: 12, amp: 0.6, cutoff: rrand(60, 80 + (stage*0.5)) 
      synth :hollow, note: base_chord.choose - 12, attack: 10, sustain: 6, release: 10, amp: 0.4, pan: -0.5, cutoff: rrand(50, 70)
      synth :hollow, note: base_chord.choose - 12, attack: 10, sustain: 6, release: 10, amp: 0.4, pan: 0.5, cutoff: rrand(55, 75) 
    end
  end
  sleep 16
end

# Evolving melodic and textural layer, changes scale and synth based on stage
live_loop :evolving_texture do
  sync :deep_drone 
  stage = get[:evolution_stage]
  
  use_synth [:fm, :pretty_bell, :kalimba].choose 
  current_scale = [:minor_pentatonic, :egyptian, :ionian, :dorian][stage % 4]
  notes = scale(:c4, current_scale, num_octaves: 2).shuffle
  
  if one_in(3) 
    play notes.tick,
      amp: rrand(0.1, 0.3 + (stage * 0.01)), 
      release: rrand(1, 3),
      pan: rrand(-0.8, 0.8),
      cutoff: rrand(70, 100 + (stage * 0.5))
    
    # Adds echo effects for higher stages
    if stage > 2 && one_in(2) 
      with_fx :echo, phase: [0.5, 0.75, 1].choose, decay: rrand(4, 8), mix: rrand(0.2, 0.4) do
        play notes.look, 
          amp: rrand(0.05, 0.15),
          release: rrand(1, 2),
          pan: rrand(-0.6, 0.6)
      end
    end
  end
  
  sleep [0.5, 0.75, 1, 1.25].choose 
end

# Ambient nature sounds, evolving with the stage
live_loop :nature_sounds do
  stage = get[:evolution_stage]
  
  nature_sample = [:ambi_lunar_land, :ambi_soft_buzz, :ambi_drone, :ambi_glass_hum].choose
  
  if one_in(6) 
    sample nature_sample,
      amp: rrand(0.1, 0.4 + (stage * 0.01)), 
      rate: rrand(0.8, 1.2), 
      pan: rrand(-1, 1)
  end
  sleep rrand(4, 10) 
end

# Subtle rhythmic layer, only appears at higher stages
live_loop :subtle_rhythm do
  stage = get[:evolution_stage]
  if stage > 10 && one_in(4)
    with_fx :lpf, cutoff: rrand(50, 70) do 
      sample [:elec_tick, :elec_blip, :drum_cymbal_soft].choose,
        amp: rrand(0.05, 0.15),
        rate: rrand(0.8, 1.2),
        pan: rrand(-0.5, 0.5)
    end
  end
  sleep [1, 1.5, 2].choose
end

