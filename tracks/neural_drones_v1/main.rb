# -*- encoding: utf-8 -*-
use_debug false
use_sched_ahead_time 2 # افزایش زمان پیش پردازش برای مدیریت بهتر لوپ های متعدد
start_time = Time.now

# پارامترهای الهام گرفته شده (نه پیاده سازی دقیق علمی)
theta_freq_inspiration = 40
beta_freq_inspiration = 18
binaural_beat_inspiration = 0.5

# ---------------------------
# فاز ۱: پیشدرآمد (۰-۱۵ دقیقه) - 0 تا 900 ثانیه
# ---------------------------

# پهپاد اصلی
live_loop :neural_drones do
  elapsed = Time.now - start_time
  stop if elapsed > 4500 # توقف کلی
  
  current_phase = elapsed / 4500.0
  
  if elapsed <= 900 # فقط در 15 دقیقه اول
    phase_1_progress = elapsed / 900.0 # 0.0 to 1.0
    current_amp = 0.7 * (1.0 - phase_1_progress)
    current_cutoff = rrand(60 - phase_1_progress * 10, 80 - phase_1_progress * 10)
    
    # افکت با تغییرات نامحسوس
    with_fx :reverb, room: 0.8, mix: 0.6, damp: 0.5 do
      with_fx :ixi_techno, phase: rrand(10, 60), phase_offset: rand, cutoff_min: 50, cutoff_max: 90, res: rrand(0.1, 0.5), mix: rrand(0.2, 0.5) do
        synth :dark_ambience, note: :c2, attack: 15, release: 15, amp: current_amp, cutoff: current_cutoff
      end
    end
  end
  sleep 15
end

# لایه پهپاد دوم (برای بافت غنی تر)
live_loop :drone_layer2 do
  elapsed = Time.now - start_time
  stop if elapsed > 900 # فقط در فاز ۱
  
  if elapsed < 900 # فقط در 15 دقیقه اول
    phase_1_progress = elapsed / 900.0
    current_amp = 0.5 * (1.0 - phase_1_progress)
    
    with_fx :reverb, room: 0.9, mix: 0.5 do
      # سینت متفاوت با مدولاسیون آهسته
      synth :prophet, note: :g1, attack: 20, release: 20, amp: current_amp, cutoff: rrand(50, 70), detune: rrand(0.05, 0.2)
    end
  end
  sleep 22 # زمان خواب متفاوت برای ایجاد حس عدم تطابق کامل
end



# ---------------------------
# فاز ۲: افزایش تنش (۱۵-۴۵ دقیقه) - 900 تا 2700 ثانیه
# ---------------------------

# ضربان قلب اصلی (با تغییرات)
live_loop :doomsday_clock do
  elapsed = Time.now - start_time
  stop if elapsed > 2700
  
  if elapsed >= 900
    phase_2_progress = (elapsed - 900.0) / (2700.0 - 900.0)
    current_distort = 0.2 + (phase_2_progress * 0.6) # افزایش دیستورشن از 0.2 به 0.8
    current_amp = [0.1, 1.2 - (phase_2_progress * 1.0)].max
    current_rate = [0.8, 1.0, 1.2, 1.4].choose * (1 + phase_2_progress * 0.5) # نرخ کمی سریعتر می شود
    
    # افکت Slicer برای ایجاد حالت گلیچ یا قطع و وصل شدن
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

# ریتم هشدار دهنده فرعی (برای افزایش تنش)
live_loop :warning_rhythm do
  # Ensure phase_2_progress is defined even if the loop runs before elapsed >= 1200
  phase_2_progress = 0
  elapsed = Time.now - start_time
  stop if elapsed > 2700
  
  if elapsed >= 1200 && elapsed < 2700 # کمی دیرتر از ضربان قلب شروع شود
    phase_2_progress = (elapsed - 900.0) / (2700.0 - 900.0) # Recalculate if in the active time
    current_amp = 0.1 + (phase_2_progress * 0.4) # صدا به تدریج بیشتر می شود
    current_rate = 1.0 + (phase_2_progress * 1.5) # سرعت بیشتر می شود
    
    # استفاده از فیلتر برای حس دور بودن یا خفه بودن
    # Ensure calculated cutoff for hpf stays within valid MIDI range (e.g., 0-130)
    hpf_cutoff = [0, 80 + phase_2_progress * 20].max # Prevent negative cutoff
    hpf_cutoff = [hpf_cutoff, 130].min # Prevent cutoff > 130
    with_fx :hpf, cutoff: hpf_cutoff do
      with_fx :echo, phase: 0.3, decay: 2, mix: 0.4 do
        if rand < 0.4 # گاهی اوقات اجرا شود
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
# فاز ۳: اوج گیری (۴۵-۶۰ دقیقه) - 2700 تا 3600 ثانیه
# ---------------------------

# هارمونی اصلی هرج و مرج (تقویت شده)
live_loop :nuclear_meltdown do
  elapsed = Time.now - start_time
  stop if elapsed > 3600
  
  if elapsed >= 2700
    phase_3_progress = (elapsed - 2700.0) / (3600.0 - 2700.0)
    current_amp = [0.1, 1.8 - (phase_3_progress * 1.5)].max
    # تغییر بیشتر پارامترهای FM
    # Use tick for line to ensure it progresses correctly within the loop
    current_divisor = line(0.5, 3.0, steps: 30).reflect.tick(:fm_div_meltdown)
    current_depth = line(1, 10, steps: 40).reflect.tick(:fm_depth_meltdown)
    
    # اضافه کردن افکت Bitcrusher برای خشونت بیشتر
    with_fx :bitcrusher, bits: rrand(4, 8), sample_rate: rrand(5000, 15000), mix: phase_3_progress * 0.6 do
      use_synth :fm
      play chord(:e3, :diminished7).choose, attack: 0.01, release: rrand(0.1, 0.3), amp: current_amp * rrand(0.8, 1.2), divisor: current_divisor, depth: current_depth, pan: rrand(-1, 1)
    end
    
    sleep_modifier = 1.0 + phase_3_progress * 2.0 # سریعتر شدن بیشتر
    sleep [0.05, 0.1, 0.15, 0.2].choose / sleep_modifier
  else
    sleep 1
  end
end

# لایه نویز و کوبه ای (برای تکمیل هرج و مرج)
live_loop :chaos_noise_percussion do
  # Define phase_3_progress outside the if block for sleep calculation
  phase_3_progress = 0
  elapsed = Time.now - start_time
  stop if elapsed > 3600
  
  if elapsed >= 2700
    phase_3_progress = (elapsed - 2700.0) / (3600.0 - 2700.0) # Recalculate if active
    noise_amp = phase_3_progress * rrand(0.3, 0.8)
    perc_amp = phase_3_progress * rrand(0.5, 1.0)
    
    # نویز با فیلتر متحرک
    if rand < 0.6
      # Use tick for line to ensure cutoff progresses
      noise_lpf_cutoff = line(130, 70, steps: 20).tick(:noise_cutoff_chaos)
      with_fx :lpf, cutoff: noise_lpf_cutoff do
        synth :noise, sustain: rrand(0.05, 0.2), release: 0.1, amp: noise_amp
      end
    end
    
    # سمپل های کوبه ای خشن و صنعتی
    if one_in(4)
      sample [:perc_impact_1, :perc_impact_2, :metal_crash, :loop_industrial].choose, rate: rrand(0.8, 1.5), amp: perc_amp * rrand(0.6, 1.0)
    end
  end
  # Calculate sleep time using phase_3_progress (which has a value)
  sleep_duration = rrand(0.1, 0.3) / (1 + phase_3_progress)
  sleep [0.05, sleep_duration].max # Ensure minimum sleep time
end


# ---------------------------
# فاز ۴: پساآخرالزمان (۶۰-۷۵ دقیقه) - 3600 تا 4500 ثانیه
# ---------------------------

# اتمسفر اصلی (با جزئیات بیشتر)
live_loop :radioactive_aftermath do
  elapsed = Time.now - start_time
  stop if elapsed > 4500
  
  if elapsed >= 3600
    phase_4_progress = (elapsed - 3600.0) / (4500.0 - 3600.0)
    base_amp = [0.05, 1.5 - (phase_4_progress * 1.4)].max # محو شدن آرام تر
    reverb_mix = [0.1, 0.95 - (phase_4_progress * 0.7)].max
    
    with_fx :gverb, room: 120, mix: reverb_mix, damp: 0.9, dry: 0.1 do
      # صدای وهم آور اصلی
      if rand < 0.15
        synth :hollow, note: [:e6, :c7, :g6, :a5].choose, release: rrand(25, 45), amp: base_amp * rrand(0.5, 1.0), cutoff: rrand(70, 100)
      end
      
      # صدای باد بهبود یافته با Band Pass Filter
      if rand < 0.4
        # Ensure centre frequency for bpf is valid (usually Hz, but check range if needed)
        bpf_centre = rrand(600, 2000)
        # Ensure noise cutoff is valid MIDI note
        noise_cutoff_aftermath = [rrand(90, 120), 130].min
        with_fx :bpf, centre: bpf_centre, res: rrand(0.3, 0.6) do # مرکز فرکانس تغییر می کند
          synth :noise, sustain: rrand(8, 15), release: 6, amp: base_amp * 0.15, cutoff: noise_cutoff_aftermath
        end
      end
      
      # قطعه ملودی کوتاه و غم انگیز (جدید)
      if one_in(8) # به ندرت ظاهر شود
        use_synth :piano
        notes = scale(:a3, :minor, num_octaves: 1).shuffle.take(3)
        play notes[0], release: 3, amp: base_amp * 0.3, pan: -0.5
        sleep rrand(0.5, 1.0)
        play notes[1], release: 4, amp: base_amp * 0.25, pan: 0.5
        sleep rrand(0.5, 1.0)
        play notes[2], release: 5, amp: base_amp * 0.2, pan: 0
      end
      
    end
    sleep rrand(10, 25) # فواصل همچنان طولانی
  else
    sleep 10
  end
end

# شمارشگر گایگر (واضح تر)
live_loop :geiger_counter do
  elapsed = Time.now - start_time
  stop if elapsed > 4500
  
  if elapsed >= 3700 && elapsed < 4450 # کمی بعد از شروع فاز 4 و کمی قبل از پایان
    phase_4_progress = (elapsed - 3600.0) / (4500.0 - 3600.0)
    click_prob = 0.1 + phase_4_progress * 0.4 # احتمال کلیک با زمان افزایش می یابد
    base_amp = [0.05, 1.0 - (phase_4_progress * 0.9)].max
    
    if rand < click_prob
      # استفاده از سمپل یا سینت کوتاه برای کلیک
      # synth :beep, note: rrand(80, 100), release: 0.01, amp: rrand(0.4, 0.8) * base_amp, pan: rrand(-1, 1)
      sample :elec_tick, rate: rrand(1.5, 3), amp: rrand(0.4, 0.8) * base_amp, pan: rrand(-1, 1)
      # گاهی اوقات دو کلیک نزدیک به هم
      sleep rrand(0.02, 0.1) if one_in(3)
      sample :elec_tick, rate: rrand(1.5, 3), amp: rrand(0.3, 0.6) * base_amp, pan: rrand(-1, 1) if one_in(3)
    end
  end
  sleep rrand(0.2, 1.5) # زمان نامنظم بین تلاش ها برای کلیک
end


# ---------------------------
# سیستم "جذب شنیداری" (تلاش برای بهبود مفهوم بینورال)
# ---------------------------
live_loop :auditory_focus do
  elapsed = Time.now - start_time
  stop if elapsed > 4500
  
  current_phase = elapsed / 4500.0
  
  # --- تلاش برای پیاده سازی نزدیک تر به ضربان بینورال ---
  # استفاده از فرکانس های پایین و پن دقیق
  
  base_freq = 100 + (current_phase * 30) # فرکانس پایه بین 100Hz تا 130Hz تغییر می کند
  beat_freq = binaural_beat_inspiration # 0.5 Hz
  
  # امپلیتیود بسیار کم برای حالت تقریبا ناخودآگاه
  binaural_amp = 0.08 * (1.0 - current_phase) # بسیار کم و محو شونده
  
  if binaural_amp > 0.01 # فقط اگر امپلیتیود قابل توجه است پخش کن
    
    # *** شروع اصلاح ***
    # محاسبه فرکانس cutoff به هرتز
    cutoff_freq_hz = base_freq + 50 # فرکانس مورد نظر: 150Hz تا 180Hz
    
    # تبدیل فرکانس cutoff به شماره نت MIDI
    cutoff_midi = hz_to_midi(cutoff_freq_hz)
    
    # اطمینان از اینکه شماره نت MIDI در محدوده مجاز است (مثلا <= 130)
    safe_cutoff_midi = [cutoff_midi, 130].min
    
    # استفاده از شماره نت MIDI معتبر برای cutoff افکت lpf
    with_fx :lpf, cutoff: safe_cutoff_midi do # <-- استفاده از safe_cutoff_midi
      use_synth :sine
      # گوش چپ
      play hz_to_midi(base_freq), amp: binaural_amp, pan: -1, attack: 0.1, release: 0.8
      # گوش راست (با تفاوت فرکانس کم)
      play hz_to_midi(base_freq + beat_freq), amp: binaural_amp, pan: 1, attack: 0.1, release: 0.8
    end
    # *** پایان اصلاح ***
    
  end
  
  # یک لایه بالاتر (مفهومی بتا/اضطراب) - شاید با سینت دیگر
  if elapsed > 900 # فقط بعد از فاز اول
    beta_amp = 0.15 * (current_phase - 0.2) * (1.0 - current_phase) # قوسی شکل، اوج در میانه
    beta_amp = [0, beta_amp].max
    if beta_amp > 0.01
      # Ensure play frequency is a valid MIDI note or use hz_to_midi if it's Hz
      # base_freq * 2 + rrand(-5, 5) is likely in Hz, so convert it
      play_freq_hz = base_freq * 2 + rrand(-5, 5)
      play_note_midi = hz_to_midi(play_freq_hz)
      safe_play_note_midi = [play_note_midi, 130].min # Clamp to valid MIDI range
      
      with_fx :tremolo, depth: 0.3, phase: rrand(0.1, 0.5) do
        use_synth :pulse
        play safe_play_note_midi , pulse_width: rrand(0.3, 0.7), release: 1.5, amp: beta_amp, pan: rrand(-0.5, 0.5) # فرکانس بالاتر و کمی نامنظم
      end
    end
  end
  
  sleep_time = [0.8, 1.0, 1.3].choose * (1.0 - (current_phase * 0.5))
  sleep [0.1, sleep_time].max # Ensure minimum sleep time
end

# ---------------------------
# کنترل زمان کلی
# ---------------------------
live_loop :master_timer do
  elapsed = Time.now - start_time
  remaining = 4500 - elapsed
  if remaining <= 0
    puts "75 minutes finished."
    # ممکن است بخواهید اینجا یک fade out کلی برای همه لوپ ها پیاده کنید
    # با استفاده از set/get و کنترل amp در هر لوپ
    stop
  end
  puts "Elapsed: #{elapsed.round}s / 4500s"
  sleep 10
end