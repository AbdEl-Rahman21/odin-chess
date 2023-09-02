# frozen_string_literal: true

require_relative '../../lib/pieces/king'

describe King do
  describe '#possible_moves' do
    subject(:king_moves) { described_class.new([6, 5], 'White') }

    it 'gets all possible moves of king' do
      moves = [[5, 4], [5, 5], [5, 6], [6, 4], [6, 6], [7, 4], [7, 5], [7, 6]]
      expect { king_moves.possible_moves }.to change { king_moves.moves }.to(moves)
    end
  end
end
