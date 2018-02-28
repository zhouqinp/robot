$LOAD_PATH.unshift File.dirname(__FILE__)

require "robot"
require "test_loader"

puts "Let's start with the test A!"
testA = Test_Loader.new("A")
testA.runCommand(testA.readFile("test_a.txt"))
puts "=========END==========="

puts "Let's start with the test B!"
testB = Test_Loader.new("B")
testB.runCommand(testB.readFile("test_b.txt"))
puts "=========END==========="

puts "Let's start with the test C!"
testC = Test_Loader.new("C")
testC.runCommand(testC.readFile("test_c.txt"))
puts "=========END==========="