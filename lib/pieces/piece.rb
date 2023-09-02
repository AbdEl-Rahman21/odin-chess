# frozen_string_literal: true

class Piece
  attr_reader :coordinates, :color, :moves

  def initialize(coordinates, color)
    @coordinates = coordinates
    @color = color
    @moves = []
    @first_move = true
  end

  def move_blocked?(pieces, move)
    pieces.each do |piece|
      if piece.coordinates == move && piece.color == @color
        return true
      elsif piece.coordinates == move && piece.color != @color
        @moves.push(move.dup)

        return true
      end
    end

    false
  end

  def move_piece(move)
    @coordinates = move

    @first_move = false
  end
end
