# frozen_string_literal: true

require_relative './piece'

class Knight < Piece
  @@TRANSITIONS = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]].freeze

  def possible_moves
    @@TRANSITIONS.each do |transition|
      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      @moves.push(move.dup) unless move.any? { |e| e <= 0 } || move.any? { |e| e > 8 } # or occupied
    end
  end
end
