class Yeah::Space
  class << self
    attr_accessor :width, :height, :clear_color

    def size
      [width, height]
    end

    def size=(value)
      self.width, self.height = value
    end
  end

  attr_reader :game
  attr_accessor :width, :height

  def initialize(game)
    @game = game
    self.size = self.class.size
    self.clear_color = self.class.clear_color
  end

  def things
    @things ||= []
  end

  def size
    [width, height]
  end

  def size=(value)
    self.width, self.height = value
  end

  def clear_color
    @game.display.clear_color
  end

  def clear_color=(value)
    @game.display.clear_color = value
  end

  def step
    things.each { |t| t.act(nil, self) }
    @game.display.clear
    things.each { |t| t.look.draw(t, @game.display) }
  end
end
