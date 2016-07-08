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

  describe 'authorization' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'non-signedin user - edit page' do
      before { visit edit_user_path(user) }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-warning', text: 'Please') }
    end

    describe 'non-signedin user - update' do
      before { patch user_path(user) }

      specify { expect(response).to redirect_to(signin_path) }
    end

    describe 'non-signed user - index' do
      before { visit users_path }

      it { should have_title('Sign in') }
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:confirmed_user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'tmpUser@tmp.ru', login: 'tmpUser' ) }

      before { sign_in(user) }

      describe 'edit page' do
        before { visit edit_user_path(wrong_user) }

        it { should have_title(user.login) }
        it { should have_selector('div.alert.alert-warning', text: 'Access denied') }
      end

      describe 'update url' do
        before { patch user_path(wrong_user) }

        specify { expect(response).to redirect_to(user_url(user)) }
      end
    end

    describe 'non-signedin friendly redirect' do
      let(:user) { FactoryGirl.create(:confirmed_user) }

      describe 'when attempting to visit a protected page' do
        before { visit edit_user_path(user) }

        it { should have_title('Sign in') }

        describe 'after signing in' do
          before { sign_in user }

          it { should have_title('Edit') }
        end
      end
    end

    describe 'delete redirect' do
      let(:user) { FactoryGirl.create(:confirmed_user) }
      let(:another_user) { FactoryGirl.create(:confirmed_user) }

      before do
        sign_in user
        delete user_path(another_user)
      end

      specify { expect(response).to redirect_to(user_url(user)) }
    end

    describe 'Signed in signin page redirect' do
      let(:user) { FactoryGirl.create(:confirmed_user) }

      before do
        sign_in user
        visit signin_path
      end

      it { should have_title(user.login) }
    end
  end
end