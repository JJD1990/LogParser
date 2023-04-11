require 'set'

class LogParser
  # Initialize the LogParser with either a file path or log data string
  def initialize(file_path_or_log_data, is_file_path: true)
    if is_file_path
      @log_data = File.read(file_path_or_log_data).split("\n")
    else
      @log_data = file_path_or_log_data.split("\n")
    end
  end

  # Method to calculate total page views
  def total_page_views
    page_views = Hash.new(0)

    # Iterate through each log entry
    @log_data.each do |line|
      path, ip = line.split
      
      # Raise an error if the log entry is incomplete
      raise RuntimeError, 'Incomplete log entry' if path.nil? || ip.nil?
      
      # Increment the page view count for the given path
      page_views[path] += 1
    end

    # Sort the page views in descending order
    page_views.sort_by { |_path, visits| -visits }
  end

  # Method to calculate unique page views
  def unique_page_views
    # Use a Set to store unique IPs for each path
    page_views = Hash.new { |hash, key| hash[key] = Set.new }

    # Iterate through each log entry
    @log_data.each do |line|
      path, ip = line.split
      
      # Raise an error if the log entry is incomplete
      raise RuntimeError, 'Incomplete log entry' if path.nil? || ip.nil?
      
      # Add the IP to the Set for the given path
      page_views[path].add(ip)
    end

    # Calculate the unique view count for each path and sort in descending order
    unique_views = page_views.map { |path, ips| [path, ips.size] }
    unique_views.sort_by { |_path, visits| -visits }
  end
end
