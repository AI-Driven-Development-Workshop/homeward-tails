require "rails_helper"

RSpec.describe Organizations::UserRolesPolicy, type: :policy do
  let(:account) { create(:super_admin) }
  let(:policy) { Organizations::UserRolesPolicy.new(account, user: user) }

  describe "#change_role?" do
    subject { policy.apply(:change_role?) }

    context "when user is nil" do
      let(:user) { nil }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when user is adopter" do
      let(:user) { create(:adopter) }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when user is fosterer" do
      let(:user) { create(:fosterer) }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when user is staff" do
      let(:user) { create(:admin) }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when user is staff admin" do
      let(:user) { create(:super_admin) }

      context "when account belongs to a different organization" do
        before do
          ActsAsTenant.with_tenant(create(:organization)) do
            account = create(:admin)
          end
        end

        it "returns false" do
          expect(subject).to eq(false)
        end
      end

      context "when account belongs to user's organization" do
        it "returns true" do
          expect(subject).to eq(true)
        end
      end

      context "when account is the user" do
        before do
          account = user
        end

        it "returns false" do
          expect(subject).to eq(false)
        end
      end
    end
  end
end