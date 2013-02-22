if Rails.env.production?
  BedAndBreakfast::Application.config.middleware.use(
    ExceptionNotifier,
    :email_prefix => "[MnM] [Exception] ",
    :sender_address => "fguillen.mail@gmail.com",
    :exception_recipients => "fguillen.mail@gmail.com"
  )
end