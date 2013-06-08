require "mini_magick"
require "chunky_png"
require "rtesseract"

PNG_PATH = File.expand_path(File.join(File.dirname(__FILE__), "pngs"))
RESULTS_PATH = File.expand_path(File.join(File.dirname(__FILE__), "results"))

def handle_image(image_file)
  name = image_file.chomp(".png")
  img = MiniMagick::Image.open(PNG_PATH + "/" + image_file)

  img.monochrome
  #img.write("#{RESULTS_PATH}/mono-pic_#{name}.png")
  img.colorspace("GRAY")
  img.write("#{RESULTS_PATH}/gray-pic_#{name}.png")

  woo = RTesseract.new("#{RESULTS_PATH}/gray-pic_#{name}.png")
  puts woo.to_s

  #img.negate
  #img.write("#{RESULTS_PATH}/negte-pic_#{name}.png")
end




puts PNG_PATH
Dir.glob("#{PNG_PATH}/*.png").each do |file|
  handle_image File.basename(file)
  puts file
end
