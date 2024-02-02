# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames
  end

  def score
    @frames = split_frame_array
    game_score = 0
    10.times do |idx|
      frame = Frame.new(@frames[idx])
      game_score += frame.score

      @frames[idx + 1] ||= []
      @frames[idx + 2] ||= []
      if frame.strike?
        next_frame = (@frames[idx + 1] + @frames[idx + 2]).slice(0, 2)
        game_score += next_frame.sum { |s| Shot.new(s).score }
      elsif frame.spare?
        next_shot = @frames[idx + 1][0]
        game_score += Shot.new(next_shot).score
      end
    end
    game_score
  end

  def split_frame_array
    shots = @frames.split(',')
    frame = []
    frames = []
    shots.each do |s|
      frame << s

      if frames.size < 10
        if frame.size >= 2 || s == 'X'
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << s
      end
    end
    frames
  end
end
