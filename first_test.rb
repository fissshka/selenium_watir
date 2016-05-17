require 'test/unit'
require 'selenium-webdriver'

class FirstTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  end
  def test_positive_registration
    register_user

    expected_text = 'Your account has been activated. You can now log in.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)

  end

  def register_user
    @driver.navigate.to 'http://demo.redmine.org'
    @wait.until{@driver.find_element(:class, 'register').displayed?}
    @driver.find_element(:class, 'register').click

    @wait.until{@driver.find_element(:id, 'user_login').displayed?}

    @login = ('login' + rand(99999).to_s)
    @init_pass = 'Qwerty'

    @driver.find_element(:id, 'user_login').send_keys @login
    @driver.find_element(:id, 'user_password').send_keys @init_pass
    @driver.find_element(:id, 'user_password_confirmation').send_keys @init_pass
    @driver.find_element(:id, 'user_firstname').send_keys 'first_name'
    @driver.find_element(:id, 'user_lastname').send_keys 'user_lastname'
    @driver.find_element(:id, 'user_mail').send_keys(@login + '@mailinator.com')

    @driver.find_element(:name, 'commit').click

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

    @logged_user = 'Zxcvbnm'
    @init_pass = 'Qwertyu'
    @new_pass = 'Qwertyui'

    @wait.until{@driver.find_element(:id, 'username').displayed?}
    @driver.find_element(:id, 'username').send_keys @logged_user
    @driver.find_element(:id, 'password').send_keys @init_pass
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