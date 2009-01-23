# -*- encoding: utf-8 -*-
class StandardMove
  include Diagram::NodeBase
  @@move_amt = {:down=>[0,-1], :left=>[1,0], :right=>[-1,0], :up=>[0,1]}
  def initialize(amount)
    self[:from] = nil
    self[:to] = nil
    self[:dir] = nil
    @amount     = amount
    @move_amount = nil
    @cnt        = 0
    @finished   = false
    @moved      = false
  end
  
  def start
    amount_base = @@move_amt[self[:dir]]
    @move_amount = amount_base.map{|v| v * @amount}
    amt = amount_base.map{|d| d * -1 }.zip(Screen.rect.to_a[2..3]).map{|v| v[0] * v[1]}
    @cnt = (amt[0] + amt[1]).abs
    self[:to].move(*amt)
  end
  
  def update
    self[:from].move(*@move_amount)
    self[:to].move(*@move_amount)
    return unless @moved
		return unless @move_amount
    @cnt -= (@move_amount[0] + @move_amount[1]).abs
    @cnt = 0 if @cnt < 0
    @finished = (@cnt == 0)
    self[:to].centering if @finished
    @moved = false
  end

  def render
		return unless @move_amount
    return if @cnt < 0
    return if @finished
    self[:from].render
    self[:to].render
    @moved = true
  end

  def stop
    @finished = true
  end

  def finish?
    return @finished
  end
end

class StandardMoveFactory
  def StandardMoveFactory.create(amount = 48)
    return Diagram::Processor.new{|dia|
      dia.add :move, StandardMove.new(amount)
      dia.add_arrow(:move, nil){|obj| obj.finish? }
    }
  end
end

module MPSSlide
  def add_arrow_standard_move(event, slide, amount=48)
    hash = {
      :event => event,
      :slide => slide,
      :condition => Arrow.non_cond, 
      :trigger => @@dir2trigger[event].new,
      :move_type => StandardMoveFactory.create(amount)
    }
    add_arrow_ex(hash)
  end
end
