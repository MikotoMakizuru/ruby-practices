#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  if options['l']
    file_info, count_line_total = retrieve_file_info
    display_number_of_line(file_info, count_line_total)
  else
    file_info, count_line_total, count_word_total, bytes_total = retrieve_file_info
    display_file_info(file_info, count_line_total, count_word_total, bytes_total)
  end
end

def retrieve_file_info
  file_info = {}
  count_line_total = 0
  count_word_total = 0
  bytes_total = 0

  target_contents = ARGV.empty? ? [$stdin.read] : ARGV
  target_contents.each do |content|
    file_text = target_contents == ARGV ? File.read(content) : content

    file_info[content] = {}
    file_info[content][:count_line] = file_text.count("\n")
    file_info[content][:count_word] = file_text.split(/\s/).count
    file_info[content][:bytes] = file_text.bytesize
    file_info[content][:file_name] = target_contents == ARGV ? content : nil

    count_line_total += file_text.count("\n")
    count_word_total += file_text.split(/\s/).count
    bytes_total += file_text.bytesize
  end
  [file_info, count_line_total, count_word_total, bytes_total]
end

def display_number_of_line(file_info, count_line_total)
  file_info.each_value do |file|
    print file[:count_line].to_s.rjust(8)
    print " #{file[:file_name]}"
    print "\n"
  end
  return unless file_info.size >= 2

  print " #{count_line_total}".to_s.rjust(8)
  print ' total'
  print "\n"
end

def display_file_info(file_info, count_line_total, count_word_total, bytes_total)
  file_info.each_value do |info|
    print info[:count_line].to_s.rjust(8)
    print info[:count_word].to_s.rjust(8)
    print info[:bytes].to_s.rjust(8)
    print " #{info[:file_name]}"
    print "\n"
  end
  return unless file_info.size >= 2

  print " #{count_line_total}".to_s.rjust(8)
  print " #{count_word_total}".to_s.rjust(8)
  print " #{bytes_total}".to_s.rjust(8)
  print ' total'
  print "\n"
end

options = ARGV.getopts('l')
main(options)
