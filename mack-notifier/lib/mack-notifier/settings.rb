config = {
  :mack => {
    :notifier => {
      :sendmail_settings => {
        :location => '/usr/sbin/sendmail',
        :arguments => '-i -t'
      },
      :smtp_settings => {
        :address => 'localhost',
        :port => 25,
        :domain => 'localhost.localdomain'
      },
      :deliver_with => (Mack.env == "test" ? "test" : "smtp"),
      :adapter => 'tmail'
    }
  }
}

configatron.configure_from_hash(config.merge(configatron.to_hash))