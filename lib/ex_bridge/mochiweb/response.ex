module ExBridge::Mochiweb::Response
  mixin ExBridge::Response

  % api: private
  def serve_body!(status, headers, body)
    response = { status, convert_headers(headers), body }
    Erlang.apply(@request, 'respond, [response])
    status
  end

  % api: private
  def serve_file!(path, headers := {})
    serve_file_conditionally path, do
      Erlang.apply(@request, 'serve_file, [path.to_char_list, @docroot, convert_headers(headers)])
    end
  end

  private

  def convert_headers(headers)
    headers.to_list
  end
end