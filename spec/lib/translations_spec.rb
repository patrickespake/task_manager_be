# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'I18n', type: :model do
  it 'translates errors.parameter_missing' do
    expect(I18n.t(
      'errors.parameter_missing',
      param: 'test_param',
    )).to eq('param is missing or the value is empty: test_param')
  end

  it 'translates errors.path_not_found' do
    expect(I18n.t('errors.path_not_found', path: '/test_path')).to eq('/test_path not found')
  end

  it 'translates activerecord.errors.models.user.attributes.password.password_complexity' do
    expected_string = 'Complexity requirement not met. Length should be 8-70 characters ' \
                      'and include: 1 uppercase, 1 lowercase, 1 digit, and 1 special character'
    expect(I18n.t('activerecord.errors.models.user.attributes.password.password_complexity')).to eq(expected_string)
  end
end
