require "spec_helper"

RSpec.describe Sm808 do
  it { expect(Sm808::VERSION).to eq("0.1.0") }

  it { expect(Sm808::InactiveStep::INDICATOR).to eq("0") }
  it { expect(Sm808::ActiveStep::INDICATOR).to eq("X") }
  it { expect(Sm808::InactiveStep.instance).not_to be_active }
  it { expect(Sm808::ActiveStep.instance).to be_active }
end
