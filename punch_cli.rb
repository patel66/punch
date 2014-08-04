# get timestamps between work and break
# get git commits automatically

# 1. welcome message
puts %Q(\
  1. Use Enter to start/finish a break
  2. Use Ctrl-C to escape
)

# 2 capture <C-c>
begin
  while true
    timestamps << Time.now
    if timestamps.count.odd?
      print 'WORK...'
      # print time taken during last break
      if timestamps.count >= 3
        interval = timestamps[-1] - timestamps[-2]
        mins = (interval / 60).floor
        seconds = (interval - mins * 60).round
        print "(Last break took #{mins} MINS #{seconds} SECONDS.)"
      end
      print "\n"
    else
      puts 'BREAK...'
    end
    gets
  end
rescue Interrupt
  # if the current state is woring, we add a timestamp at the end
  timestamps << Time.now if timestamps.count.odd?
  # generate timesheet data
  puts 'What a day! You must be tired. Please sit back and allow me to generate your freshbook timesheet.'
  # TODO deal with edge case: there are only two timestamps
  max_break_interval = 0
  max_break_index = 0
  breaks = timestamps[1..-2].each_slice(2).to_a
  breaks.each_with_index do |break_a, index|
    interval = break_a[1] - break_a[0]
    if interval > max_break_index
      max_break_interval = interval
      max_break_index = index
    end
  end
  timesheet_split_timestamp = breaks[max_break_index][0] + max_break_interval / 2
  periods = {
    morning: {timestamps: [], notes: '', hours: nil},
    afternoon: {timestamps: [], notes: '', hours: nil}
  }
  timestamps.each do |t|
    if t < timesheet_split_timestamp
      periods[:morning][:timestamps] << t
    else
      periods[:afternoon][:timestamps] << t
    end
  end
  periods.each do |period, content|
    content[:hours] = content[:timestamps].each_slice(2).map do |work_a|
      ((work_a[1] - work_a[0]) / 3600).round(2)
    end.reduce(0, :+)
  end
  # get git log info by time
  username = `git config user.name`.strip

  periods[:morning][:notes] = `git log --after='#{today} #{periods[:morning][:timestamps][0]}' --before='#{today} #{timesheet_split_timestamp}' --author='Chun-Yang' --pretty=format:'%s'`
  .split("\n")
  .reverse
  .join("\n")

  periods[:afternoon][:notes] = `git log --after='#{today} #{timesheet_split_timestamp}' --before='#{today} #{periods[:afternoon][:timestamps][-1]}' --author='Chun-Yang' --pretty=format:'%s'`
  .split("\n")
  .reverse
  .join("\n")

  puts periods
end
