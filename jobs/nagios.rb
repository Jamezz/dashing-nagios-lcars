SCHEDULER.every '15s' do
  require 'bundler/setup'
  require 'nagiosharder'

  environments = {
    dev: { url: 'http://NAGIOS/nagios/cgi-bin/', username: '', password: '' },
  }

  environments.each do |key, env|
    nag = NagiosHarder::Site.new(env[:url], env[:username], env[:password], 3, 'us')
    unacked = nag.service_status(:host_status_types => [:all], :service_status_types => [:warning, :critical], :service_props => [:no_scheduled_downtime, :state_unacknowledged, :checks_enabled])

    critical_count = 0
	criticals_list = []
    warning_count = 0
  warnings_list = []
    unacked.each do |alert|
    if alert["status"].eql? "CRITICAL"
      split = alert["attempts"].split("/")
      currentAttempt = Integer(split[0])
      maxAttempts = Integer(split[1])
      if (currentAttempt>=maxAttempts)
        criticals_list.push(alert)
        critical_count += 1
      end
    elsif alert["status"].eql? "WARNING"
      split = alert["attempts"].split("/")
      currentAttempt = Integer(split[0])
      maxAttempts = Integer(split[1])
      if (currentAttempt>=maxAttempts)
        warnings_list.push(alert)
        warning_count += 1
      end
    end
  end
  
    status = critical_count > 0 ? "red" : (warning_count > 0 ? "yellow" : "green")

    # nagiosharder may not alert us to a problem querying nagios.
    # If no problems found check that we fetch service status and
    # expect to find more than 0 entries.
    if critical_count == 0 and warning_count == 0
      if nag.service_status.length == 0
        status = "error"
      end
    end
  
    send_event('nagios-' + key.to_s, { criticals: critical_count, warnings: warning_count, status: status })
	send_event('nagios-details-' + key.to_s, { criticals_details: criticals_list, warnings_details: warnings_list })
  end
end
