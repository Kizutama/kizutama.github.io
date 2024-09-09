require 'fileutils'

# 定义图片文件夹路径
image_folder = File.join(Dir.pwd, 'images', 'machi_photos')

# 确保目录存在
unless Dir.exist?(image_folder)
  puts "Directory not found: #{image_folder}"
  exit
end

# 遍历图片文件夹中的所有图片
Dir.glob(File.join(image_folder, '*.{jpg,jpeg,png,gif}')).each do |image_file|
  file_name = File.basename(image_file, File.extname(image_file))
  new_image_path = File.join(image_folder, "#{file_name}.jpg")

  # 如果不是 JPG 格式，转换为 JPG 并压缩到 2MB 以内
  unless File.extname(image_file).downcase == '.jpg'
    # 使用 ImageMagick 将图片转换为 JPG 并压缩到 2MB 以内
    system("magick #{image_file} -define jpeg:extent=2000KB #{new_image_path}")
    puts "Converted and compressed #{image_file} to #{new_image_path}"

    # 删除原始文件
    File.delete(image_file)
    puts "Deleted original file: #{image_file}"
  else
    # 如果图片已经是 JPG，检查是否需要压缩
    file_size = File.size(new_image_path).to_f / (1024 * 1024) # 转换为 MB
    if file_size > 2.0
      puts "#{new_image_path} is larger than 2MB (#{file_size.round(2)}MB), compressing..."
      # 压缩图片到 2MB 以内
      system("magick #{new_image_path} -define jpeg:extent=2000KB #{new_image_path}")
      compressed_size = File.size(new_image_path).to_f / (1024 * 1024)
      puts "Compressed #{new_image_path} to #{compressed_size.round(2)}MB"
    end
  end
end

puts "Image conversion and compression complete."
