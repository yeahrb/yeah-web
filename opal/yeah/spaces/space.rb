class Yeah::Space
  class << self
    attr_accessor :width, :height, :color, :collisions, :things

    def size
      [width, height]
    end

    def size=(value)
      self.width, self.height = value
    end

    def collisions
      @collisions ||= RectangleCollisions
    end

    private

    def inherited(klass)
      super

      @color ||= [0.5, 0.5, 0.5]
      @things ||= {}
    end
  end

  attr_reader :game
  attr_accessor :width, :height, :color, :collisions, :things

  def initialize(game)
    @game = game
    self.size = self.class.size
    self.color = self.class.color
    @collisions = self.class.collisions.new

    @things = []
    self.class.things.each_pair do |klass, all_options|
      all_options.each do |options|
        @things << klass.new(game, options)
      end
    end

    prepare
    start
  end

  def size
    [width, height]
  end

  def size=(value)
    self.width, self.height = value
  end

  def color=(value)
    @color = value
    @game.display.clear_color = value
  end

  def progress(elapsed)
    @things.each { |t| t.act(elapsed) }
    @collisions.resolve(@things)

    @game.display.clear
    @things.each { |t| t.look.draw(@game.display, elapsed) }

    @game.keyboard.clear
    @game.mouse.clear
  end

  def create(thing_class, x, y, options)
    @things << thing_class.new(game, x, y, options)
  end

  private

  def prepare
    return
  end

  def start
    return
  end
end
