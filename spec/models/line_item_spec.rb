require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:cart).class_name('Cart') }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:product_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
  end
end
