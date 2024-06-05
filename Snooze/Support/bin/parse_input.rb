require 'date'

WEEKDAYS = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]

def add_months(dt, months_to_add)
  year = dt.year + (dt.month + months_to_add - 1) / 12
  month = (dt.month + months_to_add - 1) % 12 + 1
  day = [dt.day, Date.new(year, month, -1).day].min
  Date.new(year, month, day)
end

def timespec2targetdate(spec, todays_date)
  raise ArgumentError, 'Invalid snooze time format: <None>' if spec.nil?

  if WEEKDAYS.include?(spec)
    target_weekday = WEEKDAYS.index(spec) + 1
    days_until_target = (target_weekday - todays_date.wday) % 7
    days_until_target = 7 if days_until_target == 0
    return todays_date + days_until_target
  end

  return todays_date + 1 if spec == 'tom'

  unit = spec[-1]
  amount = spec[0...-1].to_i

  raise ArgumentError, "Negative value in timespec: '#{spec}'" if amount < 0

  case unit
  when 'd'
    todays_date + amount
  when 'w'
    todays_date + amount * 7
  when 'm'
    add_months(todays_date, amount)
  else
    raise ArgumentError, "Invalid unit in timespec: '#{unit}'"
  end
end

def snooze2targetdate_with_format(x, format)
  raise ArgumentError, 'Invalid snooze time format: <None>' if x.nil?
  Date.strptime(x, format)
rescue ArgumentError
  raise ArgumentError, "Invalid snooze time format: '#{x}'"
end

def snooze2targetdate(x, todays_date)
  formats = ['%Y-%m-%d', '%d.%m.%Y', '%d.%m.']
  formats.each do |format|
    begin
      dt = snooze2targetdate_with_format(x, format)
      if format == '%d.%m.'
        year = todays_date.year
        year += 1 if Date.new(year, dt.month, dt.day) <= todays_date
        dt = Date.new(year, dt.month, dt.day)
      end
      return dt
    rescue ArgumentError
      next
    end
  end
  raise ArgumentError, "Invalid snooze time format: '#{x}'"
end

def parse_input(x, todays_date = Date.today)
  raise ArgumentError, "Invalid Input: <None>" if x.nil?
  raise ArgumentError, "Invalid Input with length 0" if x.empty?
  return Date.parse("3000-01-01") if x == "ff"

  begin
    timespec2targetdate(x, todays_date)
  rescue ArgumentError
    snooze2targetdate(x, todays_date)
  end
end
