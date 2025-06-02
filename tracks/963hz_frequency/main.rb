# Sonic Pi Code: 963 Hz - Frequency of Gods - Spiritual Music v5 (Harmony & Volume Adjustments)

# Global tempo - slow and meditative
use_bpm 50

# --- State for sharing current chord ---
set :current_chord_root, :Bb3 # Initial value
# Adding current chord type to state for more harmonically aware elements
set :current_chord_type, :major7 # Initial type matching Bb3,major7

# --- Divine Frequency Drone (approx. 963 Hz) ---
live_loop :divine_frequency_drone do
  use_synth :sine
  
  current_lpf_cutoff_drone = line(90, 120, steps: 60).mirror.tick(:lpf_cutoff_drone_tick)
  if current_lpf_cutoff_drone.nil?
    puts "!!! WARNING: current_lpf_cutoff_drone is nil in :divine_frequency_drone. Defaulting to 100. !!!"
    current_lpf_cutoff_drone = 100
  end
  
  # Reduced drone amplitude
  drone_amp = line(0.18, 0.25, steps: 120).mirror.tick(:drone_amp_tick)
  if drone_amp.nil?
    puts "!!! WARNING: drone_amp is nil in :divine_frequency_drone. Defaulting to 0.2. !!!"
    drone_amp = 0.2 # Adjusted default
  end
  
  with_fx :lpf, cutoff: current_lpf_cutoff_drone, res: 0.1 do
    with_fx :reverb, room: 0.9, mix: 0.7, damp: 0.8 do
      play :as5, detune: 0.5532, amp: drone_amp, attack: 10, sustain: 15, release: 10
    end
  end
  sleep 30
end

# --- Celestial Pads ---
live_loop :celestial_pads do
  use_synth :dark_ambience
  
  chords_data = [
    {root: :Bb3, type: :major7},
    {root: :Eb3, type: :major7},
    {root: :F3, type: :major},
    {root: :G3, type: :minor7} # Note the minor7 here
  ]
  current_chord_info = chords_data.tick(:pad_chords_info)
  set :current_chord_root, current_chord_info[:root]
  set :current_chord_type, current_chord_info[:type] # Set the chord type in global state
  
  current_chord_notes = chord(current_chord_info[:root], current_chord_info[:type], num_octaves: 2)
  
  pad_pan = line(-0.5, 0.5, steps: 80).mirror.tick(:pad_pan_tick)
  if pad_pan.nil?
    puts "!!! WARNING: pad_pan is nil in :celestial_pads. Defaulting to 0. !!!"
    pad_pan = 0
  end
  
  pad_cutoff = line(70, 110, steps: 90).mirror.tick(:pad_cutoff_tick)
  if pad_cutoff.nil?
    pad_cutoff = 90
  end
  
  with_fx :reverb, room: 0.9, mix: 0.6, damp: 0.5 do
    with_fx :flanger, phase: 4, depth: 5, mix: 0.3, feedback: 0.2 do
      play current_chord_notes,
        amp: 0.4, # Slightly increased pad amplitude
        attack: 8,
        sustain: 10,
        release: 8,
        cutoff: pad_cutoff,
        pan: pad_pan,
        pan_slide: 4
    end
  end
  sleep 16
end


# --- Celestial Chimes (Revised for Harmony & FX Scope) ---
live_loop :celestial_chimes do
  sync :celestial_pads
  use_synth :kalimba
  
  if one_in(3)
    chime_scale_notes = scale(:Bb5, :major_pentatonic, num_octaves: 1) # Focus on one octave for consistency
    
    echo_decay_chime = rrand(2.5, 5.5)
    
    with_fx :reverb, room: 0.85, mix: 0.65 do # Slightly more reverb
      with_fx :echo, phase: [0.375, 0.5, 0.75].choose, decay: echo_decay_chime do
        if one_in(4)
          note1 = chime_scale_notes.choose
          note2 = chime_scale_notes.choose
          note2 = chime_scale_notes.choose while note1 == note2 && chime_scale_notes.length > 1
          
          play note1, amp: rrand(0.1, 0.18), release: rrand(1.0, 1.8), pan: rrand(-0.7, -0.2), cutoff: rrand(100,120)
          sleep [0.25, 0.375, 0.5].choose # Slightly longer sleeps in motif
          play note2, amp: rrand(0.1, 0.18), release: rrand(1.2, 2.2), pan: rrand(0.2, 0.7), cutoff: rrand(100,120)
        else
          play chime_scale_notes.choose,
            amp: rrand(0.1, 0.18), # Slightly increased chime amplitude
            release: rrand(1.5, 3.0), # Longer release for single chimes
            attack: 0.01,
            pan: rrand(-0.8, 0.8),
            cutoff: rrand(100, 125)
        end
      end
    end
  end
  sleep [3.5, 4.5, 5.5].choose
end

# --- Breathing Texture (Subtle) ---
live_loop :breathing_texture do
  use_synth :bnoise
  
  tremolo_freq_values = (ring 0.05, 0.07, 0.09, 0.11, 0.13, 0.15, 0.13, 0.11, 0.09, 0.07)
  current_tremolo_freq = tremolo_freq_values.tick(:tremolo_freq_tick_breathing_final)
  
  if current_tremolo_freq.nil?
    current_tremolo_freq = 0.1
  end
  
  current_lpf_cutoff_texture = line(50, 70, steps: 40).mirror.tick(:lpf_cutoff_breathing_final)
  if current_lpf_cutoff_texture.nil?
    current_lpf_cutoff_texture = 60
  end
  
  with_fx :lpf, cutoff: current_lpf_cutoff_texture, res: 0.01 do
    with_fx :tremolo, depth: 0.5, phase: 0.25, freq: current_tremolo_freq do
      play :c1, amp: 0.03, attack: 5, sustain: 5, release: 5 # Kept very subtle
    end
  end
  sleep 10
end

# --- Cosmic Pulses (Synth Variation) ---
live_loop :cosmic_pulses do
  pulse_synth = one_in(3) ? :tb303 : :subpulse
  use_synth pulse_synth
  
  if one_in(6)
    pulse_cutoff = (pulse_synth == :tb303) ? rrand(30,60) : rrand(40,70)
    pulse_res = (pulse_synth == :tb303) ? rrand(0.5, 0.8) : 0.2
    
    with_fx :lpf, cutoff: (pulse_synth == :tb303) ? 70 : 60, res: (pulse_synth == :tb303) ? 0.3 : 0.2 do
      with_fx :reverb, room: 0.7, mix: 0.4 do
        play [:Bb1, :C2, :Eb1].choose, # Notes are harmonically grounded
          amp: rrand(0.08, 0.15), # Kept subtle
          attack: 0.5,
          sustain: rrand(1, 2),
          release: rrand(2, 4),
          cutoff: pulse_cutoff,
          res: pulse_res
      end
    end
  end
  sleep 8
end

# --- Shimmering Veil (Revised for Harmony & Mystical Feel) ---
live_loop :shimmering_veil do
  use_synth :supersaw
  
  # Using only very high Bb and F (root and fifth of Bb) for extreme consonance and ethereal quality
  veil_note_options = [:Bb7, :F8]
  
  if one_in(4)
    with_fx :reverb, room: 0.95, mix: 0.85, damp: 0.6 do # More mix, slightly more damp
      with_fx :slicer, phase: [0.375, 0.5, 0.625].choose, mix: rrand(0.05, 0.2), smooth: 0.2 do # Even more subtle slicer
        play veil_note_options.choose,
          amp: rrand(0.01, 0.035), # Further reduced amp for extreme subtlety
          attack: rrand(12, 20), # Even longer attack
          sustain: rrand(8,15), # Longer sustain
          release: rrand(12, 20), # Even longer release
          cutoff: 130, # Fixed very high cutoff
          detune: rrand(0.15, 0.3) # Slightly wider detune for more wash
      end
    end
  end
  sleep 20
end