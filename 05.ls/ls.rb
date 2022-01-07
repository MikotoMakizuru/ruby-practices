# frozen_string_literal: true

NUM_COLUMN = 3

def main
  files_count.map do |files|
    files.each do |file|
      if file == files.last
        puts "#{file}\n"
      else
        print file.ljust(24)
      end
    end
  end
end

def files_retrieve
  Dir.glob('*')
end

def files_count
  file_count_num = (files_retrieve.size / NUM_COLUMN).ceil(0)
  file_element_segmentation = files_retrieve.each_slice(file_count_num).to_a
  file_element_segmentation.transpose
end

main
