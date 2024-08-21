"""
$docstring_ymd
"""
function ymd(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF|THE" => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end
    # Try "yyyymmdd" format
    m = match(r"(\d{4})(\d{1,2})(\d{1,2})", date_string)
    if m !== nothing
        year_str, month_str, day_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    # Try "yyyy/mm/dd" and "yyyy-mm-dd" formats
    m = match(r"(\d{4})[/-](\d{1,2})[/-](\d{1,2})", date_string)
    if m !== nothing
        year_str, month_str, day_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

        # Try "Year Month Day" format
    m = match(r"(\d{4})\s*(\w+)\s*(\d{1,2})(st|nd|rd|th)?", date_string)
    if m !== nothing
        year_str, month_str, day_str, _ = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    return nothing
end

"""
$docstring_ymd_hms
"""
function ymd_hms(datetime_string::Union{AbstractString, Missing})
    # If input is missing, return missing
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end
    # Extract year, month, day, hour, minute, and second using a flexible regular expression
    m = match(r"(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)
    
    if m !== nothing
        year_str, month_str, day_str, hour_str, minute_str, second_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        hour = parse(Int, hour_str)
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string) 
            hour += 12
        end
        minute = parse(Int, minute_str)
        second = parse(Int, second_str)

        # Return as DateTime
        return DateTime(year, month, day, hour, minute, second)
    end

    # If no match found, return missing
    return missing
end

"""
$docstring_ymd_hm
"""
function ymd_hm(datetime_string::Union{AbstractString, Missing})
    # If input is missing, return missing
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end
    
    # Extract year, month, day, hour, and minute using a flexible regular expression
    m = match(r"(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)
    
    if m !== nothing
        year_str, month_str, day_str, hour_str, minute_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        hour = parse(Int, hour_str)
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
            hour += 12
        end
        minute = parse(Int, minute_str)

        # Return as DateTime
        return DateTime(year, month, day, hour, minute)
    end

    # If no match found, return missing
    return missing
end

"""
$docstring_ymd_h
"""
function ymd_h(datetime_string::Union{AbstractString, Missing})
    # If input is missing, return missing
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end
    
    # Extract year, month, day, and hour using a flexible regular expression
    m = match(r"(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)
    
    if m !== nothing
        year_str, month_str, day_str, hour_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
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
