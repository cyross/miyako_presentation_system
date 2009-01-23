# -*- encoding: utf-8 -*-
class ShowSlide
  include Miyako::Diagram::NodeBase

  def initialize
    @com = Common.instance
    @now_slide = nil
    @old_slide = nil
    @slide = nil
    @finished = false
    @moving = nil
  end
  def start
    @now_slide = @com.now_chapter[@com.selected_index]
    @slide = @now_slide.new
    @slide.pre_process
    @slide.start
    show_arrow
    @finished = false
  end
  def stop
    hide_arrow
    @slide.post_process
    @slide.stop
    @slide.dispose
    @com.now_chapter[@com.selected_index] = @now_slide
  end
  def update
    if @moving
      # 移動が終了したときの後始末
      if @moving.finish?
        @moving.stop
        @moving = nil
        @slide.pre_process
        @old_slide.stop
        @old_slide = nil
        show_arrow
      end
      # 移動中の時は、移動を優先
      return
    end
    @slide.update
    if (ret = @slide.trigger?)
      @slide.post_trigger
      hide_arrow
      @now_slide = ret.next_slide
      @old_slide = @slide
      @slide = @now_slide.new
      @slide.start
      # 移動タイプが無指定のときは、瞬時に移動する手続きを取る
      unless ret.move_type
        @slide.pre_process
        @old_slide = nil
        show_arrow
        return
      end
      @moving = ret.move_type
      @moving[:move][:from] = @old_slide
      @moving[:move][:to]   = @slide
      @moving[:move][:dir]  = ret.event
      @moving.start
    end
  end
  def update_input
    return unless @slide
    @finished = Miyako::Input.pushed_any?(:btn2)
    list = Miyako::Input.pushed_any?(:btn1) ? [:btn1] : []
    @com.dirs.each{|dir| 
      if Miyako::Input.pushed_any?(dir)
        list << dir
        break
      end
    }
    if @moving && !(@moving.finish?)
      @moving.update
    else
      @slide.update_input(list)
      @slide.update_animation
      @slide.update
    end
    @slide.get_arrow_dirs.each{|ar| @com.arrow[ar].update_animation }
  end
  def render
    if @moving && !(@moving.finish?)
      @moving.render
    else
      @slide.render
    end
    @slide.get_arrow_dirs.each{|ar| @com.arrow[ar].render }
  end
  def dispose
    @slide.dispose
  end
  def finished?
    return @finished
  end
  def show_arrow
    @slide.get_arrow_dirs.each{|ar| @com.arrow[ar].start }
  end
  def hide_arrow
    @com.arrow.values.each{|ar| ar.stop }
  end
  private :show_arrow, :hide_arrow
end
