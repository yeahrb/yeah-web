class Yeah::RectangleCollisions < Yeah::Collisions
  def resolve(things)
    things.each do |thing|
      next if thing.body.nil?

      things.each do |other|
        next if other.body.nil? || other == thing

        overlap_right = thing.body.right - other.body.left
        overlap_left = other.body.right - thing.body.left
        overlap_top = thing.body.top - other.body.bottom
        overlap_bottom = other.body.top - thing.body.bottom

        overlap_right = 0 if overlap_right < 0
        overlap_left = 0 if overlap_left < 0
        overlap_top = 0 if overlap_top < 0
        overlap_bottom = 0 if overlap_bottom < 0

        overlap_x = overlap_right < overlap_left ? overlap_right : -overlap_left
        overlap_y = overlap_top < overlap_bottom ? overlap_top : -overlap_bottom

        if overlap_x != 0 && overlap_y != 0
          thing.body.collide(other, overlap_x, overlap_y)
        end
      end
    end
  end
end
