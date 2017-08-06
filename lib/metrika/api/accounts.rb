module Metrika
  module Api
    module Accounts
      def get_accounts(params = {})
        self.get(self.accounts_path, params)['accounts']
      end

      def accounts_path
        '/management/v1/accounts'
      end
    end
  end
end