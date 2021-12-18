#!/usr/bin/env ruby
# frozen_string_literal: true

# スクリプトに与えられた引数を配列で渡す
score = ARGV[0]
scores = score.split(',')

# スコアを足算するので、文字列から整数に変換
shots = scores.map do |s|
  if s == 'X' # strike
    shots = []
    shots << 10 << 0
  else
    s.to_i
  end
end

# 'X'の場合、[10, 0]となってしまうので、配列を平坦化する
shots = shots.flatten

# 引数で指定した数ずつで、配列を作る
frames = shots.each_slice(2).to_a

point = 0

# スペアとストライクを分けて足算する
frames.each_with_index do |frame, i|
  point += if i >= 9
             frame.sum
           # ダブルストライクの処理
           elsif frame[0] == 10 && frames[i + 1][0] == 10
             20 + frames[i + 2][0]
           # ストライクの処理
           elsif frame[0] == 10
             10 + frames[i + 1].sum
           # スペアの処理
           elsif frame.sum == 10
             10 + frames[i + 1][0]
           # それ以外
           else
             frame.sum
           end
end

puts point
