# LSD Trip Simulation - Ultimate Psychedelic Sonic Pi Experience
# Infinite Loop Version - Phase changes every 3 minutes

use_bpm 60
use_debug false
use_real_time

### GLOBAL VARIABLES & UTILITIES
phase_time = {
  intro: 180,
  ascent: 180,
  build: 180,
  peak: 180,
  transcendence: 180,
  reflection: 180,
  cooldown: 180
} # 3 minutes per phase, infinite loop

set :trip_phase, :intro
set :start_time, Time.now

define :phase_elapsed? do |phase|
  Time.now - get(:start_time) > phase_time[phase]
end

define :trigger_phase_switch do
  current = get(:trip_phase)
  phase_order = [:intro, :ascent, :build, :peak, :transcendence, :reflection, :cooldown]
  next_phase = phase_order[(phase_order.index(current) + 1) % phase_order.size]
  set :trip_phase, next_phase
  set :start_time, Time.now
  puts "=== PHASE CHANGE: #{next_phase.upcase} ==="
end

in_thread(name: :phase_controller) do
  loop do
    sleep_interval = (get(:trip_phase) == :peak ? 1 : 2)
    trigger_phase_switch if phase_elapsed?(get(:trip_phase))
    sleep sleep_interval
  end
end

### HYPNOTIC BRAINWAVE ENTRAINMENT
live_loop :brainwave_entrainment do
  sync :tick
  use_synth :sine
  with_fx :ping_pong, phase: 0.25 do
    play 200, pan: -0.8, amp: 0.3 * 1.4, release: 2
    play 204, pan: 0.8, amp: 0.3 * 1.4, release: 2
  end
  sleep 4
end

### TRANCE RHYTHM GENERATOR
live_loop :trance_rhythm do
  sync :tick
  with_fx :rlpf, cutoff: 100 do
    sample :drum_cymbal_pedal,
      rate: 1.5,
      amp: 0.2 * 1.4,
      hpf: 60
    sleep 0.5
  end
end

### SEROTONIN SPARKLES
live_loop :serotonin_sparkles do
  use_synth :pluck
  with_fx :hpf, cutoff: 90 do
    with_fx :reverb, mix: 0.2, room: 0.8 do
      play chord(:e5, :major7).choose,
        release: 0.03,
        amp: rand * 0.52,
        pan: rrand(-0.5, 0.5)
      sleep 0.25
    end
  end
end

### DOPAMINE RUSH GENERATOR
live_loop :dopamine_rush do
  sync :moment_silence
  with_fx :distortion, distort: 0.7 do
    sample :bass_drop_c, rate: 0.75, amp: 1.2 * 1.4, pitch: -12
    sleep 2
  end
end

### ENHANCED NATURE AMBIENCE
live_loop :nature_ambience do
  with_fx :echo, phase: 0.5, decay: 1 do
    sample :ambi_choir,
      rate: rrand(-0.3, 0.3),
      amp: 0.2 * 1.4,
      pan: 0
    sleep rrand(4, 8)
  end
end

### NEURO-OSCILLATING BASS
live_loop :neuro_bass do
  sync :tick
  use_synth :fm
  with_fx :slicer, phase: 0.25 do
    play :c1, release: 4, cutoff: 90, amp: 0.45 * 1.4, depth: 2
    sleep 4
  end
end

### PSYCHEDELIC PATTERN GENERATOR
live_loop :fractal_patterns do
  use_random_seed Time.now.to_i % 200
  with_fx :slicer, phase: 0.25 do
    4.times do
      play scale(:c4, :chromatic).choose,
        release: 0.02,
        amp: rand * 0.1,
        pan: 0,
        cutoff: 110
      sleep 0.25
    end
  end
end

### ENHANCED MICROTONAL TEXTURE
live_loop :microtonal do
  sync :tick
  use_synth :blade
  with_fx :reverb, room: 0.9, mix: 0.6 do
    with_fx :echo, phase: 0.375, decay: 4 do
      with_fx :pitch_shift, pitch: 5 do
        degree = choose(scale(:c4, :egyptian, num_octaves: 2)) + rrand(-0.1, 0.1)
        play degree, attack: 1.5, release: 5, amp: 0.09, cutoff: 90, pan: rrand(-0.5, 0.5)
      end
    end
  end
  sleep 2
end



### TIMING CONTROL
live_loop :metronome do
  cue :tick
  sleep 1
end

puts "NEURO-CHEMICAL SYNTHESIS ENGINE ACTIVATED!"
