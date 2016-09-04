class report_slack2 (
  $username   = undef,
  $webhook    = undef,
  $channels   = [],
  $report_url = undef,
) {

  $slack_puppet_confdir = $::puppet_confdir

  $slack = {
    username    => $username,
    webhook     => $webhook,
    channels    => $channels,
    report_url  => $report_url
  }

  file { "${slack_puppet_confdir}/slack.yaml":
    content     => inline_template('<%= YAML.dump(@slack) %>')
  }

  ini_subsetting { 'puppet.conf/reports/slack':
    ensure                => present,
    path                  => "${slack_puppet_confdir}/puppet.conf",
    section               => 'master',
    setting               => 'reports',
    subsetting            => 'slack',
    subsetting_separator  => ',',
    require               => File [ "${slack_puppet_confdir}/slack.yaml"],
  }
}
