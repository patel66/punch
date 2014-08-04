require 'selenium-webdriver'
require_relative 'selenium_wrapper'

# 2 Login
base_url = 'https://poeticsystems.freshbooks.com/'
timesheet_url = "#{base_url}timesheet#date/#{Date.today.to_s}"

driver.navigate.to base_url
fill_in('username', 'trent@poeticsystems.com')
fill_in('password', 'lxis3000')
driver.find_element(id: 'log_in').click

# 3 fill in fields and submit
driver.navigate.to timesheet_url
@periods.each do |period, content|
  sleep 2
  select('projectid', 'FIP Online')
  sleep 2
  select('taskid', 'App Design/Dev')
  fill_in('hours', content[:hours])
  fill_in('notes', content[:notes])
  driver.find_element(id: 'log-hours-button').click
end

# sleep to wait for the post request
sleep 2
driver.quit

# Structure:
#  (check if the rb file already exist, if yes, skip this)
# 1 gather the time and notes for today, put this into an rb file of today
#
# 2 save data into a data file as a ruby obj
# 3 use selenium to post the data
#
# TODO

# vim shortcut to run external function or use tubux to run command link <leader>m
# use two times instead of a time interval for rest
# use command line, auto generate the data file(use date as filename)

# commands:
# fbts (freshbooktimesheet) -s (default) -p (punch/post)
# <enter>: add a new timestamp, show the current status: working / playing
# <ctrl-c>: exit, output a @data hash and ask the user to confirm
# save the file
# y: run selenium, n: exit
