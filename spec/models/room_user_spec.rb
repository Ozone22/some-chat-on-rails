require 'rails_helper'

describe RoomUser do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:room) { Room.create }

  let(:room_user) { room.room_users.build(user_id: user.id) }

  subject { room_user }

  it { should be_valid }

  it { should respond_to(:user) }
  it { should respond_to(:room) }
  specify { expect(subject.user).eql? user}
  specify { expect(subject.room).eql? room }

  describe 'when user is not present' do
    before { subject.user = nil }

    it { should_not be_valid }
  end

  describe 'when room is not present' do
    before { subject.room = nil }

    it { should_not be_valid }
  end
end
