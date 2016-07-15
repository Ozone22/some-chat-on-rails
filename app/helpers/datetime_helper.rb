module DatetimeHelper

  def current_time_show(datetime)
    local_time = datetime.localtime
    if local_time < DateTime.now.to_date
      local_time.strftime("%d.%m.%Y")
    else
      local_time.strftime("%H:%M:%S")
    end
  end
end