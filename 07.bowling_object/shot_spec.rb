# frozen_string_literal: true

require_relative 'shot'

describe Shot do
  describe '#score' do
    context 'markがXのとき' do
      example '10を返すこと' do
        shot = Shot.new('X')
        expect(shot.score).to eq(10)
      end
    end

    context 'markが数字のとき' do
      example 'そのまま数字を返すこと' do
        shot = Shot.new(1)
        expect(shot.score).to eq(1)
      end
    end
  end
end
