require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_length_of(:username).is_at_least(2) }

  it { should validate_presence_of(:first_name) }
  it { should validate_length_of(:first_name).is_at_least(2) }

  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:last_name).is_at_least(2) }

  it { should validate_length_of(:bio).is_at_least(2) }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }
end
