require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, '/chromedriver.exe')
    @driver = Selenium::WebDriver.for :chrome
    #@driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end
  def hover
    @driver.navigate_to 'https://the-internet.herokuapp.com/hovers'
    @driver.find-element(:class, 'figure')
    @driver.move_to.(element).perform
    assert (driver.find_element(:class, 'figcaption').displayed?)
  end

  def teardown
    @driver.quit
  end
end