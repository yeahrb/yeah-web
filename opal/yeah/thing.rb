class Yeah::Thing
  class << self
    attr_accessor :look, :body

    def look
      @look ||= Look
    end
  end

  attr_reader :game
  attr_accessor :x, :y, :look, :body

  def initialize(game, x = 0, y = 0, options = {})
    @game = game
    @x = x
    @y = y
    @look = self.class.look.new(self)
    @body = self.class.body.new(self) unless self.class.body.nil?

    options.each_pair { |k, v| send("#{k}=", v) }

    prepare
    start
  end

  def position
    [@x, @y]
  end

  def position=(value)
    @x, @y = value
  end

  def act(elapsed)
    return
  end

  protected

  def display
    game.display
  end

  def keyboard
    game.keyboard
  end

  def mouse
    game.mouse
  end

  def space
    game.space
  end

  private

  def prepare
    return
  end

  def start
    return
  end
end
