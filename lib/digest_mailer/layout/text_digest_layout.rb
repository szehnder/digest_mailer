module DigestMailer
  module Layouts
    class TextDigest
      def self.layout(messages)
        body = ""
        templates.each do |t|
          body += "Email Template [#{t.id}]\r"
        end
        body
      end
    end
  end
end
