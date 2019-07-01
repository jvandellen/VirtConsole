class VirtConsole
  require 'serialport'
  attr_accessor :port, :command
  def initialize(hash)
    @path = hash[:path]
    @command = hash[:command]
  end
  def execute
    sp = SerialPort.open("#{@path}", baud = 9600, data_bits = 8, stop_bits = 1) { |tty|
      tty.sync = true
      line = ""
      Thread.new {
        tty.write @command + "\015"
      }
      until line =~ /^(Execution Completed)/ do
        line = (tty.readline.chomp!)
        print "#{line}\n"
      end
    print "\n"
    }
  end
end

