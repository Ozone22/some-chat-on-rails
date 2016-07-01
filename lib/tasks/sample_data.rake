namespace :db do
  desc 'Fill with fake data'
  task populate: :environment do
    User.create!(login: 'tmpUser',
                email: 'example@tmpEmail.org',
                password: 'foobarD1',
                password_confirmation: 'foobarD1',
                email_confirmed: true )
    99.times do |n|
      login = "tmpUser#{n}"
      email = "example#{n}@tmpEmail.org"
      password = 'passworD1'
      password_confirmation = password
      User.create!(login: login,
                   email: email,
                   password: password,
                   password_confirmation: password_confirmation,
                   email_confirmed: true )
    end
  end
end