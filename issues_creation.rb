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
    expected = 'Logged in as '+ @login
    actual = @driver.find_element(:id, 'loggedas').text
    assert_equal(expected, actual)
  end
  def login_user
    test_positive_registration

    @wait.until{@driver.find_element(:class, 'logout').displayed?}
    @driver.find_element(:class, 'logout').click

    @wait.until{@driver.find_element(:class, 'login').displayed?}
    @driver.find_element(:class, 'login').click


    @wait.until{@driver.find_element(:id, 'username').displayed?}
    @driver.find_element(:id, 'username').send_keys @login
    @driver.find_element(:id, 'password').send_keys @init_pass
    @driver.find_element(:name, 'login').click
  end


  def test_ProjectCreation
    project_creation
    expected_text = 'Successful creation.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)
  end

  def project_creation
    test_positive_login
    @wait.until{@driver.find_element(:class, 'projects').displayed?}
    @driver.find_element(:class, 'projects').click

    @wait.until{@driver.find_element(:class, 'icon-add').displayed?}
    @driver.find_element(:class, 'icon-add').click

    @wait.until{@driver.find_element(:id, 'project_name').displayed?}

    @project_title =  ('fir_Project' + rand(99999).to_s)
    @project_identifier = ('grys' + rand(99999).to_s)

    @driver.find_element(:id, 'project_name').send_keys @project_title
    @driver.find_element(:id, 'project_description').send_keys 'Project has been created as a sample'
    @driver.find_element(:id, 'project_identifier').send_keys @project_identifier
    @driver.find_element(:id, 'project_enabled_module_names_issue_tracking').click

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click

  end
  def test_issue_bug
    bug_creation

    expected = 'Issue ' + @project_title + ' created.'
    actual = @driver.find_element(:class, 'flash notice').text
    assert_equal(expected, actual)
  end

  def bug_creation
    test_ProjectCreation
    @wait.until{@driver.find_element(:class, 'projects').displayed?}
    @driver.find_element(:class, 'projects').click
    @driver.find_element(:name, 'q').send_keys @project_title
    @driver.find_element(:name, 'q').click
    @driver.find_element(:class, 'highlight token-0').click
    @wait.until{@driver.find_element(:class, 'new-issue').displayed?}
    @driver.find_element(:class, 'new-issue').click

    @wait.until{@driver.find_element(:id, 'issue_tracker_id').displayed?}
    @driver.find_element(:id, 'issue_tracker_id').click
    @driver.find_element(:value, '1').text
    @driver.find_element(:value, '1').click

    @issue_subject = 'Critical bug in the project'
    @bug_description = 'This is bug'

    @driver.find_element(:id, 'issue_subject').send_keys @issue_subject
    @driver.find_element(:id, 'issue_description').send_keys @bug_description
    @driver.find_element(:id, 'issue_priority_id').click
    @driver.find_element(:value, '7').text
    @driver.find_element(:value, '7').click

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click

    @wait.until{@driver.find_element(:class, 'issues selected').displayed?}
    @wait.until{@driver.find_element(:class, 'issues selected').click}

    @wait.until{@driver.find_element(:id, 'values_tracker_id_1').displayed?}
    @driver.find_element(:id, 'values_tracker_id_1').click
    @driver.find_element(:value, '1').click

  end

  def teardown
    @driver.quit
  end
end

