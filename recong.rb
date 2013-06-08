require "mini_magick"
require "chunky_png"
require "awesome_print"


IMAGE = File.expand_path(File.join(File.dirname(__FILE__), "g.png"))

m4qn  = ChunkyPNG::Image.from_file(IMAGE)
m4qncanvas = ChunkyPNG::Canvas.from_file(IMAGE)


chars_path = File.expand_path(File.join(File.dirname(__FILE__), "/chars"))
chars = []
Dir.glob(chars_path + "/*.png") do |char|
  mcanvas = ChunkyPNG::Canvas.from_file(char)
  m = Array.new(mcanvas.width) { Array.new(mcanvas.height) }
  for h in 0..(mcanvas.height - 1)
    for w in 0..(mcanvas.width - 1)
      value = mcanvas[w, h] == 255 ? "1" : "0"
      print value
      m[w][h] = value
    end
    print "\n"
  end
  chars << [char.chomp(".png"), m]
end

c = Array.new(m4qncanvas.width) { Array.new(m4qncanvas.height) }


puts "=================="

for h in 0..(m4qncanvas.height - 1)
  for w in 0..(m4qncanvas.width - 1)
    value = m4qncanvas[w, h] == 255 ? "1" : "0"
    print value
    c[w][h] = value
  end
  print "\n"
end

def print_region(region)
  width = region.size - 1
  height = region[0].size - 1  
  for w in 0..height
    for h in 0..width
      print region[h][w]
    end
    print "\n"
  end
end


def find_region(data, start_x, start_y, w, h)
  region_in_c = Array.new(w) { Array.new(h) }
  for x in 0..(w-1)
    for y in 0..(h-1)
      region_in_c[x][y] = data[start_x + x][start_y + y]        
    end
  end

  region_in_c
end

def match_percent(region_a, region_b)
  total = matched = 0
  width = region_a.size - 1
  height = region_a[0].size - 1
  #print_region region_a
  #print_region region_b
  for w in (0..width)
    for h in (0..height)
      total += 1
      matched += (region_a[w][h] == region_b[w][h] ? 1 : 0)
    end
  end

  matched / total.to_f
end

def find(c, m)
  c_width = c.size
  c_height = c[0].size
  m_width = m.size
  m_height = m[0].size
  percents = []

  for h_cursor in 0..(c_height - m_height)
    for w_cursor in 0..(c_width - m_width)
      region_in_c = find_region(c, w_cursor, h_cursor, m_width, m_height)
      percents.push [w_cursor, match_percent(region_in_c, m)]
    end
  end

  percents.sort_by{|arr| arr[1] }.reverse[0]
end

results = []
chars.each do |char, char_data|
  #print_region char
  results << [char, find(c, char_data)]
end

ap results.sort_by{|r| r[1][1] }.reverse[0, 4].sort_by{|r| r[1][0] }.map{|r| r[0]}

