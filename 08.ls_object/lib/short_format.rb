# frozen_string_literal: true

require 'io/console'

class ShortFormat
  def initialize(file_paths)
    @file_paths = file_paths
  end

  def format_table
    transpose_files(@file_paths).map do |row_files|
      insert_sapce(row_files)
    end.join("\n")
  end

  private

  def insert_sapce(row_files)
    row_files.map do |file|
      file ||= ''
      file.ljust(filename_max_length(@file_paths) + 7)
    end.join.rstrip
  end

  def transpose_files(file_paths)
    splitted_file_names = file_basenames(file_paths).each_slice(row_count(file_paths)).to_a
    splitted_file_names[0].zip(*splitted_file_names[1..])
  end

  def file_basenames(file_paths)
    file_paths.map do |file_path|
      File.basename(file_path)
    end
  end

  def row_count(file_paths)
    column_count(file_paths).zero? ? file_basenames(file_paths).count : (file_basenames(file_paths).count.to_f / column_count(file_paths)).ceil
  end

  def column_count(file_paths)
    display_width_size / (filename_max_length(file_paths) + 8)
  end

  def filename_max_length(file_paths)
    file_basenames(file_paths).map(&:length).max
  end

  def display_width_size
    IO.console.winsize[1]
  end
end
