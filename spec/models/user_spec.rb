require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'validates the presence of password and password_confirmation' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => nil, :password_confirmation => nil)
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("Password can't be blank")
    end

    it 'validates password and password_confirmation match' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test321")
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("Password confirmation doesn't match Password")
    end

    it 'validates email is unique' do
      @user = User.new(:first_name => "test", :last_name => "2test", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      @user2 = User.new(:first_name => "2test", :last_name => "test", :email => "TEST@TEST.com", :password => "test12", :password_confirmation => "test12")
      expect(@user2).not_to be_valid
      expect(@user2.errors.full_messages[0]).to eq("Email has already been taken")
    end

    it 'validates the presence of firstname' do
      @user = User.new(:first_name => nil, :last_name => "2test", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("First name can't be blank")
    end

    it 'validates the presence of lastname' do
      @user = User.new(:first_name => "2test", :last_name => nil, :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("Last name can't be blank")
    end

    it 'validates the presence of email' do
      @user = User.new(:first_name => "2test", :last_name => "1test", :email => nil, :password => "test123", :password_confirmation => "test123")
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("Email can't be blank")
    end 

    it 'password should have at least 6 characters' do
      @user = User.new(:first_name => "2test", :last_name => "1test", :email => "test@test.COM", :password => "test", :password_confirmation => "test")
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages[0]).to eq("Password is too short (minimum is 6 characters)")
    end 

  describe '.authenticate_with_credentials' do
    it 'should authenticate with credentials' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      expect(User.authenticate_with_credentials(@user.email, @user.password)).to eq(@user)
    end

    it 'should not authenticate with wrong email' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      expect(User.authenticate_with_credentials("test@test1.COM", @user.password)).to be_nil
    end

    it 'should not authenticate with wrong password' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      expect(User.authenticate_with_credentials(@user.email, "test1234")).to be_nil
    end

    it 'should authenticate with wrong case email' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      expect(User.authenticate_with_credentials("test@TEST.COM", @user.password)).to eq(@user)
    end

    it 'should authenticate with extra spaces' do
      @user = User.new(:first_name => "William", :last_name => "li", :email => "test@test.COM", :password => "test123", :password_confirmation => "test123")
      @user.save
      expect(User.authenticate_with_credentials("   test@test.COM   ", @user.password)).to eq(@user)
    end

  end

  end
end