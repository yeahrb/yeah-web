module Yeah::AssetLoader
  def self.load_all(&block)
    # Load all assets then yield to passed block.
    %x{
      window.yeahImages = {}; // for image lookup in Yeah::Image
      window.yeahAudios = {}; // for audio lookup in Yeah::Audio

      var assetsLoaded = 0;

      var onAssetLoad = function() {
        assetsLoaded++;

        if (assetsLoaded == YEAH_ASSET_TOTAL) {
          #{block.call}
        }
      }

      for (var i = 0; i < YEAH_IMAGE_PATHS.length; i++) {
        var image = new Image();
        image.onload = onAssetLoad;
        image.src = "/assets/images/" + YEAH_IMAGE_PATHS[i];
        yeahImages[YEAH_IMAGE_PATHS[i]] = image;
      }

      for (var i = 0; i < YEAH_AUDIO_PATHS.length; i++) {
        var audio = new Audio();

        audio.oncanplaythrough = function() {
          onAssetLoad();
          audio.oncanplaythrough = null;
        }

        audio.src = "/assets/audios/" + YEAH_AUDIO_PATHS[i];
        yeahAudios[YEAH_AUDIO_PATHS[i]] = audio;
      }
    }
  end
end
