require 'spec_helper'

describe Ability do

  describe "Admin" do
    let(:admin) { Fabricate :admin }
    it "should be able to manage all" do
      Ability.new(admin).can?(:manage, :all).should be_true
    end
  end

end
