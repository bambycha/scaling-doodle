require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:line_items).class_name('LineItem') }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end
end
