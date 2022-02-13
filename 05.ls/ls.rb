# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_SIZE = 3
SPACE_WIDTH = 24

FILE_TYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = parse_options
  if options.key?(:l)
    block_size, files = retrieve_files_info
    display_files_info(block_size, files)
  else
    display_files
  end
end

def parse_options
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse(ARGV)
  params
end

def find_files
  options = parse_options
  flags = options.key?(:a) ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', flags)
  file_names = file_names.reverse if options.key?(:r)
  file_names
end

def retrieve_files_info
  file_names = find_files
  block_size = 0
  files = Hash.new { |hash, key| hash[key] = {} }
  file_names.each do |name|
    file_stat = File.lstat(name)

    block_size += file_stat.blocks
    files[name][:type] = FILE_TYPE[File.ftype(name)]
    files[name][:permission] = permission(file_stat)
    files[name][:hard_link] = file_stat.nlink.to_s
    files[name][:user] = Etc.getpwuid(File.stat(name).uid).name
    files[name][:group] = Etc.getgrgid(File.stat(name).gid).name
    files[name][:size] = file_stat.size.to_s
    files[name][:month] = file_stat.mtime.month.to_s
    files[name][:day] = file_stat.mtime.day.to_s
    files[name][:time] = file_stat.mtime.strftime('%H:%M')
    files[name][:file_name] = find_link_target(name)
  end
  [block_size, files]
end

def permission(file_stat)
  permissions = ''
  mode_octal_number = file_stat.mode.to_s(8)
  3.times do |i|
    permissions += PERMISSION[mode_octal_number[-3 + i]]
  end
  permissions[2] = (permissions[2] == 'x' ? 's' : 'S') if file_stat.setuid?
  permissions[5] = (permissions[5] == 'x' ? 's' : 'S') if file_stat.setgid?
  permissions[8] = (permissions[8] == 'x' ? 't' : 'T') if file_stat.sticky?
  permissions
end

def find_link_target(name)
  File.lstat(name).symlink? ? "#{name} -> #{File.readlink(name)}" : name
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
    print " #{file[:file_name]}"
    print "\n"
  end
end

def divide_files
  file_names = find_files
  return [file_names] if file_names.size == 1

  row_count = (file_names.size / COLUMN_SIZE.to_f).ceil
  segment_files = file_names.each_slice(row_count).to_a
  segment_files.inject(&:zip).map(&:flatten)
end

def display_files
  divide_files.each do |files|
    line = files.compact.sum('') do |file|
      file.ljust(SPACE_WIDTH)
    end
    puts line.rstrip
  end
end

main
