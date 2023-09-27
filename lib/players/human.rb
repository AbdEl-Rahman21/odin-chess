# frozen_string_literal: true

require_relative './player'
require 'rainbow'

class Human < Player
  COMMANDS = %w[save back resign].freeze

  def get_name(number)
    print "Player #{number} (#{print_color}), enter your name: "

    @name = gets.chomp
  end

  def get_choice(step)
    loop do
      print "#{@name} (#{print_color}), "

      print_step(step)

      choice = gets.chomp.downcase

      return choice if valid_choice?(choice)

      print_error_massage
    end
  end

  def valid_choice?(choice)
    return true if (choice.length == 2 && ('a'..'h').include?(choice[0]) && ('1'..'8').include?(choice[1])) ||
                   COMMANDS.include?(choice)

    false
  end

  def print_step(step)
    if step == 1
      print 'enter piece to move: '
    else
      print 'move piece to: '
    end
  end

  def print_error_massage
    puts Rainbow('Invalid choice.').color(:red)
    puts Rainbow('Examples: e4, a1, h8.').color(:blue)
  end
end
