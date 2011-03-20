% elixir: cache

object ExBridge::Misultin::Request
  proto ExBridge::Request

  def respond(status, headers, body)
    response = [ status, convert_headers(headers), body.to_bin ]
    Erlang.apply(@request, 'respond, response)
  end

  def serve_file(path, [] := [])
    if @docroot
      Erlang.apply(@request, 'file, [File.expand_path(path, @docroot).to_bin])
    else
      self.error { 'nodocroot, "Cannot send file without docroot" }
    end
  end

  def serve_file(_path, _headers)
    self.error { 'notsupported, "Sending headers while serving file not supported by misultin" }
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_char_list, value.to_char_list}
  end
end