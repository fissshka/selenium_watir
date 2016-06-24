require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, '/chromedriver.exe')
    @driver = Selenium::WebDriver.for :chrome
    #@driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end
  def test_hover
    hover
    expected = @driver.find_element(:class, 'figcaption')
    assert(expected.displayed?)
  end
  def hover
    @driver.navigate.to 'https://the-internet.herokuapp.com/hovers'
    @hover = @driver.find_element(:class, 'figure')
    @driver.mouse.move_to @hover
  end
  def test_drag
    drag_drop
    expected = @driver.find_element(:tag_name, 'header')
    @position = [String]
    assert_equal(expected, 'A')
  end
  def drag_drop
    @driver.navigate.to 'https://the-internet.herokuapp.com/drag_and_drop'
    @left_block = @driver.find_element(:id, 'column-a')
    @right_block = @driver.find_element(:id, 'column-b')
    @driver.action.drag_and_drop(@left_block, @right_block)
    #@left_block.drag_and_drop_on @right_block

  end
  def test_select
    select_list
    expected = 'Option 1'
    assert (expected.displayed?)
  end
  def select_list
    @driver.navigate.to 'https://the-internet.herokuapp.com/dropdown'
    @wait.until{@driver.find_element(:id, 'dropdown').displayed?}
    @list = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, 'dropdown'))
    @list.select_by(:value, '1')

  end

  def teardown
    @driver.quit
  end
end