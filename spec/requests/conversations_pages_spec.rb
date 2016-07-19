require 'rails_helper'

describe 'Conversation pages' do

  subject { page }

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:recipient) { FactoryGirl.create(:confirmed_user) }
  let(:conversation) { user.begin_conversation(recipient.id) }

  before do
    sign_in user
    user.begin_conversation(recipient.id)
  end

  specify { expect(user.conversations).to include(conversation) }

  describe 'Index page' do
    before { visit conversations_path }

    it { should have_title('Messages') }
    it { should have_link(recipient.login, href: user_path(recipient)) }
    it { should have_link('No messages yet', href: conversation_path(conversation)) }

    describe 'when message exist' do
      before do
        conversation.messages.create!(sender: user, text: 'Hello')
        visit conversations_path
      end

      it { should have_link('Hello', href: conversation_path(conversation)) }
    end

    describe 'create room button' do
      before { visit conversations_path }

      it { should have_link('Create room') }

      describe 'room creating modal' do
        before do
          click_link 'Create room'
          fill_in 'Chat name', with: 'test-room'
          click_button 'Begin conversation'
        end

        it { should have_content('No messages yet') }
      end
    end
  end



  describe 'User page' do
    before do
      user.friends_with!(recipient)
      recipient.accept_friendship(user)
      visit user_path(recipient)
    end

    it { should have_button('Begin conversation') }

    describe 'Begin conversation' do
      before { click_button 'Begin conversation' }

      it { should have_title 'Messages' }

      describe 'Send message' do
        before do
          fill_in 'message_text', with: 'How are you?'
          click_button 'Send'
        end

        it { should have_content('How are you') }
      end
    end
  end
end