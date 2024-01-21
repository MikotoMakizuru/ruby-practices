# frozen_string_literal: true

require_relative 'game'

describe Game do
  describe '#score' do
    context 'ボーリングの点数の記録を受け取ったとき' do
      example 'スコアを返すこと' do
        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        expect(game.score).to eq(139)
      end
    end
  end

  describe '#split_frame_array' do
    context '有効な入力が行われたとき' do
      example '各フレームを配列で返すこと' do
        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        expect(game.split_frame_array).to eq([
          ["6", "3"], ["9", "0"], ["0", "3"], ["8", "2"],
          ["7", "3"], ["X"], ["9", "1"], ["8", "0"],
          ["X"], ["6", "4", "5"]
        ])
      end
    end
  end
end
