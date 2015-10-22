class Yeah::Display
  def initialize
    @canvas = `document.querySelectorAll('canvas#yeah-game')[0]`
    @context = `#@canvas.getContext('2d')`

    `DISPLAY = #{self}`
  end

  private

  def scale_to_window
    %x{
      var canvas = document.getElementsByTagName('canvas')[0];

      if (#{@width.nil?} && #{@height.nil?}) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        canvas.setAttribute('style', "");
      } else {
        var widthScale = window.innerWidth / canvas.width,
            heightScale = window.innerHeight / canvas.height;
        window.displayScale = Math.min(widthScale, heightScale);

        if (displayScale >= 1) {
          displayScale = Math.floor(displayScale);
        }

        var width = canvas.width * displayScale,
            height = canvas.height * displayScale,
            sizeStyle = "width:"+width+"px; height:"+height+"px";

        canvas.setAttribute('style', sizeStyle);
      }
    }
  end

  def width
    `#@canvas.width`
  end
  def width=(value)
    @width = value
    `#@canvas.width = #{value}` unless value.nil?
  end

  def height
    `#@canvas.height`
  end
  def height=(value)
    @height = value
    `#@canvas.height = #{value}` unless value.nil?
  end

  def size
    [`#@canvas.width`, `#@canvas.height`]
  end
  def size=(value)
    @width, @height = value

    unless value.nil?
      `#@canvas.width = #{value[0]}`
      `#@canvas.height = #{value[1]}`
    end
  end
end
