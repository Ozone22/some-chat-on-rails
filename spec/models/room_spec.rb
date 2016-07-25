require 'rails_helper'

describe Room do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:recipient) { FactoryGirl.create(:confirmed_user) }
  let(:another_recipient) { FactoryGirl.create(:confirmed_user) }

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

  describe 'create with users' do
    before { @another_room = user.begin_conference(name: 'friend-chat', users: [another_recipient]) }

    specify { expect(another_recipient.rooms).to include(@another_room) }
    specify { expect(user.rooms).to include(@another_room) }
    specify { expect(@another_room.users).to include(user) }
    specify { expect(@another_room.users).to include(another_recipient) }
  end

  describe 'when user join to the chat' do

    it 'should increase chat users by 1' do
      expect { subject.add_interlocutor(recipient) }.to change { subject.users.count }.by(1)
    end
  end

end

