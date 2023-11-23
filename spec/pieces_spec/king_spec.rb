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

  describe '#castling' do
    subject(:king_castle) { described_class.new([5, 1], :w) }

    context 'when the king has moved before' do
      before do
        king_castle.instance_variable_set(:@first_move, false)
      end

      it 'returns without calling anything' do
        expect(king_castle.castling(king_castle)).to be_zero
      end
    end
  end

  # No tests for #long_castling because it is the same as short_castling

  describe '#short_castling' do
    subject(:king_castle) { described_class.new([5, 1], :w) }

    context 'when there is no rook' do
      it "doesn't add the move" do
        pieces = [king_castle]
        expect { king_castle.short_castling(pieces) }.to_not(change { king_castle.moves })
      end
    end

    context 'when the rook has moved before' do
      let(:rook_castle) { double('rook', coordinates: [8, 1], color: :w, first_move: false) }

      it "doesn't add the move" do
        pieces = [king_castle, rook_castle]
        expect { king_castle.short_castling(pieces) }.to_not(change { king_castle.moves })
      end
    end

    context "when the rook hasn't moved before" do
      let(:rook_castle) { double('rook', coordinates: [8, 1], color: :w, first_move: true) }

      it 'adds the move' do
        pieces = [king_castle, rook_castle]
        new_moves = [[7, 1]]
        expect { king_castle.short_castling(pieces) }.to change { king_castle.moves }.to(new_moves)
      end
    end

    context 'when there is a piece in the way' do
      let(:rook_castle) { double('rook', coordinates: [8, 1], color: :w, first_move: false) }
      let(:obstacle_piece) { double('knight', coordinates: [7, 1], color: :w) }

      it "doesn't add the move" do
        pieces = [king_castle, rook_castle, obstacle_piece]
        expect { king_castle.short_castling(pieces) }.to_not(change { king_castle.moves })
      end
    end

    context 'when there is an attacking piece in the way' do
      let(:rook_castle) { double('rook', coordinates: [8, 1], color: :w, first_move: true) }
      let(:attacking_piece) { double('bishop', coordinates: [8, 3], color: :b, moves: [[6, 1]]) }

      it "doesn't add the move" do
        pieces = [king_castle, rook_castle, attacking_piece]
        expect { king_castle.short_castling(pieces) }.to_not(change { king_castle.moves })
      end
    end
  end
end
