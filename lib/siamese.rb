require "twilio-ruby"
require "siamese/message"

module Siamese
  mattr_accessor(:deliveries) { [] }
  mattr_accessor :account_sid, :auth_token, :from

  class << self
    def method_missing meth, *args, **kwargs, &block
      template = "sms/#{meth}"
      if ApplicationController.new.lookup_context.exists?(template)
        context = args.first
        options = args.second || {}
        Message.new(template, context, options)
      else
        super
      end
    end

    def deliver attributes
      deliveries << attributes
      if Rails.env.production?
        while deliveries.any?
          attributes = deliveries.pop
          client.api.account.messages.create(attributes)
        end
      end
    end

    def client
      @client ||= Twilio::REST::Client.new(account_sid, auth_token)
    end
  end
end

