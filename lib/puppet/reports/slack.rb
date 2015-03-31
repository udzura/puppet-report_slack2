require 'puppet'
require 'puppet/network/http_pool'
require 'uri'
require 'json'

Puppet::Reports.register_report(:slack) do
  def process
    configdir = File.dirname(Puppet.settings[:config])
    configfile = File.join(configdir, 'slack.yaml')
    raise(Puppet::ParseError, "Slack report config file #{configfile} not readable") unless File.file?(configfile)

    @config = YAML.load_file(configfile)

    return if self.status == "unchanged"

    pretxt = "Puppet status: *%s*" % self.status
    message = <<-FORMAT % [self.host, Puppet.settings[:environment]]
```
Hostname    = %s
Environment = %s
```
FORMAT

    if self.status == "changed"
      pretxt = ":congratulations: #{pretxt}"
    else
      pretxt = ":warning: #{pretxt}"
    end

    payload = make_payload(pretxt, message)

    @config["channels"].each do |channel|
      channel.gsub!(/^\\/, '')
      _payload = payload.merge("channel" => channel)
      params = {"payload" => _payload.to_json}
      Net::HTTP.post_form(@config["webhook"], params)
    end
  end

  private
  def make_payload(pretxt, message)
    {
      "username" => (@config["username"] || "puppet"),
      "icon_url" => (@config["icon_url"] || "https://cloud.githubusercontent.com/assets/91011/6860448/96c424a0-d46b-11e4-9131-31a711893171.png"),
      "attachments" => [{
          "pretext" => pretxt,
          "text"    => message,
          "mrkdwn_in" => [:text, :pretext],
        }],
    }
  end
end
