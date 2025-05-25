# Overall settings for a deeper psychedelic, spiritual, and therapeutic experience
use_bpm 15 # Very slow tempo for deeper immersion in space, time, and tranquility
use_synth :sine # Sine wave synthesizer for its purity and flexibility in creating subtle harmonics
set_volume! 1.8 # Global volume setting (Note: 1.8 might be loud, monitor levels)

# Define the main frequency of 423 Hz
base_freq = 423.0

puts "Deeper Psychedelic, Spiritual & Therapeutic Frequency: #{base_freq} Hz" # This comment is already in English

# INITIALIZATION: Ensure :binaural_control and :amp_control_val are set to floats before any live_loop starts
# This line ensures that `binaural_control` and `amp_control_val` always have numerical values from the start.
set :binaural_control, 0.5
set :amp_control_val, 0.4 # Initial value for pad volume control

# Add an initial pause to ensure `set` commands are initialized
sleep 1

# --- Section 1: Evolving, Breathing Binaural Core Pad ---
# This section is the heart of the experience, inducing a sense of movement and shifting consciousness through subtle, slow changes.
live_loop :core_pad do
  with_fx :reverb, room: 0.98, mix: 1, damp: 0.95 do # Maximal reverb for a boundless and expansive space
    with_fx :flanger, depth: 0.8, phase: 0.6, decay: 12, stereo_width: 0.8 do # Deeper flanger for a sense of movement and dissociation
      with_fx :eq, low: -1, high: 0.8 do # EQ adjustment for a deep and slightly brighter space
        # Dynamic control for binaural beat frequency offset (slow change between 0.3 to 0.7 Hz)
        freq_offset_val_raw = get(:binaural_control)
        
        # Dynamic control for pad volume (breathing sensation) - now controlled via set/get
        amp_mod_raw = get(:amp_control_val)
        
        # Check and ensure that the retrieved values are numeric
        if freq_offset_val_raw.is_a?(Numeric)
          freq_offset_val = freq_offset_val_raw
        else
          puts "Warning: :binaural_control was not Numeric. Value: #{freq_offset_val_raw.inspect}. Defaulting to 0.5." # English comment
          freq_offset_val = 0.5 # Default value
        end
        
        if amp_mod_raw.is_a?(Numeric)
          amp_mod = amp_mod_raw
        else
          puts "Warning: :amp_control_val was not Numeric. Value: #{amp_mod_raw.inspect}. Defaulting to 0.4." # English comment
          amp_mod = 0.4 # Default value
        end
        
        synth :sine, note: hz_to_midi(base_freq), attack: 12, release: 18, amp: 0.4 * amp_mod # Central note without offset
        synth :sine, note: hz_to_midi(base_freq + freq_offset_val), attack: 12, release: 18, amp: 0.35 * amp_mod, pan: 0.5
        synth :sine, note: hz_to_midi(base_freq - freq_offset_val), attack: 12, release: 18, amp: 0.35 * amp_mod, pan: -0.5
        
        sleep 25 # Notes are re-triggered every 25 seconds with subtle changes
      end
    end
  end
end

# Control loop for slowly changing binaural beat frequency
live_loop :binaural_control_loop do
  set :binaural_control, rrand(0.3, 0.7) # `set` now stores a random numerical value.
  sleep 0.5 # Speed of control change
end

# Control loop for slowly changing pad volume (breathing sensation)
live_loop :amp_mod_control_loop do
  amp_val = (line 0.3, 0.5, steps: 100, mirror: true).tick # `tick` automatically returns a value from the `line` sequence in each iteration.
  set :amp_control_val, amp_val # `set` now stores a numerical value.
  sleep 0.25 # Speed of volume change
end


# --- Section 2: Floating & Non-Linear Harmonies with Evolving Filters ---
# Adding notes that induce a sense of expansion and uncertainty.
live_loop :floating_harmonies do
  sync :core_pad
  use_synth :tri # Triangle synthesizer for a soft and suspended sound
  
  # Dynamic control for filter cutoff and resonance
  cutoff_val = (line 50, 90, steps: 150, mirror: true).tick
  res_val = (line 0.5, 0.9, steps: 150, mirror: true).tick
  
  with_fx :lpf, cutoff: cutoff_val, res: res_val do # Low-pass filter with variable resonance for a subtle and evolving "growl"
    with_fx :wobble, phase: 10, phase_slide: 10, res: 0.3, invert_wave: 1 do # Deeper wobble for slow and irregular oscillations
      # Notes with unusual harmonic relationships or slow changes from an ambiguous scale
      # Using a pentatonic scale or eastern scales for a spiritual feel
      current_note = scale(hz_to_midi(base_freq * 0.75), :major_pentatonic, num_octaves: 2).shuffle.tick # Ensuring `current_note` is a number, not an array, using .tick
      
      play current_note, amp: 0.15, attack: 10, release: 15, pan: rrand(-0.8, 0.8), pan_slide: 5 # Random panning with slide for smooth spatial movement
      sleep [15, 20, 25].choose # Irregular and longer time intervals
    end
  end
end

# --- Section 3: Deep, Resonating Bass Layer with Evolving Vowel ---
# To create a sense of endless depth and immersion.
live_loop :deep_resonances do
  sync :core_pad
  use_synth :sine # Sine synthesizer for very low and deep frequencies
  
  # Dynamic control for vowel sound
  vowel_idx = (ring 1, 2, 3, 4, 5).tick # Cycle through vowel sounds
  
  with_fx :hpf, cutoff: 20 do # High-pass filter to remove unnecessary very low frequencies
    with_fx :vowel, vowel_sound: vowel_idx, vowel_sound_slide: 20 do # Evolving vowel effect for a vibrating "whisper" sensation
      with_fx :echo, phase: 12, decay: 25, mix: 0.5 do # Very long echo for gradual and deeper fade-out
        with_fx :slicer, phase: 8, mix: 0.1, pulse_width: 0.5 do # Very subtle slicer for a variable texture
          play hz_to_midi(base_freq * 0.25), amp: 0.2, attack: 15, release: 25 # Very long and deep note
          sleep 40 # Very slow changes
        end
      end
    end
  end
end

# --- Section 4: Ethereal & Random Glitches with New Textures ---
# Adding unexpected and spatial sonic details to stimulate perception.
live_loop :ethereal_sounds do
  sync :core_pad
  use_synth :fm # FM synthesizer for metallic and spatial sounds
  
  with_fx :pitch_shift, mix: 0.6, time_warp: 0.3 do # Deeper pitch shift for a "detached" sound sensation
    with_fx :ping_pong, phase: 3, mix: 0.8 do # Stronger ping-pong for sound movement in space
      sleep [8, 12, 18, 22, 28].choose # Irregular and longer intervals
      
      if one_in(2) # Plays with higher probability
        play hz_to_midi(base_freq * rrand(1.5, 2.5)), amp: 0.03, release: rrand(1, 5), pan: rrand(-1, 1), cutoff: rrand(80, 120) # Higher frequencies with random pan, variable release, and random cutoff
      end
      
      if one_in(3) # Higher probability for a spatial noise or ambient texture
        sample_choice = [:ambi_choir, :ambi_lunar_land, :ambi_drone].choose # Random selection from ambient samples
        sample sample_choice, amp: 0.015, rate: rrand(0.05, 0.3), pan: rrand(-1, 1), attack: 5, release: 10 # Sample with very slow rate and long attack/release
      end
      
      if one_in(5) # Adding a subtle glitch texture
        with_fx :bitcrusher, mix: 0.05, bits: 8 do # Very subtle bitcrusher
          synth :noise, amp: 0.008, release: 0.5, pan: rrand(-1, 1) # Short and sharp noise
        end
      end
    end
  end
end

# --- Section 5: Ethereal Cosmic Dust ---
# Adding a very subtle and evolving textural layer for greater spatial depth.
live_loop :cosmic_dust do
  sync :core_pad # Synchronization with the main pad for coherence
  use_synth :prophet # Synthesizer capable of creating warm and evolving sounds

  with_fx :reverb, room: 0.95, mix: 0.85, damp: 0.8 do # Very large reverb for a sense of vast space
    # Replacing :chorus with :flanger and adjusting parameters for a similar effect
    with_fx :flanger, phase: rrand(0.5, 4), depth: rrand(0.1, 0.5), decay: rrand(1, 5), mix: rrand(0.3, 0.6) do # Flanger effect for movement and shimmer
      # Very high and sparse notes, with slight variations for an organic feel
      # Using higher multiples of the base frequency and adding a fifth for harmony
      note_value = hz_to_midi(base_freq * [2, 3].choose * 1.5) + rrand_i(-2, 2) 
      
      play note_value,
        amp: rrand(0.004, 0.02), # Very low volume for a subtle background texture
        attack: rrand(8, 18),    # Long attack for soft entry of sound
        release: rrand(12, 22),  # Long release for gradual fade-out
        cutoff: rrand(85, 115),  # Variable cutoff for changing sound color
        pan: rrand(-0.95, 0.95), # Wide and variable panning
        pan_slide: rrand(8, 15)  # Pan slide for smooth movement in space
      
      sleep [22, 33, 44].choose # Long and irregular time intervals for unpredictability
    end
  end
end

# --- Section 6: Healing & Grounding Resonance ---
# This section is designed to create a calming and stable underlying layer that aids the therapeutic feel of the music.
live_loop :healing_drone do
  sync :core_pad # Synchronization with the main pad for coherence
  use_synth :hollow # Synthesizer with a warm and gentle sound, suitable for a sense of calm

  # Selecting a very low and stable note, related to the base frequency for a grounding feel
  # Lower octaves of the base frequency or fixed notes in calming scales can be used.
  # Here, a fixed low note is used.
  drone_note = :c2 # A low and stable note

  with_fx :reverb, room: 0.9, mix: 0.7, damp: 0.7 do # Soft reverb to create space
    with_fx :lpf, cutoff: 70, cutoff_slide: 20 do |lpf_fx| # Low-pass filter for softer sound
      control lpf_fx, cutoff: rrand(50, 80) # Very slow changes in filter cutoff
      
      play drone_note,
        amp: 0.08,         # Low volume to sit in the background and create a sense of calm
        attack: 20,        # Very long attack for soft and gradual entry of sound
        sustain: 30,       # Long sustain of the sound
        release: 25,       # Very long release for a gentle fade-out
        pan: rrand(-0.3, 0.3), # Gentle and centered panning
        pan_slide: 15
      
      sleep 50 # Very long time intervals to create a sense of stability and stillness
    end
  end
end

