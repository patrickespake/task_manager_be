# frozen_string_literal: true

FactoryBot.define { factory(:access_token, class: 'Doorkeeper::AccessToken') { application } }
