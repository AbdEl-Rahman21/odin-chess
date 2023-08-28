# frozen_string_literal: true

require 'pry-byebug'

def pawn(coord)
  moves = []
  transitions = [[0, 1], [0, 2], [-1, 1], [1, 1]].freeze

  transitions.each { |combo| small_moves(combo, coord.dup).each { |move| moves.push(move) } }

  moves
end

def small_moves(shift, coord)
  moves = []

  coord = [coord[0] + shift[0], coord[1] + shift[1]]

  if !(coord.any?(&:zero?) || coord.any? { |e| e > 8 }) && (shift == [0, 1] || conditions?(shift)) # or occupied
    moves.push(coord.dup)
  end

  moves
end

def conditions?(shift)
  cond = { first_move: true, left: true, right: true }

  return true if (shift == [0, 2] && cond[:first_move]) ||
                 (shift == [1, 1] && cond[:right]) ||
                 (shift == [-1, 1] && cond[:left])

  false
end

# p pawn([6, 2])
