# frozen_string_literal: true

class Game
  attr_reader :marks

  def initialize(shots)
    @shots = shots
  end

  def score
    frames = split_frame_array
    game_score = 0
    10.times do |idx|
      frame = Frame.new(frames[idx])
      game_score += frame.score

      frames[idx + 1] ||= []
      frames[idx + 2] ||= []
      if frame.strike?
        next_frame = (frames[idx + 1] + frames[idx + 2]).slice(0, 2)
        game_score += next_frame.sum { |s| Shot.new(s).score }
      elsif frame.spare?
        next_shot = frames[idx + 1][0]
        game_score += Shot.new(next_shot).score
      end
    end
    game_score
  end

  def split_frame_array
    shots = @shots.split(',')
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

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    score == 10
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark == 'X' ? 10 : @mark.to_i
  end
end

game = Game.new(ARGV[0])
puts game.score
