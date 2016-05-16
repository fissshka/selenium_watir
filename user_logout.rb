require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def test_positive_logout
    require './user_login_logout.rb'
    logout_user


  end
  def logout_user
    @driver.navigate.to 'http://demo.redmine.org'
    @driver.find_element(:id, 'top-menu').displayed?
    @wait.until{@driver.find_element(:id, 'account').displayed?}

    @wait.until{@driver.find_element(:class, 'logout').displayed?}
    @driver.find_element(:class, 'logout').click
  end

  def teardown
    @driver.quit
  end
end

