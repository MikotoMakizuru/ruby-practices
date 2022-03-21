#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  option = options
  file_info, count_line_total, count_word_total, bytes_total = retrieve_file_info
  display_file_info(file_info, count_line_total, count_word_total, bytes_total, option)
end

def retrieve_file_info
  file_info = []
  count_line_total, count_word_total, bytes_total = 0, 0, 0,
  target_contents = ARGV.empty? ? [$stdin.read] : ARGV
  target_contents.each do |content|
    file_text = target_contents == ARGV ? File.read(content) : content
    count_line = file_text.count("\n")
    count_word = file_text.split.size
    bytes = file_text.bytesize

    file_info << {
      count_line: count_line,
      count_word: count_word,
      bytes: bytes,
      file_name: target_contents == ARGV ? content : nil
    }

    count_line_total += count_line
    count_word_total += count_word
    bytes_total += bytes
  end
  [file_info, count_line_total, count_word_total, bytes_total]
end

def display_file_info(file_info, count_line_total, count_word_total, bytes_total, option)
  file_info.each do |info|
    print info[:count_line].to_s.rjust(8)
    unless option['l']
      print info[:count_word].to_s.rjust(8)
      print info[:bytes].to_s.rjust(8)
    end
    print " #{info[:file_name]}"
    print "\n"
  end
  return unless file_info.size >= 2

  print " #{count_line_total}".to_s.rjust(8)
  unless option['l']
    print " #{count_word_total}".to_s.rjust(8)
    print " #{bytes_total}".to_s.rjust(8)
  end
  print ' total'
  print "\n"
end

options = ARGV.getopts('l')
main(options)
