module Mack
  module Mailer
    class Attachment
      
      attr_accessor :body
      attr_accessor :content_type
      attr_accessor :file_name
      
      def initialize(body = nil)
        unless body.nil?
          self.add_file(body) if body.is_a?(String)
          self.add_io(body) if body.is_a?(IO)
        end
      end
      
      def add_io(io)
        self.body = io.read
      end
      
      def add_file(file, content_type = File.extname(file).gsub('.', ''))
        self.file_name = File.basename(file)
        self.body = File.read(file)
        self.content_type = Mack::Utils::MimeTypes[content_type]
      end
      
    end # Attachment
  end # Mailer
end # Mack