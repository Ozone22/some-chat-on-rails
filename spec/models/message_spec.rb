require 'rails_helper'

describe Message do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:recipient) { FactoryGirl.create(:confirmed_user) }

  let(:message) do
    conversation = user.conversations.create(recipient_id: recipient.id)
    user.messages.build(text: 'Text', dialog: conversation)
  end

  subject { message }

  it { should be_valid }

  it { should respond_to(:sender) }
  it { should respond_to(:text) }
  it { should respond_to(:dialog_id) }
  it { should respond_to(:dialog_type) }
  it { should respond_to(:is_readed) }
  specify { expect(subject.sender).eql? user }

  describe 'when dialog is not present' do
    before { subject.dialog = nil }

    it { should_not be_valid }
  end

  describe 'when text is not present' do
    before { subject.text = nil }

    it { should_not be_valid }
  end

  describe 'user messages' do
    it 'should not be empty' do
      expect(user.messages).to include(subject)
    end
  end
end
