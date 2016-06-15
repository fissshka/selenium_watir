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


  def test_project_creation
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


    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click

  end
  def test_subproject_creation
    sub_project_creation
    expected_text = 'Successful creation.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
    assert_equal(expected_text, actual_text)
  end

  def sub_project_creation
    test_project_creation

    @wait.until{@driver.find_element(:class, 'overview').displayed?}
    @driver.find_element(:class, 'overview').click

    @wait.until{@driver.find_element(:class, 'icon-add').displayed?}
    @driver.find_element(:class, 'icon-add').click

    @sub_project_title =  ('sub_Project' + rand(99999).to_s)
    @sub_project_id = ('sub' + rand(99999).to_s)

    @wait.until{@driver.find_element(:id, 'project_name').displayed?}
    @driver.find_element(:id, 'project_name').send_keys @sub_project_title
    @driver.find_element(:id, 'project_description').send_keys 'This subproject relates to project' + @project_title
    @driver.find_element(:id, 'project_identifier').send_keys @sub_project_id

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click
  end

  def subproj_open
    test_subproject_creation
    @driver.find_element(:id, 'loggedas').find_element(:class, 'active').click
    @wait.until{@driver.find_element(:id, 'quick-search').displayed?}
    @action_key = @driver.find_element(:name, 'q')
    @action_key.send_keys @sub_project_title
    @action_key.submit
    @wait.until{@driver.find_element(:class, 'project').displayed?}
    @driver.find_element(:class, 'token-0').click
  end

  def test_issue_bug
    bug_creation

    @wait.until{@driver.find_element(:class, 'issue').displayed?}
    expected = @driver.current_url @bug_subject  expected = @driver.find_element (:class, 'notice').find_element(:tag_name, 'title').text (@support_subject)
    actual = @driver.find_element(:class, 'issue').find_element(:class, 'subject').text
    assert_equal(expected, actual)

  end

  def bug_creation
    test_subproject_creation
    subproj_open

    @wait.until{@driver.find_element(:id, 'main-menu').displayed?}
    @driver.find_element(:id, 'main-menu').find_element(:class, 'new-issue').click
    @wait.until{@driver.find_element(:id, 'issue_tracker_id').displayed?}
    @issue_type = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, 'issue_tracker_id'))
    @issue_type.select_by(:value, '1')

    @bug_subject = 'Critical bug in the project'
    @bug_description = 'This is bug'

    @driver.find_element(:id, 'issue_subject').send_keys @bug_subject
    @driver.find_element(:id, 'issue_description').send_keys @bug_description

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click
  end

  def test_issue_feature
    feature_creation

    @wait.until{@driver.find_element(:class, 'issue').displayed?}
    expected = @feature_subject
    actual = @driver.find_element(:class, 'issue').find_element(:class, 'subject').text
    assert_equal(expected, actual)

  end

  def feature_creation
    test_subproject_creation
    subproj_open

    @wait.until{@driver.find_element(:id, 'main-menu').displayed?}
    @driver.find_element(:id, 'main-menu').find_element(:class, 'new-issue').click
    @wait.until{@driver.find_element(:id, 'issue_tracker_id').displayed?}
    @issue_type = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, 'issue_tracker_id'))
    @issue_type.select_by(:value, '2')

    @feature_subject = 'New feature'
    @feature_description = 'This is awesome feature'

    @driver.find_element(:id, 'issue_subject').send_keys @feature_subject
    @wait = Selenium::WebDriver::Wait.new(:timeout => 2)
    @driver.find_element(:id, 'issue_description').send_keys @feature_description
    @wait = Selenium::WebDriver::Wait.new(:timeout => 2)

    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click
  end

  def test_issue_support
    support_creation

    @wait.until{@driver.find_element(:class, 'issue').displayed?}
    expected = @support_subject
    actual = @driver.find_element(:class, 'issue').find_element(:class, 'subject').text
    assert_equal(expected, actual)

  end

  def support_creation
    test_subproject_creation
    subproj_open

    @wait.until{@driver.find_element(:id, 'main-menu').displayed?}
    @driver.find_element(:id, 'main-menu').find_element(:class, 'new-issue').click
    @wait.until{@driver.find_element(:id, 'issue_tracker_id').displayed?}
    @issue_type = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, 'issue_tracker_id'))
    @issue_type.select_by(:value, '3')

    @support_subject = 'New support issue'
    @suport_description = 'This is support issue'

    @driver.find_element(:id, 'issue_subject').send_keys @support_subject
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    @driver.find_element(:id, 'issue_description').send_keys @support_description
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)


    @wait.until{@driver.find_element(:name, 'commit').displayed?}
    @driver.find_element(:name, 'commit').click
  end
  def teardown
    @driver.quit
  end
end

