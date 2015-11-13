class Yeah::Thing
  class << self
    attr_accessor :look
  end

  attr_accessor :x, :y, :look

  def initialize(options)
    self.look = self.class.look.new

    options.each { |k, v| self.send("#{k}=", v) }
  end

  def position
    [x, y]
  end

  def position=(value)
    self.x, self.y = value
  end

  def act(input, space)
  end
end
