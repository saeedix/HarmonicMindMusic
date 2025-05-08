# -*- encoding: utf-8 -*-
use_debug false
use_sched_ahead_time 2 # Increase scheduling ahead time for better management of multiple loops
start_time = Time.now

# Inspired parameters (not strict scientific implementation)
theta_freq_inspiration = 40
beta_freq_inspiration = 18
binaural_beat_inspiration = 0.5

# ---------------------------
# Phase 1: Introduction (0-15 minutes) - 0 to 900 seconds
# ---------------------------

# Main drone
live_loop :neural_drones do
  elapsed = Time.now - start_time
  stop if elapsed > 4500 # Stop everything after 75 minutes

  current_phase = elapsed / 4500.0

  if elapsed <= 900 # Only in the first 15 minutes
    phase_1_progress = elapsed / 900.0 # 0.0 to 1.0
    current_amp = 0.7 * (1.0 - phase_1_progress)
    current_cutoff = rrand(60 - phase_1_progress * 10, 80 - phase_1_progress * 10)

    # Subtle effect changes
    with_fx :reverb, room: 0.8, mix: 0.6, damp: 0.5 do
      with_fx :ixi_techno, phase: rrand(10, 60), phase_offset: rand, cutoff_min: 50, cutoff_max: 90, res: rrand(0.1, 0.5), mix: rrand(0.2, 0.5) do
        synth :dark_ambience, note: :c2, attack: 15, release: 15, amp: current_amp, cutoff: current_cutoff
      end
    end
  end
  sleep 15
end

# Second drone layer (for richer texture)
live_loop :drone_layer2 do
  elapsed = Time.now - start_time
  stop if elapsed > 900 # Only in phase 1

  if elapsed < 900 # Only in the first 15 minutes
    phase_1_progress = elapsed / 900.0
    current_amp = 0.5 * (1.0 - phase_1_progress)

    with_fx :reverb, room: 0.9, mix: 0.5 do
      # Different synth with slow modulation
      synth :prophet, note: :g1, attack: 20, release: 20, amp: current_amp, cutoff: rrand(50, 70), detune: rrand(0.05, 0.2)
    end
  end
  sleep 22 # Different sleep time to create a sense of imperfect alignment
end

# ---------------------------
# Phase 2: Tension Build-up (15-45 minutes) - 900 to 2700 seconds
# ---------------------------

# Main heartbeat (with variations)
live_loop :doomsday_clock do
  elapsed = Time.now - start_time
  stop if elapsed > 2700

  if elapsed >= 900
    phase_2_progress = (elapsed - 900.0) / (2700.0 - 900.0)
    current_distort = 0.2 + (phase_2_progress * 0.6) # Distortion increases from 0.2 to 0.8
    current_amp = [0.1, 1.2 - (phase_2_progress * 1.0)].max
    current_rate = [0.8, 1.0, 1.2, 1.4].choose * (1 + phase_2_progress * 0.5) # Slightly faster rate

    # Slicer effect for glitchy, stuttering feel
    with_fx :slicer, phase: [0.125, 0.25].choose, probability: 0.1 + phase_2_progress*0.3, mix: rrand(0.3, 0.7) do
      with_fx :distortion, distort: current_distort, mix: rrand(0.6, 0.9) do
        sample :drum_bass_hard, rate: current_rate, amp: current_amp, pan: rrand(-0.2, 0.2)
      end
    end

    sleep_time = rrand(2.5 - (phase_2_progress * 1.8), 4.0 - (phase_2_progress * 2.5))
    sleep [0.3, sleep_time].max
  else
    sleep 5
  end
end

# Secondary warning rhythm (to increase tension)
live_loop :warning_rhythm do
  # Ensure phase_2_progress is defined even if the loop runs before elapsed >= 1200
  phase_2_progress = 0
  elapsed = Time.now - start_time
  stop if elapsed > 2700

  if elapsed >= 1200 && elapsed < 2700 # Starts a bit later than the heartbeat
    phase_2_progress = (elapsed - 900.0) / (2700.0 - 900.0) # Recalculate if in the active time
    current_amp = 0.1 + (phase_2_progress * 0.4) # Gradually increases in volume
    current_rate = 1.0 + (phase_2_progress * 1.5) # Gets faster

    # Use filter for a distant or muffled feel
    # Ensure calculated cutoff for hpf stays within valid MIDI range (e.g., 0-130)
    hpf_cutoff = [0, 80 + phase_2_progress * 20].max # Prevent negative cutoff
    hpf_cutoff = [hpf_cutoff, 130].min # Prevent cutoff > 130
    with_fx :hpf, cutoff: hpf_cutoff do
      with_fx :echo, phase: 0.3, decay: 2, mix: 0.4 do
        if rand < 0.4 # Sometimes play
          sample :elec_blip2, rate: current_rate, amp: current_amp * rrand(0.7, 1.0), pan: rrand(-0.6, 0.6)
        end
      end
    end
  end
  # Calculate sleep time outside the if block, ensuring phase_2_progress has a value
  sleep_duration = [0.25, 0.5, 0.75].choose / (1 + phase_2_progress * 1.0)
  sleep [0.1, sleep_duration].max # Ensure minimum sleep time
end

# ---------------------------
# Phase 3: Climax (45-60 minutes) - 2700 to 3600 seconds
# ---------------------------

# Main chaos harmony (intensified)
live_loop :nuclear_meltdown do
  elapsed = Time.now - start_time
  stop if elapsed > 3600

  if elapsed >= 2700
    phase_3_progress = (elapsed - 2700.0) / (3600.0 - 2700.0)
    current_amp = [0.1, 1.8 - (phase_3_progress * 1.5)].max
    # More FM parameter changes
    # Use tick for line to ensure it progresses correctly within the loop
    current_divisor = line(0.5, 3.0, steps: 30).reflect.tick(:fm_div_meltdown)
    current_depth = line(1, 10, steps: 40).reflect.tick(:fm_depth_meltdown)

    # Add bitcrusher effect for more harshness
    with_fx :bitcrusher, bits: rrand(4, 8), sample_rate: rrand(5000, 15000), mix: phase_3_progress * 0.6 do
      use_synth :fm
      play chord(:e3, :diminished7).choose, attack: 0.01, release: rrand(0.1, 0.3), amp: current_amp * rrand(0.8, 1.2), divisor: current_divisor, depth: current_depth, pan: rrand(-1, 1)
    end

    sleep_modifier = 1.0 + phase_3_progress * 2.0 # Gets even faster
    sleep [0.05, 0.1, 0.15, 0.2].choose / sleep_modifier
  else
    sleep 1
  end
end

# Noise and percussive layer (to complete the chaos)
live_loop :chaos_noise_percussion do
  # Define phase_3_progress outside the if block for sleep calculation
  phase_3_progress = 0
  elapsed = Time.now - start_time
  stop if elapsed > 3600

  if elapsed >= 2700
    phase_3_progress = (elapsed - 2700.0) / (3600.0 - 2700.0) # Recalculate if active
    noise_amp = phase_3_progress * rrand(0.3, 0.8)
    perc_amp = phase_3_progress * rrand(0.5, 1.0)

    # Noise with moving filter
    if rand < 0.6
      # Use tick for line to ensure cutoff progresses
      noise_lpf_cutoff = line(130, 70, steps: 20).tick(:noise_cutoff_chaos)
      with_fx :lpf, cutoff: noise_lpf_cutoff do
        synth :noise, sustain: rrand(0.05, 0.2), release: 0.1, amp: noise_amp
      end
    end

    # Harsh, industrial percussive samples
    if one_in(4)
      sample [:perc_impact_1, :perc_impact_2, :metal_crash, :loop_industrial].choose, rate: rrand(0.8, 1.5), amp: perc_amp * rrand(0.6, 1.0)
    end
  end
  # Calculate sleep time using phase_3_progress (which has a value)
  sleep_duration = rrand(0.1, 0.3) / (1 + phase_3_progress)
  sleep [0.05, sleep_duration].max # Ensure minimum sleep time
end

# ---------------------------
# Phase 4: Post-apocalypse (60-75 minutes) - 3600 to 4500 seconds
# ---------------------------

# Main atmosphere (with more detail)
live_loop :radioactive_aftermath do
  elapsed = Time.now - start_time
  stop if elapsed > 4500

  if elapsed >= 3600
    phase_4_progress = (elapsed - 3600.0) / (4500.0 - 3600.0)
    base_amp = [0.05, 1.5 - (phase_4_progress * 1.4)].max # Slower fade out
    reverb_mix = [0.1, 0.95 - (phase_4_progress * 0.7)].max

    with_fx :gverb, room: 120, mix: reverb_mix, damp: 0.9, dry: 0.1 do
      # Main eerie sound
      if rand < 0.15
        synth :hollow, note: [:e6, :c7, :g6, :a5].choose, release: rrand(25, 45), amp: base_amp * rrand(0.5, 1.0), cutoff: rrand(70, 100)
      end

      # Improved wind sound with Band Pass Filter
      if rand < 0.4
        # Ensure centre frequency for bpf is valid (usually Hz, but check range if needed)
        bpf_centre = rrand(600, 2000)
        # Ensure noise cutoff is valid MIDI note
        noise_cutoff_aftermath = [rrand(90, 120), 130].min
        with_fx :bpf, centre: bpf_centre, res: rrand(0.3, 0.6) do # Centre frequency changes
          synth :noise, sustain: rrand(8, 15), release: 6, amp: base_amp * 0.15, cutoff: noise_cutoff_aftermath
        end
      end

      # Short, sad melody fragment (new)
      if one_in(8) # Rarely appears
        use_synth :piano
        notes = scale(:a3, :minor, num_octaves: 1).shuffle.take(3)
        play notes[0], release: 3, amp: base_amp * 0.3, pan: -0.5
        sleep rrand(0.5, 1.0)
        play notes[1], release: 4, amp: base_amp * 0.25, pan: 0.5
        sleep rrand(0.5, 1.0)
        play notes[2], release: 5, amp: base_amp * 0.2, pan: 0
      end

    end
    sleep rrand(10, 25) # Still long intervals
  else
    sleep 10
  end
end

# Geiger counter (more prominent)
live_loop :geiger_counter do
  elapsed = Time.now - start_time
  stop if elapsed > 4500

  if elapsed >= 3700 && elapsed < 4450 # Starts a bit after phase 4 and ends a bit before the end
    phase_4_progress = (elapsed - 3600.0) / (4500.0 - 3600.0)
    click_prob = 0.1 + phase_4_progress * 0.4 # Click probability increases over time
    base_amp = [0.05, 1.0 - (phase_4_progress * 0.9)].max

    if rand < click_prob
      # Use a short synth or sample for the click
      # synth :beep, note: rrand(80, 100), release: 0.01, amp: rrand(0.4, 0.8) * base_amp, pan: rrand(-1, 1)
      sample :elec_tick, rate: rrand(1.5, 3), amp: rrand(0.4, 0.8) * base_amp, pan: rrand(-1, 1)
      # Sometimes two close clicks
      sleep rrand(0.02, 0.1) if one_in(3)
      sample :elec_tick, rate: rrand(1.5, 3), amp: rrand(0.3, 0.6) * base_amp, pan: rrand(-1, 1) if one_in(3)
    end
  end
  sleep rrand(0.2, 1.5) # Irregular time between click attempts
end

# ---------------------------
# "Auditory Entrainment" system (attempt to improve the binaural concept)
# ---------------------------
live_loop :auditory_focus do
  elapsed = Time.now - start_time
  stop if elapsed > 4500

  current_phase = elapsed / 4500.0

  # --- Attempt to implement closer to binaural beats ---
  # Use low frequencies and precise panning

  base_freq = 100 + (current_phase * 30) # Base frequency changes from 100Hz to 130Hz
  beat_freq = binaural_beat_inspiration # 0.5 Hz

  # Very low amplitude for a nearly subconscious effect
  binaural_amp = 0.08 * (1.0 - current_phase) # Very low and fading

  if binaural_amp > 0.01 # Only play if amplitude is significant

    # *** Start of adjustment ***
    # Calculate cutoff frequency in Hz
    cutoff_freq_hz = base_freq + 50 # Target frequency: 150Hz to 180Hz

    # Convert cutoff frequency to MIDI note number
    cutoff_midi = hz_to_midi(cutoff_freq_hz)

    # Ensure MIDI note number is within valid range (e.g., <= 130)
    safe_cutoff_midi = [cutoff_midi, 130].min

    # Use valid MIDI note number for lpf effect cutoff
    with_fx :lpf, cutoff: safe_cutoff_midi do # <-- using safe_cutoff_midi
      use_synth :sine
      # Left ear
      play hz_to_midi(base_freq), amp: binaural_amp, pan: -1, attack: 0.1, release: 0.8
      # Right ear (slightly different frequency)
      play hz_to_midi(base_freq + beat_freq), amp: binaural_amp, pan: 1, attack: 0.1, release: 0.8
    end
    # *** End of adjustment ***

  end

  # Higher layer (beta/anxiety concept) - maybe with another synth
  if elapsed > 900 # Only after phase 1
    beta_amp = 0.15 * (current_phase - 0.2) * (1.0 - current_phase) # Arc-shaped, peaks in the middle
    beta_amp = [0, beta_amp].max
    if beta_amp > 0.01
      # Ensure play frequency is a valid MIDI note or use hz_to_midi if it's Hz
      # base_freq * 2 + rrand(-5, 5) is likely in Hz, so convert it
      play_freq_hz = base_freq * 2 + rrand(-5, 5)
      play_note_midi = hz_to_midi(play_freq_hz)
      safe_play_note_midi = [play_note_midi, 130].min # Clamp to valid MIDI range

      with_fx :tremolo, depth: 0.3, phase: rrand(0.1, 0.5) do
        use_synth :pulse
        play safe_play_note_midi , pulse_width: rrand(0.3, 0.7), release: 1.5, amp: beta_amp, pan: rrand(-0.5, 0.5) # Higher, slightly irregular frequency
      end
    end
  end

  sleep_time = [0.8, 1.0, 1.3].choose * (1.0 - (current_phase * 0.5))
  sleep [0.1, sleep_time].max # Ensure minimum sleep time
end

# ---------------------------
# Overall time control
# ---------------------------
live_loop :master_timer do
  elapsed = Time.now - start_time
  remaining = 4500 - elapsed
  if remaining <= 0
    puts "75 minutes finished."
    # You may want to implement a global fade out for all loops here
    # Using set/get and controlling amp in each loop
    stop
  end
  puts "Elapsed: #{elapsed.round}s / 4500s"
  sleep 10
end