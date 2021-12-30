Rails.application.configure do
  config.lograge.enabled = true
end

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

require 'colorized_string'

class ColorKeyValue < Lograge::Formatters::KeyValue
  FIELDS_COLORS = {
    method: :yellow,
    path: :yellow,
    error: :red,
    params: :green
  }

  def format(key, value)
    line = super(key, value)

    color = FIELDS_COLORS[key] || :white
    ColorizedString.new(line).public_send(color)
  end
end

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    begin
        params = event.payload[:params].reject { |k| ['controller', 'action'].freeze.include?(k) }
        {time: event.time, params: params }
    rescue
      puts "UNRECOGNIZED ERROR:"
      puts event.inspect
    end
  end
  config.lograge.formatter = ColorKeyValue.new
end
