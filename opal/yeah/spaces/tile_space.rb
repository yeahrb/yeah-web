class Yeah::TileSpace < Yeah::Space
  class << self
    attr_accessor :tile_width, :tile_height, :tile_key, :tiles

    def tile_size
      [@tile_width, @tile_height]
    end

    def tile_size=(value)
      @tile_width, @tile_height = value
    end
  end

  def prepare
    tile_width = self.class.tile_width
    tile_height = self.class.tile_height

    self.class.tiles.reverse.each_with_index do |row, tile_y|
      row.chars.each_with_index do |tile, tile_x|
        thing_class = self.class.tile_key[tile]
        next if thing_class.nil?

        create thing_class, tile_x * tile_width, tile_y * tile_height
      end
    end
  end
end
