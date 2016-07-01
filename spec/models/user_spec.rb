require 'rails_helper'

describe User do

  before do

    params = { email: 'testUser@tst.ru', login: 'testUser1',
               unread_message_count: 0, password: 'pasS12', password_confirmation: 'pasS12' }
    @user = User.new(params)

  end

  subject { @user }

  it { should respond_to(:login) }
  it { should respond_to(:email) }
  it { should respond_to(:unread_message_count) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:avatar) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:password_reset_token) }
  it { should respond_to(:password_reset_send_at) }
  it { should respond_to(:confirm_token) }
  it { should respond_to(:email_confirmed) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when login is not present" do

    before { @user.login = ""}
    it { should_not be_valid }

  end

  describe "when login is too short" do

    before { @user.login = "R"}
    it { should_not be_valid }

  end

  describe "when login is too long" do

    before { @user.login = "R" * 61 }
    it { should_not be_valid }

  end

  describe "when email is not present" do

    before { @user.email = " " }
    it { should_not be_valid }

  end

  describe "when email format is invalid" do

    it "should be invalid" do

      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|

        @user.email = invalid_address
        expect(@user).not_to be_valid

      end
    end
  end

  describe "when email format is valid" do

    it "should be valid" do

      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|

        @user.email = valid_address
        expect(@user).to be_valid

      end
    end
  end


  describe "when user with some email already exist" do

    before do
      user_dup = @user.dup
      user_dup.email = @user.email.upcase
      user_dup.save
    end

    it { should_not be_valid }

  end

  describe "when password is not present" do

    before do
      pass = ''
      @user.password = @user.password_confirmation = pass
    end

    it { should_not be_valid }

  end

  describe "when password_confirmation is mismatch" do

    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }

  end

  describe "when password is too short" do

    before do
      pass = 'Dd1'
      @user.password = @user.password_confirmation = pass
    end

    it { should_not be_valid }

  end

  describe "when password not contain digits" do

    before do
      pass = 'passssS'
      @user.password = @user.password_confirmation = pass
    end

    it { should_not be_valid }

  end

  describe "when password not contain capital letters" do

    before do
      pass = 'password2'
      @user.password = @user.password_confirmation = pass
    end

    it { should_not be_valid }

  end

  describe "when password valid" do

    before do
      pass = 'passworD2'
      @user.password = @user.password_confirmation = pass
    end

    it { should be_valid }

  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "remember token" do
    before { @user.save }

    it "should not be blank" do
      expect(:remember_token).not_to be_blank
    end
  end
end