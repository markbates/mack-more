module Mack
  module Mailer
    class Attachment
      
      attr_accessor :body
      attr_accessor :content_type
      
      def initialize(body = nil)
        unless body.nil?
          self.add_file(body) if body.is_a?(String)
          self.add_io(body) if body.is_a?(IO)
        end
      end
      
      def add_io(io, content_type = nil)
        
      end
      
      def add_file(file, content_type = File.extname(file).gsub('.', ''))
        self.body = File.read(file)
        self.content_type = Mack::Utils::MimeTypes[content_type]
      end
      
    end # Attachment
  end # Mailer
end # Mack