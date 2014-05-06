class ApplicationApi < Grape::API
  format :json

  get '/' do
    {greeting: 'hello'}
  end
end
