# -*- encoding: utf-8 -*-
class Plugins
  extend Forwardable
  include Enumerable

  @@instance = nil
  
  def initialize
    @array = []
  end

  def Plugins.create
    @@instance = Plugins.new unless @@instance
    return @@instance
  end

  def each
    @array.each{|el| yield el}
    return self
  end
  
  def init
    @array.each{|el| el.init if el.methods.include?(:init) }
  end
  
  def init
    @array.each{|el| el.init if el.methods.include?(:init) }
  end
  
  def start
    @array.each{|el| el.start if el.methods.include?(:start) }
  end
  
  def update
    @array.each{|el| el.update if el.methods.include?(:update) }
  end
  
  def render
    @array.each{|el| el.render if el.methods.include?(:render) }
  end
  
  def stop
    @array.each{|el| el.stop if el.methods.include?(:stop) }
  end
  
  def dispose
    @array.each{|el| el.dispose if el.methods.include?(:dispose) }
  end
  
  def_delegators(:@array, :<<, :push, :pop, :length)
end
