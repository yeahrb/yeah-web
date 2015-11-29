require 'yeah/display'
require 'yeah/keyboard'
require 'yeah/mouse'

class Yeah::Game
  attr_reader :display, :keyboard, :mouse, :space

  class << self
    attr_accessor :space, :title

    private

    def inherited(klass)
      subclasses << klass

      super
    end

    def subclasses
      @@subclasses ||= []
    end

    def display
      @display ||= Struct.new(:size).new
    end
  end

  def initialize
    @display = Yeah::Display.new(self.class.display.to_h)
    @keyboard = Yeah::Keyboard.new
    @mouse = Yeah::Mouse.new(@display)
    @space = self.class.space.new(self)

    %x{
      var now,
          lastNow = Date.now();

      var loop = function() {
        now = Date.now();

        #{@space.step(`(now - lastNow) / 1000.0`)}
        #{keyboard.step}
        #{mouse.step}

        lastNow = now;

        window.requestAnimationFrame(loop);
      }

      window.requestAnimationFrame(loop);
    }
  end
end
