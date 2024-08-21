"""
$docstring_dmy
"""
function dmy(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF|THE" => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end
    
    # Match for "ddmmyyyy" format
    m = match(r"(\d{1,2})(\d{1,2})(\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    # Match for "dd Month yyyy" format
    m = match(r"(\d{1,2}) (\d{1,2}) (\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    # Match for "Month dd, yyyy" format
    m = match(r"(\d{1,2})(ST|ND|RD|TH)?\s*(\w+)\s*(\d{4})", date_string)
    if m !== nothing
        day_str, _, month_str, year_str = m.captures
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        month = tryparse(Int, month_str)
        if month === nothing
            return missing
        end
        return Date(year, month, day)
    end

    # Match for "dd-mm-yyyy" or "dd/mm/yyyy" format
    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    return missing
end


"""
$docstring_dmy_hms
"""
function dmy_hms(datetime_string::Union{AbstractString, Missing})

    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract day, month, year, hour, minute, and second using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        day_str, month_str, year_str, hour_str, minute_str, second_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
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
