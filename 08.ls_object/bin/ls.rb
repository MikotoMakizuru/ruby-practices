# frozen_string_literal: true

require_relative '../lib/display_list'

display_list = DisplayList.new(ARGV)
display_list.run_ls
