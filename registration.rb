require 'test/unit'
  require 'selenium-webdriver'

  class FirstTest < Test::Unit::TestCase
    def setup
      @driver = Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, '/chromedriver.exe')
      @driver = Selenium::WebDriver.for :chrome
      #@driver = Selenium::WebDriver.for :firefox
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
    def teardown
      @driver.quit
    end
  end