require 'yeah/display'

class Yeah::Game
  attr_reader :display, :space

  class << self
    attr_accessor :space

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
    @space = self.class.space.new(self)

    `window.setInterval(function() { #{@space.step(self)} }, 1000)`
  end
end
