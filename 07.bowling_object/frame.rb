# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(marks)
    @first_shot = Shot.new(marks[0])
    @second_shot = Shot.new(marks[1])
    @third_shot = Shot.new(marks[2])
  end

  def calculate_frame_score
    if strike?
      [@first_shot.score, @second_shot.score, @third_shot.score].sum
    elsif spare?
      [@first_shot.score, @second_shot.score, @third_shot.score].sum
    else
      [@first_shot.score, @second_shot.score].sum
    end
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10 && @first_shot.score != 10
  end
end
