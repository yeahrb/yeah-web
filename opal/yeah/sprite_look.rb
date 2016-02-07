class Yeah::SpriteLook < Yeah::AnimationLook
  class << self
    attr_accessor :animations
  end

  attr_reader :animation

  def initialize
    super

    self.animation = self.class.animations.keys.first
  end

  def animation=(value)
    frames = self.class.animations[value]

    if frames.respond_to? :first
      @first_frame = frames.first
      @last_frame = frames.last
    else
      @first_frame = @last_frame = frames
    end

    @frame = @first_frame

    @animation = value
  end
end
