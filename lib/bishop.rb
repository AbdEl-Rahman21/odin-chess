# frozen_string_literal: true

require_relative './piece'

class Bishop < Piece
  @@TRANSITIONS = [[-1, -1], [-1, 1], [1, -1], [1, 1]].freeze

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