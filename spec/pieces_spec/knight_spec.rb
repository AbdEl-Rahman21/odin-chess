# frozen_string_literal: true

require_relative '../../lib/pieces/knight'

describe Knight do
  describe '#get_moves' do
    subject(:knight_moves) { described_class.new([1, 1], :w) }

    context 'when move has a coordinate that is zero' do
      it "doesn't add the move" do
        pieces = []
        move = [1, 0]
        expect { knight_moves.get_moves(pieces, move) }.to_not(change { knight_moves.moves })
      end
    end

    context 'when move has a coordinate that is greater than 8' do
      it "doesn't add the move" do
        pieces = []
        move = [7, 9]
        expect { knight_moves.get_moves(pieces, move) }.to_not(change { knight_moves.moves })
      end
    end

    context 'when a move is blocked' do
      before do
        allow(knight_moves).to receive(:move_blocked?).and_return(true)
      end

      it "doesn't add the move" do
        pieces = []
        move = [1, 2]
        expect { knight_moves.get_moves(pieces, move) }.to_not(change { knight_moves.moves })
      end
    end

    context 'when the move is valid' do
      before do
        allow(knight_moves).to receive(:move_blocked?).and_return(false)
      end

      it 'adds the move' do
        pieces = []
        move = [7, 8]
        expect { knight_moves.get_moves(pieces, move) }.to change { knight_moves.moves }.to([move])
      end
    end
  end

  describe '#update_moves' do
    subject(:knight_moves) { described_class.new([4, 5], :w) }
    let(:white_piece) { double('knight', coordinates: [2, 6], color: :w) }
    let(:black_piece) { double('knight', coordinates: [5, 3], color: :b) }

    it 'gets all possible moves of knight' do
      pieces = [white_piece, black_piece]
      moves = [[2, 4], [3, 3], [3, 7], [5, 3], [5, 7], [6, 4], [6, 6]]
      expect { knight_moves.update_moves(pieces) }.to change { knight_moves.moves }.to(moves)
    end
  end
end
