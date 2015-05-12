module Kvizovi
  class Error < ArgumentError
    def initialize(id)
      case id
      when Symbol
        @id = id
        super translations.fetch(id)
      when String
        super id
      end
    end

    attr_reader :id

    alias title message

    def status
      400
    end

    private

    def translations
      {}
    end

    class MissingParam < Error
      def initialize(key)
        @id = "param_missing"
        super "Missing param \"#{key}\""
      end
    end

    class Unauthorized < Error
      def status
        401
      end

      private

      def translations
        {
          authorization_missing:        "No authorization credentials given",
          token_missing:                "No authorization token given",
          token_invalid:                "No user with that token",
          credentials_invalid:          "Incorrect email or password",
          confirmation_token_invalid:   "Confirmation token doesn't exist",
          password_reset_token_invalid: "Password reset token doesn't exist",
          email_invalid:                "No user with that email address",
          account_expired:              "Account hasn't been confirmed by email",
        }
      end
    end

    class NotFound < Error
      def status
        404
      end

      private

      def translations
        {
          record_not_found: "Record not found",
        }
      end
    end
  end
end
