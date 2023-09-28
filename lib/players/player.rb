# frozen_string_literal: true

require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/knight'
require_relative '../pieces/pawn'
require_relative '../pieces/queen'
require_relative '../pieces/rook'

# Superclass for players
class Player
  attr_reader :name, :color, :in_check, :pieces

  def initialize(color)
    @name = ''
    @color = color
    @pieces = []
  end

  def create_pieces
    i = 1
    j = 2

    if @color == :b
      i = 8
      j = 7
    end

    # rubocop:disable Layout/LineLength
    @pieces = [Pawn.new([1, j], @color), Pawn.new([2, j], @color), Pawn.new([3, j], @color), Pawn.new([4, j], @color),
               Pawn.new([5, j], @color), Pawn.new([6, j], @color), Pawn.new([7, j], @color), Pawn.new([8, j], @color),
               Rook.new([1, i], @color), Knight.new([2, i], @color), Bishop.new([3, i], @color), Queen.new([4, i], @color),
               Rook.new([8, i], @color), Knight.new([7, i], @color), Bishop.new([6, i], @color), King.new([5, i], @color)]

    # rubocop:enable Layout/LineLength
  end

  def print_color
    @color == :w ? 'White' : 'Black'
  end
end
