# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    @input = input
  end

  def score
    marks = parse_input_with_three_values
    game_score = 0
    10.times do |idx|
      frame = Frame.new(@frames[idx])
      game_score += frame.calculate_frame_score

      @frames[idx + 1] ||= []
      @frames[idx + 2] ||= []
      if frame.strike?
        next_frame = (@frames[idx + 1] + @frames[idx + 2]).slice(0, 2)
        game_score += Frame.new(next_frame).calculate_frame_score
      elsif frame.spare?
        next_shot = @frames[idx + 1][0]
        game_score += Shot.new(next_shot).score
      end
    end
    game_score
  end

  private

  def parse_input_with_three_values
    parsed_input = parse_input
    frames = []
    9.times do |idx|
      frame = parsed_input[idx]
      if frame.one? && frame.first == 'X'
        next_frame = parse_input[idx + 1]
        if next_frame.one? && next_frame.first == 'X'
          next_after_frame = parse_input[idx + 2]
          frame = frame + next_frame + next_after_frame
          frames << if frame.size > 3
              frame[0..2]
            else
              frame
          end
        else
          frame.concat(next_frame)
          if frame.size > 3
            frames << frame[0..2]
          else
            frames << frame
          end
        end
      elsif frame.size < 3
        next_frame = parse_input[idx + 1]
        if next_frame
          frame << next_frame[0]
        end
        frames << frame
      end
    end
    if frames.size < 10
      frames << parsed_input.last
    end
    frames
  end

  def parse_input
    splitted_input = @input.split(',')
    frame = []
    frames = []
    splitted_input.each do |s|
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
