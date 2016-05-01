class Yeah::SpriteLook < Yeah::AnimationLook
  class << self
    attr_accessor :animations
  end

  attr_accessor :animation

  def initialize(thing)
    super

    @animation = self.class.animations.keys.first
  end

  def draw(display, elapsed)
    current_animation = animation

    if current_animation != @last_animation
      frames = self.class.animations[current_animation]

      if frames.respond_to? :first
        @first_frame = frames.first
        @last_frame = frames.last
      else
        @first_frame = @last_frame = frames
      end

      @frame = @first_frame
    end

    @last_animation = current_animation

    super
  end
end
