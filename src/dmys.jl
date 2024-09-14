"""
$docstring_dmy
"""
function dmy(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF" => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end

    # Add regex match for "ddmmyyyy" format
    m = match(r"(\d{1,2})(\d{1,2})(\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})\s*(\d{1,2})\s*(\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{2})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, "20" * year_str)  # Assuming 21st century for two-digit years
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})(?:ST|ND|RD|TH)?\s+(\d{1,2}|\w+)\s+(\d{2,4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        # Parse month as integer or use month names
        month = parse(Int, replace_month_with_number(month_str))  # Handle month names
        year = parse(Int, year_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        return Date(year, month, day)
    end
    
    m = match(r"(\d{1,2})(ST|ND|RD|TH)?\s*(OF)?\s*(\d{1,2}),?\s*(\d{4})", date_string)
    if m !== nothing
        day_str, _, _, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    return missing
end

"""
$docstring_dmy_h
"""
function dmy_h(datetime_string::Union{AbstractString, Missing})
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract day, month, year, and hour using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        day_str, month_str, year_str, hour_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        hour = parse(Int, hour_str)
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string) 
            hour += 12
        end

        # Return as DateTime
        return DateTime(year, month, day, hour)
    end

    # If no match found, return missing
    return missing
end

"""
$docstring_dmy_hm
"""
function dmy_hm(datetime_string::Union{AbstractString, Missing})
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract day, month, year, hour, and minute using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        day_str, month_str, year_str, hour_str, minute_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        hour = parse(Int, hour_str)
        minute = parse(Int, minute_str)
        if minute == 60
            @warn "Minute is 60, returning missing"
            return missing
        end
        # Handle AM/PM format
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
            hour += 12
        end

        # Handle the case when hour is 24 by incrementing the date and setting time to 00:xx
        if hour == 24
            return DateTime(year, month, day, 0, minute) + Day(1)
        end

        # Return as DateTime
        return DateTime(year, month, day, hour, minute)
    end

    # If no match found, return missing
    return missing
end



