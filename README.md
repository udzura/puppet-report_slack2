puppet-report_slack2
--------------------

Yet another slack report processor.

* https://github.com/udzura/puppet-report_slack2
* https://forge.puppetlabs.com/udzura/report_slack2

![screen](./screem.png)

## Install && setup

Run:

```bash
puppet module install udzura-report_slack2
# or use librarian-puppet
```

Create config file `/etc/puppet/slack.yaml` as:

```yaml
--- 
username: "puppet reporter"
webhook: "https://hooks.slack.com/services/YOUR/incoming-web-hook/AddRess!!!"
channels: 
  - "#udzura_dev"
```

Puppet way, like this:

```puppet
$slack = {
  username => "puppet reporter",
  webhook  => "https://hooks.slack.com/services/YOUR/incoming-web-hook/AddRess!!!",
  channels => ["#udzura_dev"]
}

file {
  '/etc/puppet/slack.yaml':
    content => inline_template("<%= YAML.dump(@slack) %>")
}
```

Then set reporter:

```toml
[master]
...

report  = true
reports = store,slack
```

## See also

* https://github.com/lamanotrama/puppet-report-ikachan
* https://github.com/fsalum/puppet-slack

## License

[MIT](./LICENSE).
