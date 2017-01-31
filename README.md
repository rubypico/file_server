# file_server
Browse files via web

## Usage
1. Create `public` directory at documents root
2. Put the files you want to share in `public` directory
3. Run script (Display below message)
```
http://xxx.xxx.xxx.xxx:8000
```
4. Open the URL from other PC or smartphone

## Customize
Can rewrite the script.

```ruby
server = SimpleHttpServer.new({
  :server_ip => "0.0.0.0",
  :port  =>  8000,                                        # port
  :document_root => File.join(Dir.documents, "public"),   # root directory
  # :debug => true,                                       # debug mode
})
```
