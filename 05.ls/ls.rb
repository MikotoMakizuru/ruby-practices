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

def main(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', flags)
  file_names.reverse! if options['r']

  if options['l']
    block_size, files = retrieve_files_info(file_names)
    display_files_info(block_size, files)
  else
    display_files(file_names)
  end
end

def retrieve_files_info(file_names)
  block_size = 0
  files = Hash.new { |hash, key| hash[key] = {} }
  file_names.each do |name|
    file_stat = File.lstat(name)

    block_size += file_stat.blocks
    files[name][:type] = FILE_TYPE[File.ftype(name)]
    files[name][:permission] = retrieve_permission(file_stat)
    files[name][:hard_link] = file_stat.nlink
    files[name][:user] = Etc.getpwuid(file_stat.uid).name
    files[name][:group] = Etc.getgrgid(file_stat.gid).name
    files[name][:size] = file_stat.size
    files[name][:mtime] = file_stat.mtime
    files[name][:file_name] = format_file_name(name)
  end
  [block_size, files]
end

def retrieve_permission(file_stat)
  mode_octal_number = file_stat.mode.to_s(8)
  permissions = -3.upto(-1).map { |i| PERMISSION[mode_octal_number[i]] }.join
  permissions[2] = (permissions[2] == 'x' ? 's' : 'S') if file_stat.setuid?
  permissions[5] = (permissions[5] == 'x' ? 's' : 'S') if file_stat.setgid?
  permissions[8] = (permissions[8] == 'x' ? 't' : 'T') if file_stat.sticky?
  permissions
end

def format_file_name(name)
  File.lstat(name).symlink? ? "#{name} -> #{File.readlink(name)}" : name
end

def display_files_info(block_size, files)
  puts "total #{block_size}"
  files.each_value do |file|
    print file[:type]
    print file[:permission]
    print file[:hard_link].to_s.rjust(4)
    print file[:user].rjust(7)
    print file[:group].rjust(7)
    print file[:size].to_s.rjust(6)
    print file[:mtime].strftime('%_m %_d %H:%M').to_s.rjust(12)
    print " #{file[:file_name]}"
    print "\n"
  end
end

def display_files(file_names)
  row_count = (file_names.size / COLUMN_SIZE.to_f).ceil
  divide_files = file_names.each_slice(row_count).to_a
  # injectは要素が1つ（ファイル数が1つ）の場合、ブロックを実行せずに要素を返すため
  divided_files = file_names.size == 1 ? divide_files : divide_files.inject(&:zip).map(&:flatten)
  divided_files.each do |files|
    line = files.sum('') do |file|
      file.to_s.ljust(SPACE_WIDTH)
    end
    puts line.rstrip
  end
end

options = ARGV.getopts('alr')
main(options)
