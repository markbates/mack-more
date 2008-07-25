module Mack
  module Mailer
    # Creates an attachment for a Mack::Mailer object.
    class Attachment
      
      # Returns a String representing the body of the attachment. This String is NOT encoded in anyway!
      attr_accessor :body
      # Returns the name of the attached file.
      attr_accessor :file_name
      
      def initialize(body = nil)
        unless body.nil?
          self.add_file(body) if body.is_a?(String)
          self.add_io(body) if body.is_a?(IO)
          self.add_uploaded_file(body) if body.is_a?(Mack::Request::UploadedFile)
        end
      end
      
      # Takes an IO object and sets the body. You'll need to explicity set the file_name afterwards.
      def add_io(io)
        self.body = io.read
      end
      
      # Takes a path to a file, reads it in, and sets the file_name based on the path.
      def add_file(file)
        self.file_name = File.basename(file)
        self.body = File.read(file)
      end
      
      # Takes a Mack::Request::UploadedFile file object, reads it in, and sets the file name.
      def add_uploaded_file(file)
        self.body = File.read(file.temp_file.path)
        self.file_name = file.file_name
      end
      
    end # Attachment
  end # Mailer
end # Mack