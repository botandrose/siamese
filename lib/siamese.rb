require "twilio-ruby"

class Siamese < Struct.new(:template, :context, :options)
  cattr_accessor(:deliveries) { [] }
  cattr_accessor :account_sid, :auth_token, :from

  def deliver_now
    deliveries << {
      from: options[:from] || from,
      to: options[:to] || context.phone,
      body: options[:body] || render,
    }
    send_deliveries if Rails.env.production?
  end


  def self.method_missing meth, *args, **kwargs, &block
    template = "sms/#{meth}"
    if ApplicationController.new.lookup_context.exists?(template)
      context = args.first
      options = args.second || {}
      new(template, context, options)
    else
      super
    end
  end

  private

  def render
    body = ApplicationController.render({
      template: template,
      locals: { context: context },
      layout: false,
    })
    body.strip
  end

  def send_deliveries
    while deliveries.any?
      attributes = deliveries.pop
      client.api.account.messages.create(attributes)
    end
  end

  def client
    @client ||= Twilio::REST::Client.new(account_sid, auth_token)
  end
end

