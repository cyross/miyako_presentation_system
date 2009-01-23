# -*- encoding: utf-8 -*-
=begin
Miyako Presentation System 2 v1.0
Copyright (C) 2009  Cyross Makoto

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
=end
require 'Miyako/miyako'
require 'Miyako/EXT/slides'
require 'setting'
require 'lib/modules' # ユーティリティモジュール群を組み込み
require 'lib/log_timer'
require 'lib/common'
load 'lib/preset.rb', true # requires.rb の作成

include Miyako

Screen.set_size(800, 600)

require 'tmp/plugins' # 作成した plugins.rb を読み込んで、スライドを組み込み
require 'tmp/requires' # 作成した requires.rb を読み込んで、スライドを組み込み
require 'lib/select_chapter'
require 'lib/slide_nodes'
require 'lib/main_scene'

presen = Story.new
presen.run(MainScene)

