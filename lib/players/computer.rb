# frozen_string_literal: true

require_relative './player'

# Class for the computer player
class Computer < Player
  def initialize(color)
    super(color)

    @chosen_piece = 0
  end

  def get_choice(step)
    if step == 1
      select_piece
    else
      select_move
    end
  end

  def promote(piece)
    @pieces.unshift(Queen.new(piece.coordinates, @color))

    @pieces.delete(piece)
  end

  private

  def select_piece
    @chosen_piece = @pieces.filter { |piece| !piece.moves.empty? }.sample

    [(@chosen_piece.coordinates[0] + 9).to_s(36), @chosen_piece.coordinates[1].to_s].join
  end

  def select_move
    move = @chosen_piece.moves.sample

    [(move[0] + 9).to_s(36), move[1].to_s].join
  end
end
