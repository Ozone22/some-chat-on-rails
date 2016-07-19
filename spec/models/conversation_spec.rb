require 'rails_helper'

describe Conversation do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:recipient) { FactoryGirl.create(:confirmed_user) }

  let(:conversation) { user.conversations.build(recipient_id: recipient.id) }

  subject { conversation }

  it { should be_valid }

  it { should respond_to(:sender) }
  it { should respond_to(:recipient) }
  it { should respond_to(:messages) }
  specify { expect(subject.sender).eql? user }
  specify { expect(subject.recipient).eql? recipient }

  describe 'when user is not present' do
    before { subject.sender = nil }

    it { should_not be_valid }
  end

  describe 'when friend is not present' do
    before { subject.recipient = nil }

    it { should_not be_valid }
  end

  describe 'when conversation exist' do
    let(:another_conversation) { Conversation.new(sender_id: subject.recipient.id,
                                                  recipient_id: subject.sender.id) }
    before { subject.save! }
    specify { expect{ another_conversation.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
