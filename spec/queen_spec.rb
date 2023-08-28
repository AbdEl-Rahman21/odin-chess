# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
  describe '#possible_moves' do
    subject(:queen_moves) { described_class.new([4, 4], 'White') }

    it 'gets all possible moves of queen' do
      moves = [[3, 3], [2, 2], [1, 1], [3, 4], [2, 4], [1, 4], [3, 5], [2, 6], [1, 7], [4, 3], [4, 2], [4, 1], [4, 5],
               [4, 6], [4, 7], [4, 8], [5, 3], [6, 2], [7, 1], [5, 4], [6, 4], [7, 4], [8, 4], [5, 5], [6, 6], [7, 7], [8, 8]]
      expect { queen_moves.possible_moves }.to change { queen_moves.moves }.to(moves)
    end
  end
end
