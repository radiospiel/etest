module Dlog
  def dlog(*args)
  end
end

if !ENV["NO_DLOG"]

module Dlog
  ROOT = if defined?(RAILS_ROOT)
    RAILS_ROOT
  else
    File.expand_path(Dir.getwd) 
  end
  
  HOME = ENV["HOME"] + "/"
  
  def self.release!
    @release = true
  end

  def self.release?
    @release
  end
      
  def self.debug!
    @release = false
  end

  def self.debug?
    !@release
  end

  def self.quiet!
    @quiet = true
  end

  def self.quiet?
    @quiet
  end

  def dlog(*args)
    return if Dlog.quiet?
    
    msg = ""
    was_string = true
    args.map do |s|
      msg += was_string ? " " : ", " unless msg.empty?
      msg += ((was_string = s.is_a?(String)) ? s : s.inspect)
    end
    STDERR.puts "#{Dlog.release? ? rlog_caller : dlog_caller} #{msg}"
  end

  def rlog_caller
    if caller[1] =~ /^(.*):(\d+)/
      file, line = $1, $2
      "[" + File.basename(file).sub(/\.[^\.]*$/, "") + "]"
    else
      "[log]"
    end
  end

  def dlog_caller
    if caller[1] =~ /^(.*):(\d+)/
      file, line = $1, $2
      file = File.expand_path(file)

      file.gsub!(ROOT, ".") or
      file.gsub!(HOME, "~/")
    
      "#{file}(#{line}):"
    else
      "<dlog>:"
    end
  end
end

end

class Object
  include Dlog
end
