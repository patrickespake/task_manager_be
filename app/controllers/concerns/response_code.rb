# frozen_string_literal: true

# The `ResponseCode` module is designed to manage API response codes.
# Instead of returning explicit error messages, this system employs codes
# which communicate the nature of the response or error to the developers
# who are familiar with our system, both on the backend and frontend.
# The main advantage of this approach is to obfuscate the meaning of
# these responses from external parties, especially hackers. By not
# exposing direct error messages, we make it harder for unauthorized
# individuals to deduce the specifics of our API behavior, thereby
# strengthening our API's security.
#
# For instance, instead of sending an explanatory string about an
# authentication error, a specific code (e.g., 'CODE_A5') will be sent.
# While this is meaningful to our internal developers, outsiders would
# find it challenging to interpret, making targeted attacks more difficult.
module ResponseCode
  CODES = {
    authentication: {
      login_success: 'CODE_A1',
      logout_success: 'CODE_A2',
      no_active_session: 'CODE_A3',
      account_deletion_success: 'CODE_A4',
      invalid_email_or_password: 'CODE_A5',
      invalid_client: 'CODE_A6',
      invalid_grant: 'CODE_A7',
      unsupported_grant_type: 'CODE_A8',
      invalid_request: 'CODE_A9',
    },
    general: {
      not_found: 'CODE_A10',
    },
  }.freeze

  public_constant :CODES
end
