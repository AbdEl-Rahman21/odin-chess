# frozen_string_literal: true

require_relative '../../lib/pieces/queen'

describe Queen do
  describe '#get_moves' do
    subject(:queen_moves) { described_class.new([1, 1], :w) }

    context 'when move has a coordinate that is zero' do
      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [-1, 1]
        expect { queen_moves.get_moves(pieces, move, transition) }.to_not(change { queen_moves.moves })
      end
    end

    context 'when move has a coordinate that is greater than 8' do
      it "doesn't add the move" do
        pieces = []
        move = [7, 8]
        transition = [-1, 1]
        expect { queen_moves.get_moves(pieces, move, transition) }.to_not(change { queen_moves.moves })
      end
    end

    context 'when a move is blocked' do
      before do
        allow(queen_moves).to receive(:move_blocked?).and_return(true)
      end

      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [1, 1]
        expect { queen_moves.get_moves(pieces, move, transition) }.to_not(change { queen_moves.moves })
      end
    end

    context 'when the move is valid' do
      before do
        allow(queen_moves).to receive(:move_blocked?).and_return(false)
      end

      it 'adds the move' do
        pieces = []
        move = [7, 7]
        transition = [1, 1]
        moves = [8, 8]
        expect { queen_moves.get_moves(pieces, move, transition) }.to change { queen_moves.moves }.to([moves])
      end
    end
  end

  describe '#update_moves' do
    subject(:queen_moves) { described_class.new([4, 4], :w) }
    let(:white_piece) { double('queen', coordinates: [2, 6], color: :w) }
    let(:black_piece) { double('queen', coordinates: [6, 6], color: :b) }

    it 'gets all possible moves of queen' do
      pieces = [white_piece, black_piece]
      moves = [[3, 3], [2, 2], [1, 1], [3, 4], [2, 4], [1, 4], [3, 5], [4, 3], [4, 2], [4, 1], [4, 5], [4, 6], [4, 7],
               [4, 8], [5, 3], [6, 2], [7, 1], [5, 4], [6, 4], [7, 4], [8, 4], [5, 5], [6, 6]]
      expect { queen_moves.update_moves(pieces) }.to change { queen_moves.moves }.to(moves)
    end
  end
end
