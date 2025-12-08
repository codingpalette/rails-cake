module TimeSelectHelper
  def time_options
    options = []
    # 오전 시간 (00:00 ~ 11:30)
    (0..11).each do |hour|
      ["00", "30"].each do |minute|
        time = sprintf("%02d:%s", hour, minute)
        label = if hour == 0
                  minute == "00" ? "자정" : "오전 12:30"
                elsif hour < 12
                  "오전 #{hour}:#{minute}"
                else
                  "오후 #{hour}:#{minute}"
                end
        options << [label, time]
      end
    end
    
    # 오후 시간 (12:00 ~ 23:30)
    (12..23).each do |hour|
      ["00", "30"].each do |minute|
        time = sprintf("%02d:%s", hour, minute)
        display_hour = hour == 12 ? 12 : hour - 12
        label = if hour == 12 && minute == "00"
                  "정오"
                else
                  "오후 #{display_hour}:#{minute}"
                end
        options << [label, time]
      end
    end
    
    options
  end

  def format_time_label(time_str)
    return "" if time_str.blank?
    
    hour, minute = time_str.split(":").map(&:to_i)
    
    if hour == 0 && minute == 0
      "자정"
    elsif hour == 12 && minute == 0
      "정오"
    elsif hour == 0
      "오전 12:#{sprintf('%02d', minute)}"
    elsif hour < 12
      "오전 #{hour}:#{sprintf('%02d', minute)}"
    elsif hour == 12
      "오후 12:#{sprintf('%02d', minute)}"
    else
      "오후 #{hour - 12}:#{sprintf('%02d', minute)}"
    end
  end
end