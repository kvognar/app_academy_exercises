require "debugger"
class Hand
  attr_reader :cards
  
  RANK_ORDER = [ 
    :royal_flush, :straight_flush, :four_of_a_kind, :full_house,
    :flush, :straight, :three_of_a_kind, :two_pair, :one_pair,
    :no_pair
  ]
  
  def initialize
    @cards = []
  end
  
  def rank
    RANK_ORDER.each do |rank|
      return rank if self.send(rank)
    end 
  end
  
  def high_card
    if [:royal_flush, :straight_flush, :flush, :straight, :no_pair].include?(rank)
      sort_values.max
    elsif [:four_of_a_kind].include?(rank)
      sort_values.select { |value| sort_values.count(value) == 4 }.max
    elsif [:full_house, :three_of_a_kind].include?(rank)
      sort_values.select { |value| sort_values.count(value) == 3}.max
    elsif [:two_pair, :one_pair].include?(rank)
      sort_values.select { |value| sort_values.count(value) == 2}.max
    end
  end
  
  def deal(*cards)
    @cards.concat(cards)
  end
  
  def beats?(other)
    case RANK_ORDER.index(self.rank) <=> RANK_ORDER.index(other.rank)
    when -1
      true
    when 1
      false
    when 0
      self.high_card > other.high_card
    end
  end
  
  private
  
  def royal_flush
    sort_values == [10, 11, 12, 13, 14] && flush
  end
  
  def straight
    values = sort_values
    values.each_with_index do |value, index|
       return false unless value == values[0] + index
    end
    true
  end
  
  def straight_flush
    straight && flush
  end
  
  def four_of_a_kind
    sort_values.any? { |val| sort_values.count(val) == 4 }
  end
  
  def three_of_a_kind
    sort_values.any? { |val| sort_values.count(val) == 3 }
  end
  
  def full_house
    three_of_a_kind && one_pair
  end
  
  def two_pair
    one_pair && sort_values.uniq.count == 3
  end
  
  def one_pair
    sort_values.any? { |val| sort_values.count(val) == 2 }
  end
  
  def flush
    @cards.all? { |card| card.suit == @cards.first.suit }
  end
  
  def no_pair
    true
  end
  
  def sort_values
    @cards.map { |card| card.value }.sort
  end
end