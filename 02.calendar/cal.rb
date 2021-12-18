#!/usr/bin/env ruby
require 'date'
require 'optparse'
require 'color_echo'
day = Date.today
opt = ARGV.getopts("y:", "m:")

if opt["y"]
  year = opt["y"].to_i
else
  year = day.year
end

if opt["m"]
  mon = opt["m"].to_i
else
  mon = day.mon
end

days = ["日", "月", "火", "水", "木", "金", "土"]  # 曜日を作成
month_ad = Date.new(year,mon,1).strftime("%m月 %Y")
firstday_wday = Date.new(year,mon,1).wday        # 曜日を返す。1で1日の曜日を取得
lastday_date = Date.new(year,mon,-1).day         # 月の日にちを返す。-1で最終日を取得

puts month_ad.center(20)
puts days.join(" ")  # 曜日の間と間に空白を出力 
print "   " * firstday_wday #1日までに空白を入れる

(1..lastday_date).each do |date| # 1日から最終日まで繰り返す
  print date.to_s.rjust(2) + " " # 日にちの間と間に空白を出力
  firstday_wday = firstday_wday + 1
  if firstday_wday % 7 == 0
    print "\n"
  end
end
if firstday_wday % 7 != 0
  print "\n"
end
