# -*- encoding: UTF-8 -*-

# describe here on-startup-instanced-plugins(instance)
# e.x.
# plugins << Hoge.new
# plugins << Fuga.new

plugins = Plugins.create
plugins << WriteBoard.instance.tap{|wb| wb.color=[200,200,255]}
