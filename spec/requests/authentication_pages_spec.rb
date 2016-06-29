require 'rails_helper'

describe 'Authentication' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_title('Sign in') }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger') }

      describe 'redirect another page after invalid signin' do
        before { click_link 'About' }

        it { should_not have_selector('div.alert.alert-danger') }
      end

    end

    describe 'sign in without confirmation' do
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in(user) }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-warning', text: 'activate') }
    end

    describe 'sign in with confirmation' do
      let(:user) { FactoryGirl.create(:user, email_confirmed: true) }

      before { sign_in(user) }

      it { should have_title(user.login) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end