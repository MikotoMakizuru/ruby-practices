# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    @input = input
  end

  def score
    score_board = parse_input_with_three_values
    game_score = 0
    10.times do |idx|
      frame = Frame.new(score_board[idx])
      @frames = score_board

      if frame.strike?
        game_score += frame.calculate_frame_score
      elsif frame.spare?
        game_score += frame.calculate_frame_score
      else
        @frames[idx].pop if @frames[idx].size > 2
        frame = @frames[idx]
        game_score += Frame.new(frame).calculate_frame_score
      end
    end
    game_score
  end

  def parse_input_with_three_values
    parsed_input = parse_input
    frames = []

    9.times do |idx|
      frame = parsed_input[idx]
      next_frame = parse_input[idx + 1]
      next_after_frame = parse_input[idx + 2]

      if all_x_values?(frame)
        concat_frame(frame, next_frame, next_after_frame)
      elsif frame.size < 3
        frame << next_frame[0] if next_frame
      end

      frames << if frame.size > 3
                  frame[0..2]
                else
                  frame
                end
    end
    frames << parsed_input.last if frames.size < 10
    frames
  end

  def concat_frame(frame, next_frame, next_after_frame)
    if all_x_values?(next_frame)
      frame.concat(next_frame).concat(next_after_frame)
    else
      frame.concat(next_frame)
    end
  end

  def all_x_values?(frame)
    frame.one? && frame.first == 'X'
  end

  private

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
