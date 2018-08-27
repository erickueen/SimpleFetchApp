require 'net/http'
require 'date'
require_relative 'my_helpers'

# This class connects to a service to fetch an ammount of
# invoices between dates and saves the ammount of calls 
# made to the host. The get_invoice_count method allow
# us to fetch recursively if the range is too big
class DataFetcher include MyHelpers
    attr_accessor :host, :id
    attr_reader :calls


    # Configure host if given and the ID to fetch from host.
    # Initialize calls at 0
    def initialize(params = {})
        @host = params.fetch(:host,'http://34.209.24.195/facturas')
        @id = params.fetch(:id,'')
        @calls=0
    end

    # Given a date range, it fetchs an invoice count, if the ammount is too big, it
    # calls itself with a smaller range.
    # Returns the ammount of invoices if there was no errors, -1 if there was
    # a bad request or nil if there was an error.
    # Params: 
    # +start_date+:: Initial date of range
    # +finish_date+:: End date of range
    # +count+:: Previous ammount of invoices
    def get_invoice_count(start_date,finish_date,count)
        start_date = parse_date(start_date)
        finish_date = parse_date(finish_date)

        response = fetch_by_date_range(start_date,finish_date)

        if(response.is_a?Net::HTTPSuccess)
            if(response.body.to_i && response.body.to_i>0)
                return count + response.body.to_i
            else
                half_days = split_dates_in_days(start_date,finish_date)


                half_date = finish_date-half_days
                return get_invoice_count(start_date,half_date,count) + get_invoice_count(half_date+1,finish_date,count)

            end
        elsif(response.is_a?Net::HTTPBadRequest)
            return -1
        else
            return nil
        end

        return response

    end

    # Given a date range, it makes a call to host with the given range and the configured
    # class ID.
    # Params:
    # +start_date+:: Initial date of range
    # +finish_date+:: End date of range
    def fetch_by_date_range(start_date, finish_date)
        
        start_date = parse_date(start_date)
        finish_date = parse_date(finish_date)

        if(!start_date || !finish_date || !valid_date_range?(start_date,finish_date))
            return nil
        end
        params = {id: @id, start: start_date, finish: finish_date}
        fetch_from_host(params)
        
    end

    private

    # It makes a call to the host with the given params and return the response if success or nil if
    # the class URL is invalid.
    def fetch_from_host(params)
        if @host =~ URI::regexp
        
            uri = URI(@host)
            @calls+=1
            uri.query = URI.encode_www_form(params)

            res = Net::HTTP.get_response(uri)
            return res
        else
            return nil
        end
    end

end