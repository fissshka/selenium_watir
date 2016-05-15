require 'watir-webdriver'

browser = Watir::Browser.new :firefox

browser.goto 'http://demo.redmine.org'
browser.link(class: 'register').click
browser.text_field(id: 'user_login').set('1wertqwertyuureqqq1')
browser.text_field(id: 'user_password').set('123456Qw')
browser.text_field(id: 'user_password_confirmation').set('123456Qw')
browser.text_field(id: 'user_firstname').set('userueyufyd')
browser.text_field(id: 'user_lastname').set('usernssdffssdfhi')
browser.text_field(id: 'user_mail').set('1wertqwertyuureqqq1@mail.com')

browser.button(value: 'Submit').click

fail unless browser.link(class: 'user').text.include? '1wertqwertyuureqqq1'

browser.link(class: 'projects').click
browser.link(class: 'icon icon-add').click

browser.text_field(id: 'project_name').set('my_first_test_project12')
browser.text_field(id: 'project_identifier').set('my_first_test_project12')
browser.button(value: 'Create').click



fail unless browser.div(id: 'main').text.include? 'Successful creation'
sleep 2

browser.quit
