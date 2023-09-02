# frozen_string_literal: true

require_relative '../../lib/pieces/piece'

describe Piece do
  describe '#move_blocked?' do
    subject(:piece_move) { described_class.new([4, 4], :w) }

    context 'when there is a white piece in this coordinate' do
      let(:white_piece) { double('piece', coordinates: [5, 5], color: :w) }

      it "doesn't add move" do
        move = [5, 5]
        pieces = [white_piece]
        expect { piece_move.move_blocked?(pieces, move) }.to_not(change { piece_move.moves })
      end

      it 'returns true' do
        move = [5, 5]
        pieces = [white_piece]
        expect(piece_move.move_blocked?(pieces, move)).to be true
      end
    end

    context 'when there is a black piece in this coordinate' do
      let(:black_piece) { double('piece', coordinates: [5, 5], color: :b) }

      it 'adds move' do
        move = [5, 5]
        pieces = [black_piece]
        expect { piece_move.move_blocked?(pieces, move) }.to change { piece_move.moves }.to([move])
      end

      it 'returns true' do
        move = [5, 5]
        pieces = [black_piece]
        expect(piece_move.move_blocked?(pieces, move)).to be true
      end
    end

    context "when there isn't a piece in coordinate" do
      it 'returns false' do
        move = [5, 5]
        pieces = []
        expect(piece_move.move_blocked?(pieces, move)).to be false
      end
    end
  end

  describe '#move_piece' do
    subject(:piece_position) { described_class.new([4, 4], :w) }

    it 'changes current coordinates to new coordinates' do
      move = [5, 5]
      expect { piece_position.move_piece(move) }.to change { piece_position.coordinates }.to(move)
    end

    it 'changes @first_move to new false' do
      move = [5, 5]
      expect { piece_position.move_piece(move) }.to change {
                                                      piece_position.instance_variable_get(:@first_move)
                                                    }.to(false)
    end
  end
end
