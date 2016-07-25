require 'rails_helper'
require 'spec_helper'

describe "UserMailer" do
  let(:user) { FactoryGirl.create(:user) }

  shared_examples_for 'Base Email' do
    let(:base_mail) { UserMailer.email_confirmation(user).deliver_now }

    describe 'tests' do
      it 'renders the receiver email' do
        expect(base_mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(base_mail.from).to eq(['some.chat.rails@gmail.com'])
      end
    end
  end

  describe 'Reset password email' do
    let(:mail) { user.send_password_reset }

    it_behaves_like "Base Email"

    it 'renders the subject' do
      expect(mail.subject).to eq('Password reset on Some_Chat')
    end

    it 'assigns @password_reset_url' do
      expect(mail.body.encoded)
          .to match(edit_reset_password_url(user.password_reset_token))
    end
  end


  describe 'Email confirmation email' do
    let(:mail) { UserMailer.email_confirmation(user).deliver_now }

    it_behaves_like 'Base Email'

    it 'renders the subject' do
      expect(mail.subject).to eq('Email confirmation')
    end

    it 'assigns @login' do
      expect(mail.body.encoded)
          .to match(user.login)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
          .to match(confirm_email_user_url(user.confirm_token))
    end
  end
end
