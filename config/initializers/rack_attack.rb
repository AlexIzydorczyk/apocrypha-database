# Block suspicious requests for '/etc/password' or wordpress specific paths.
# After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
Rack::Attack.blocklist('fail2ban pentesters') do |req|
  # `filter` returns truthy value if request fails, or if it's from a previously banned IP
  # so the request is blocked
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 20.minutes) do
    # The count for the IP is incremented if the return value is truthy
    CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
    req.path.include?('/etc/passwd') ||
    req.path.include?('wp-admin') ||
    req.path.include?('wp-login') ||
    req.path.include?('wp-content') ||
    req.path.include?('wp-includes') ||
    req.path.include?('_ignition') ||
    req.path.include?('.well-known') ||
    req.path.include?('phpunit') ||
    req.path.include?('dns-query') ||
    req.path.include?('api/v1/device/check') ||
    req.path.include?('wordpress') ||
    req.path.include?('/backup/') ||
    req.path.include?('503.php') ||
    req.path.include?('magento') ||
    req.path.include?('/.env') ||
    req.path.include?('/stream/') ||
    req.path.include?('phpinfo') ||
    req.path.include?('/_profiler/') ||
    req.path.include?('actuator') ||
    req.path.include?('wordpress') ||
    req.path.include?('/sitemap.xml') ||
    req.path.include?('/owa/auth/') ||
    req.path.include?('/webfig/')
  end
end