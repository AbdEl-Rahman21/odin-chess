# frozen_string_literal: true

require_relative '../../lib/pieces/king'

describe King do
  describe '#get_moves' do
    subject(:king_moves) { described_class.new([1, 1], :w) }

    context 'when move has a coordinate that is zero' do
      it "doesn't add the move" do
        pieces = []
        move = [1, 0]
        expect { king_moves.get_moves(pieces, move) }.to_not(change { king_moves.moves })
      end
    end

    context 'when move has a coordinate that is greater than 8' do
      it "doesn't add the move" do
        pieces = []
        move = [7, 9]
        expect { king_moves.get_moves(pieces, move) }.to_not(change { king_moves.moves })
      end
    end

    context 'when a move is blocked' do
      before do
        allow(king_moves).to receive(:move_blocked?).and_return(true)
      end

      it "doesn't add the move" do
        pieces = []
        move = [1, 2]
        expect { king_moves.get_moves(pieces, move) }.to_not(change { king_moves.moves })
      end
    end

    context 'when the move is valid' do
      before do
        allow(king_moves).to receive(:move_blocked?).and_return(false)
      end

      it 'adds the move' do
        pieces = []
        move = [7, 8]
        expect { king_moves.get_moves(pieces, move) }.to change { king_moves.moves }.to([move])
      end
    end
  end

  describe '#update_moves' do
    subject(:king_moves) { described_class.new([6, 5], :w) }
    let(:white_piece) { double('king', coordinates: [5, 5], color: :w) }
    let(:black_piece) { double('king', coordinates: [7, 5], color: :b) }

    it 'gets all possible moves of king' do
      pieces = [white_piece, black_piece]
      moves = [[5, 4], [5, 6], [6, 4], [6, 6], [7, 4], [7, 5], [7, 6]]
      expect { king_moves.update_moves(pieces) }.to change { king_moves.moves }.to(moves)
    end
  end
end
