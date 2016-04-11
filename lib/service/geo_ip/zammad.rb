# Copyright (C) 2012-2013 Zammad Foundation, http://zammad-foundation.org/

require 'cache'

class Service::GeoIp::Zammad
  def self.location(address)

    # check cache
    cache_key = "zammadgeoip::#{address}"
    cache = Cache.get(cache_key)
    return cache if cache

    # do lookup
    host = 'https://geo.zammad.com'
    url  = "/lookup?ip=#{CGI.escape address}"
    data = {}
    begin
      response = UserAgent.get(
        "#{host}#{url}",
        {},
        {
          json: true,
          open_timeout: 2,
          read_timeout: 4,
          total_timeout: 4,
        },
      )
      if !response.success? && response.code.to_s !~ /^40.$/
        raise "ERROR: #{response.code}/#{response.body}"
      end

      data = response.data

      # compat. map
      if data && data['country_code2']
        data['country_code'] = data['country_code2']
      end

      Cache.write(cache_key, data, { expires_in: 90.days })
    rescue => e
      Rails.logger.error "#{host}#{url}: #{e.inspect}"
      Cache.write(cache_key, data, { expires_in: 60.minutes })
    end
    data
  end
end
