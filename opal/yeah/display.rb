class Yeah::Display
  VERTEX_SHADER = <<-glsl
    attribute vec2 a_position;

    uniform vec2 u_resolution;

    void main(void) {
      // Convert the rectangle from pixels to -1.0 to +1.0
      vec2 clip_space = (a_position / u_resolution) * 2.0 - 1.0;

      gl_Position = vec4(clip_space, 0.0, 1.0);
    }
  glsl

  FRAGMENT_SHADER = <<-glsl
    precision mediump float;

    uniform vec4 u_color;

    void main(void) {
      gl_FragColor = u_color;
    }
  glsl

  def initialize(options)
    @canvas = `document.querySelectorAll('canvas#yeah-game')[0]`
    @gl = `#@canvas.getContext('webgl')`

    options.each { |k, v| self.send("#{k}=", v) }

    initialize_shaders
    scale_to_window

    `DISPLAY = #{self}`
  end

  def scale_to_window
    %x{
      var canvas = document.getElementsByTagName('canvas')[0];

      if (#{@width.nil?} && #{@height.nil?}) {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
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

      #@gl.viewport(0, 0, #{@width}, #{@height});

      var resolutionLocation = #@gl.getUniformLocation(#@shader_program, "u_resolution");
      #@gl.uniform2f(resolutionLocation, #{@width}, #{@height});
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

  def clear_color
    `Array.prototype.slice.call(#@gl.getParameter(#@gl.COLOR_CLEAR_VALUE), 0, 3)`
  end

  def clear_color=(value)
    `#@gl.clearColor(#{value[0]}, #{value[1]}, #{value[2]}, 1.0)`
  end

  def clear
    `#@gl.clear(#@gl.COLOR_BUFFER_BIT)`
  end

  def fill(x, y, width, height, color)
    %x{
      // Create a buffer containing a single clipspace rectangle
      var positionLocation = #@gl.getAttribLocation(#@shader_program, "a_position");
      var buffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, buffer);
      #@gl.bufferData(
          #@gl.ARRAY_BUFFER,
          new Float32Array([
            #{x}, #{y},
            #{x + width}, #{y},
            #{x}, #{y + height},
            #{x}, #{y + height},
            #{x + width}, #{y},
            #{x + width}, #{y + height}]),
          #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(positionLocation);
      #@gl.vertexAttribPointer(positionLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Set color
      var colorLocation = #@gl.getUniformLocation(#@shader_program, "u_color");
      #@gl.uniform4f(colorLocation, #{color[0]}, #{color[1]}, #{color[2]}, 1);

      // Draw
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
  end

  def draw_image(x, y, image)
    puts "[Display] Draw image '#{image}' at (#{x}, #{y})."
  end

  private

  def initialize_shaders
    %x{
      var vertexShader = #@gl.createShader(#@gl.VERTEX_SHADER);
      #@gl.shaderSource(vertexShader, #{VERTEX_SHADER});
      #@gl.compileShader(vertexShader);

      if (!#@gl.getShaderParameter(vertexShader, #@gl.COMPILE_STATUS)) {
        #{raise `#@gl.getShaderInfoLog(vertexShader)`}
      }

      var fragmentShader = #@gl.createShader(#@gl.FRAGMENT_SHADER);
      #@gl.shaderSource(fragmentShader, #{FRAGMENT_SHADER});
      #@gl.compileShader(fragmentShader);

      if (!#@gl.getShaderParameter(fragmentShader, #@gl.COMPILE_STATUS)) {
        #{raise `#@gl.getShaderInfoLog(fragmentShader)`}
      }

      #@shader_program = #@gl.createProgram();
      #@gl.attachShader(#@shader_program, vertexShader);
      #@gl.attachShader(#@shader_program, fragmentShader);
      #@gl.linkProgram(#@shader_program);

      if (!#@gl.getProgramParameter(#@shader_program, #@gl.LINK_STATUS)) {
        #{raise "Could not link shader program"}
      }

      #@gl.useProgram(#@shader_program);
    }
  end
end
