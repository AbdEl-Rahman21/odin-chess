## frozen_string_literal: true

require_relative './piece'

class King < Piece
  @@TRANSITIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def possible_moves
    @@TRANSITIONS.each do |transition|
      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      @moves.push(move.dup) unless move.any?(&:zero?) || move.any? { |e| e > 8 } # or occupied
    end
  end
end
