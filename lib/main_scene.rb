# -*- encoding: utf-8 -*-
class MainScene
  include Miyako::Story::Scene

  def init
    @com = Common.instance
    @yuki = Yuki.new
    @yuki.select_textbox(@com.selectbox[:box])
    @yuki.select_commandbox(@com.selectbox[:box])
    # マウス右クリックによるキャンセルを禁止
    @yuki.cancel_checks.clear
    @yuki.cancel_checks << lambda{ Input.pushed_all?(:btn2) }
    titles = Chapters.titles
    chapters = Chapters.startup_chapters
    @commands = Array.new(titles.size){|idx|
      Yuki::Command.new(titles[idx], titles[idx], lambda{true}, idx)
    }
    @com.now_chapter = chapters.clone
    manager = @yuki.manager(self.method(:plot))
    @pr = Miyako::Diagram::Processor.new{|dia|
      dia.add :start,          StartPresen.new(manager)
      dia.add :select_chapter, SelectChapter.new(manager)
      dia.add :show_slide,     ShowSlide.new
      dia.add :end,            EndPresen.new(manager)
      dia.add_arrow(:start, :select_chapter)      {|from|  from.finished? }
      dia.add_arrow(:select_chapter, :end)        {|from|  from.finished? }
      dia.add_arrow(:select_chapter, :show_slide) {|from|  from.show_slide? }
      dia.add_arrow(:show_slide, :start)          {|from|  from.finished? }
      dia.add_arrow(:end, nil)                    {|from|  from.finished? }
    }
    @plugins = Plugins.create
  end

  def setup
    @yuki.setup
    @com.timer.start
    @pr.start
    @plugins.start
  end

  def update
    return nil if Input.quit_or_escape?
    @pr.update_input
    @pr.update
    return nil if @pr.finish?
    @plugins.update
    return @now
  end

  def render
    @com.render
    @pr.render
    @plugins.render
  end
  
  def plot(yuki)
    yuki.command @commands, "cansel"
    return nil if yuki.select_result == "cansel" # cansel?
    return yuki.select_result
  end

  def final
    @com.timer.stop
    @pr.stop
    @plugins.stop
  end

  def dispose
    @com.dispose
    @plugins.dispose
  end
end
