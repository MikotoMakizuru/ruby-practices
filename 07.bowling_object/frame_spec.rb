# frozen_string_literal: true

require_relative 'frame'

describe Frame do
  describe '#calculate_score' do
    context 'フレームの点数を受け取ったとき' do
      example '合計を返すこと' do
        frame = Frame.new([3, 5])
        expect(frame.calculate_score).to eq(3 + 5)
      end
    end
  end

  describe '#strike?' do
    context 'フレーム内の1投目がXだったとき' do
      example 'trueを返すこと' do
        frame = Frame.new(['X'])
        expect(frame.send(:strike?)).to be true
      end
    end

    context 'フレーム内の1投目がX以外だったとき' do
      example 'falseを返すこと' do
        frame = Frame.new([3, 5])
        expect(frame.send(:strike?)).to be false
      end
    end
  end

  describe '#spare?' do
    context 'フレームの1投目と2投目の合計が10だったとき' do
      example 'trueを返すこと' do
        frame = Frame.new([8, 2])
        expect(frame.send(:spare?)).to be true
      end
    end

    context 'フレームの1投目と2投目の合計が10未満だったとき' do
      example 'falseを返すこと' do
        frame = Frame.new([7, 2])
        expect(frame.send(:spare?)).to be false
      end
    end

    context 'フレーム内の1投目がXだったとき' do
      example 'falseを返すこと' do
        frame = Frame.new(['X'])
        expect(frame.send(:spare?)).to be false
      end
    end
  end
end
