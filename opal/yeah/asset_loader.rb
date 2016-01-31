module Yeah::AssetLoader
  def self.load_all(&block)
    # Load all images then yield to passed block.
    %x{
      // This is used for asset lookup within Yeah::Image.
      window.YEAH_IMAGES = {};

      var images = document.querySelectorAll("#yeah-assets img"),
          imagesLoaded = 0;

      for (var i = 0; i < images.length; i++) {
        var image = images[i];

        YEAH_IMAGES[image.getAttribute('data-path')] = image;

        image.onload = function() {
          imagesLoaded++;

          if (imagesLoaded == images.length) {
            #{block.call}
          }
        }
      }
    }
  end
end
