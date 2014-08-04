# utilities
require 'time'
require 'date'

def today
  Date.today.to_s
end

def timesheet(name = today)
  "#{name}.timesheet.rb"
end

def timestamps
  # 0 - 1: work
  # 1 - 2: break
  @timestamps ||= []
end
