require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def test_positive_login
    login_user
    @wait.until{@driver.find_element(:id, 'loggedas').displayed?}
    expected = 'Logged in as '+'Zxcvbnm'
    actual = @driver.find_element(:id, 'loggedas').text
    assert_equal(expected, actual)
  end
  def login_user
    @driver.navigate.to 'http://demo.redmine.org'
    @wait.until{@driver.find_element(:class, 'login').displayed?}
    @driver.find_element(:class, 'login').click

    @wait.until{@driver.find_element(:id, 'username').displayed?}
    @driver.find_element(:id, 'username').send_keys 'Zxcvbnm'
    @driver.find_element(:id, 'password').send_keys 'Qwertyu'
    @driver.find_element(:name, 'login').click
  end

  def test_positive_logout
    logout_user
    expected_result = @driver.find_element(:class, 'login')
    assert (expected_result.displayed?)
  end
  def logout_user
    test_positive_login
    @wait.until{@driver.find_element(:class, 'logout').displayed?}
    @driver.find_element(:class, 'logout').click
  end

  def teardown
    @driver.quit
  end
end