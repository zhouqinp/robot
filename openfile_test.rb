class Robot
# read a local file of command, and create an string[] of commandlines
  def self.readfile(filename)
    # create an string[] of commnadlines
    commandlines = []
    p commandlines
    # open file
    command_file = File.open(filename)
    #raise "WARNING! The file is not valid!"
    File.open(filename) do |f|
      f.each_line do |line|
        commandlines << line.gsub("\n","")
        p commandlines
      end
    end
    p commandlines
    # return an string[]
    commandlines
  rescue SystemCallError => e
    puts e.class.name
    puts e.message
    false
  else
    puts "File is loaded."
  ensure
    command_file.close if command_file
  end


end

r = Robot.new
#Robot.readfile("C:\Users\Jzhouqing\ruby", "test_a.txt")
file = File.open("C:/Users/Jzhouqing/ruby/test_a.txt")
puts file.closed?
File.open("C:/Users/Jzhouqing/ruby/test_a.txt") do |f|
  f.each_line do |line|
    puts line
    puts file.closed?
  end
  puts file.closed?
end

Robot.readfile("C:/Users/Jzhouqing/ruby/test_a.txt")
Robot.readfile("C:/Users/Jzhouqing/ruby/test_b.txt")
Robot.readfile("C:/Users/Jzhouqing/ruby/test_c.txt")
Robot.readfile("C:/Users/Jzhouqing/ruby/test_d.txt")
Robot.readfile("test_a.txt")