require_relative 'piece'

class Board
  attr_reader :grid, :current_turn
  
  def initialize(empty = false)
    @grid = Array.new(8) { Array.new(8) }
    [:black, :red].each { |color| place_pieces(color) } unless empty
    @current_turn = :red
  end
  
  def place_pieces(color)
    rows = color == :black ? [0, 1, 2] : [5, 6, 7]
    rows.each do |row|
      8.times do |column|
        next if (row + column).odd?
        self[[row, column]] = Piece.new(color, [row, column], self)
      end
    end
  end
  
  def [](pos)
    y, x = pos
    return nil if @grid[y].nil?
    @grid[y][x]
  end
  
  def []=(pos, element)
    y, x = pos
    @grid[y][x] = element
  end
  
  def display
    @grid.each do |row|
      p row
    end
  end
  
  def move_piece(piece, pos)
    self[piece.pos] = nil
    self[pos] = piece
  end
  
  def jump_piece(piece, pos, victim_pos)
    self[piece.pos] = nil
    self[pos] = piece
    self[victim_pos] = nil
  end
  
  def dup
    piece_data = pieces.map do |piece|
      [piece.color, piece.pos.dup, piece.king]
    end
    dup_board = Board.new(true)
    piece_data.each do |color, pos, king|
      dup_board[pos] = Piece.new(color, pos, king, dup_board)
    end
    dup_board
  end
  
  def pieces(color = nil)
    return @grid.flatten.compact if color.nil?
    @grid.flatten.compact.select { |piece| piece.color == color }
  end
  
  def switch_turns
    @current_turn = @current_turn == :black ? :red : :black
  end
  
  def jump_possible?(color)
    pieces.select { |piece| piece.color == color }.any? do |piece|
      piece.jumps.count > 0
    end
  end
  
  private
    
  
end