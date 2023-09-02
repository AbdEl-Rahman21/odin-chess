# frozen_string_literal: true

class Piece
  attr_reader :coordinates, :color, :moves

  def initialize(coordinates, color)
    @coordinates = coordinates
    @color = color
    @moves = []
  end
end
