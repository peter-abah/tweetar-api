# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  body       :text
#  parent_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
