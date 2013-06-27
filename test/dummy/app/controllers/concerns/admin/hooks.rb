require 'active_support/concern'

module Admin
  module Hooks

    extend ActiveSupport::Concern

    included do
      before_filter :switch_label_2
    end

    def switch_label_2
      logger.info "%" * 72
      logger.info "%" * 72
      logger.info "%" * 72
      logger.info "%" * 72
      logger.info "%" * 72
    end

  end
end
