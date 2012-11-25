module PendingImage
  class Collection

    def initialize images, options={}
      @images = images
      @options = options
    end

    def filtered_images
      @filtered_images ||= images_without_excluded_etags
    end

    def each(&blk)
      filtered_images.each(&blk)
    end

    private

    def images_without_excluded_etags
      if @options.is_a?(Hash) and excluded_etags = @options[:except_etags]
        @images.reject { |image| excluded_etags.include?(image.etag) }
      else
        @images
      end
    end
  end
end