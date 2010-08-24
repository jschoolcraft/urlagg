HoptoadNotifier.configure do |config|
  config.api_key = {:project => 'urlagg',
                    :tracker => 'Bug',
                    :api_key => ENV['REDMINE_API_KEY'],
                    :category => 'Development',
                    :assigned_to => 'admin',
                    :priority => 5
                   }.to_yaml
  config.host = 'rm.thequeue.net'
  config.port = 443
  config.secure = true
end