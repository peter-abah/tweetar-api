# == Schema Information
#
# Table name: tweets
#
#  id             :integer          not null, primary key
#  body           :text
#  parent_id      :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  replies_count  :integer          default("0")
#  retweets_count :integer          default("0")
#  likes_count    :integer          default("0")
#

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Tweet').optional }
    it { should have_many(:replies).class_name('Tweet') }
    it { should have_many(:retweets) }
    it { should have_many(:likes) }
    it { should have_many(:bookmarks) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(1) }
    it { should validate_length_of(:body).is_at_most(250) }
  end
end
