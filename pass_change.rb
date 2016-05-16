require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def test_ChangePass
    pass_change
    expected_text = 'Password was successfully updated.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)

  end

  def pass_change
    require './user_login.rb'
    @wait.until{@driver.find_element(:class, 'my-account').displayed?}
    @driver.find_element(:class, 'my-account').click

    @wait.until{@driver.find_element(:class, 'icon-passwd').displayed?}
    @driver.find_element(:class, 'icon-passwd').click

    @wait.until{@driver.find_element(:id, 'password').displayed?}

    @driver.find_element(:id, 'password').send_keys @init_pass
    @driver.find_element(:id, 'new_password').send_keys @new_pass
    @driver.find_element(:id, 'new_password_confirmation').send_keys @new_pass

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click


    @wait.until{@driver.find_element(:class, 'icon-passwd').displayed?}
    @driver.find_element(:class, 'icon-passwd').click

    @wait.until{@driver.find_element(:id, 'password').displayed?}

    @driver.find_element(:id, 'password').send_keys @new_pass
    @driver.find_element(:id, 'new_password').send_keys @init_pass
    @driver.find_element(:id, 'new_password_confirmation').send_keys @init_pass

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click

  end

  def teardown
    @driver.quit
  end
end


=begin
  def test_ChangePass
    pass_change
    expected_text = 'Password was successfully updated.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)

  end

  def pass_change
    test_positive_login
    @wait.until{@driver.find_element(:class, 'my-account').displayed?}
    @driver.find_element(:class, 'my-account').click

    @wait.until{@driver.find_element(:class, 'icon-passwd').displayed?}
    @driver.find_element(:class, 'icon-passwd').click

    @wait.until{@driver.find_element(:id, 'password').displayed?}

    @driver.find_element(:id, 'password').send_keys @init_pass
    @driver.find_element(:id, 'new_password').send_keys @new_pass
    @driver.find_element(:id, 'new_password_confirmation').send_keys @new_pass

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click


    @wait.until{@driver.find_element(:class, 'icon-passwd').displayed?}
    @driver.find_element(:class, 'icon-passwd').click

    @wait.until{@driver.find_element(:id, 'password').displayed?}

    @driver.find_element(:id, 'password').send_keys 'Qwertyui'
    @driver.find_element(:id, 'new_password').send_keys 'Qwertyu'
    @driver.find_element(:id, 'new_password_confirmation').send_keys 'Qwertyu'

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click
=end