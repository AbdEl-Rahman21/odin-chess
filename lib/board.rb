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
    system('clear')

    puts "\s\s\sa\s\sb\s\sc\s\sd\s\se\s\sf\s\sg\s\sh"

    print_tiles(pieces)

    puts "\s\s\sa\s\sb\s\sc\s\sd\s\se\s\sf\s\sg\s\sh"
  end

  def print_tiles(pieces)
    i = 0

    (1..8).reverse_each do |number|
      print "#{number}\s"

      8.times do
        print_single_tile(i, pieces)

        i += 1
      end

      print "\s#{number}\n"
    end
  end

  def print_single_tile(index, pieces)
    if @tiles[index].sum.even?
      print Rainbow("\s#{tile_status(index, pieces)}").bg(:green)
      print Rainbow("\s").bg(:green)
    else
      print Rainbow("\s#{tile_status(index, pieces)}").bg(:snow)
      print Rainbow("\s").bg(:snow)
    end
  end

  def tile_status(index, pieces)
    pieces.each do |piece|
      return piece_color(piece) if piece.coordinates == @tiles[index]
    end

    "\s"
  end

  def piece_color(piece)
    if piece.instance_of?(Pawn)
      piece.color == :w ? Rainbow("\u2659").color(:black) : "\u265F"
    elsif piece.instance_of?(Rook)
      piece.color == :w ? Rainbow("\u2656").color(:black) : "\u265C"
    elsif piece.instance_of?(Knight)
      piece.color == :w ? Rainbow("\u2658").color(:black) : "\u265E"
    elsif piece.instance_of?(Bishop)
      piece.color == :w ? Rainbow("\u2657").color(:black) : "\u265D"
    elsif piece.instance_of?(Queen)
      piece.color == :w ? Rainbow("\u2655").color(:black) : "\u265B"
    elsif piece.instance_of?(King)
      piece.color == :w ? Rainbow("\u2654").color(:black) : "\u265A"
    end
  end
end
