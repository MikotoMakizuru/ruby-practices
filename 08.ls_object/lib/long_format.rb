# frozen_string_literal: true

require_relative '../lib/file_info'

class LongFormat
  def initialize(file_paths)
    @files_info = file_paths.map { |file_path| FileInfo.new(file_path) }
  end

  def display
    format_rows
  end

  private

  def format_rows
    files_info = @files_info.map do |file_info|
      [
        "#{file_info.type}#{file_info.permission}",
        "  #{file_info.nlink.rjust(nlink_max_length)}",
        " #{file_info.user.ljust(user_max_length)}",
        "  #{file_info.group.ljust(group_max_length)}",
        "  #{file_info.bytesize.rjust(bytesize_max_length)}",
        "  #{file_info.udatetime}",
        " #{file_info.basename}"
      ].join
    end
    [block_total] + files_info
  end

  def nlink_max_length
    @files_info.map { |file_info| file_info.nlink.to_s.size }.max
  end

  def user_max_length
    @files_info.map { |file_info| file_info.user.to_s.size }.max
  end

  def group_max_length
    @files_info.map { |file_info| file_info.group.to_s.size }.max
  end

  def bytesize_max_length
    @files_info.map { |data| data.bytesize.to_s.size }.max
  end

  def block_total
    block_total = @files_info.sum(&:blocks)
    "total #{block_total}"
  end
end
