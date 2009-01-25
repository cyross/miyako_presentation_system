# -*- encoding: utf-8 -*-
require 'singleton'

class WritePen
  def initialize(color=[255,0,0])
    @color = color
    @org_pos = [-1,-1]
  end

  def draw(sprite, x, y)
    @org_pos = [x, y] if @org_pos == [-1,-1]
#    Drawing.line(sprite, @org_pos << x <<  y, @color)
    Drawing.circle(sprite, [x, y], 5, @color, :fill)
    @org_pos = [x, y]
  end

  def reset
    @org_pos = [-1, -1]
  end
end

class WriteBoard
  include Singleton

  def initialize(color = [255,0,0])
    @board = Sprite.new(:size=>[Screen.w, Screen.h], :type=>:ac)
    @pen = WritePen.new(color)
  end

  def color=(color)
    @pen = WritePen.new(color)
  end

  def start
    clear
  end
  
  def update
    clear if Input.click?(:right)
    pos = Input.get_mouse_position
    if Input.mouse_trigger?(:left)
      draw(pos[:x], pos[:y])
    else
      reset
    end
  end
  
  def draw(x, y)
    @pen.draw(@board, x, y)
  end

  def move(x, y)
    @pen.move(x, y)
  end

  def render
    @board.render
  end
  
  def reset
    @pen.reset
  end

  def clear
    @board.fill([0,0,0,0])
  end
  
  def dispose
    @board.dispose
    @board = nil
  end
end
