require_relative 'advice'

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = {'Content-Type' => 'text/html'}
      response(status, headers) { erb :index }
      
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = '200'
      headers = {'Content-Type' => 'text/html'}
      response(status, headers) { erb :index, message: piece_of_advice }
    else
      status = '404'
      headers = {'Content-Type' => 'text/html'}
      response(status, headers) { erb :not_found }
    end
  end

  private

  def erb(filename, local = {})
    b = binding
    message = local[:message]
    content = File.read("./views/#{filename}.erb")
    ERB.new(content).result(b)
  end
end

def response(status, headers, body='')
  body = yield if block_given?
  [status, headers, body]
end