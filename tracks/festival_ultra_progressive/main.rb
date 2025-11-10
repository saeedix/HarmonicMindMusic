# ==========================================================
# ⚡ ALGORITHMIC MUSIC LAB — FESTIVAL ULTRA PROGRESSIVE
# ==========================================================
# Author: @AlgorithmicMusicLab
# Description:
#   A high energy, progressive, festival-style electronic track.
#   Features:
#     - 3 Drops with dynamic energy progression
#     - Bridge melodies and short Fill FX between Drops
#     - Layered Bassline, Chords, Pads, and DJ FX
#     - Fully synchronized loops to avoid timing errors
#     - Progressive energy growth to maximize engagement
# ==========================================================

use_bpm 126

# --------------------------
# Track Structure (Bars)
# --------------------------
intro_bars    = 16
build_bars    = 16
bridge_bars   = 8
drop_bars     = 32
fill_bars     = 8
second_drop   = 32
third_drop    = 32
outro_bars    = 16
cycle_bars    = intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars + third_drop + outro_bars

set :bar_count, 0

# --------------------------
# Helper Functions
# --------------------------
define :energy_level do |bar|
  # Returns a dynamic energy factor (0..1.4) based on bar count
  if bar < intro_bars
    return 0.4 + (bar.to_f / intro_bars) * 0.4
  elsif bar < intro_bars + build_bars
    return 0.8 + ((bar - intro_bars).to_f / build_bars) * 0.4
  elsif bar < intro_bars + build_bars + bridge_bars
    return 1.0 + ((bar - (intro_bars + build_bars)).to_f / bridge_bars) * 0.2
  elsif bar < intro_bars + build_bars + bridge_bars + drop_bars
    drop_progress = (bar - (intro_bars + build_bars + bridge_bars)).to_f / drop_bars
    return 1.2 + 0.2 * Math.sin(drop_progress * Math::PI)
  elsif bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars
    fill_progress = (bar - (intro_bars + build_bars + bridge_bars + drop_bars)).to_f / fill_bars
    return 1.0 + 0.3 * Math.sin(fill_progress * Math::PI*2)
  elsif bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop
    drop_progress = (bar - (intro_bars + build_bars + bridge_bars + drop_bars + fill_bars)).to_f / second_drop
    return 1.3 + 0.2 * Math.sin(drop_progress * Math::PI)
  elsif bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars
    fill_progress = (bar - (intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop)).to_f / fill_bars
    return 1.1 + 0.25 * Math.sin(fill_progress * Math::PI*2)
  elsif bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars + third_drop
    drop_progress = (bar - (intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars)).to_f / third_drop
    return 1.35 + 0.25 * Math.sin(drop_progress * Math::PI)
  else
    return [[0.6 - ((bar - (intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars + third_drop)).to_f / outro_bars) * 0.4, 0].max, 0].max
  end
end

define :cutoff_from_energy do |energy|
  [[70 + (energy * 40), 0].max, 130].min
end

# --------------------------
# Clock / Bar Counter
# --------------------------
live_loop :clock do
  cue :bar
  set :bar_count, get(:bar_count) + 1
  sleep 1
end

# --------------------------
# Kick Drum
# --------------------------
live_loop :kick, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)
  sample :bd_haus, amp: [2.2 + (energy * 1.5), 0].max
  sleep 1
end

# --------------------------
# Hi-Hats
# --------------------------
live_loop :hats, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)

  8.times do
    sample :drum_cymbal_closed, amp: [0.4 + energy * 0.6, 0].max, sustain: 0, release: 0.03
    sleep 0.5
  end

  if energy > 0.8
    sample :drum_cymbal_open, amp: [0.6 + energy*0.7, 0].max, sustain: 0.05, release: 0.15
  end
end

# --------------------------
# Snare / Clap
# --------------------------
live_loop :snare, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)

  sleep 1
  sample :sn_dub, amp: [1.2 + energy*0.7, 0].max
  sleep 2
  sample :sn_dub, amp: [1.2 + energy*0.7, 0].max
end

# --------------------------
# Layered Bassline
# --------------------------
live_loop :bass, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)
  use_synth :tb303
  cutoff = cutoff_from_energy(energy)

  pattern = (ring :a2, :e2, :g2, :a2, :c3, :b2, :a2, :e2)
  rhythm  = (ring 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 1)

  8.times do |i|
    play pattern[i], release: rhythm[i]*0.9,
         cutoff: [[cutoff + rrand(-5, 10) + Math.sin(bar*0.2)*10, 0].max, 130].min,
         res: 0.7,
         amp: [1.6 + energy*1.5, 0].max

    with_fx :slicer, phase: 0.125 do
      with_fx :flanger, phase: 0.25, mix: 0.3 do
        play pattern[i], release: rhythm[i]*0.6,
             cutoff: [[cutoff - rrand(5, 15), 0].max, 130].min,
             res: 0.6,
             amp: [0.7 + energy*0.8, 0].max,
             pan: rrand(-0.3, 0.3)
      end
    end
    sleep rhythm[i]
  end
end

# --------------------------
# Layered Chords
# --------------------------
live_loop :chords, sync: :bar do
  use_synth :prophet
  bar = get(:bar_count)
  energy = energy_level(bar)

  chord_prog = (ring chord(:a3, :minor), chord(:f3, :major7),
                chord(:g3, :dom7), chord(:e3, :minor))
  slicer_phase = (ring 0.25, 0.125, 0.0625, 0.125, 0.25)[bar % 5]

  4.times do |i|
    ch = chord_prog[i]
    prob = [[0.7 + (energy*0.2), 0].max, 1].min
    pan_val = Math.sin(bar*0.1 + i) * 0.5
    cutoff_var = [[cutoff_from_energy(energy) + rrand(-5,5) + Math.sin(bar*0.15)*10, 0].max, 130].min

    with_fx :slicer, phase: slicer_phase, probability: prob do
      with_fx :reverb, room: 0.7, mix: 0.35 do
        with_fx :echo, phase: [0.25,0.125].choose, decay: 1.5, mix: 0.25 do
          play ch, release: 0.3, attack: 0.01,
               amp: [0.6 + energy*0.9, 0].max,
               cutoff: cutoff_var,
               pan: pan_val
        end
      end
    end

    with_fx :echo, phase: 0.5, decay: 2, mix: 0.2 do
      play ch, release: 0.4, attack: 0.05,
           amp: [0.3 + energy*0.4, 0].max,
           cutoff: [[cutoff_var - 10, 0].max, 130].min,
           pan: -pan_val
    end
    sleep 1
  end
end

# --------------------------
# Bridge & Fill FX
# --------------------------
live_loop :bridge_fill, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)

  # Bridge Melody
  if bar >= intro_bars + build_bars && bar < intro_bars + build_bars + bridge_bars
    use_synth :sine
    play_pattern = (ring :c4, :d4, :e4, :g4)
    play_pattern.each do |n|
      play n, release: 0.4, amp: [0.3 + energy*0.5, 0].max
      sleep 0.5
    end
  # Fill FX after Drops
  elsif (bar >= intro_bars + build_bars + bridge_bars + drop_bars &&
         bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars) ||
        (bar >= intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop &&
         bar < intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars)
    use_synth :fm
    8.times do
      play :e4, release: 0.2, amp: [0.2 + energy*0.4,0].max, pan: rrand(-0.5,0.5)
      sleep 0.25
    end
  else
    sleep 1
  end
end

# --------------------------
# Pads Layered
# --------------------------
live_loop :pad, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)
  use_synth :blade
  cutoff = cutoff_from_energy(energy)

  sustain_val = 4 + Math.sin(bar*0.05)*3
  amp_val = [0.4 + energy*0.5 + Math.sin(bar*0.08)*0.3, 0].max

  with_fx :reverb, room: 0.85, mix: 0.5 do
    with_fx :echo, phase: 0.375, decay: 2 do
      play_chord chord(:a4, :minor), sustain: sustain_val, amp: amp_val, cutoff: cutoff
    end
  end

  with_fx :reverb, room: 0.9, mix: 0.3 do
    play_chord chord(:e4, :minor),
               sustain: sustain_val*0.6,
               amp: amp_val*0.6,
               cutoff: [[cutoff-10,0].max,130].min,
               pan: rrand(-0.3,0.3)
  end
  sleep 4
end

# --------------------------
# DJ Sweeps / Transition FX
# --------------------------
live_loop :dj_transition, sync: :bar do
  bar = get(:bar_count)
  energy = energy_level(bar)

  if (bar % cycle_bars) > 48 && (bar % cycle_bars) < 56
    with_fx :reverb, mix: 0.5 do
      with_fx :echo, phase: 0.25, decay: 1.0, mix: 0.3 do
        use_synth :mod_sine
        play :a4, release: 0.25, amp: [0.3 + energy*0.5, 0].max,
             cutoff: 80 + (bar%8)*5
      end
    end

    use_synth :noise
    with_fx :hpf, cutoff: 70 do
      play :a4, sustain: 0.15, amp: [0.2 + energy*0.3, 0].max
    end
  end

  sleep 1
end

# --------------------------
# Outro / Soft Fade
# --------------------------
live_loop :outro, sync: :bar do
  bar = get(:bar_count)
  if bar > intro_bars + build_bars + bridge_bars + drop_bars + fill_bars + second_drop + fill_bars + third_drop
    with_fx :echo, phase: 0.25, decay: 2 do
      sample :drum_splash_soft, amp: 0.7
    end
  end
  sleep 8
end
