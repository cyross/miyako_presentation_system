# -*- encoding: utf-8 -*-
module Chapter
  def self.title; return "" end
end

module Chapters
  @@chapters = []
  @@now_chapters = []
  def Chapters.add_chapter(chapters, startup)
    @@chapters << [chapters.title, startup]
    @@now_chapters << startup
  end
  def Chapters.titles; @@chapters.map{|ch| ch[0]} end
  def Chapters.startup_chapters; @@chapters.map{|ch| ch[1]} end
  def Chapters.now_chapters; @@now_chapters end
end

module MPSSlide
  include Miyako::Slide

  def init(slide)
    init_slide(slide)
    centering
    @@presen_arrows ||= {}
    @@presen_arrows[self.__id__] = []
  end
  
  def pre_process
    @@presen_arrows[self.__id__].each {|item| item.pre_process }
  end
  
  def post_process
    @@presen_arrows[self.__id__].each {|item| item.post_process }
  end

  def update
  end

  def trigger?
    @@presen_arrows[self.__id__].each {|item|
      return item if item.trigger?
    }
    return nil
  end
  
  def post_trigger
    @@presen_arrows[self.__id__].each {|item| item.post_trigger }
  end
  
  def update_input(list)
    @@presen_arrows[self.__id__].each {|item|
      item.update_input(list)
    }
  end

  def add_arrow(event, slide)
    @@presen_arrows[self.__id__] << Arrow.new(event, slide, Arrow.non_cond, @@dir2trigger[event].new, nil)
  end
 
  def add_arrow_ex(hash)
    raise MiyakoError, "don't enough set arrow parameters!" unless hash[:event] && hash[:slide]
    hash[:condition] ||= Arrow.non_cond
    hash[:trigger] ||= @@dir2trigger[hash[:event]].new
    hash[:move_type] ||= nil
    yield hash if block_given?
    @@presen_arrows[self.__id__] << Arrow.new(hash[:event], hash[:slide], hash[:condition], hash[:trigger], hash[:move_type])
  end
 
  def get_arrow_dirs
    return @@presen_arrows[self.__id__].inject([]){|r, ar| r << ar.event}.uniq
  end

  class Arrow
    @@non_cond = lambda{true}
    def self.non_cond; return @@non_cond end

    attr_reader :event, :next_slide, :move_type
    
    def initialize(event, slide, condition, trigger, move_type)
      @event = event
      @next_slide = slide
      @cond  = condition
      @trigger = trigger
      @move_type = move_type
    end
    
    def pre_process
      @trigger.pre_process
    end
    
    def post_process
      @trigger.post_process
    end
    
    def update_input(params)
      @trigger.update_input(params)
    end
    
    def trigger?
      return @trigger.trigger?
    end

    def post_trigger
      @trigger.post_trigger
    end
  end

  module SlideTrigger
    def pre_process
    end
    def post_process
    end
    def trigger?
      return true
    end
    def post_trigger
    end
    def update_input(params)
    end
  end

  class LeftTrigger
    include SlideTrigger
    def initialize
      @btn = :left
      @pushed = false
      @trigger = false
    end
    def update_input(params)
      @pushed = params.include?(@btn)
    end
    def trigger?
      return @pushed
    end
  end

  class RightTrigger
    include SlideTrigger
    def initialize
      @btn = :right
      @pushed = false
      @trigger = false
    end
    def update_input(params)
      @pushed = params.include?(@btn)
    end
    def trigger?
      return @pushed
    end
  end

  class UpTrigger
    include SlideTrigger
    def initialize
      @btn = :up
      @pushed = false
      @trigger = false
    end
    def update_input(params)
      @pushed = params.include?(@btn)
    end
    def trigger?
      return @pushed
    end
  end

  class DownTrigger
    include SlideTrigger
    def initialize
      @btn = :down
      @pushed = false
      @trigger = false
    end
    def update_input(params)
      @pushed = params.include?(@btn)
    end
    def trigger?
      return @pushed
    end
  end

  class ButtonTrigger
    include SlideTrigger
    def initialize
      @btn = :btn1
      @pushed = nil
      @trigger = false
    end
    def update_input(params)
      @pushed = params.include?(@btn)
    end
    def trigger?
      return @pushed
    end
  end

  class TimerTrigger
    include SlideTrigger
    def initialize(time)
      @timer = Miyako::WaitCounter.new(time)
      @trigger = false
    end
    def pre_process
      @timer.start
    end
    def trigger?
      return @timer.finish?
    end
    def post_trigger
      @timer.stop
    end
    def post_process
      @timer.stop
    end
  end

  @@dir2trigger = {:up=>UpTrigger, :left=>LeftTrigger, :right=>RightTrigger, :down=>DownTrigger}
  
end
