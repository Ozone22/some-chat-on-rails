require 'rails_helper'

describe 'Reset Password' do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  subject { page }

  describe 'create reset password page' do

    before { visit new_reset_password_path }
    let(:submit) { 'Reset password' }

    it { should have_title('Password Reset') }

    describe 'with invalid information(Empty field)' do
      before { click_button submit }

      it { should have_title('Password Reset') }
      it { should have_selector('div.alert.alert-danger') }

      describe 'redirect another page after invalid signin' do
        before { click_link 'About' }

        it { should_not have_selector('div.alert.alert-danger') }
      end

    end

    describe 'with invalid information' do
      before do
        fill_in 'Email', with: 'invalidEmail'
        click_button submit
      end

      it { should have_selector('div.alert.alert-danger') }
    end

    describe 'with valid information' do

      before { fill_in 'Email', with: user.email }

      it 'should send email with instructions' do
        expect{ click_button submit }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      describe 'info block' do
        before { click_button submit }

        it { should have_selector('div.alert.alert-info') }

        describe 'after redirect to another page' do
          before { click_link 'About' }

          it { should_not have_selector('div.alert.alert-info') }
        end
      end

    end

  end

  describe 'new password enter page' do
    let(:submit) { 'Update Password' }

    before do
      user.send_password_reset
      visit new_pass_path(user.password_reset_token)
    end

    it { should have_title('Password Reset') }

    describe "enter empty pass" do
      before { click_button submit }

      it { should have_selector('div.alert.alert-danger') }

    end

    describe "enter invalid pass" do
      let(:invalid_pass) { 'invalidpass1' }
      before do
        fill_in 'Password', with: invalid_pass
        fill_in 'Password confirmation', with: invalid_pass
        click_button submit
      end

      it { should have_selector('div.alert.alert-danger') }

    end

    describe 'enter valid pass' do
      let(:valid_pass) { 'Validpass1' }

      before do
        fill_in 'Password', with: valid_pass
        fill_in 'Password confirmation', with: valid_pass
        click_button submit
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_title('Sign in') }

      describe 'sign in with new pass' do
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: valid_pass
          click_button 'Sign in'
        end

        it { should have_title(user.login) }
      end

    end

  end
end