use_bpm 65

# -------------------------
# Global Dynamic Control
# -------------------------
set :main_amp, 0.9      # Main output amplitude
set :melody_amp, 0.28   # Melody amplitude
set_mixer_control! amp: 0.9

# -------------------------
# Binaural Beats for Deep Focus
# -------------------------
live_loop :binaural_beat do
  use_synth :sine
  base_freq = 440
  binaural_diff = 8 # 8Hz alpha wave difference
  with_fx :lpf, cutoff: 120 do
    in_thread { play base_freq, pan: -0.5, amp: 0.05, attack: 0.1, release: 1.2 }
    in_thread { play base_freq + binaural_diff, pan: 0.5, amp: 0.05, attack: 0.1, release: 1.2 }
  end
  sleep 1
end

# -------------------------
# Main Evolving Harmony
# -------------------------
live_loop :harmonic_foundation, delay: 8 do
  use_synth :hollow
  use_synth_defaults attack: 5, release: 10, amp: 0.55
  chords = [
    chord(:c2, :m9),
    chord(:ds2, :m11),
    chord(:f2, :m7),
    chord(:g2, :m9),
    chord(:as2, :add9),
    chord(:c2, :m9)
  ].shuffle # Slow, random chord movement
  with_fx :reverb, mix: 0.87, room: 1 do
    with_fx :lpf, cutoff: 70 do
      play_chord chords.tick, amp: 0.3
    end
  end
  sleep 8
end

# -------------------------
# Main Legato Melody
# -------------------------
live_loop :main_melody do
  use_synth :dark_ambience
  use_synth_defaults amp: get(:melody_amp) || 0.28, release: 5.5
  melody_phrases = [
    [:c4, :ds4, :f4, :g4, :as4, :c5, :g4],
    [:ds4, :f4, :gs4, :c5, :ds5, :c5, :gs4],
    [:c4, :ds4, :f4, :g4, :as4, :c5, :g4],
    [:f4, :gs4, :c5, :ds5, :f5, :ds5, :c5]
  ]
  with_fx :echo, phase: 3.5, decay: 7, mix: 0.35 do
    with_fx :reverb, room: 0.85 do
      current_phrase = melody_phrases.tick
      current_phrase.each do |note|
        play note, release: rrand(3.5,5.5), cutoff: rrand(60,85), pan: rrand(-0.25,0.25)
        sleep 1.5
      end
    end
  end
  sleep 1
end

# -------------------------
# Evolving Counter-Melody
# -------------------------
live_loop :counter_melody do
  use_synth :tri
  use_synth_defaults amp: 0.12, release: 4
  counter_notes = [
    [:g3, :as3, :c4, :ds4],
    [:f3, :gs3, :ds4, :f4],
    [:g3, :as3, :c4, :ds4],
    [:ds3, :f3, :gs3, :as3]
  ]
  with_fx :echo, phase: 3.5, decay: 6, mix: 0.25 do
    counter_notes.tick.each do |note|
      play note, release: rrand(3.5,4.5), pan: rrand(-0.2,0.2)
      sleep 1.5
    end
  end
end

# -------------------------
# Melodic Bassline
# -------------------------
live_loop :melodic_bass do
  use_synth :fm
  use_synth_defaults amp: 0.18, release: 3
  bass_line = [
    [:c2, 4], [:g2, 2], [:ds2, 2], [:as2, 4],
    [:f2, 2], [:c2, 2], [:g2, 4], [:ds2, 4]
  ]
  with_fx :lpf, cutoff: 55 do
    with_fx :distortion, distort: 0.07 do
      bass_line.each do |note, duration|
        play note, release: duration - 0.5
        sleep duration
      end
    end
  end
end

# -------------------------
# Long Atmospheric Pads
# -------------------------
live_loop :moving_pads do
  use_synth :dark_ambience
  use_synth_defaults amp: 0.07, attack: 12, release: 12
  pad_progression = [:c3, :g3, :ds3, :as3].shuffle
  with_fx :reverb, mix: 0.93, room: 1 do
    pad_progression.each do |note|
      play note, pan: rrand(-0.25,0.25), cutoff: rrand(50,70)
      sleep 4
    end
  end
end

# -------------------------
# Legato Arpeggios
# -------------------------
live_loop :delicate_arpeggios do
  use_synth :pretty_bell
  use_synth_defaults amp: 0.1, release: 3.5
  arp_chords = [
    chord(:c4, :m9),
    chord(:g4, :m9),
    chord(:ds4, :m11),
    chord(:as4, :add9)
  ].shuffle
  with_fx :reverb, mix: 0.92, room: 0.95 do
    with_fx :echo, phase: 1.8, decay: 5.5 do
      arp_chords.tick.each do |note|
        play note + 12, release: rrand(3,4), pan: rrand(-0.25,0.25)
        sleep 0.75
      end
    end
  end
end

# -------------------------
# Calm, Organic Rhythm
# -------------------------
live_loop :organic_rhythm do
  with_fx :level, amp: 0.32 do
    sample :loop_amen, rate: 0.28, beat_stretch: 16, amp: 0.22
    sleep 16
  end
end

# -------------------------
# Gentle Ambient Effects
# -------------------------
live_loop :ambient_fluctuations do
  if one_in(7)
    with_fx :reverb, room: 1 do
      sample [:ambi_glass_hum, :ambi_soft_buzz, :ambi_drone].choose, amp: 0.05, pan: rrand(-0.8,0.8)
    end
  end
  sleep rrand(6,14)
end

# -------------------------
# Gradual Dynamic Evolution
# -------------------------
live_loop :evolution do
  phase = (vt / 32).floor % 16
  case phase
  when 0..3
    set :main_amp, 0.8
    set :melody_amp, 0.22
  when 4..7
    set :main_amp, 0.9
    set :melody_amp, 0.28
  when 8..11
    set :main_amp, 0.85
    set :melody_amp, 0.25
  when 12..15
    set :main_amp, 0.88
    set :melody_amp, 0.27
  end
  sleep 8
end