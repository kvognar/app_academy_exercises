# encoding: utf-8
class Piece
  attr_reader :pos, :color, :king
  
  def initialize(color, pos, king = false, board)
    @color = color
    @pos = pos
    @king = king
    @board = board
  end
  
  def moves
    slides + jumps
  end
  
  def slides
    sliding_spots = vectors.map { |dy, dx| [@pos[0] + dy, @pos[1] + dx] }
    sliding_spots.select do |end_pos|
      @board[end_pos].nil? && end_pos.all? {|i| i.between?(0,7) }
    end
  end
  
  def jumps
    landing_spots = []
    vectors.each do |dy, dx|
      slide_spot = [@pos[0] + dy, @pos[1] + dx]
      landing_spot = [@pos[0] + dy * 2, @pos[1] + dx * 2]
      unless @board[slide_spot].nil? ||
             @board[slide_spot].color == @color ||
             landing_spot.any? { |i| !i.between?(0,7) }
        landing_spots << landing_spot
      end
    end
    landing_spots  
  end
  
  def jump!(end_pos)
    unless jumps.include?(end_pos)
      raise InvalidMoveError.new("I can't go there")
      return
    end

    victim_pos = middle_square(@pos, end_pos)
    @board.jump_piece(self, end_pos, victim_pos)
    @pos = end_pos
    maybe_promote
  end
  
  def slide!(end_pos)
    raise "I can't go there" unless slides.include?(end_pos)
    @board.move_piece(self, end_pos)
    @pos = end_pos
    maybe_promote
  end
  
  def vectors
    up = [[-1, -1], [-1, 1]]
    down = [[1, 1], [1, -1]]
    if @king
      up + down
    else
      @color == :black ? down : up
    end
  end
  
  def to_s
    if @king
      @color == :black ? '✿' : '❀'
    else
      @color == :black ? '◉' : '◎'
    end
  end
  
  def inspect
    to_s
  end
  
  def stats
    {"color" => :color,
      "moves" => moves,
      "king?" => @king,
      "position" => pos
    }
  end
  
  def middle_square(pos1, pos2)
    pos1.zip(pos2).map { |a, b| (a + b) / 2 }
  end
  
  def maybe_promote
    back_row = color == :black ? 7 : 0
    @king = true if @pos[0] == back_row
  end
  
  def perform_moves!(move_sequence)
    if move_sequence.count == 1 && slides.include?(move_sequence[0])
      slide!(move_sequence[0])
      return
    end 
    move_sequence.each do |move|
      # begin
        jump!(move)
      # rescue InvalidMoveError => e
      #   puts e.message
      #   break
      # end
    end
  end
  
  def perform_moves(move_sequence)
    if valid_move_sequence?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError.new("Invalid move sequence!")
      return false
    end
    true
  end
  
  def valid_move_sequence?(move_sequence)
    begin
      @board.dup[@pos].perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    end
    true
  end
  
  
end

class InvalidMoveError < ArgumentError
end