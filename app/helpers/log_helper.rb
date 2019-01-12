module LogHelper

  def write_log(title, value)
    log_filename = "#{title}-#{Time.now.strftime("%Y%m%d_%H-%M-%S")}.log"
    directory_name = 'tmp/global_logs'
    Dir.mkdir(Rails.root.join(directory_name)) unless File.exists?(directory_name)
    my_logger = Logger.new("#{Rails.root}/#{directory_name}/#{log_filename}")
    my_logger.info value
  end

end
