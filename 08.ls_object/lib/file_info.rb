# frozen_string_literal: true

require 'etc'
require_relative '../lib/permission'

class FileInfo
  TYPE_TABLE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  attr_reader :file_path, :stat

  def initialize(file_path, stat)
    @file_path = file_path
    @stat = stat
  end

  def type
    File.ftype(file_path).gsub(/\A[a-z]+\z/, TYPE_TABLE)
  end

  def permission
    Permission.new(stat).mode
  end

  def nlink
    stat.nlink.to_s
  end

  def user
    Etc.getpwuid(stat.uid).name
  end

  def group
    Etc.getgrgid(stat.gid).name
  end

  def bytesize
    stat.size.to_s
  end

  def udatetime
    stat.mtime.strftime('%-m %e %H:%M')
  end

  def basename
    File.basename(file_path)
  end

  def blocks
    stat.blocks
  end
end
