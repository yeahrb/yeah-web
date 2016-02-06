module Yeah::AssetLoader
  def self.load_all(&block)
    # Load all images then yield to passed block.
    %x{
      // This is used for looking up assets within Yeah::Image.
      window.YEAH_IMAGES = {};

      var imagesLoaded = 0;

      for (var i = 0; i < YEAH_IMAGE_PATHS.length; i++) {
        var image = new Image();
        image.src = "/assets/images/" + YEAH_IMAGE_PATHS[i];

        YEAH_IMAGES[YEAH_IMAGE_PATHS[i]] = image;

        image.onload = function() {
          imagesLoaded++;

          if (imagesLoaded == YEAH_IMAGE_PATHS.length) {
            #{block.call}
          }
        }
      }
    }
  end
end
