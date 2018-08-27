module MyHelpers

    # Return half of the days of a date range
    def split_dates_in_days(start,finish)
        dif = finish-start
        return dif.to_i/2
    end

    # Returns a new Date if a valid value is given, same date if it's already a date
    # or nil if it can't be parsed.
    def parse_date(date)
        if(date.is_a?Date)
            return date
        end
        date = Date.parse(date)
        rescue ArgumentError
            return nil
        return date        
    end


    def valid_date_range?(start,finish)
        if(start&&finish)
            return start<=finish
        end
        return false
    end

end