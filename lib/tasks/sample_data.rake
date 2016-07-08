namespace :db do
  desc 'Fill with fake data'
  task populate: :environment do
    make_users
    make_relationships
  end

  def make_users
    admin = User.create!(login: 'AdminUser',
                         email: 'adminUser@bk.com',
                         password: '17d3199F',
                         password_confirmation: '17d3199F',
                         email_confirmed: true,
                         admin: true)
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

  def make_relationships
    users = User.all
    user = users.first
    friends = users[2..50]
    friends.each do |friend|
      friend.friends_with!(user)
      user.accept_friendship(friend)
    end
  end


end