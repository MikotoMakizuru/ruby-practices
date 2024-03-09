# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    @input = input
  end

  def score
    frames = create_frames
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

  def create_frames
    parsed_inputs = parse_inputs
    source_frames = []

    9.times do |idx|
      source_frame = parsed_inputs[idx]
      source_next_frame = parsed_inputs[idx + 1]
      source_next_after_frame = parsed_inputs[idx + 2]

      if all_x_values?(source_frame)
        concat_frame(source_frame, source_next_frame, source_next_after_frame)
      elsif source_frame.size < 3
        source_frame << source_next_frame[0] if source_next_frame
      end

      source_frames << if source_frame.size > 3
                         source_frame[0..2]
      else
        source_frame
      end
    end
    source_frames << parsed_inputs.last if source_frames.size < 10
    frames = []
    source_frames.each do |source_frame|
      frame = Frame.new(source_frame)
      frames << frame
    end
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

  def parse_inputs
    inputs = @input.split(',')
    source_frame = []
    source_frames = []
    inputs.each do |input|
      source_frame << input

      if source_frames.size < 10
        if source_frame.size >= 2 || input == 'X'
          source_frames << source_frame.dup
          source_frame.clear
        end
      else
        source_frames.last << input
      end
    end
    source_frames
  end
end
