require 'minitest/autorun'
require_relative '../lib/log_parser'

class LogParserTest < Minitest::Test
  # Set up the test environment by providing a hardcoded log data string
  def setup
    log_data = <<~LOG_DATA
      /home 111.111.111.111
      /index 111.111.111.111
      /home 222.222.222.222
      /about 111.111.111.111
      /home 111.111.111.111
      /index 222.222.222.222
    LOG_DATA

    # Create a LogParser instance with the hardcoded log data string
    @parser = LogParser.new(log_data, is_file_path: false)
  end

  # Test the total_page_views method of the LogParser class
  def test_total_page_views
    expected_result = [
      ['/home', 3],
      ['/index', 2],
      ['/about', 1]
    ]
    assert_equal expected_result, @parser.total_page_views
  end

  # Test the unique_page_views method of the LogParser class
  def test_unique_page_views
    expected_result = [
      ['/home', 2],
      ['/index', 2],
      ['/about', 1]
    ]
    assert_equal expected_result, @parser.unique_page_views
  end

  # Test if the LogParser is able to accept and process a log file
  def test_accepts_log_file
    log_file_path = 'data/webserver.log'
    parser = LogParser.new(log_file_path)

    # Check if total_page_views returns an array of the expected format
    assert(parser.total_page_views.all? { |item| item.is_a?(Array) && item.size == 2 })

    # Check if unique_page_views returns an array of the expected format
    assert(parser.unique_page_views.all? { |item| item.is_a?(Array) && item.size == 2 })
  end

  # Test with an empty log
  def test_empty_log
    parser = LogParser.new("", is_file_path: false)
    assert_equal [], parser.total_page_views
    assert_equal [], parser.unique_page_views
  end

  # Test with a incomplete log entry
  def test_incomplete_log_entry
    log_data = "/home 111.111.111.111\n/index\n/home 222.222.222.222"
    parser = LogParser.new(log_data, is_file_path: false)

    assert_raises(RuntimeError) do
      parser.total_page_views
    end

    assert_raises(RuntimeError) do
      parser.unique_page_views
    end
  end

  # Test with invalid file path
  def test_invalid_file_path
    invalid_file_path = 'data/nonexistent.log'

    assert_raises(Errno::ENOENT) do
      LogParser.new(invalid_file_path)
    end
  end
end
