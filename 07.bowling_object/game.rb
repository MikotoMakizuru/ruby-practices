# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    @input = input
  end

  def score
    frames = create_frames
    game_score = 0
    frames.each do |frame|
      game_score += frame.calculate_frame_score
    end
    game_score
  end

  private

  def create_frames
    source_frames = parse_inputs
    frames = []
    source_frames.each do |source_frame|
      frame = Frame.new(source_frame)
      frames << frame
    end
    frames
  end

  # 入力された得点を1つの配列が3つの要素を持つは次元配列にparseする
  def parse_inputs
    inputs = @input.split(',')
    source_frames = []
    source_frame = []

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
    source_frames_with_three_values(source_frames)
  end

  def source_frames_with_three_values(parsed_inputs)
      source_frames = []

      9.times do |idx|
        source_frame = parsed_inputs[idx]
        source_next_frame = parsed_inputs[idx + 1]
        source_next_after_frame = parsed_inputs[idx + 2]
  
        if all_x_values?(source_frame)
          concat_source_frame(source_frame, source_next_frame, source_next_after_frame)
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
  end
  
    def concat_source_frame(source_frame, source_next_frame, source_next_after_frame)
      if all_x_values?(source_next_frame)
        source_frame.concat(source_next_frame).concat(source_next_after_frame)
      else
        source_frame.concat(source_next_frame)
      end
    end
  
    def all_x_values?(source_frame)
      source_frame.one? && source_frame.first == 'X'
    end
end
