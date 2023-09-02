# frozen_string_literal: true

require_relative './piece'

class Rook < Piece
  @@TRANSITIONS = [[-1, 0], [0, -1], [0, 1], [1, 0]].freeze
  @first_move = true

  def possible_moves
    @@TRANSITIONS.each do |transition|
      move = @coordinates.dup

      loop do
        move = [move[0] + transition[0], move[1] + transition[1]]

        break if move.any?(&:zero?) || move.any? { |e| e > 8 } # or occupied

        @moves.push(move.dup)
      end
    end
  end
end
