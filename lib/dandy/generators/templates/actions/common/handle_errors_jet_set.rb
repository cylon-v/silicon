class HandleErrors < Dandy::HandleErrors
  def initialize(container, dandy_error, sequel)
    super(container, dandy_error)

    @sequel = sequel
  end

  def call
    @sequel.disconnect

    # implement your own error handling logic here.
    # by default let's print the error to standard output
    puts @dandy_error.message
    puts @dandy_error.backtrace

    # use preferred HTTP status code for different cases
    # i.e. set_http_status(403) for authorization issue
    set_http_status(500)
  end
end