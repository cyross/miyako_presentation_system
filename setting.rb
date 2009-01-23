# -*- encoding: utf-8 -*-
require 'singleton'

class Setting
  include Singleton

  PRESET_IMAGE_DIR = "preset_image" # プリセット画像格納ディレクトリ名
  
  attr_reader :bg_filename # 背景ファイル名
  attr_reader :arrow_filename # 矢印ファイル名
  attr_reader :wait_cursor_filename # ウェイトカーソルファイル名
  attr_reader :select_cursor_filename # 選択カーソルファイル名
  attr_reader :plugin_dir # プラグインファイル格納ディレクトリ名
  attr_reader :slide_dir # スライドファイル格納ディレクトリ名
  attr_reader :box_margin #　章選択ボックスと背景とのマージン
  attr_reader :box_color # 章選択ボックスの背景色
  
  def initialize
    @bg_filename = "image/hachune_back_02.png"
    @arrow_filename = "#{PRESET_IMAGE_DIR}/arrow_blue.png"
    @wait_cursor_filename = "#{PRESET_IMAGE_DIR}/wait_cursor.png"
    @select_cursor_filename = "#{PRESET_IMAGE_DIR}/cursor.png"
    @plugin_dir = "plugins"
    @slide_dir = "slides"
    @box_margin = 8
    @box_color = [128,0,0,64]
  end
end
