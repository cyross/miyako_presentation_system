# -*- encoding: utf-8 -*-
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.

class LogTimer
  include Miyako::Diagram::NodeBase
  
  def initialize
    @font_size = 32
    @font = Miyako::Font.sans_serif
    @font.size = @font_size
    @font.color = Color[:white]
    size = [Miyako::Screen::w, @font.line_height]
    @spr = Miyako::Sprite.new(:size => size, :type => :ac).bottom
    @from = Time.now
    @to = Time.now
    @timer = 0
    @update = false
  end

  def start
    @from = Time.now
    @update = true
  end
  
  def stop
    @update = false
  end
  
  def reset
    @from = Time.now
    @timer = 0
  end

  def pause
    @update = false
  end
  
  def resume
    self.start
  end
  
  def update
    return unless @update
    @to = Time.now
    @timer = (@to - @from).to_i
  end

  # 表示部分を消去した瞬間に画面に反映されるのを防ぐため、renderメソッドを明示的に呼び出す
  def render
    @spr.fill([0,0,0,0])
    @font.draw_text(@spr, "経過時間："+Time.at(@timer).getutc.strftime("%H:%M:%S"), 0, 0)
  end
  
  def dispose
    @spr.dispose
  end
end

class LogTimerManager
  def initialize
    @tm = Miyako::Diagram::Processor.new{|dia| dia.add :main, LogTimer.new() }
  end
  def start; @tm.start end
  def stop; @tm.stop end
  def pause; @tm.pause end
  def resume; @tm.pause end
  def render; @tm.render end
  def dispose; @tm.dispose end
end