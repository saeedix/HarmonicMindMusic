use_bpm 58
use_tuning :just
transition_counter = 0
global_phase = (line 0, 1, steps: 60*60, inclusive: true) # One-hour progression

# Temporal architecture: cues the global progress every second
live_loop :temporal_architecture do
  tick
  cue :global_progress, global_phase.look
  sleep 1
end

# Dynamic evolution: responds to global progress and triggers transitions
live_loop :dynamic_evolution do
  sync :global_progress
  current_phase = look(:global_progress)
  
  # Dynamic changes based on natural attention cycles
  if current_phase % 0.0833 < 0.001 # Every 5 minutes
    transition_counter += 1
    cue :morph_transition, transition_counter
  end
  
  # Update fluid parameters
  control :harmonic_bed, room: 0.8 + (Math.sin(current_phase*2*Math::PI)*0.1)
  control get(:solfeggio_frequency), amp: 0.08 + (Math.cos(current_phase*4*Math::PI)*0.02)
end

# Solfeggio frequency layer: gentle sine wave, modulated by transitions
live_loop :solfeggio_frequency do
  synth :sine, note: :E5 + 0.31 + (Math.sin(transition_counter*0.5)*0.01),
    amp: 0.1, release: 8, cutoff: 90 + (transition_counter % 4)*10
  sleep 8
end

# Harmonic bed: evolving chords with reverb and echo, modulated by transitions
live_loop :harmonic_bed do
  with_fx :reverb, room: 0.9, damp: 1 do
    with_fx :echo, phase: 1.618, decay: 8, mix: 0.3 do
      chords = (ring chord(:C3, :m7), chord(:G3, :major7), chord(:D3, :sus4), chord(:A3, :add9))
      synth :hollow, note: chords.look + (transition_counter % 2)*0.01,
        sustain: 8, release: 4, cutoff: 80 + (transition_counter % 8)*5, amp: 0.6
      sleep 8
    end
  end
end

# Binaural beats: two sine waves panned left and right, with subtle frequency and rhythm modulation
live_loop :binaural_beats do
  current_phase = look(:global_progress)
  delta = 0.1 + (Math.sin(current_phase*Math::PI*2)*0.05) # Harmonic variation
  with_fx :pan, pan: -0.5 do
    synth :sine, note: :C3 + delta, amp: 0.15, release: 4
  end
  with_fx :pan, pan: 0.5 do
    synth :sine, note: :C3 + 0.1 + delta, amp: 0.15, release: 4
  end
  sleep 4 + (Math.cos(current_phase*Math::PI*8)*0.25) # Subtle rhythmic variation
end

# Neuro-entrainment: percussive layer triggered by morph transitions, with evolving filter and stereo movement
live_loop :neuro_entrainment do
  sync :morph_transition
  use_random_seed Time.now.to_i ^ transition_counter
  density [1, 0.5, 2].choose do
    max_cutoff = [120 + (transition_counter % 6)*20, 130].min # Cutoff limit
    with_fx :lpf, cutoff: max_cutoff do
      8.times do |n|
        sample :drum_tom_hi_hard, rate: rrand(0.5, 2),
          pan: (Math.sin(n*0.5 + transition_counter)*0.7),
          amp: 0.1 * (1.0 - n/8.0)
        sleep 0.25
      end
    end
  end
end

# Alpha waves: deep, slow-moving synth layer, modulated by transitions and filtered for safety
live_loop :alpha_waves do
  sync :morph_transition
  with_fx :ixi_techno, phase: 16 - (transition_counter % 4), res: 0.8 do
    calculated_cutoff = 90 + (transition_counter % 4)*10 # Safe calculation
    safe_cutoff = [calculated_cutoff, 130].min # Apply cutoff limit
    with_fx :lpf, cutoff: safe_cutoff do
      synth :growl, note: :C2 - (transition_counter % 3),
        amp: 0.05 + (Math.sin(transition_counter)*0.01),
        release: 16 - (transition_counter % 4)
    end
  end
  sleep 16
end