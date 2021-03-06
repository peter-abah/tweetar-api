# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :citext
#  first_name           :string
#  last_name            :string
#  password_digest      :string
#  bio                  :text             default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :citext
#  followers_count      :integer          default("0")
#  followed_users_count :integer          default("0")
#  tweets_count         :integer          default("0")
#  location             :string           default("")
#  website              :string           default("")
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:tweets) }
    it { should have_many(:followers).class_name('User') }
    it { should have_many(:followed_users).class_name('User') }
    it { should have_many(:retweets) }
    it { should have_many(:likes) }
    it { should have_many(:bookmarks) }
    it { should have_many(:bookmarked_tweets).class_name('Tweet') }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    it { should validate_length_of(:username).is_at_least(2) }

    it { should validate_presence_of(:first_name) }

    it { should validate_length_of(:bio).is_at_most(250) }
    it { should validate_length_of(:website).is_at_most(100) }
    it { should validate_length_of(:location).is_at_most(100) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

    context 'should validate correct usernames' do
      it 'validates a correct username (with only letters, numbers and underscores' do
        user = FactoryBot.build(:user, username: 'a_correct__username1_2_3')
        expect(user).to be_valid
      end

      it 'does not allow usernames with periods' do
        user = FactoryBot.build(:user, username: 'incorrect.username')
        expect(user).not_to be_valid
      end

      it 'does not allow usernames with spaces' do
        user = FactoryBot.build(:user, username: 'incorrect username')
        expect(user).not_to be_valid
      end

      it 'does not allow usernames with special characters' do
        user = FactoryBot.build(:user, username: 'incorrect,:;@#$%username')
        expect(user).not_to be_valid
      end
    end
  end

  describe '#name' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns users full name' do
      expected = "#{user.first_name} #{user.last_name}"
      expect(user.name).to eq(expected)
    end
  end
end
