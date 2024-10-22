require "rails_helper"

RSpec.describe Organization, type: :model do
  describe "associations" do
    it { should have_many(:default_pet_tasks) }
    it { should have_many(:forms).class_name("CustomForm::Form").dependent(:destroy) }
    it { should have_many(:faqs) }
    it { should have_many(:form_answers).dependent(:destroy) }
    it { should have_many(:people) }
    it { should have_one(:form_submission).dependent(:destroy) }
    it { should have_one(:custom_page).dependent(:destroy) }
    it { should have_many(:locations) }
    it { should accept_nested_attributes_for(:locations) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:email) }
    it { should allow_value("valid-slug_123").for(:slug) }
    it { should_not allow_value("invalid/slug!").for(:slug).with_message("only allows letters, numbers, hyphens, and underscores") }
    it { should allow_value("https://something.com").for(:facebook_url) }
    it { should allow_value("").for(:facebook_url) }
    it { should allow_value("https://something.com").for(:instagram_url) }
    it { should allow_value("").for(:instagram_url) }
    it { should allow_value("https://something.com").for(:donation_url) }
    it { should allow_value("").for(:donation_url) }
  end

  describe "callbacks" do
    it "normalizes phone number before saving" do
      organization = FactoryBot.build(:organization, phone_number: "123-456-7890")
      organization.save
      organization.reload
      expect(organization.phone_number).to eq("+11234567890")
    end
  end
end
