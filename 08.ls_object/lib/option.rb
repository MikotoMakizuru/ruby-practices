# frozen_string_literal: true

require 'optparse'

class Option
  def initialize(params)
    @params = extract_start_with_hyphen(params)
  end

  def parse
    options = { long_format: false, reverse: false, dot_match: false }

    OptionParser.new do |opt|
      opt.on('-l') { options[:long_format] = true }
      opt.on('-r') { options[:reverse] = true }
      opt.on('-a') { options[:dot_match] = true }
    end.parse!(@params)
    options
  end

  private

  def extract_start_with_hyphen(params)
    params.empty? ? [] : params.select { |param| param.start_with?('-') }
  end
end
