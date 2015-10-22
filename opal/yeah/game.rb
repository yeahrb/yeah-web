require 'yeah/display'

class Yeah::Game
  attr_reader :display

  class << self
    private

    def inherited(klass)
      subclasses << klass

      super
    end

    def subclasses
      @@subclasses ||= []
    end
  end

  def initialize
    @display = Yeah::Display.new
  end
end
