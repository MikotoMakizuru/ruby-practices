# frozen_string_literal: true

require_relative 'frame'

describe Frame do
  describe '#calculate_frame_score' do
    context 'フレームの点数を受け取ったとき' do
      example '合計を返すこと' do
        frame = Frame.new([3, 5])
        expect(frame.calculate_frame_score).to eq(3 + 5)
      end
    end
  end

  describe '#strike?' do
    context 'ストライクだったとき' do
      example 'trueを返すこと' do
        frame = Frame.new([10])
        expect(frame.strike?).to be true
      end
    end

    context 'ストライクではないとき' do
      example 'falseを返すこと' do
        frame = Frame.new([3, 5])
        expect(frame.strike?).to be false
      end
    end
  end

  describe '#spare?' do
    context 'スペアだったとき' do
      example 'trueを返すこと' do
        frame = Frame.new([8, 2])
        expect(frame.spare?).to be true
      end
    end

    context 'スペアではないとき' do
      example 'falseを返すこと' do
        frame = Frame.new([7, 2])
        expect(frame.spare?).to be false
      end
    end
  end
end
