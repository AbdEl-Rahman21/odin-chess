# frozen_string_literal: true

require_relative '../../lib/players/computer'

describe Computer do
  describe '#get_choice' do
    subject(:computer_choice) { described_class.new(:w) }
    let(:movable_piece) { double('king', coordinates: [5, 5], moves: [[5, 6]]) }

    context 'when there is a piece that can move' do
      before do
        computer_choice.instance_variable_set(:@pieces, [movable_piece])
        computer_choice.instance_variable_set(:@chosen_piece, movable_piece)
      end

      it 'gets its coordinates' do
        expect(computer_choice.get_choice(1)).to eq('e5')
      end

      it 'gets its move' do
        expect(computer_choice.get_choice(2)).to eq('e6')
      end
    end

    context "when there is a piece that can move and another that can't" do
      let(:unmovable_piece) { double('pawn', coordinates: [5, 8], moves: []) }

      before do
        computer_choice.instance_variable_set(:@pieces, [movable_piece, unmovable_piece])
      end

      it 'gets the coordinates of the movable piece' do
        expect(computer_choice.get_choice(1)).to eq('e5')
      end
    end
  end
end
