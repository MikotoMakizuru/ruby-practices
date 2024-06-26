#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console'
require 'optparse'
require 'pathname'

require_relative '../lib/ls_command'

opt = OptionParser.new

params = { long_format: false, reverse: false, show_dots: false }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.on('-a') { |v| params[:show_dots] = v }
opt.parse!(ARGV)
path = ARGV[0] || '.'
pathname = Pathname(path)
width = IO.console.winsize[1]

puts run_ls(pathname, width: width, **params)
