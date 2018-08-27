# Simple Data Fetcher
**This simple ruby app gets the total count of invoices from a service**
- The service should return 3 options
    - An HTTP status 200 and an amount of invoices if
    - An HTTP status 200 and a message warning indicating the amount is too big.
    - An HTTP status 400 and a messsage warning.
    
The application will print in your console the total amount of invoices found and the number of calls required to fetch them.
## Downloading the project
```
    git clone git@github.com:erickueen/SimpleFetchApp.git
    cd SimpleFetchApp
    bundle
    ./bin/simplefetcher -h
```
## Running the application
Ensure that the bin directory files have executable permissions
```
./bin/simplefetcher -start '2017-01-01' -finish '2017-12-31' -id '1f1bcc03-5fa9-4e73-a150-79a569f912d9'
```
## Running tests

```
./bin/rspec
```