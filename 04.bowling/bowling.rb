#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map do |s|
  if s == 'X'
    shots = [10, 0]
  else
    s.to_i
  end
end

shots = shots.flatten
frames = shots.each_slice(2).to_a

point =
  frames.each_with_index.sum do |frame, i|
    if i >= 9
      frame.sum
    elsif frame[0] == 10 && frames[i + 1][0] == 10
      20 + frames[i + 2][0]
    elsif frame[0] == 10
      10 + frames[i + 1].sum
    elsif frame.sum == 10
      10 + frames[i + 1][0]
    else
      frame.sum
    end
  end

puts point
