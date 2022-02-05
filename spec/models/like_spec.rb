require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:tweet_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end
end
