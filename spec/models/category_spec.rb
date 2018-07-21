require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with attributes' do
    category = create(:category)
    expect(category).to be_valid
  end

  context 'Validates' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'Associations' do
    it 'has_many' do
      category = create(:category_with_products)
      expect(category.products.count).to eq(3)
    end
  end
end
