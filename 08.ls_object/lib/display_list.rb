# frozen_string_literal: true

require 'pathname'
require_relative '../lib/short_format'
require_relative '../lib/long_format'
require_relative '../lib/option'

class DisplayList
  def initialize(argv)
    @options = Option.new(argv).parse
    @pathname = determine_pathname(argv)
  end

  def run_ls
    file_paths = collect_file_paths
    formatted = @options[:long_format] ? LongFormat.new(file_paths) : ShortFormat.new(file_paths)
    display(formatted)
  end

  private

  def determine_pathname(params)
    if params.empty?
      Dir.pwd
    else
      specified_pathname = params.find { |param| !param.start_with?('-') }
      specified_pathname || Dir.pwd
    end
  end

  def collect_file_paths
    pattern = Pathname(@pathname).join('*')
    options = @options[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_paths = Dir.glob(*options)
    @options[:reverse] ? file_paths.reverse : file_paths
  end

  def display(formatted)
    puts formatted.display
  end
end
