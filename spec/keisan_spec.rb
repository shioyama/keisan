require "spec_helper"

RSpec.describe Keisan do
  it "has a version number" do
    expect(Keisan::VERSION).not_to be nil
    expect(Keisan::VERSION).to eq "0.2.1"
  end
end
