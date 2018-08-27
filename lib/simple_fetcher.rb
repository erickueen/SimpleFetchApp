require_relative 'data_fetcher'
class SimpleFetcher

    # Main method, expects a map with id, start and finish values.
    # Prints the total amount of invoices found of a given range
    def self.run(args)

        return nil if !ARGS[:start] or !ARGS[:finish] or !ARGS[:id]

        fetcher = DataFetcher.new(id: args[:id], host: args[:host])
        total_invoices = fetcher.get_invoice_count(args[:start],args[:finish],0)
        p "Amount of invoices found: #{total_invoices}"
        p "Number of calls: #{fetcher.calls}"
    end

end