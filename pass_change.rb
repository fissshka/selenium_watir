require 'test/unit'
require 'selenium-webdriver'
require './user_login.rb'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  end

  def test_change_pass
    #login_user
    pass_change
    expected_text = 'Password was successfully updated.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    sleep 2
    assert_equal(expected_text, actual_text)

  end

  def pass_change
    @wait.until{@driver.find_element(:class, 'logout').displayed?}
    @driver.find_element(:class, 'my-account').click

    @wait.until{@driver.find_element(:class, 'icon icon-passwd').displayed?}
    changePassButton = @driver.find_element(:class, 'icon icon-passwd').click

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

