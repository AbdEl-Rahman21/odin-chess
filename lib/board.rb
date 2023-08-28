# frozen_string_literal: true

require 'rainbow'

class Board
  def initialize
    @tiles = []

    generate_tiles
  end

  def generate_tiles
    i = 0

    8.times do
      j = 0

      8.times do
        @tiles.push([8 - i, 1 + j])

        j += 1
      end

      i += 1
    end
  end

  def print_board(pieces)
    i = 0

    (1..8).each do |number|
      print "#{number}\s"
      8.times do
        print_tile(i, pieces)

        i += 1
      end

      print "\n"
    end

    puts "\s\s\sa\s\sb\s\sc\s\sd\s\se\s\sf\s\sg\s\sh"
  end

  def print_tile(index, pieces)
    if @tiles[index].sum.even?
      print Rainbow("\s#{tile_status(pieces)}\s").bg(:green)
    else
      print Rainbow("\s#{tile_status(pieces)}\s").bg(:white)
    end
  end

  def tile_status(index, pieces)
    pieces.each do |piece|
      return piece_color if piece.coordinates == @tiles[index]
    end

    "\s"
  end

  def piece_color(piece)
    case piece.class
    when Pawn
      piece.color == :w ? "\u2659" : "\u265F"
    when Rook
      piece.color == :w ? "\u2656" : "\u265C"
    when Knight
      piece.color == :w ? "\u2658" : "\u265E"
    when Bishop
      piece.color == :w ? "\u2657" : "\u265D"
    when Queen
      piece.color == :w ? "\u2655" : "\u265B"
    when King
      piece.color == :w ? "\u2654" : "\u265A"
    end
  end
end
