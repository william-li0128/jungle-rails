require "rails_helper"

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it "validate the presence of name" do
      @categories = Category.new(:name => "Evergreens")
      @product = Product.new(:name => nil, :price => 1000, :quantity => 2, :category => @categories)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages[0]).to eq("Name can't be blank")
    end

    it "validate the presence of price_cents and price " do
      @categories = Category.new(:name => "Evergreens")
      @product = Product.new(:name => "Almond", :price => nil, :price_cents => nil, :quantity => 4, :category => @categories)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages[0]).to eq("Price cents is not a number")
      expect(@product.errors.full_messages[1]).to eq("Price is not a number")
      expect(@product.errors.full_messages[2]).to eq("Price can't be blank")
    end

    it "validate the presence of quantity" do
      @categories = Category.new(:name => "Evergreens")
      @product = Product.new(:name => "Almond", :price => 1000, :quantity => nil, :category => @categories)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages[0]).to eq("Quantity can't be blank")
    end

    it "validate the presence of quantity" do
      @categories = Category.new(:name => "Evergreens")
      @product = Product.new(:name => "Almond", :price => 1000, :quantity => 2, :category => nil)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages[0]).to eq("Category must exist")
    end

  end
end