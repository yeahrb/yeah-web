class Yeah::Game
  attr_reader :display, :keyboard, :mouse, :space

  class << self
    attr_accessor :title, :display_size, :space

    def title
      @title ||= "Game"
    end

    def space
      @space ||= Space
    end

    def display_options
      {
        size: @display_size
      }
    end

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
    @display = Display.new(self.class.display_options)
    @keyboard = Keyboard.new
    @mouse = Mouse.new(@display)
    @space = self.class.space.new(self)

    # Set web page title.
    `document.getElementsByTagName('title')[0].innerHTML = #{title}`

    # Start game loop.
    %x{
      var now,
          lastNow = Date.now();

      var loop = function() {
        now = Date.now();

        #{@space.step(`(now - lastNow) / 1000.0`)}
        #{@keyboard.step}
        #{@mouse.step}

        lastNow = now;

        window.requestAnimationFrame(loop);
      }

      window.requestAnimationFrame(loop);
    }
  end

  def title
    self.class.title
  end
end
