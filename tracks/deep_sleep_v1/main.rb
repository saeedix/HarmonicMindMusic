use_bpm 60

# پایه ریتمیک تتا (تحریک امواج مغزی)
live_loop :theta_binaural do
  use_synth :hollow
  play :C2, attack: 4, release: 4, pan: -0.5, amp: 0.7  # افزایش 30 درصدی بلندی
  play :C3, attack: 4, release: 4, pan: 0.5, amp: 0.7  # افزایش 30 درصدی بلندی
  sleep 8
end

# ملودی اصلی با نسبتهای طلایی (1.618)
live_loop :golden_ratio_melody do
  use_synth :piano
  with_fx :reverb, room: 0.8 do
    notes = [:c3, :e3, :g3, :b3]
    durations = [1.618, 2.618, 1.618, 3.618]
    idx = tick
    play notes[idx % notes.length], attack: 3, release: 5, amp: 0.6  # افزایش 30 درصدی بلندی
    sleep durations[idx % durations.length]
  end
end

# پسزمینه نوروساینس (فرکانسهای دلتا)
live_loop :delta_pads do
  use_synth :dark_ambience
  with_fx :gverb, damp: 1 do
    play chord(:c2, :m7), attack: 8, decay: 8, sustain: 8, release: 8, cutoff: 60, amp: 0.42  # افزایش 30 درصدی بلندی
  end
  sleep 16
end

# ریتم بیولوژیک (هماهنگ با تنفس طبیعی)
live_loop :respiratory_rhythm do
  sample :ambi_soft_buzz, rate: 0.5, attack: 5, release: 5, pan: -0.3, amp: 0.9  # افزایش 30 درصدی بلندی
  sleep 13
end

# تحریک گاما با صدای نرم‌تر و فرکانس پایین‌تر
live_loop :gamma_entrainment do
  use_synth :hollow
  play :c3,
    attack: 0.5,
    sustain: 0,
    release: 1,
    amp: 0.27 + rrand(0, 0.069),  # افزایش 30 درصدی بلندی
    pan: Math.sin(vt * 2 * Math::PI)
  sleep 0.066
end

# سیستم کاهش اضطراب خودکار
live_loop :amygdala_soothe do
  with_fx :echo, phase: 1.618 do
    use_synth :blade
    play 60, attack: 7, release: 7, cutoff: 60, amp: 0.72  # افزایش 30 درصدی بلندی
  end
  sleep 15
end
