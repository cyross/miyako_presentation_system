# -*- encoding: utf-8 -*-
# 共通データクラス
require 'singleton'

class Common
  include Singleton

  attr_accessor :now_chapter    # 各章で現在（最初に）表示するスライドクラスのリスト
  attr_accessor :selected_index # 章選択で、選択された章を示す番号
  attr_reader :bg               # 背景画像
  attr_reader :arrow            # 矢印画像(:down, :left, :right, :up)
  attr_reader :selectbox        # 章選択テキストボックス
  attr_reader :timer            # タイマー表示部
  attr_reader :dirs             # index -> symbol
  
  def initialize
    @setting = Setting.instance
    @bg = nil
    @dirs = [:down, :left, :right, :up]
    @dir2idx = {:down=>0, :left=>1, :right=>2, :up=>3}
    @dir2pos = {
      :down=>lambda{|spr|to_bottom(spr)},
      :left=>lambda{|spr|to_left(spr)}, 
      :right=>lambda{|spr|to_right(spr)}, 
      :up=>lambda{|spr|to_top(spr)}
    }
    @arrow_img = {}
    @arrow_img.default= nil
    @arrow = {}
    @arrow.default= nil
    @wc = Miyako::Sprite.new(:file=>@setting.wait_cursor_filename, :type=>:ck)
    @wc.oh = @wc.ow
    @wca = Miyako::SpriteAnimation.new(:sprite=>@wc, :wait=>0.1, :pattern_list=>[0,1,2,3,2,1])
    @sc = Miyako::Sprite.new(:file=>@setting.select_cursor_filename, :type=>:ck)
    @sc.oh = @sc.ow
    @sca = Miyako::SpriteAnimation.new(:sprite=>@sc, :wait=>0.1, :pattern_list=>[0,1,2,3,2,1])
    @box = Miyako::TextBox.new(:font=>Font.sans_serif,
                                       :size=>[12,12],
                                       :wc=>@wca,
                                       :sc=>@sca)
    @box_bg = Sprite.new(:size=>[@box.w+@setting.box_margin, @box.h+@setting.box_margin], :type=>:ac).fill(@setting.box_color)
    @selectbox = Miyako::Parts.new(@box_bg.size)
    @selectbox[:bg] = @box_bg
    @selectbox[:box] = @box
    @selectbox[:box].centering
    
    @timer = LogTimerManager.new
    @now_chapter = nil
    @selected_index = -1
    self.bg = @setting.bg_filename
    preset_arrow(@setting.arrow_filename)
  end

  def preset_arrow(filename, type=:ck)
    @dirs.each{|dir|
      spr = Miyako::Sprite.new(:file=>filename, :type=>type)
      spr.ow = spr.ow / 4
      spr.oh = spr.oh / 4
      @arrow_img[dir] = spr
      anm = Miyako::SpriteAnimation.new(:sprite => spr, :wait => 0.3)
      anm.character(@dir2idx[dir])
      @dir2pos[dir].call(anm)
      @arrow[dir] = anm
    }
  end

  def render
    @bg.render
    @selectbox.render
    @timer.render
  end
  
  def to_bottom(spr); spr.center.bottom end
  def to_left(spr);   spr.left.middle end
  def to_right(spr);  spr.right.middle end
  def to_top(spr);    spr.center.top end
  
  private :preset_arrow, :to_bottom, :to_left, :to_right, :to_top
  
  def bg=(filename)
    @bg = set_image(@bg, Miyako::Plane.new(:filename => filename, :type => :as))
  end

  def set_image(org, sprite)
    if org
      org.stop
      org.dispose
    end
    return sprite
  end
  
  private :set_image
  
  def dispose
    @bg.dispose if @bg
    @arrow.values.each{|v| v.dispose if v}
    @arrow_img.values.each{|v| v.dispose if v}
    @timer.stop
    @timer.dispose
  end
end
