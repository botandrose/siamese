module Siamese
  class Message < Struct.new(:template, :context, :options)
    def deliver_now
      Siamese.deliver({
        from: options[:from] || Siamese.defaults[:from],
        to: options[:to] || context.phone || Siamese.defaults[:to],
        body: options[:body] || render,
      })
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
  end
end

