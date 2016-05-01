class Yeah::Game
  class << self
    attr_accessor :title, :creators, :version, :display_size, :space

    def title
      @title ||= "untitled"
    end

    def creator
      @creators.first
    end

    def creator=(value)
      @creators = [value]
    end

    def creators
      @creators ||= ["anonymous"]
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

  attr_reader :display, :keyboard, :mouse
  attr_accessor :space

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
        #{@space.progress(`(now - lastNow) / 1000.0`)}
        lastNow = now;

        window.requestAnimationFrame(loop);
      }

      window.requestAnimationFrame(loop);
    }
  end

  def title
    self.class.title
  end

  def creator
    self.class.creator
  end

  def creators
    self.class.creators
  end

  def version
    self.class.version
  end
end
