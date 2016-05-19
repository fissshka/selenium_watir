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

    @logged_user = 'Zxcvbnm'
    @init_pass = 'Qwertyu'
    @new_pass = 'Qwertyui'

    @wait.until{@driver.find_element(:id, 'username').displayed?}
    @driver.find_element(:id, 'username').send_keys @logged_user
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

    @issue_title = @driver.find_element (:css, 'a.title')
    @issue_title = @driver.find_element (:a, @issue_subject).text

    expected_text = 'Issue' + title
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)
  end

  def bug_creation
    test_ProjectCreation
    @wait.until{@driver.find_element(:class, 'new-issue').displayed?}
    @driver.find_element(:class, 'new-issue').click

    @wait.until{@driver.find_element(:id, 'issue_tracker_id').displayed?}
    @driver.find_element(:id, 'issue_tracker_id').click
    @driver.find_element(:value, '1').text
    @driver.find_element(:value, '1').click

    @issue_subject = 'Critical bug in the project'

    @driver.find_element(:id, 'issue_subject').send_keys @issue_subject
    @driver.find_element(:id, 'issue_priority_id').click
    @driver.find_element(:value, '7').text
    @driver.find_element(:value, '7').click

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click

  end

  def teardown
    @driver.quit
  end
end

