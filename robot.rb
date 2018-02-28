class Robot
  def initialize(name)
    @name = name
    @x = "NA"
    @y = "NA"
    @f = "NA"
    @ontable = false
  end

  # set some arrays for faces
  @@facelist = ["SOUTH", "NORTH", "EAST", "WEST"]
  @@facemove = [["SOUTH", 0, -1], ["NORTH", 0, 1], ["EAST", 1, 0], ["WEST", -1, 0]]
  @@turnlist = ["LEFT", "RIGHT"]
  @@faceleft = ["EAST", "NORTH", "WEST", "SOUTH", "EAST"]
  @@faceright = ["EAST", "SOUTH", "WEST", "NORTH", "EAST"]
  # set the command array
  @@commandlist = ["PLACE", "MOVE", "LEFT", "RIGHT", "REPORT"]

  # grant access to private fields
  attr_accessor :name, :x, :y, :f, :ontable


  # check whether the robot is on the table, change @ontable, return true/false
  def isontable?
    if @x.is_a?(Integer) && @y.is_a?(Integer) && @x.between?(0, 5) && @y.between?(0, 5) && @f.is_a?(String) && @@facelist.include?(@f)
      @ontable = true
    else
      @ontable = false
    end
    @ontable
  end

  # check the place parameters and check whether the robot is on the table, change @x, @y, @f, @ontable, tolerance to Upper/lowercase
  def place(numx, numy, facef)
    #raise "The x, y coordinates are not valid!" if numx.integer? #&& numy.integer? && numx >= 0 && numy >= zero
    #raise "The face is not valid!" unless facef.is_a?(String)
    if numx.is_a?(Integer) && numy.is_a?(Integer) && numx.between?(0, 5) && numy.between?(0, 5) && facef.is_a?(String) && @@facelist.include?(facef.upcase)
      @x = numx
      @y = numy
      @f = facef.upcase
      isontable?
      puts "The toy is placed."
    else
      puts "The coordinates or face is not valid!"
    end
  end

  # check the face and required move, prohibit danger move, check @x+xmove, @y+ymove, change @x, @y
  def move
    if @ontable
      xmove = @@facemove[@@facelist.index(@f)][1]
      ymove = @@facemove[@@facelist.index(@f)][2]
      if (@x + xmove).between?(0, 5) && (@y + ymove).between?(0, 5)
        @x += xmove
        @y += ymove
        puts "This move " + @f + " is completed."
      else
        puts "WARNING! This move " + @f + " is prohibited!"
      end
    else
      puts "WARNING! This move " + @f + " is prohibited!"
    end
  end

  # turn left or right, change @f
  def turn(turnLR)
    if @ontable && turnLR.is_a?(String) && @@turnlist.include?(turnLR.upcase)
      case turnLR.upcase
        when @@turnlist[0] # case turn left
          @f = @@faceleft[@@faceleft.index(@f) + 1]
          puts "This turn " + turnLR.upcase + " is completed."
        when @@turnlist[1] # case turn right
          @f = @@faceright[@@faceright.index(@f) + 1]
          puts "This turn " + turnLR.upcase + " is completed."
        else
          "WARNING! This turn " + turnLR.upcase + " is prohibited!"
      end
    else
      puts "WARNING! This turn " + turnLR.upcase + " is prohibited!"
    end

  end

  # check whether the robot is on the table and report the @x, @y, @f
  def report
    if @ontable
      printf "Output: %d, %d, %s\n", @x, @y, @f
      printf "REPORT: The robot is now on position(%d, %d) with face to the %s.\n", @x, @y, @f
    else
      puts "WARNING! This report is prohibited!"
    end
  end

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
        place(paras[0].to_i, paras[1].to_i, paras[2]) #place parameters
      else
        puts "WARNING! The coordinates are not valid!"
      end
      # other commands when ontable
    elsif @ontable && command.length == 1 && command[0].is_a?(String) && @@commandlist.include?(command[0].upcase)
      case command[0].upcase
        when @@commandlist[1] #case move
          move
        when @@commandlist[2], @@commandlist[3] #case left, right
          turn(command[0])
        when @@commandlist[4] #case report
          report
      end
    else
      puts "WARNING! The command is not valid!"
    end
  end

end