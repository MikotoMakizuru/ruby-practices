# frozen_string_literal: true

COLUMN_SIZE = 3
SPACE_WIDTH = 24

def main
  files_count.each do |files|
    remove_nil_files = files.compact
    line = remove_nil_files.sum('') do |file|
      file.ljust(SPACE_WIDTH)
    end
    print line.rstrip
    print "\n"
  end
end

def find_files
  Dir.glob('*')
end

def files_count
  files = find_files
  division_linecount_count_file = (files.size / COLUMN_SIZE.to_f).ceil(0)
  segment_file = files.each_slice(division_linecount_count_file).to_a
  if segment_file.count == 1
    segment_file
  else
    segment_file.inject(&:zip).map(&:flatten)
  end
end

main
