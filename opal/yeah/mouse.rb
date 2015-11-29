class Yeah::Mouse
  BUTTONS = [:left, :middle, :right, 4, 5]

  BUTTON_CODE_KEYS = {
    0 => :left,
    1 => :middle,
    2 => :right,
    3 => 4,
    4 => 5
  }

  attr_reader :x, :y

  def initialize(display)
    @pressing_buttons = default_buttons
    @pressed_buttons = default_buttons
    @released_buttons = default_buttons
    @x = 0
    @y = 0

    %x{
      window.addEventListener('mousedown', function(event) {
        #{button = BUTTON_CODE_KEYS[`event.button`]}

        if (!#{@pressing_buttons[button]}) {
          #{@pressing_buttons[button] = true}
          #{@pressed_buttons[button] = true}
        }
      });

      window.addEventListener('mouseup', function(event) {
        #{button = BUTTON_CODE_KEYS[`event.button`]}

        #{@pressing_buttons[button] = false}
        #{@released_buttons[button] = true}
      });

      window.addEventListener('mousemove', function(event) {
        if (event.offsetX) {
          #@x = event.offsetX / window.displayScale;
          #@y = -(event.offsetY / window.displayScale) + #{display.height};
        } else {
          #@x = event.layerX / window.displayScale;
          #@y = -(event.layerY / window.displayScale) + #{display.height};
        }
      });
    }
  end

  def position
    [x, y]
  end

  def pressing?(button)
    @pressing_buttons[button]
  end

  def pressed?(button)
    @pressed_buttons[button]
  end

  def released?(button)
    @released_buttons[button]
  end

  def step
    @pressed_buttons.clear
    @released_buttons.clear
  end

  private

  def default_buttons
    Hash.new { |h, k| BUTTONS.include?(k) ? false : nil }
  end
end
