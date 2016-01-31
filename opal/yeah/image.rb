class Yeah::Image
  attr_reader :path, :native

  class << self
    alias :[] :new
    private :new
  end

  def initialize(path)
    @path = path
    @native = `document.querySelectorAll("#yeah-assets img[data-path='#{path}']")[0]`
  end

  def width
    @native.width
  end

  def height
    @native.height
  end
end
