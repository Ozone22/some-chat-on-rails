require 'rails_helper'

describe Relationship do

  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:friend) { FactoryGirl.create(:confirmed_user) }

  let(:relationship) { user.relationships.build(friend_id: friend.id) }

  subject { relationship }

  it { should be_valid }

  it { should respond_to(:user) }
  it { should respond_to(:friend) }
  specify { expect(subject.user).eql? user}
  specify { expect(subject.friend).eql? friend }
  specify { expect(subject.status).eql? :requested}

  describe 'when user is not present' do
    before { subject.user = nil }

    it { should_not be_valid }
  end

  describe 'when friend is not present' do
    before { subject.friend = nil }

    it { should_not be_valid }
  end

  describe 'when status is not present' do
    before { subject.status = nil }

    it { should_not be_valid }
  end
end
