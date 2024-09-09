require 'fileutils'

# 设置图片文件夹路径和输出文件路径
image_folder = 'images/machi_photos'
output_file = 'image_list.yml'

# 获取所有图片文件
image_files = Dir.glob("#{image_folder}/*.{jpg,jpeg,png}")

# 生成 YAML 数据
images = image_files.map do |file_path|
  # 提取文件名（去掉路径和扩展名）
  filename = File.basename(file_path, File.extname(file_path))

  # 去掉末尾的数字
  title = filename.gsub(/[\d０１２３４５６７８９]+$/, '')

  {
    'image_path' => "/#{file_path}", # 生成完整的相对路径
    'title' => title
  }
end

# 写入 YAML 文件
File.open(output_file, 'w') do |file|
  file.write("images:\n")
  images.each do |image|
    file.write("  - image_path: #{image['image_path']}\n")
    file.write("    title: #{image['title']}\n")
  end
end

puts "Generated #{output_file} with #{images.size} images."
