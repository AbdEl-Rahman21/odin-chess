# frozen_string_literal: true

require_relative './piece'

# Class for the Pawn piece
class Pawn < Piece
  TRANSITIONS = [[0, 1], [0, 2], [-1, 1], [1, 1], [0, -1], [0, -2], [-1, -1], [1, -1]].freeze

  def update_moves(pieces)
    @moves = []

    TRANSITIONS.each do |transition|
      next if skip?(transition)

      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      get_moves(pieces, move, transition)
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def skip?(transition)
    return true if (transition[1].abs == 2 && (!@first_move || @moves.empty?)) ||
                   (transition[1].negative? && @color == :w) || (transition[1].positive? && @color == :b)

    false
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def get_moves(pieces, move, transition)
    @moves.push(move.dup) unless move.any?(&:zero?) || move.any? { |e| e > 8 } ||
                                 move_blocked?(pieces, move, transition)
  end

  def move_blocked?(pieces, move, transition)
    if transition[0].zero?
      pieces.each { |piece| return true if piece.coordinates == move }
    else
      pieces.each { |piece| return false if piece.coordinates == move && piece.color != @color }

      return true
    end

    false
  end
end
