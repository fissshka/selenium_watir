require 'test/unit'
require 'selenium-webdriver'


class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)

  end

  def test_ChangePass
    pass_change
    expected_text = 'Password was successfully updated.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)

  end

  def pass_change
    require './user_login_logout.rb'
    @driver.navigate.to 'http://demo.redmine.org'
    @wait.until{@driver.find_element(:class, 'my-account').displayed?}
    @driver.find_element(:class, 'my-account').click

    @wait.until{@driver.find_element(:class, 'icon icon-passwd').displayed?}
    change_PassButton = @driver.find_element(:class, 'icon icon-passwd').click

    @wait.until{@driver.find_element(:id, 'password').displayed?}

    @driver.find_element(:id, 'password').send_keys 'Qwertyu'
    @driver.find_element(:id, 'new_password').send_keys 'Qwertyui'
    @driver.find_element(:id, 'new_password_confirmation').send_keys 'Qwertyui'

    @wait.until{@driver.find_element(:value, 'Apply').displayed?}
    @driver.find_element(:value, 'Apply').click
  end


  def teardown
    @driver.quit
  end

end

