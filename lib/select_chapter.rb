# -*- encoding: utf-8 -*-
class StartPresen
  include Miyako::Diagram::NodeBase
  def initialize(manager)
    @common = Common.instance
    @manager = manager
    @finished = false
  end
  def start
    
  end
  def stop
    
  end
  def update
    @common.timer.start
    @manager.start
    @finished = true
  end
  def render
    @common.render
  end
  def finished?
    return @finished
  end
  def dispose
    
  end
end

class SelectChapter
  include Miyako::Diagram::NodeBase
  def initialize(manager)
    @common = Common.instance
    @manager = manager
    @result = -1
  end
  def start
    
  end
  def stop
    
  end
  def update
    @manager.update
    @result = @manager.result
    @result = nil if (@result && !(@result.kind_of?(Integer)) && @result == -1)
    @common.selected_index = @result if @result
  end
  def render
    @common.render
  end
  def update_input
  end
  def finished?
    return !(@manager.executing?) && @result == nil
  end
  def show_slide?
    return !(@manager.executing?) && @result.kind_of?(Integer)
  end
  def dispose
    
  end
end

class EndPresen
  include Miyako::Diagram::NodeBase
  def initialize(manager)
    @common = Common.instance
    @manager = manager
    @finished = false
  end
  def start
    
  end
  def stop
    
  end
  def update
    @common.timer.stop
    @finished = true
  end
  def render
    @common.render
  end
  def update_input
  end
  def finished?
    return @finished
  end
  def dispose
  end
end
