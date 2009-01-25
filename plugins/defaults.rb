# -*- encoding: utf-8 -*-
require 'singleton'

class DefaultFont
  include Singleton
  def DefaultFont.get(size=nil)
    return Font.sans_serif.tap{|f|
						 f.color = Color[:black]
#						 f.color = Color[:white]
		         f.size  = size if size
		       }
  end
end

class DefaultSlide
  include Singleton
  def DefaultSlide.get
    return Slide[]
#    return Slide["black"]
	end
end
