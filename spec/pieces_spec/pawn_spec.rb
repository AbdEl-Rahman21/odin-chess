# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'

describe Pawn do
  describe '#move_blocked?' do
    subject(:pawn_move) { described_class.new([4, 5], :w) }

    context 'when there is a white piece in this coordinate (forward move)' do
      let(:white_piece) { double('pawn', coordinates: [5, 5], color: :w) }

      it 'returns true' do
        move = [5, 5]
        pieces = [white_piece]
        transitions = [0, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be true
      end
    end

    context 'when there is a black piece in this coordinate (forward move)' do
      let(:black_piece) { double('pawn', coordinates: [5, 5], color: :b) }

      it 'returns true' do
        move = [5, 5]
        pieces = [black_piece]
        transitions = [0, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be true
      end
    end

    context 'when there is a white piece in this coordinate (side move)' do
      let(:white_piece) { double('pawn', coordinates: [5, 5], color: :w) }

      it 'returns true' do
        move = [5, 5]
        pieces = [white_piece]
        transitions = [-1, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be true
      end
    end

    context 'when there is a black piece in this coordinate (side move)' do
      let(:black_piece) { double('pawn', coordinates: [5, 5], color: :b) }

      it 'returns false' do
        move = [5, 5]
        pieces = [black_piece]
        transitions = [1, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be false
      end
    end

    context "when there isn't a piece in coordinate (forward move)" do
      it 'returns false' do
        move = [5, 5]
        pieces = []
        transitions = [0, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be false
      end
    end

    context "when there isn't a piece in coordinate (side move)" do
      it 'returns true' do
        move = [5, 5]
        pieces = []
        transitions = [1, 1]
        expect(pawn_move.move_blocked?(pieces, move, transitions)).to be true
      end
    end
  end

  describe '#get_moves' do
    subject(:pawn_moves) { described_class.new([1, 1], :w) }

    context 'when move has a coordinate that is zero' do
      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [-1, 1]
        expect { pawn_moves.get_moves(pieces, move, transition) }.to_not(change { pawn_moves.moves })
      end
    end

    context 'when move has a coordinate that is greater than 8' do
      it "doesn't add the move" do
        pieces = []
        move = [7, 8]
        transition = [-1, 1]
        expect { pawn_moves.get_moves(pieces, move, transition) }.to_not(change { pawn_moves.moves })
      end
    end

    context 'when a move is blocked' do
      before do
        allow(pawn_moves).to receive(:move_blocked?).and_return(true)
      end

      it "doesn't add the move" do
        pieces = []
        move = [1, 1]
        transition = [1, 1]
        expect { pawn_moves.get_moves(pieces, move, transition) }.to_not(change { pawn_moves.moves })
      end
    end

    context 'when the move is valid' do
      before do
        allow(pawn_moves).to receive(:move_blocked?).and_return(false)
      end

      it 'adds the move' do
        pieces = []
        move = [7, 7]
        transition = [1, 1]
        expect { pawn_moves.get_moves(pieces, move, transition) }.to change { pawn_moves.moves }.to([move])
      end
    end
  end

  describe '#update_moves' do
    context 'when pawn is white' do
      subject(:pawn_moves) { described_class.new([2, 2], :w) }

      context "when it isn't the first move" do
        before do
          pawn_moves.instance_variable_set(:@first_move, false)
        end

        it 'call #get_moves thrice' do
          pieces = []
          expect(pawn_moves).to receive(:get_moves).thrice
          pawn_moves.update_moves(pieces)
        end
      end

      context "when there isn't other pieces to the side" do
        it 'gets all possible forward moves' do
          pieces = []
          moves = [[2, 4], [2, 3]]
          expect { pawn_moves.update_moves(pieces) }.to change { pawn_moves.moves }.to(moves)
        end
      end

      context 'when there is other pieces to the side' do
        let(:white_piece) { double('pawn', coordinates: [1, 3], color: :w) }
        let(:black_piece) { double('pawn', coordinates: [3, 3], color: :b) }

        it 'gets all possible moves of pawn' do
          pieces = [white_piece, black_piece]
          moves = [[2, 4], [2, 3], [3, 3]]
          expect { pawn_moves.update_moves(pieces) }.to change { pawn_moves.moves }.to(moves)
        end
      end
    end

    context 'when pawn is black' do
      subject(:pawn_moves) { described_class.new([2, 7], :b) }

      context "when it isn't the first move" do
        before do
          pawn_moves.instance_variable_set(:@first_move, false)
        end

        it 'call #get_moves thrice' do
          pieces = []
          expect(pawn_moves).to receive(:get_moves).thrice
          pawn_moves.update_moves(pieces)
        end
      end

      context "when there isn't other pieces to the side" do
        it 'gets all possible forward moves' do
          pieces = []
          moves = [[2, 5], [2, 6]]
          expect { pawn_moves.update_moves(pieces) }.to change { pawn_moves.moves }.to(moves)
        end
      end

      context 'when there is other pieces to the side' do
        let(:white_piece) { double('pawn', coordinates: [1, 6], color: :w) }
        let(:black_piece) { double('pawn', coordinates: [3, 6], color: :b) }

        it 'gets all possible moves of pawn' do
          pieces = [white_piece, black_piece]
          moves = [[1, 6], [2, 5], [2, 6]]
          expect { pawn_moves.update_moves(pieces) }.to change { pawn_moves.moves }.to(moves)
        end
      end
    end
  end
end
