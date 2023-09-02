# frozen_string_literal: true

require_relative '../../lib/pieces/rook'

describe Rook do
  describe '#possible_moves' do
    subject(:rook_moves) { described_class.new([4, 5], 'White') }

    it 'gets all possible moves of rook' do
      moves = [[3, 5], [2, 5], [1, 5], [4, 4], [4, 3], [4, 2], [4, 1], [4, 6], [4, 7], [4, 8], [5, 5], [6, 5], [7, 5],
               [8, 5]]
      expect { rook_moves.possible_moves }.to change { rook_moves.moves }.to(moves)
    end
  end
end
