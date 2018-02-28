$LOAD_PATH.unshift File.dirname(__FILE__)
require "robot"

class Test_Loader
  def initialize(name)
    @test_name = name
    @robot = Robot.new(name)
  end
  attr_accessor :robot, :test_name

  # set the command array
  @@commandlist = ["PLACE", "MOVE", "LEFT", "RIGHT", "REPORT"]

  # check if a string is an integer with "", return true/false
  def checkInt(s)
    /\A[-+]?\d+\z/ === s
  end

  # read a local file of command, and create an string[] of commandlines
  def readFile(filename)
    # create an string[] of commnadlines
    commandlines = []
    # open file
    command_file = File.open(filename)
    #raise "WARNING! The file is not valid!"
    File.open(filename) do |f|
      f.each_line do |line|
        commandlines << line.gsub("\n", "")
      end
    end
    # return an string[]
    return commandlines
  rescue SystemCallError => e
    puts e.class.name
    puts e.message
    false
  else
    puts "File is loaded."
  ensure
    command_file.close if command_file
  end

  # execute commandlines one by one
  def runCommand(commandlines)
    commandlines.each {|commandline| convertCommand(commandline)}
    return true
  rescue SystemCallError => e
    puts e.class.name
    puts e.message
    false
  end

  # convert command string to call methods, torlerance to upper/lowercase
  def convertCommand(commandline)
    command = commandline.split
    # command place
    if command[0].upcase == @@commandlist[0] && command.length == 2
      paras = command[1].split(',')
      # check if paras is valid
      if checkInt(paras[0]) && checkInt(paras[1])
        @robot.place(paras[0].to_i, paras[1].to_i, paras[2]) #place parameters
      else
        puts "WARNING! The coordinates are not valid!"
      end
      # other commands when ontable
    elsif @robot.isontable? && command.length == 1 && command[0].is_a?(String) && @@commandlist.include?(command[0].upcase)
      case command[0].upcase
        when @@commandlist[1] #case move
          @robot.move
        when @@commandlist[2], @@commandlist[3] #case left, right
          @robot.turn(command[0])
        when @@commandlist[4] #case report
          @robot.report
      end
    else
      puts "WARNING! The command is not valid!"
    end
  end

end