# frozen_string_literal: true

require 'bp3-request_state'

RSpec.describe Bp3::Activeadmin do
  it 'has a version number' do
    expect(Bp3::Activeadmin::VERSION).not_to be_nil
  end

  describe 'configuration' do
    it 'stores request state class' do
      described_class.global_request_state_class_name = 'Bp3::RequestState'
      described_class.global_request_state_method = :current_user
      expect(described_class.global_request_state_class).to eq(Bp3::RequestState)
      expect(described_class.global_request_state_method).to eq(:current_user)
    end
  end
end
