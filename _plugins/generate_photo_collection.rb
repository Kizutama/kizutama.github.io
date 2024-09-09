require 'fileutils'

module Jekyll
  class PhotoCollectionGenerator < Jekyll::Generator
    priority :low

    def generate(site)
      # Define the path to your photo directory
      photo_dir = File.join(site.source, 'images', 'machi_photos')

      # Ensure the directory exists
      unless Dir.exist?(photo_dir)
        puts "Directory not found: #{photo_dir}"
        return
      end

      # Create the collection if it doesn't exist
      site.collections['machi_photo_gallery'] ||= Jekyll::Collection.new(site, 'machi_photo_gallery')

      # Collect image files
      image_files = Dir.glob(File.join(photo_dir, '*.{jpg,jpeg,png,gif}'))
      image_files.each do |image_file|
        # Create a new document for each image
        image_name = File.basename(image_file)
        image_path = "/images/machi_photos/#{image_name}"
        title = File.basename(image_name, File.extname(image_name)).capitalize

        # Define the front matter for the new document
        front_matter = {
          'image_path' => image_path,
          'title' => title
        }

        # Create a new Jekyll document
        doc = Jekyll::Document.new(
          File.join(site.source, '_photo_gallery', "#{image_name}.md"),
          {
            'layout' => 'photo_gallery_item',
            'photo_gallery' => front_matter
          }
        )
        
        # Add the document to the collection
        site.collections['machi_photo_gallery'].docs << doc
      end
    end
  end
end
