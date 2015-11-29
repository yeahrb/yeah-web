class Yeah::Display
  VERTEX_SHADER = <<-glsl
    attribute vec2 a_position;
    attribute vec2 a_texCoord;

    uniform vec2 u_resolution;

    varying vec2 v_texCoord;

    void main(void) {
      // Convert the rectangle from pixels to -1.0 to +1.0
      vec2 clip_space = (a_position / u_resolution) * 2.0 - 1.0;

      gl_Position = vec4(clip_space, 0.0, 1.0);

      v_texCoord = a_texCoord;
    }
  glsl

  FRAGMENT_SHADER = <<-glsl
    precision mediump float;

    uniform vec4 u_color;
    uniform sampler2D u_image;
    uniform int u_useTexture;

    varying vec2 v_texCoord;

    void main(void) {
      if (u_useTexture == 1) {
        gl_FragColor = texture2D(u_image, v_texCoord);
      } else {
        gl_FragColor = u_color;
      }
    }
  glsl

  def initialize(options)
    @canvas = `document.querySelectorAll('canvas#yeah-display')[0]`
    @gl = `#@canvas.getContext('webgl')`

    load_images
    initialize_shaders

    # Assign options.
    options.each { |k, v| self.send("#{k}=", v) }

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

        if (window.displayScale >= 1) {
          window.displayScale = Math.floor(window.displayScale);
        }

        var width = canvas.width * window.displayScale,
            height = canvas.height * window.displayScale,
            sizeStyle = "width:"+width+"px; height:"+height+"px";

        canvas.setAttribute('style', sizeStyle);
      }

      #@gl.viewport(0, 0, #{@width}, #{@height});

      var resolutionLocation = #@gl.getUniformLocation(#@gl_program, "u_resolution");
      #@gl.uniform2f(resolutionLocation, #{@width}, #{@height});
    }
  end

  def width
    `#@canvas.width`
  end
  def width=(value)
    @width = value

    `#@canvas.width = #{value}`

    scale_to_window
  end

  def height
    `#@canvas.height`
  end
  def height=(value)
    @height = value

    `#@canvas.height = #{value}`

    scale_to_window
  end

  def size
    [`#@canvas.width`, `#@canvas.height`]
  end
  def size=(value)
    @width, @height = value

    %x{
      #@canvas.width = #{value[0]};
      #@canvas.height = #{value[1]};
    }

    scale_to_window
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
      // Provide rectangle clipspace coordinates
      var positionLocation = #@gl.getAttribLocation(#@gl_program, "a_position");
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
      var colorLocation = #@gl.getUniformLocation(#@gl_program, "u_color");
      #@gl.uniform4f(colorLocation, #{color[0]}, #{color[1]}, #{color[2]}, 1);

      // Don't use texture
      var useTextureLocation = #@gl.getUniformLocation(#@gl_program, "u_useTexture");
      #@gl.uniform1i(useTextureLocation, 0);

      // Draw
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
  end

  def draw_image(x, y, image_path)
    %x{
      var image = YEAH_DISPLAY_IMAGES[#{image_path}];

      // Provide rectangle clipspace coordinates
      var positionLocation = #@gl.getAttribLocation(#@gl_program, "a_position");
      var positionBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, positionBuffer);
      #@gl.bufferData(
          #@gl.ARRAY_BUFFER,
          new Float32Array([
            #{x}, #{y},
            #{x} + image.width, #{y},
            #{x}, #{y} + image.height,
            #{x}, #{y} + image.height,
            #{x} + image.width, #{y},
            #{x} + image.width, #{y} + image.height
          ]),
          #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(positionLocation);
      #@gl.vertexAttribPointer(positionLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Set texture
      var texture = #@gl.createTexture();
      #@gl.bindTexture(#@gl.TEXTURE_2D, texture);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_S, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_T, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MIN_FILTER, #@gl.NEAREST);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MAG_FILTER, #@gl.NEAREST);
      #@gl.texImage2D(#@gl.TEXTURE_2D, 0, #@gl.RGBA, #@gl.RGBA, #@gl.UNSIGNED_BYTE, image);

      // Use texture
      var useTextureLocation = #@gl.getUniformLocation(#@gl_program, "u_useTexture");
      #@gl.uniform1i(useTextureLocation, 1);

      // Draw
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
  end

  private

  def load_images
    %x{
      window.YEAH_DISPLAY_IMAGES = {};

      var elements = document.querySelectorAll('#yeah-assets img');
      for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        YEAH_DISPLAY_IMAGES[element.getAttribute('data-path')] = element;
      }
    }
  end

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

      #@gl_program = #@gl.createProgram();
      #@gl.attachShader(#@gl_program, vertexShader);
      #@gl.attachShader(#@gl_program, fragmentShader);
      #@gl.linkProgram(#@gl_program);

      if (!#@gl.getProgramParameter(#@gl_program, #@gl.LINK_STATUS)) {
        #{raise "Could not link shader program"}
      }

      #@gl.useProgram(#@gl_program);

      // Provide texture coordinates
      var texCoordLocation = #@gl.getAttribLocation(#@gl_program, "a_texCoord");
      var texCoordBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, texCoordBuffer);
      #@gl.bufferData(
        #@gl.ARRAY_BUFFER,
        new Float32Array([
          0.0, 1.0,
          1.0, 1.0,
          0.0, 0.0,
          0.0, 0.0,
          1.0, 1.0,
          1.0, 0.0
        ]),
        #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(texCoordLocation);
      #@gl.vertexAttribPointer(texCoordLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Use texture alpha values
      #@gl.blendFunc(#@gl.SRC_ALPHA, #@gl.ONE_MINUS_SRC_ALPHA);
      #@gl.enable(#@gl.BLEND);
    }
  end
end
