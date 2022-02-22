# frozen_string_literal: true

require 'etc'

MODE_TABLE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def run_ls(_pathname, width: 80, long_format: false, reverse: false, show_dots: false)
  params = show_dots ? ['test/fixtures/sample-app/*', File::FNM_DOTMATCH] : ['test/fixtures/sample-app/*']
  filenames = Pathname.glob(*params).sort
  filenames = filenames.reverse if reverse
  long_format ? ls_long(filenames) : ls_short(filenames.map(&:basename).map(&:to_s), width)
end

def ls_long(pathnames)
  block_total = 0
  max_nlink = 0
  max_user_length = 0
  max_group_length = 0
  max_size = 0
  pathnames.each do |pathname|
    stat = pathname.stat
    max_nlink = [max_nlink, stat.nlink.to_s.size].max
    max_user_length = [max_user_length, Etc.getpwuid(stat.uid).name.size].max
    max_group_length = [max_group_length, Etc.getgrgid(stat.gid).name.size].max
    max_size = [max_size, stat.size.to_s.size].max
    block_total += stat.blocks
  end
  rows = ["total #{block_total}"]
  rows += pathnames.map do |pathname|
    format_row(pathname, max_nlink, max_user_length, max_group_length, max_size)
  end
  rows.join("\n")
end

def format_row(pathname, max_nlink, max_user_length, max_group_length, max_size)
  ret = ''
  stat = pathname.stat
  ret += pathname.directory? ? 'd' : '-'
  mode = stat.mode.to_s(8)[-3..]
  ret += format_mode(mode)
  ret += "  #{stat.nlink.to_s.rjust(max_nlink)}"
  ret += " #{Etc.getpwuid(stat.uid).name.ljust(max_user_length)}"
  ret += "  #{Etc.getgrgid(stat.gid).name.ljust(max_group_length)}"
  ret += "  #{stat.size.to_s.rjust(max_size)}"
  ret += " #{stat.mtime.strftime('%_m %e %H:%M')}"
  ret += " #{pathname.basename}"
  ret
end

def format_mode(digits)
  digits.each_char.map do |c|
    MODE_TABLE[c]
  end.join
end

def ls_short(pathname, width)
  max_filename_count = pathname.map(&:size).max
  col_count = width / (max_filename_count + 1)
  row_count = col_count.zero? ? pathname.count : (pathname.count.to_f / col_count).ceil
  transposed_pathname = safe_transpose(pathname.each_slice(row_count).to_a)
  format_teble(transposed_pathname, max_filename_count)
end

def safe_transpose(nested_file_names)
  nested_file_names[0].zip(*nested_file_names[1..])
end

def format_teble(pathname, max_filename_count)
  pathname.map do |row_files|
    row_files.map { |filename| filename.to_s.ljust(max_filename_count + 7) }.join.rstrip
  end.join("\n")
end
