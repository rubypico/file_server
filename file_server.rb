require 'simplehttpserver'

class FileServer
  attr_reader :server

  def initialize(opt = nil)
    unless opt
      opt = {
        :server_ip => "0.0.0.0",
        :port  =>  8000,
        :document_root => File.join(Dir.documents, "public"),
        # :debug => true,
      }
    end

    @server = SimpleHttpServer.new(opt)

    @server.http do |r|
      @server.set_response_headers({
                                     "Server" => "file_server",
                                     "Date" => @server.http_date,
                                   })
    end

    @server.location "/" do |r|
      path = File.join @server.config[:document_root], r.path

      if File.directory? path
        @server.set_response_headers "Content-type" => "text/html; charset=utf-8"

        files = Dir.entries(path).map do |e|
          "    <li><a href=\"#{File.join r.path, e}\">#{e}</a></li>"
        end

        @server.response_body = <<EOS
<html>
<head>
  <title>#{r.path}</title>
</head>
<body>
  <h1>#{r.path}</h1>
  <ul>
    #{files.join("\n")}
  </ul>
</body>
</html>
EOS

        @server.create_response
      else
        @server.file_response r, path, "text/plain"
      end
    end
  end
  
  def url
    @server.url
  end
  
  def config
    @server.config
  end
  
  def run
    @server.run
  end
  
  def run_with_message
    unless File.exists? @server.config[:document_root]
      puts <<EOS
Not found server directory at "#{@server.config[:document_root]}".

Please create the directory and put the files you want to share.

Or change the :document_root parameter.
EOS
    else
      puts @server.url
      @server.run
    end
  end
end

if __FILE__ == $0
  s = FileServer.new
  s.run_with_message
end
