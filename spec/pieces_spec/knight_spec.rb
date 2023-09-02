# frozen_string_literal: true

require_relative '../../lib/pieces/knight'

describe Knight do
  describe '#possible_moves' do
    subject(:knight_moves) { described_class.new([4, 5], 'White') }

    it 'gets all possible moves of knight' do
      moves = [[2, 4], [2, 6], [3, 3], [3, 7], [5, 3], [5, 7], [6, 4], [6, 6]]
      expect { knight_moves.possible_moves }.to change { knight_moves.moves }.to(moves)
    end
  end
end
