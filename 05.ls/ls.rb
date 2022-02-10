# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_SIZE = 3
SPACE_WIDTH = 24

def main
  if analyse_options.key?(:l)
    block_size, files = retrieve_files_info
    display_files_info(block_size, files)
  else
    display_files
  end
end

def analyse_options
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)
  params
end

def find_files
  files = Dir.glob('*')
  all_files = Dir.glob('*', File::FNM_DOTMATCH)
  if analyse_options.key?(:a) && analyse_options.key?(:r)
    all_files.reverse
  elsif analyse_options.key?(:a)
    all_files
  elsif analyse_options.key?(:r)
    files.reverse
  else
    files
  end
end

def retrieve_files_info
  hold_files = find_files
  block_size = 0
  files = Hash.new { |hash, key| hash[key] = {} }
  hold_files.each do |file|
    file_stat = File.lstat(file)

    block_size += file_stat.blocks
    files[file][:type] = check_type(file)
    files[file][:permission] = check_permission(file_stat)
    files[file][:hard_link] = file_stat.nlink.to_s
    files[file][:user] = Etc.getpwuid(File.stat(file).uid).name
    files[file][:group] = Etc.getgrgid(File.stat(file).gid).name
    files[file][:size] = file_stat.size.to_s
    files[file][:month] = file_stat.mtime.month.to_s
    files[file][:day] = file_stat.mtime.day.to_s
    files[file][:time] = file_stat.mtime.strftime('%H:%M')
    files[file][:name] = check_symbolic_link(file)
  end
  [block_size, files]
end

def check_type(file)
  type = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }
  type[File.ftype(file)]
end

def check_permission(file_stat)
  permission = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  permissions = ''
  3.times do |i|
    permissions += permission[file_stat.mode.to_s(8)[-3 + i]]
  end
  permissions = check_setuid(permissions) if file_stat.setuid?
  permissions = check_setgid(permissions) if file_stat.setgid?
  permissions = check_sticky(permissions) if file_stat.sticky?
  permissions
end

def check_setuid(permission)
  permission[2] = permission[2] == 'x' ? 's' : 'S'
  permission
end

def check_setgid(permission)
  permission[5] = permission[5] == 'x' ? 's' : 'S'
  permission
end

def check_sticky(permission)
  permission[8] = permission[8] == 'x' ? 't' : 'T'
  permission
end

def check_symbolic_link(file)
  File.lstat(file).symlink? ? "#{file} -> #{File.readlink(file)}" : file
end

def display_files_info(block_size, files)
  puts "total #{block_size}"
  files.each_value do |file|
    print file[:type]
    print file[:permission]
    print file[:hard_link].rjust(4)
    print file[:user].rjust(7)
    print file[:group].rjust(7)
    print file[:size].rjust(6)
    print file[:month].rjust(3)
    print file[:day].rjust(3)
    print file[:time].rjust(6)
    print " #{file[:name]}"
    puts ''
  end
end

def segments_files
  files = find_files
  return [files] if files.size == 1

  row_count = (files.size / COLUMN_SIZE.to_f).ceil
  segment_files = files.each_slice(row_count).to_a
  segment_files.inject(&:zip).map(&:flatten)
end

def display_files
  segments_files.each do |files|
    line = files.compact.sum('') do |file|
      file.ljust(SPACE_WIDTH)
    end
    puts line.rstrip
  end
end

main
