#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  if options['l']
    file_info, count_line_total = retrieve_file_info
    display_number_of_line(file_info, count_line_total)
  else
    file_info, count_line_total, count_word_total, bytes_total = retrieve_file_info
    display_files_info(file_info, count_line_total, count_word_total, bytes_total)
  end
end

def retrieve_file_info
  file_info = Hash.new { |hash, key| hash[key] = {} }
  if ARGV.empty?
    file_text = $stdin.read

    file_info[$stdin][:count_line] = file_text.count("\n")
    file_info[$stdin][:count_word] = file_text.split(/\s/).count
    file_info[$stdin][:bytes] = file_text.bytesize
  else
    count_line_total = 0
    count_word_total = 0
    bytes_total = 0
    ARGV.each do |file_name|
      file_text = File.read(file_name)

      file_info[file_name][:count_line] = file_text.count("\n")
      file_info[file_name][:count_word] = file_text.split(/\s/).count
      file_info[file_name][:bytes] = file_text.bytesize
      file_info[file_name][:file_name] = file_name

      count_line_total += file_text.count("\n")
      count_word_total += file_text.split(/\s/).count
      bytes_total += file_text.bytesize
    end
  end
  [file_info, count_line_total, count_word_total, bytes_total]
end

def display_number_of_line(file_info, count_line_total)
  if file_info.size <= 1
    file_info.each_value do |file|
      print file[:count_line].to_s.rjust(8)
      print " #{file[:file_name]}"
      print "\n"
    end
  else
    file_info.each_value do |file|
      print file[:count_line].to_s.rjust(8)
      print " #{file[:file_name]}"
      print "\n"
    end
    print " #{count_line_total}".to_s.rjust(8)
    print ' total'
    print "\n"
  end
end

def display_files_info(file_info, count_line_total, count_word_total, bytes_total)
  if file_info.size <= 1
    file_info.each_value do |file|
      print file[:count_line].to_s.rjust(8)
      print file[:count_word].to_s.rjust(8)
      print file[:bytes].to_s.rjust(8)
      print " #{file[:file_name]}"
      print "\n"
    end
  else
    file_info.each_value do |file|
      print file[:count_line].to_s.rjust(8)
      print file[:count_word].to_s.rjust(8)
      print file[:bytes].to_s.rjust(8)
      print " #{file[:file_name]}"
      print "\n"
    end
    print " #{count_line_total}".to_s.rjust(8)
    print " #{count_word_total}".to_s.rjust(8)
    print " #{bytes_total}".to_s.rjust(8)
    print ' total'
    print "\n"
  end
end

options = ARGV.getopts('l')
main(options)
