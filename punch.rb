#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'punch_utils'


# when it does not exist, we start the punch cli and create the file
require_relative 'punch_cli' if !File.file?(timesheet)

# when the timesheet is created, we post the data
require_relative 'punch_post' if File.file?(timesheet)
