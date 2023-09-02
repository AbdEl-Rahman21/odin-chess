# frozen_string_literal: true

require_relative '../../lib/pieces/rook'

describe Rook do
  describe '#get_moves' do
    subject(:rook_moves) { described_class.new([1, 1], :w) }

    context 'when move has a coordinate that is zero' do
      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [-1, 0]
        expect { rook_moves.get_moves(pieces, move, transition) }.to_not(change { rook_moves.moves })
      end
    end

    context 'when move has a coordinate that is greater than 8' do
      it "doesn't add the move" do
        pieces = []
        move = [7, 8]
        transition = [0, 1]
        expect { rook_moves.get_moves(pieces, move, transition) }.to_not(change { rook_moves.moves })
      end
    end

    context 'when a move is blocked' do
      before do
        allow(rook_moves).to receive(:move_blocked?).and_return(true)
      end

      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [0, 1]
        expect { rook_moves.get_moves(pieces, move, transition) }.to_not(change { rook_moves.moves })
      end
    end

    context 'when the move is valid' do
      before do
        allow(rook_moves).to receive(:move_blocked?).and_return(false)
      end

      it 'adds the move' do
        pieces = []
        move = [7, 7]
        transition = [0, 1]
        moves = [7, 8]
        expect { rook_moves.get_moves(pieces, move, transition) }.to change { rook_moves.moves }.to([moves])
      end
    end
  end

  describe '#update_moves' do
    subject(:rook_moves) { described_class.new([4, 5], :w) }
    let(:white_piece) { double('rook', coordinates: [2, 5], color: :w) }
    let(:black_piece) { double('rook', coordinates: [6, 5], color: :b) }

    it 'gets all possible moves of rook' do
      pieces = [white_piece, black_piece]
      moves = [[3, 5], [4, 4], [4, 3], [4, 2], [4, 1], [4, 6], [4, 7], [4, 8], [5, 5], [6, 5]]
      expect { rook_moves.update_moves(pieces) }.to change { rook_moves.moves }.to(moves)
    end
  end
end
