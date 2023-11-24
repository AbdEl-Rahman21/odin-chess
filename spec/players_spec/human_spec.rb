# frozen_string_literal: true

require_relative '../../lib/players/human'
require 'rainbow'

describe Human do
  describe '#get_choice' do
    subject(:human_choice) { described_class.new(:w) }

    context 'when the user inputs three invalid inputs, then a valid input' do
      before do
        invalid = %w[aaa w2 e9]
        valid = 'a4'
        allow(human_choice).to receive(:print_step)
        allow(human_choice).to receive(:gets).and_return(invalid[0], invalid[1], invalid[2], valid)
      end

      it 'completes loop and displays error massage three times' do
        expect(human_choice).to receive(:print_error_massage).exactly(3).times
        human_choice.get_choice(1)
      end
    end

    context 'when the user inputs a valid command' do
      before do
        valid = 'back'
        allow(human_choice).to receive(:print_step)
        allow(human_choice).to receive(:gets).and_return(valid)
      end

      it 'completes loop without displaying error massage' do
        expect(human_choice.get_choice(1)).to eq('back')
      end
    end
  end

  describe '#promote' do
    subject(:human_promote) { described_class.new(:w) }

    context 'when the user inputs three invalid inputs, then a valid input' do
      before do
        invalid = %w[a w2 e9]
        valid = 'k'
        allow(human_promote).to receive(:print)
        allow(human_promote).to receive(:gets).and_return(invalid[0], invalid[1], invalid[2], valid)
        allow(human_promote).to receive(:handle_promotion)
      end

      it 'completes loop and displays error massage three times' do
        message = Rainbow('Invalid choice!').color(:red)
        expect(human_promote).to receive(:puts).with(message).exactly(3).times
        human_promote.promote([])
      end
    end

    context 'when the user inputs a valid input' do
      let(:pawn_prom) { double('pawn', coordinates: [2, 8], moves: [[]]) }

      before do
        valid = 'k'
        allow(human_promote).to receive(:print)
        allow(human_promote).to receive(:gets).and_return(valid)
      end

      it 'adds the chosen piece' do
        expect { human_promote.promote(pawn_prom) }.to change { human_promote.pieces.length }.to(1)
      end
    end
  end
end
