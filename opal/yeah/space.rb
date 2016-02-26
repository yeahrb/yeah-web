class Yeah::Space
  class << self
    attr_accessor :width, :height, :color, :things

    def size
      [width, height]
    end

    def size=(value)
      self.width, self.height = value
    end
  end

  attr_reader :game
  attr_accessor :width, :height, :color, :things

  def initialize(game)
    @game = game
    self.size = self.class.size
    self.color = self.class.color
    @things = []

    self.class.things.each_pair do |klass, all_options|
      all_options.each do |options|
        @things << klass.new(game, options)
      end
    end
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

  def step(elapsed)
    @things.each { |t| t.act(elapsed) }
    @game.display.clear
    @things.each { |t| t.look.draw(t, @game.display, elapsed) }
  end
end
