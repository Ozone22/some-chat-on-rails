require 'rails_helper'

describe 'User pages' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  describe 'SignUp page' do

    before { visit signup_path }

    it { should have_title('Sign Up') }

    let(:submit) { 'Create my account' }

    describe 'with invalid information' do

      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end

    end

    describe 'with valid fields' do

      before do
        fill_in 'Login', with: 'User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'foobaR1'
        fill_in 'Confirmation', with: 'foobaR1'
      end

      describe '(invalid avatar)' do

        before { attach_file 'Avatar', Rails.root.join('spec', 'file_upload_test', 'avatar_invalid_test.txt') }

        it 'should not create a user' do
          expect { click_button submit }.not_to change(User, :count)
        end

      end

      describe '(all valid)' do

        before { attach_file 'Avatar', Rails.root.join('spec', 'file_upload_test', 'avatar_valid_test.png') }

        it 'should create a user' do
          expect { click_button submit }.to change(User, :count).by(1)
        end

      end

      describe '(without avatar file)' do

        it 'should create a user' do
          expect { click_button submit }.to change(User, :count).by(1)
        end

      end

      describe 'confirm email' do

        it 'should be sended to user' do
          expect { click_button submit }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      describe 'after saving the user' do
        before { click_button submit }

        it { should have_title('Sign in') }
        it { should have_selector('div.alert.alert-success', text: 'Please confirm your email') }
      end
    end
  end

  describe 'Email confirmation' do

    before { visit confirm_email_user_path(user.confirm_token) }

    it { should have_title('Sign in') }
    it { should have_selector('div.alert.alert-success', text: 'Email confirmed') }

    describe 'after valid sign in' do
      before { sign_in(user) }

      it { should have_link('Sign out') }
      it { should have_title(user.login) }
    end
  end

  describe 'Confirmed user' do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    before { sign_in(user) }

    describe 'Show page' do
      before do
        visit user_path(user)
      end

      it { should have_title(user.login) }
    end

    describe 'Edit page' do
      before { visit edit_user_path(user) }

      it { should have_title('Edit') }

      describe 'with invalid information' do
        before { click_button 'Submit' }

        it { should have_selector('div.alert.alert-danger') }
      end

      describe 'with valid information' do
        let(:new_login) { 'AwesoneMan1' }
        let(:new_email) { 'validEmail@bk.ru' }
        before do
          fill_in 'Login', with: new_login
          fill_in 'Email', with: new_email
          fill_in 'Password', with: user.password
          fill_in 'Confirmation', with: user.password
          click_button 'Submit'
        end

        specify { expect(user.reload.login).to eq(new_login) }
        specify { expect(user.reload.email).to eq(new_email.downcase) }

      end
    end

    describe 'index' do
      before { visit users_path }

      it { should have_title('Users') }

      describe 'pagination' do
        before(:all) { 20.times { FactoryGirl.create(:confirmed_user) } }
        after(:all) { User.delete_all }

        it { should have_selector('div.pagination') }
      end
    end
  end

  describe 'delete links' do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    before do
      sign_in user
      visit users_path
    end

    it { should_not have_link('delete') }

    describe 'as admin' do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end

      it { should have_link('delete',href: user_path(User.first)) }
      it 'should delete another user by click' do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end

      it { should_not have_link('delete', href: user_path(admin)) }
    end
  end
end