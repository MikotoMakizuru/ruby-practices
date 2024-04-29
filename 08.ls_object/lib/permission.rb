# frozen_string_literal: true

require 'etc'

class Permission
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

  def initialize(stat)
    @stat = stat
  end

  def mode
    digits = @stat.mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_TABLE)
  end
end
