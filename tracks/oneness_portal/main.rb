# Oneness Portal – A spiritual track developed with Sonic Pi
# Theme: Connection with Oneness and Spiritual Awakening

use_bpm 60
use_debug false
set_sched_ahead_time! 1

## Global Effects: Adds reverb and echo for a spacious, immersive sound
with_fx :reverb, room: 0.8, mix: 0.5 do
  with_fx :echo, phase: 0.75, decay: 2 do
    
    ## Section 1: Expansive Ambient Pad
    # Creates a wide, atmospheric background using a hollow synth and minor 7th chord
    live_loop :ambient_pad do
      use_synth :hollow
      play_chord chord(:E3, :m7), attack: 4, sustain: 8, release: 4, amp: 0.5, pan: -0.3
      sleep 8
    end
    
    ## Section 2: Gentle Drone and Gradual Expansion
    # Adds a deep, evolving drone for a sense of calm and space
    live_loop :drone, sync: :ambient_pad do
      use_synth :dark_ambience
      play :E2, attack: 12, sustain: 16, release: 8, amp: 0.3, pan: 0.3
      sleep 16
    end
    
    ## Section 3: Awakening Melody with Variations
    # Defines and plays a bright, uplifting melody with alternating root notes
    define :oneness_melody do |root, pan_pos|
      use_synth :kalimba
      play_pattern_timed [root, root+2, root+4, root+5, root+7, root+5, root+4, root+2], [0.5,0.5,1,1,1,0.5,0.5,2], amp: 0.6, pan: pan_pos
    end
    
    live_loop :melody, sync: :ambient_pad do
      oneness_melody :E4, -0.2
      sleep 8
      oneness_melody :D4, 0.2
      sleep 8
    end
    
    
    
    ## Section 4: Soft Percussion and Spiritual Heartbeat
    # Simulates a heartbeat and gentle percussive elements with a low-pass filter
    live_loop :heartbeat, sync: :ambient_pad do
      with_fx :lpf, cutoff: rrand(70, 110) do
        sample :bd_haus, amp: 0.3, cutoff: 100
        sleep 1
        sample :perc_snap, amp: 0.2
        sleep 1
      end
    end
    
    
    
    
    ## Section 5: Spiritual Climax with Richer Pad
    # Introduces a lush pad for the climax, then stops
    live_loop :climax_pad, sync: :build_up do
      use_synth :prophet
      play_chord chord(:E4, :maj9), attack: 2, sustain: 6, release: 3, amp: 0.6
      sleep 8
      stop
    end
    
    ## Section 6: Theta Binaural Beat (Neuroscience Foundation)
    # Plays two sine waves (120Hz left, 126Hz right) to create a 6Hz theta binaural beat
    live_loop :theta_binaural_beat, sync: :ambient_pad do
      use_synth :sine
      # Left channel
      play 120, amp: 0.003, pan: -1
      # Right channel
      play 126, amp: 0.003, pan: 1
      sleep 4
    end
    
    ## Section 8: Still Ending of Spiritual Awakening
    # Plays a final, peaceful chord to conclude the track
    tick_reset
    live_loop :resolution, sync: :ambient_pad do
      stop if tick > 1
      use_synth :dark_sea_horn
      play_chord chord(:E3, :m9), attack: 8, sustain: 12, release: 6, amp: 0.5
      sleep 12
    end
    
  end
end