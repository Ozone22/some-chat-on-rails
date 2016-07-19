require 'rails_helper'

describe Room do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:recipient) { FactoryGirl.create(:confirmed_user) }

  let(:room) { user.begin_conference(name: 'test-room') }

  subject { room }

  it { should be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:users) }
  it { should respond_to(:messages) }
  specify { expect(subject.users).to include(user) }
  specify { expect(user.rooms).to include(subject) }

  describe 'when name is not present' do
    before { subject.name = nil }

    it { should be_valid }
  end

  describe 'when user join to the chat' do

    it "should increase chat users by 1" do
      expect { subject.add_interlocutor(recipient) }.to change { subject.users.count }.by(1)
    end
  end

end

