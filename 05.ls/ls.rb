# frozen_string_literal: true

COLUMN_SIZE = 3
SPACE_WIDTH = 24

def main
  files_count.each do |files|
    line = files.compact.sum('') do |file|
      file.ljust(SPACE_WIDTH)
    end
    puts line.rstrip
  end
end

def find_files
  Dir.glob('*')
end

def files_count
  files = find_files
  return [files] if files.size == 1

  row_count = (files.size / COLUMN_SIZE.to_f).ceil
  segment_files = files.each_slice(row_count).to_a
  segment_files.inject(&:zip).map(&:flatten)
end

main
