# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResponseCode, type: :module do
  describe 'CODES' do
    context 'authentication' do
      it 'contains correct authentication codes' do
        expect(described_class::CODES[:authentication][:login_success]).to eq('CODE_A1')
        expect(described_class::CODES[:authentication][:logout_success]).to eq('CODE_A2')
        expect(described_class::CODES[:authentication][:no_active_session]).to eq('CODE_A3')
        expect(described_class::CODES[:authentication][:account_deletion_success]).to eq('CODE_A4')
        expect(described_class::CODES[:authentication][:invalid_email_or_password]).to eq('CODE_A5')
        expect(described_class::CODES[:authentication][:invalid_client]).to eq('CODE_A6')
        expect(described_class::CODES[:authentication][:invalid_grant]).to eq('CODE_A7')
        expect(described_class::CODES[:authentication][:unsupported_grant_type]).to eq('CODE_A8')
        expect(described_class::CODES[:authentication][:invalid_request]).to eq('CODE_A9')
      end
    end

    context 'general' do
      it 'contains correct general codes' do
        expect(described_class::CODES[:general][:not_found]).to eq('CODE_A10')
      end
    end
  end
end
