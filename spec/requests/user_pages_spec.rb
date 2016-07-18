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

    describe 'Signed in register page redirect' do
      before { visit signup_path }

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
        sign_out user
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

  describe 'not accepted friends pages' do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    let(:another_user) { FactoryGirl.create(:confirmed_user)}
    before do
      FactoryGirl.create(:confirmed_user)
      user.friends_with!(another_user)
      sign_in user
      visit users_path
    end

    after(:all) { User.delete_all }

    it { should have_button('Add to a friends') }
    it 'should add user to pending friends' do
      expect do
        click_button('Add to a friends', match: :first)
      end.to change(user.pending_friends, :count).by(1)
    end

    describe 'friends pending pages' do
      before { visit friends_user_path(id: user.id, status: 'pending') }

      it { should have_link(another_user.login) }
      it { should have_link('Remove') }
    end

    describe 'friends requested pages' do
      before do
        sign_out user
        sign_in another_user
        visit friends_user_path(id: another_user.id, status: 'requested')
      end

      it { should have_link(user.login, href: user_path(user)) }
      it { should have_link('Remove') }
      it 'should add user to accepted friends' do
        expect do
          click_button('Accept', match: :first)
        end.to change(another_user.friends, :count).by(1)
      end
    end
  end

  describe 'accepted friends pages' do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    let(:another_user) { FactoryGirl.create(:confirmed_user) }

    before do
      user.friends_with!(another_user)
      another_user.accept_friendship(user)
      sign_in another_user
      visit friends_user_path(id: another_user.id, status: 'requested')
    end

    it { should_not have_link(user.login, href: user_path(user)) }

    describe 'should contain friends' do
      before { visit friends_user_path(another_user) }

      it { should have_link(user.login, href: user_path(user)) }
      it { should have_button('Send message') }
    end
  end
end