class Yeah::Display
  VERTEX_SHADER = <<-glsl
    attribute vec2 a_position;
    attribute vec2 a_texCoords;

    uniform vec2 u_resolution;
    uniform vec2 u_texSize;

    varying vec2 v_texCoords;

    void main(void) {
      vec2 clipPosition = (a_position / u_resolution) * 2.0 - 1.0;
      gl_Position = vec4(clipPosition, 0.0, 1.0);

      v_texCoords = a_texCoords / u_texSize;
    }
  glsl

  FRAGMENT_SHADER = <<-glsl
    precision mediump float;

    uniform sampler2D u_image;

    varying vec2 v_texCoords;

    void main(void) {
      gl_FragColor = texture2D(u_image, v_texCoords);
    }
  glsl

  def initialize(options)
    @canvas = `document.querySelectorAll('canvas#yeah-display')[0]`
    @gl = `#@canvas.getContext('webgl')`

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

  def fill(color, x, y, width, height)
    %x{
      // Provide rectangle coordinates
      var positionLocation = #@gl.getAttribLocation(#@gl_program, "a_position");
      var buffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, buffer);
      #@gl.bufferData(
          #@gl.ARRAY_BUFFER,
          new Float32Array([
            #{x}, #{y},
            #{x} + #{width}, #{y},
            #{x}, #{y} + #{height},
            #{x}, #{y} + #{height},
            #{x} + #{width}, #{y},
            #{x} + #{width}, #{y} + #{height}]),
          #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(positionLocation);
      #@gl.vertexAttribPointer(positionLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Use a color texture
      var texture = #@gl.createTexture();
      #@gl.bindTexture(#@gl.TEXTURE_2D, texture);
      #@gl.texImage2D(#@gl.TEXTURE_2D, 0, #@gl.RGBA, 1, 1, 0,
                      #@gl.RGBA, #@gl.UNSIGNED_BYTE,
                      new Uint8Array([#{color[0]} * 255,
                                      #{color[1]} * 255,
                                      #{color[2]} * 255,
                                      255]));
      // Draw rectangle
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
  end

  def draw_image(image, x, y)
    %x{
      var nativeImage = #{image.native};

      // Provide rectangle coordinates
      var positionLocation = #@gl.getAttribLocation(#@gl_program, "a_position");
      var positionBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, positionBuffer);
      #@gl.bufferData(
          #@gl.ARRAY_BUFFER,
          new Float32Array([
            #{x}, #{y},
            #{x} + nativeImage.width, #{y},
            #{x}, #{y} + nativeImage.height,
            #{x}, #{y} + nativeImage.height,
            #{x} + nativeImage.width, #{y},
            #{x} + nativeImage.width, #{y} + nativeImage.height
          ]),
          #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(positionLocation);
      #@gl.vertexAttribPointer(positionLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Provide texture coordinates
      var texCoordsLocation = #@gl.getAttribLocation(#@gl_program, "a_texCoords");
      var texCoordsBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, texCoordsBuffer);
      #@gl.bufferData(
        #@gl.ARRAY_BUFFER,
        new Float32Array([
          0, nativeImage.height,
          nativeImage.width, nativeImage.height,
          0, 0,
          0, 0,
          nativeImage.width, nativeImage.height,
          nativeImage.width, 0
        ]),
        #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(texCoordsLocation);
      #@gl.vertexAttribPointer(texCoordsLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Set texture size
      var texSizeLocation = #@gl.getUniformLocation(#@gl_program, "u_texSize");
      #@gl.uniform2f(texSizeLocation, nativeImage.width, nativeImage.height);

      // Set texture
      var texture = #@gl.createTexture();
      #@gl.bindTexture(#@gl.TEXTURE_2D, texture);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_S, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_T, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MIN_FILTER, #@gl.NEAREST);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MAG_FILTER, #@gl.NEAREST);
      #@gl.texImage2D(#@gl.TEXTURE_2D, 0, #@gl.RGBA, #@gl.RGBA, #@gl.UNSIGNED_BYTE, nativeImage);

      // Draw
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
  end

  def draw_image_part(image, x, y, part_x, part_y, part_width, part_height)
    %x{
      var nativeImage = #{image.native};

      // Provide rectangle coordinates
      var positionLocation = #@gl.getAttribLocation(#@gl_program, "a_position");
      var positionBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, positionBuffer);
      #@gl.bufferData(
          #@gl.ARRAY_BUFFER,
          new Float32Array([
            #{x}, #{y},
            #{x} + #{part_width}, #{y},
            #{x}, #{y} + #{part_height},
            #{x}, #{y} + #{part_height},
            #{x} + #{part_width}, #{y},
            #{x} + #{part_width}, #{y} + #{part_height}
          ]),
          #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(positionLocation);
      #@gl.vertexAttribPointer(positionLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Provide texture coordinates
      var texCoordsLocation = #@gl.getAttribLocation(#@gl_program, "a_texCoords");
      var texCoordsBuffer = #@gl.createBuffer();
      #@gl.bindBuffer(#@gl.ARRAY_BUFFER, texCoordsBuffer);
      #@gl.bufferData(
        #@gl.ARRAY_BUFFER,
        new Float32Array([
          #{part_x}, #{part_y} + #{part_height},
          #{part_x} + #{part_width}, #{part_y} + #{part_height},
          #{part_x}, #{part_y},
          #{part_x}, #{part_y},
          #{part_x} + #{part_width}, #{part_y} + #{part_height},
          #{part_x} + #{part_width}, #{part_y}
        ]),
        #@gl.STATIC_DRAW);
      #@gl.enableVertexAttribArray(texCoordsLocation);
      #@gl.vertexAttribPointer(texCoordsLocation, 2, #@gl.FLOAT, false, 0, 0);

      // Set texture size
      var texSizeLocation = #@gl.getUniformLocation(#@gl_program, "u_texSize");
      #@gl.uniform2f(texSizeLocation, nativeImage.width, nativeImage.height);

      // Set texture
      var texture = #@gl.createTexture();
      #@gl.bindTexture(#@gl.TEXTURE_2D, texture);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_S, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_WRAP_T, #@gl.CLAMP_TO_EDGE);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MIN_FILTER, #@gl.NEAREST);
      #@gl.texParameteri(#@gl.TEXTURE_2D, #@gl.TEXTURE_MAG_FILTER, #@gl.NEAREST);
      #@gl.texImage2D(#@gl.TEXTURE_2D, 0, #@gl.RGBA, #@gl.RGBA, #@gl.UNSIGNED_BYTE, nativeImage);

      // Draw rectangle
      #@gl.drawArrays(#@gl.TRIANGLES, 0, 6);
    }
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

      #@gl_program = #@gl.createProgram();
      #@gl.attachShader(#@gl_program, vertexShader);
      #@gl.attachShader(#@gl_program, fragmentShader);
      #@gl.linkProgram(#@gl_program);

      if (!#@gl.getProgramParameter(#@gl_program, #@gl.LINK_STATUS)) {
        #{raise "Could not link shader program"}
      }

      #@gl.useProgram(#@gl_program);

      // Use texture alpha values
      #@gl.blendFunc(#@gl.SRC_ALPHA, #@gl.ONE_MINUS_SRC_ALPHA);
      #@gl.enable(#@gl.BLEND);
    }
  end
end
