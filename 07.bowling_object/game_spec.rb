# frozen_string_literal: true

require_relative 'game'

describe Game do
  describe '#score' do
    context 'ボウリングの点数の記録を受け取ったとき' do
      example 'スコアを返すこと' do
        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        expect(game.score).to eq(139)

        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
        expect(game.score).to eq(164)

        game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
        expect(game.score).to eq(107)

        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
        expect(game.score).to eq(134)

        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
        expect(game.score).to eq(144)

        game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
        expect(game.score).to eq(300)

        game = Game.new('X,X,X,X,X,X,X,X,X,X,X,2')
        expect(game.score).to eq(292)

        game = Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0')
        expect(game.score).to eq(50)
      end
    end
  end

  describe '#parse_input' do
    context '有効な入力が行われたとき' do
      example '各フレームを配列で返すこと' do
        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        frames = game.send(:parse_input)
        expect(frames).to eq([
          ["6", "3"], ["9", "0"], ["0", "3"], ["8", "2"],
          ["7", "3"], ["X"], ["9", "1"], ["8", "0"],
          ["X"], ["6", "4", "5"]
        ])
      end
    end
  end

  describe '#parse_input_with_three_values' do
    context '1つの配列が1から3つの値を持つ二次元配列を受け取ったとき' do
      example '1つの配列が3つの値を持つ二次元配列を返すこと' do
        game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
        frames = game.parse_input_with_three_values
        expect(frames).to eq([["6", "3", "9"], ["9", "0", "0"],
          ["0", "3", "8"], ["8", "2", "7"], ["7", "3", "X"],
          ["X", "9", "1"], ["9", "1", "8"], ["8", "0", "X"],
          ["X", "6", "4"], ["6", "4", "5"]
        ])
      end
    end
  end
end
