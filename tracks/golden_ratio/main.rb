# Golden Ratio Music for Meditation and Deep Focus (Developed)
# This piece is inspired by the Golden Ratio and Fibonacci sequence to create a relaxing atmosphere.

# Define the Golden Ratio
phi = (1 + Math.sqrt(5)) / 2

# Set the overall tempo (BPM) for a calm atmosphere
use_bpm 60

# Fibonacci sequences for durations and subtle variations
fib_seq_long = [1, 2, 3, 5, 8, 13, 21, 13, 8, 5, 3, 2] # A longer sequence for gradual changes
fib_micro = [0.5, 0.8, 1.3, 2.1, 3.4] # For smaller variations

# --- Ethereal and Deep Background Pad ---
# Variable for dynamic control of the pad's cutoff
pad_cutoff_control = (line 60, 90, steps: 200, inclusive: true).mirror

live_loop :meditative_pad do
  use_synth :dark_ambience # Synth with an atmospheric and deep sound
  chords = [
    (chord :a2, :m9, num_octaves: 2),
    (chord :g2, :maj9, num_octaves: 2),
    (chord :c3, :maj9, num_octaves: 2),
    (chord :f2, :maj9, num_octaves: 2)
  ]
  current_chord = chords.tick(:pad_chords)
  
  with_fx :reverb, room: 0.9, mix: 0.7, damp: 0.6 do
    play current_chord,
      amp: rrand(1.7, 1.9), # Slight variation in volume
      attack: fib_seq_long.look(:pad_chords) * phi * 0.5,
      sustain: fib_seq_long.look(:pad_chords) * phi,
      release: fib_seq_long.look(:pad_chords) * phi * 1.5,
      cutoff: pad_cutoff_control.tick(:pad_cutoff) # Dynamic cutoff control
  end
  sleep fib_seq_long.look(:pad_chords) * phi * 0.8
end

# --- Subtle and Natural Percussion Elements ---
live_loop :gentle_percussion do
  sync :meditative_pad # Synchronize with the pad
  
  if one_in(fib_seq_long.tick(:perc_event) / 2 + 2) then # Lower probability
    sample :perc_bell, amp: rrand(0.05, 0.15), rate: rrand(0.4, 0.6) * phi, pan: rrand(-0.8, 0.8)
  end
  sleep fib_seq_long.look(:perc_event) * phi * rrand(1.8, 2.2) # Slight variation in sleep time
  
  if one_in(fib_seq_long.tick(:perc_event_2) / 2 + 3) then
    sample :elec_soft_kick, amp: rrand(0.08, 0.18), rate: 0.5 if rand < 0.15 # Lower probability
  end
  sleep fib_seq_long.look(:perc_event_2) * phi * rrand(1.3, 1.7)
  
  # Adding a very subtle textural sound
  if one_in(8) then # Very rare
    s_choice = [:ambi_swoosh, :ambi_soft_buzz, :ambi_lunar_land].choose
    sample s_choice, amp: rrand(0.03, 0.08), rate: rrand(0.3, 0.7) * phi, pan: rrand(-1, 1)
    sleep fib_micro.choose * phi * 2
  end
end

# --- Calm and Contemplative Melody ---
live_loop :healing_melody do
  sync :meditative_pad # Synchronize with the pad
  use_synth :sine
  notes = scale(:a3, :minor, num_octaves: 1)
  note_index = fib_seq_long.tick(:melody_note_main) % (notes.length * 2 / 3) # Focus more on lower notes
  note_to_play = notes[note_index]
  
  with_fx :echo, phase: phi * rrand(0.7, 0.8), decay: phi * rrand(3.5, 4.5), mix: 0.35 do
    play note_to_play,
      amp: rrand(0.25, 0.45),
      attack: phi * rrand(0.8, 1.2),
      release: (fib_seq_long.look(:melody_note_main) * phi * 0.5) * rrand(0.8, 1.2),
      cutoff: rrand(75, 95),
      pan: Math.sin(vt * phi * 0.15) * 0.8 # Slightly more pan movement
  end
  
  # Second layer of melody, subtle and sparse
  if one_in(4) then # Plays with lower probability
    use_synth :kalimba
    higher_notes = scale(:a4, :minor_pentatonic, num_octaves: 1) # Different scale for variety
    kalimba_note = higher_notes.choose
    with_fx :ping_pong, phase: fib_micro.choose * phi, feedback: 0.3, mix: 0.5 do
      play kalimba_note, amp: rrand(0.1, 0.2), release: fib_micro.choose * phi
    end
  end
  
  sleep (fib_seq_long.look(:melody_note_main) * 0.25 * phi) + (phi * rrand(0.9, 1.1))
end

# --- Deep and Stable Bass Line ---
live_loop :deep_bass do
  sync :meditative_pad # Synchronize with the pad
  use_synth :subpulse
  root_notes = [:a1, :g1, :c2, :f1]
  current_root = root_notes.tick(:bass_note)
  
  play current_root,
    amp: rrand(0.55, 0.65),
    attack: 2 * phi * rrand(0.9, 1.1),
    sustain: fib_seq_long.look(:pad_chords) * phi * rrand(0.4, 0.6),
    release: 3 * phi * rrand(0.9, 1.1), # Slight variation in release
    cutoff: rrand(45, 65) # Lower cutoff for more depth
  
  sleep fib_seq_long.look(:pad_chords) * phi * 0.8
end
