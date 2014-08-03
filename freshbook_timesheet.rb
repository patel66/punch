#!/usr/bin/env ruby
# encoding: utf-8

require "pry"
require 'pry-byebug'
require 'time'
require 'date'
require 'selenium-webdriver'
require_relative 'helper'

# 1 calculate all fields
data.each do |period, content|
  # 1.1 parse all time fields
  [:start, :end].each do |time|
    content[time] = Time.parse(content[time])
  end
  content[:rest].each_with_index do |interval, index|
    content[:rest][index] = interval.to_f
  end
  # 1.2 calculate hours
  seconds = content[:end] - content[:start]
  seconds -=  content[:rest].inject(0, :+) * 60
  content[:hours] = (seconds / 3600.0).round(2)
end

# 2 Login
base_url = 'https://poeticsystems.freshbooks.com/'
timesheet_url = "#{base_url}timesheet#date/#{Date.today.to_s}"

driver.navigate.to base_url
fill_in('username', 'trent@poeticsystems.com')
fill_in('password', 'lxis3000')
driver.find_element(id: 'log_in').click

# 3 fill in fields and submit
driver.navigate.to timesheet_url
[:morning, :afternoon].each do |period|
  sleep 2
  select('projectid', 'FIP Online')
  sleep 2
  select('taskid', 'App Design/Dev')
  fill_in('hours', data[period][:hours])
  fill_in('notes', data[period][:notes])
  driver.find_element(id: 'log-hours-button').click
end

# sleep to wait for the post request
sleep 4
driver.quit

# Structure:
#  (check if the rb file already exist, if yes, skip this)
# 1 gather the time and notes for today, put this into an rb file of today
#
# 2 save data into a data file as a ruby obj
# 3 use selenium to post the data
#
# TODO
# add git commits for today
  # username = `git config user.name`.strip
  # today = Date.today.to_s
  # logs = `git log --after='#{today} 00:00:00' --before='#{today} 23:59:58' --author='Chun-Yang' --pretty=format:'%s'`
    # .split
    # .reverse



# use capybara and add 'built-in' tests

# vim shortcut to run external function or use tubux to run command link <leader>m
# use two times instead of a time interval for rest
# use command line, auto generate the data file(use date as filename)

# commands:
# fbts (freshbooktimesheet) -s (default) -p (punch/post)
# <enter>: add a new timestamp, show the current status: working / playing
# <ctrl-c>: exit, output a @data hash and ask the user to confirm
# save the file
# y: run selenium, n: exit