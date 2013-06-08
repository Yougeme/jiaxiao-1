require "open-uri"

$start = 100
def abc
  begin
    100.times do |i|
      open("https://auth.kftpay.com.cn/captcha?#{rand(1000)}") do |image|
        IO.write("capchas/f#{i + $start}.jpeg", image.read)
      end
    end
  rescue e
    $start = $start * 10
    puts 'cucl'
    puts e
    abc
  end
end

abc
