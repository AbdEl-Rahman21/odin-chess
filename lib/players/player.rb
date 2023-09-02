# frozen_string_literal: true

require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/knight'
require_relative '../pieces/pawn'
require_relative '../pieces/queen'
require_relative '../pieces/rook'

class Player
  attr_reader :name, :color, :in_check, :pieces

  def initialize(color)
    @name = ''
    @color = color
    @in_check = false
    @pieces = []
  end

  def create_pieces
    i = 1
    j = 2

    if @color == :b
      i = 8
      j = 7
    end

    @pieces = [Pawn.new([j, 1], @color), Pawn.new([j, 2], @color), Pawn.new([j, 3], @color), Pawn.new([j, 4], @color),
               Pawn.new([j, 5], @color), Pawn.new([j, 6], @color), Pawn.new([j, 7], @color), Pawn.new([j, 8], @color),
               Rook.new([i, 1], @color), Rook.new([i, 8], @color), Knight.new([i, 2], @color), Knight.new([i, 7], @color),
               Bishop.new([i, 3], @color), Bishop.new([i, 6], @color), Queen.new([i, 4], @color), King.new([i, 5], @color)]
  end
end
