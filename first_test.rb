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
    sleep 2
    assert_equal(expected_text, actual_text)
  end

  def register_user
    @driver.navigate.to 'http://demo.redmine.org'
    @driver.find_element(:class, 'register').click

   @wait.until{@driver.find_element(:id, 'user_login').displayed?}
    sleep 3

    @login = ('login' + rand(99999).to_s)

    @driver.find_element(:id, 'user_login').send_keys @login
    @driver.find_element(:id, 'user_password').send_keys 'qwerty'
    @driver.find_element(:id, 'user_password_confirmation').send_keys 'qwerty'
    @driver.find_element(:id, 'user_firstname').send_keys 'first_name'
    @driver.find_element(:id, 'user_lastname').send_keys 'user_lastname'
    @driver.find_element(:id, 'user_mail').send_keys(login + '@mailinator.com')

    sleep 3

    @driver.find_element(:name, 'commit').click

  end



  def test_positive_login
    login_user
    sleep 3
    user_logged_in = @driver.find_element(:class, 'user active')
    assert_equal(user_logged_in, 'Zxcvbnm')
  end
  def login_user
    @driver.navigate.to 'http://demo.redmine.org'
    @driver.find_element(:class, 'login').click

    @driver.find_element(:id, 'username').send_keys 'Zxcvbnm'
    @driver.find_element(:id, 'password').send_keys 'Qwertyu'
    @driver.find_element(:name, 'login').click
  end

  def test_positive_logout
    logout_user

    login_button = @driver.find_element(:class, 'login')
    assert(login_button.dispayed?)

  end
  def logout_user
    @driver.navigate.to 'http://demo.redmine.org'
    user_logged_in = @driver.find_element(:class, 'logout')
    assert(user_logged_in.displayed?)
    @driver.find_element(:class, 'logout').click
  end

  def test_change_pass
    login_user
    pass_change
    expected_text = 'Password was successfully updated.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    sleep 2
    assert_equal(expected_text, actual_text)

  end
  def pass_change
    @driver.navigate.to 'http://demo.redmine.org'
    user_logged_in = @driver.find_element(:class, 'logout')
    assert(user_logged_in.displayed?)
    @driver.find_element(:class, 'my-account').click
    sleep 2
    change_pass_button = @driver.find_element(:class, 'icon icon-passwd').click
    sleep 2

    @driver.find_element(:id, 'password').send_keys 'Qwertyu'
    @driver.find_element(:id, 'new_password').send_keys 'Qwertyui'
    @driver.find_element(:id, 'new_password_confirmation').send_keys 'Qwertyui'
    @driver.find_element(:value, 'Apply').click
  end
  def teardown
    @driver.quit
  end
  #def test_negative_registration
  #
  #end
  # test_positive_logout
  # test_positive_login
  #




  def login
    @driver.find_element(:class, 'login').click

    sleep 3
    logout_button = @driver.find_element(:class, 'logout').click
    assert(logout_button.displayed?)
  end


  def teardown
    @driver.quit
  end
  end

