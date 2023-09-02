# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'

describe Bishop do
  describe '#possible_moves' do
    subject(:bishop_moves) { described_class.new([4, 4], 'White') }

    it 'gets all possible moves of bishop' do
      moves = [[3, 3], [2, 2], [1, 1], [3, 5], [2, 6], [1, 7], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6], [7, 7], [8, 8]]
      expect { bishop_moves.possible_moves }.to change { bishop_moves.moves }.to(moves)
    end
  end
end
