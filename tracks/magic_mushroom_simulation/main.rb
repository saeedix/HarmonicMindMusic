use_bpm 60
set_mixer_control! lpf: 110, amp: 6.0
use_debug false
use_tuning :pythagorean

# tick helper
define :v_tick do
  tick(:vt)
end

# A simple clamp function to keep value v within [lo, hi]
define :clamp_val do |v, lo, hi|
  [[v, hi].min, lo].max
end

# Advanced neural modulation system
define :neuro_mod do |rng = (0.1..1.0)|
  lo = rng.begin
  hi = rng.end
  val = (Math.sin(v_tick * 0.1) * (hi - lo)) + lo
  clamp_val(val, lo, hi)
end

# 1. Serotonergic system
live_loop :serotonin_flood do
  use_random_seed Time.now.to_i % 1000
  use_synth :hollow
  with_fx :gverb, spread: 0.95, damp: 0.9, mix: neuro_mod(0.5..0.8) do
    with_fx :panslicer, phase: [1.618, 2.618].choose, wave: 3 do
      3.times do
        play chord(:e2, [:m7, :add9, :major7].choose).shuffle.tick,
          attack: 7 * neuro_mod(0.1..1.0),
          release: 7 / neuro_mod(0.5..1.5),
          pan: line(-0.8, 0.8, steps: 13).tick,
          cutoff: 60 + (neuro_mod(0.1..1.0) * 60),
          amp: 0.9 * neuro_mod(0.75..1.8)
        sleep [5, 8, 13].choose * 0.618
      end
    end
  end
end

# 2. Dynamic synthesis
live_loop :sensory_fusion do
  use_synth :chipbass
  with_fx :slicer, phase: 0.25, wave: 3, probability: 0.618 do
    with_fx :hpf, cutoff: 90, res: 0.7 do
      density [2, 4, 1].choose do
        16.times do
          play scale(:e3, :minor_pentatonic).choose + rrand(-0.33, 0.33),
            release: 0.05 * neuro_mod(0.1..1.0),
            pan: Math.sin(v_tick * 2) * 0.8,
            amp: 0.225 + (v_tick % 0.45),
            cutoff: clamp_val(80 + rand(50) * neuro_mod(0.1..1.0), 20, 130)
          sleep 0.125 * [1, 0.618, 1.618].choose
        end
      end
    end
  end
end

# 3. Temporal distortion
live_loop :temporal_chaos do
  use_random_seed Time.now.to_i % 1000
  current_rate = [0.5, 1.0, -1.0, -1.618, 2.0].choose
  clamped_rate = [[-2.0, current_rate].max, 2.0].min
  with_fx :pitch_shift, pitch: (clamped_rate * 12).round do
    sample :loop_industrial,
      rate: clamped_rate * (0.5 + neuro_mod(0.1..0.5)),
      pan: rrand(-1, 1),
      amp: 0.675 * neuro_mod(0.75..2.25),
      attack: 1.618,
      release: 3.1415,
      cutoff: 60 + rand(60)
  end
  sleep [2, 3, 5, 8].choose * 1.618
end

# 4. Somatic simulation
live_loop :somatic_waves do
  with_fx :rlpf, cutoff: 40 + (v_tick % 80), res: 0.9 do
    with_fx :echo, phase: 5, decay: 8, mix: 0.6 do
      synth :noise,
        attack: 7 * neuro_mod(0.1..1.0),
        release: 7 / neuro_mod(0.5..1.5),
        amp: 0.45 * neuro_mod(0.75..1.8),
        pan_slide: 13 * neuro_mod(0.1..1.0),
        cutoff: clamp_val(50 + rand(30) * neuro_mod(0.1..1.0), 20, 130)
    end
  end
  sleep 13 * neuro_mod(0.8..1.2)
end

# 5. Dissolution of consciousness
live_loop :consciousness_dissolve do
  use_synth :fm
  with_fx :slicer, phase: 0.618, wave: 3 do
    with_fx :pitch_shift, pitch: 12 do
      3.times do
        nmod = neuro_mod(0.5..1.5)
        safe_div = [nmod, 0.1].max
        play 60 + rrand(-1.0, 1.0),
          divisor: 1.618 * neuro_mod(0.1..1.0),
          depth: 3 * neuro_mod(0.1..1.0),
          attack: 5 * neuro_mod(0.1..1.0),
          release: 5 / safe_div,
          pan: line(-1, 1, steps: 21).tick,
          amp: clamp_val(0.56 * neuro_mod(0.75..2.25), 0.1, 1.5)
        sleep 5.236 * neuro_mod(0.8..1.2)
      end
    end
  end
end

# 6. Neural feedback
live_loop :neuro_entanglement do
  cue :neural_phase, phase: (v_tick * 100 % 360).to_i
  with_fx :ixi_techno, phase: 0.333, cutoff: 60 + rand(60) do
    with_fx :reverb, room: 0.9, damp: 0.7 do
      synth :sine,
        note: :e1 + rand_i(3),
        release: 0.1 * neuro_mod(0.1..1.0),
        amp: clamp_val(0.112 + Math.sin(v_tick) * 0.112 * neuro_mod(0.1..1.0), 0.0, 1.5),
        cutoff: clamp_val(60 + rand(60) * neuro_mod(0.1..1.0), 20, 130)
    end
  end
  sleep (0.333 * 3) * neuro_mod(0.8..1.2)
end

# 7. Emotional cascade
live_loop :emotional_cascade do
  with_fx :distortion, distort: clamp_val(0.4 + (v_tick % 0.3) * neuro_mod(0.1..1.0), 0.1, 0.9) do
    with_fx :flanger, phase: 1.618 do
      sample :ambi_choir,
        rate: [0.5, 1, -1].choose * neuro_mod(0.5..1.5),
        pan: rrand(-0.7, 0.7),
        attack: 5 * neuro_mod(0.1..1.0),
        release: 5 / clamp_val(neuro_mod(0.1..1.0), 0.1, 1.0),
        amp: clamp_val(0.675 * neuro_mod(0.75..1.8), 0.1, 1.5)
    end
  end
  sleep 21 * neuro_mod(0.8..1.2)
end

# 8. Central controller
live_loop :psychedelic_controller do
  set :global_amp, (0.75 + Math.sin(v_tick * 0.1) * 0.3) * neuro_mod(0.5..1.5)
  set :global_cutoff, clamp_val(80 + (Math.sin(v_tick * 0.05) * 60 * neuro_mod(0.1..1.0)), 20, 130)
  set :global_pan, Math.sin(v_tick * 0.07)
  sleep 5.236 * neuro_mod(0.8..1.2)
end
