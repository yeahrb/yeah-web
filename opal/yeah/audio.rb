class Yeah::Audio
  attr_reader :path, :native

  class << self
    alias :[] :new
    private :new
  end

  def initialize(path)
    @path = path
    @native = `yeahAudios[#{path}]`
  end

  def playing?
    `!#@native.paused`
  end

  def play
    `#@native.play()`
  end

  def pause
    `#@native.pause()`
  end

  def stop
    %x{
      #@native.pause();
      #@native.currentTime = 0;
    }
  end
end

