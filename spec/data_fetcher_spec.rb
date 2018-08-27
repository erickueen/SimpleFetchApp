require 'rspec'
require 'webmock/rspec'
require_relative '../lib/data_fetcher'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.describe DataFetcher do
    describe '#fetch_by_date_range' do

        it 'returns nil if bad range is provided' do
            fetcher = described_class.new 
            expect(fetcher.fetch_by_date_range('badDate','secondBadDate')).to be_nil
            expect(fetcher.fetch_by_date_range('2017-01-1','2016-01-01')).to be_nil
        end

        it 'fetch from host when valid ranges are provided' do
            fetcher = described_class.new
            expect(fetcher).to receive(:fetch_from_host)
            fetcher.fetch_by_date_range('2017-01-01','2017-01-01')
        end
    end

    describe '#get_invoice_count' do

        it 'returns a number if host respond a valid amount' do
            fetcher = described_class.new(host: 'http://host/')
            stub_request(:get, "http://host/?finish=2017-01-01&id=&start=2017-01-01").
                with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Host'=>'host',
                    'User-Agent'=>'Ruby'
                }).
                to_return(status: 200, body: "10", headers: {})

            response = fetcher.get_invoice_count('2017-01-01','2017-01-01',0)
            expect(response).to be(10)
        end

        it 'returns -1 if host respond a bad request' do
            fetcher = described_class.new(host: 'http://host/')
            stub_request(:get, "http://host/?finish=2017-01-01&id=&start=2017-01-01").
                with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Host'=>'host',
                    'User-Agent'=>'Ruby'
                }).
                to_return(status: 400, body: "Revisa tus parametros", headers: {})
                
            response = fetcher.get_invoice_count('2017-01-01','2017-01-01',0)
            expect(response).to be(-1)
        end

        it 'calls itself with splitted range when host respond a large amount' do
            fetcher = described_class.new(host: 'http://host/')
            stub_request(:get, "http://host/?finish=2017-03-31&id=&start=2017-01-01").
                with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Host'=>'host',
                    'User-Agent'=>'Ruby'
                }).
                to_return(status: 200, body: "Hay mas de 100 resultados", headers: {})
            stub_request(:get, "http://host/?finish=2017-02-15&id=&start=2017-01-01").
                with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Host'=>'host',
                    'User-Agent'=>'Ruby'
                }).
                to_return(status: 200, body: "50", headers: {})
            stub_request(:get, "http://host/?finish=2017-03-31&id=&start=2017-02-16").
                with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Host'=>'host',
                    'User-Agent'=>'Ruby'
                }).
                to_return(status: 200, body: "51", headers: {})

            response = fetcher.get_invoice_count('2017-01-01','2017-03-31',0)
            expect(response).to be(101)
        end
    end
end