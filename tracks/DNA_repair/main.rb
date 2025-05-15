use_bpm 60 # Slow tempo

# --- Overall Mix Settings ---
# These settings can be placed at the beginning or end of the code.
set_mixer_control! lpf: 90, lpf_slope: 2 # Low-pass filter to soften the overall sound
set_mixer_control! amp: 3.0 # Adjust overall volume

# --- Section 1: Background Pad & Atmosphere ---
live_loop :ambient_pad do
  # Using :hollow synth to create a soft and spacious pad
  # Slowly changing major and minor chords to induce calmness
  chords = [(chord :C3, :major7, num_octaves: 2),
            (chord :F2, :major7, num_octaves: 2),
            (chord :A2, :minor7, num_octaves: 2),
            (chord :G2, :dom7, num_octaves: 2)] # Corrected: changed from :dominant7 to :dom7
  
  c = chords.tick
  synth :hollow, note: c, attack: 8, sustain: 8, release: 8, amp: 0.8, cutoff: rrand(70, 100)
  sleep 16
end

# --- Section 2: Gentle Evolving Melody ---
live_loop :gentle_melody do
  sync :ambient_pad # Sync with background pad
  # Using :prophet synth with reverb for a soft melody
  # Pentatonic scale provides a soothing, meditative feel
  notes = (scale :C4, :minor_pentatonic, num_octaves: 1).shuffle
  
  with_fx :reverb, room: 0.8, mix: 0.6 do
    8.times do
      play notes.tick, release: rrand(0.5, 2), amp: rrand(0.3, 0.5), pan: rrand(-0.5, 0.5)
      sleep [1, 1.5, 2].choose
    end
  end
  sleep 8
end

# --- Section 3: Subtle Low-Frequency Pulses ---
live_loop :bass_pulse do
  sync :ambient_pad # Better sync with pad start
  # Low bass pulse to create a sense of grounding and depth
  # Low frequencies can evoke a feeling of stability
  use_synth :zawa # Synth capable of producing textured low frequencies
  play :C2, attack: 4, sustain: 4, release: 4, amp: 0.6, cutoff: rrand(50, 70) # Bass note ~65 Hz
  sleep 16
  play :F1, attack: 4, sustain: 4, release: 4, amp: 0.6, cutoff: rrand(45, 65) # Bass note ~43 Hz
  sleep 16
end

# --- Section 4: Nature Sounds or Organic Textures (Optional) ---
# You can add recorded nature sounds like water or wind if desired.
live_loop :nature_sounds do
  sync :ambient_pad
  sample :ambi_lunar_land, amp: 0.3, rate: 0.5 # Example: a spacey ambient sound
  sleep 20
end

# --- Section 5: Subtle Shimmer Effects for Atmosphere ---
live_loop :shimmer do
  # Subtle shimmering effect using :blade synth and high notes
  # Symbolizes "healing" or "energy"
  sync :ambient_pad
  notes = [:C6, :E6, :G6, :B6, :D7] # Added a higher note for variety
  with_fx :echo, phase: 0.75, decay: 8, mix: 0.4 do
    synth :blade, note: notes.choose, release: rrand(1.5, 3), amp: rrand(0.1, 0.25), cutoff: rrand(90, 125)
  end
  sleep [2, 3, 4].choose # Add timing variations
end

# To stop all loops:
# uncomment and run -> stop
