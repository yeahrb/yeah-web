class Yeah::Thing
  class << self
    attr_accessor :look, :body

    def look
      @look ||= Look
    end
  end

  attr_reader :game
  attr_accessor :x, :y, :look, :body

  def initialize(game, options)
    @game = game
    @look = self.class.look.new(self)
    @body = self.class.body.new(self) unless self.class.body.nil?

    # Assign options.
    if options.respond_to? :each_pair
      options.each_pair { |k, v| send("#{k}=", v) }
    else
      @x, @y = options
    end

    start
  end

  def position
    [@x, @y]
  end

  def position=(value)
    @x, @y = value
  end

  def start
    return
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
end
