require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def test_positive_logout
    logout_user
    expected_result = @driver.find_element(:class, 'login')
    assert (expected_result.displayed?)
  end
  def logout_user
    require './user_login.rb'

    @wait.until{@driver.find_element(:class, 'logout').displayed?}
    @driver.find_element(:class, 'logout').click
  end

  def teardown
    @driver.quit
  end

end

