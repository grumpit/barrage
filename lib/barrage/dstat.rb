require "csv"

class Dstat
  def self.run(dstat_file)
    pid = fork do
      cmd = "dstat -tcmrd --disk-util -ny --output #{dstat_file}"
      exec(cmd)
    end
    return pid
  end

  def self.parse(file, column)
    time = Array.new
    values = Array.new

    start_parsing = false
    count = 0
    CSV.foreach(file) do |row|

      if start_parsing
        time.push(count - 7)
        values.push(row[column])
      else 
        start_parsing = true if count == 7
      end

      count += 1
    end

    return time, values
  end
end
