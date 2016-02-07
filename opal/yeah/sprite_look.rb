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

    if frames.respond_to? :keys
      frames = frames[:frames]
    end

    if frames.respond_to? :to_a
      frames = frames.to_a
    else
      frames = [frames]
    end

    @first_frame = frames.first
    @last_frame = frames.last
    @frame = @first_frame

    @animation = value
  end
end
