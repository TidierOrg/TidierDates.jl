"""
$docstring_mdy
"""
function mdy(dates_mdy)
    date_string = dates_mdy
     format = ""
     if !ismissing(date_string)
        if occursin(r"^\d{2}[-]\d{2}[-]\d{4}$", date_string)
            format = "mm-dd-yyyy"
        elseif occursin(r"^\d{2}[\/]\d{2}[\/]\d{4}$", date_string)
            format = "mm/dd/yyyy"
        elseif any(occursin(month, uppercase.(date_string)) for month in full_month)
            format = "U dd yyyy"
        elseif any(occursin(month, uppercase(date_string)) for month in abbrev_months)
            format = "u dd yyyy"
        else
            format = "mm/dd/yyyy"
        end
    end
    if lang == "english"
        try
            return Date.(dates_mdy, format)
        catch
            return mdy2.(dates_mdy)
        end
    else
        try
            return Date.(dates_mdy, format, locale = lang)
        catch
            return mdy2.(dates_mdy)
        end
    end
 end

function mdy2(date_string::Union{AbstractString, Missing})

    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"THE|ST|ND|RD|TH|,|OF |THE" => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end
    

    # Add new regex match for "m d yy" or "mm dd yyyy" format
    m = match(r"(\d{1,2})\s+(\d{1,2})\s+(\d{2,4})", date_string)
    if m !== nothing
        month_str, day_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        if length(year_str) == 2
            year = parse(Int, "20" * year_str)  # Assuming 21st century
        else
            year = parse(Int, year_str)
        end
        return Date(year, month, day)
    end

    # Existing regex patterns
    m = match(r"(\d{1,2})(\d{1,2})(\d{4})", date_string)
    if m !== nothing
        month_str, day_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\w+)\s*(\d{1,2})(st|nd|rd|th)?,?\s*(\d{4})", date_string)
    if m !== nothing
        month_str, day_str, _, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        month_str, day_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{2})", date_string)
    if m !== nothing
        month_str, day_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, "20" * year_str)  # Assuming 21st century for two-digit years
        return Date(year, month, day)
    end

    return missing
end





"""
$docstring_mdy_hms
"""
function mdy_hms(dates_mdy)
    # Check if the input is a vector and take the first element
    date_string = dates_mdy
    format = ""
    if !ismissing(date_string)
        if occursin(r"^[a-z]{3,4}\s\d{1,2}\s\d{4}\s\d{2}:\d{2}:\d{2}\s[a-z]{1,2}$", date_string)
            format = "u dd yyyy HH:MM:SS p"
        elseif endswith(date_string, r"[AaPp][Mm]")
            if occursin("-", date_string)
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]", date_string)
                    format = "mm-dd-yyyy HH:MM:SS p"
                else
                    format = "mm-dd-yyyy HH:MM:SSp"
                end
            else
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]", date_string)
                    format = "mm/dd/yyyy HH:MM:SS p"
                else
                    format = "mm/dd/yyyy HH:MM:SSp"
                end
            end
        else
            if occursin("-", date_string)
                format = "mm-dd-yyyy HH:MM:SS"
            else
                format = "mm/dd/yyyy HH:MM:SS"
            end
        end
    end
    if lang == "english"
        try
            return DateTime.(dates_mdy, format)
        catch
            return mdy_hms2.(dates_mdy)
        end
    else
        try
            return DateTime.(dates_mdy, format, locale = lang)
        catch
            return mdy_hms2.(dates_mdy)
        end
    end
end

function mdy_hms2(datetime_string::Union{AbstractString, Missing})

    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract year, month, day, hour, minute, and second using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        month_str, day_str, year_str, hour_str, minute_str, second_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        hour = parse(Int, hour_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        minute = parse(Int, minute_str)
        second = parse(Int, second_str)

    if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
        hour += 12
    end   # Return as DateTime
        return DateTime(year, month, day, hour, minute, second)
    end

    # If no match found, return missing
    return missing
end

"""
$docstring_mdy_hm
"""
function mdy_hm(datetime_string::Union{AbstractString, Missing})
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract month, day, year, hour, and minute using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        month_str, day_str, year_str, hour_str, minute_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
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
    
        else
           return DateTime(year, month, day, hour, minute)
        end
    end

    # If no match found, return missing
    return missing
end



"""
$docstring_mdy_h
"""
function mdy_h(datetime_string::Union{AbstractString, Missing})
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

    # Extract month, day, year, and hour using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        month_str, day_str, year_str, hour_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        hour = parse(Int, hour_str)
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
            hour += 12
        end
        if hour == 24
            return DateTime(year, month, day, 0) + Day(1)
    
        else
           return DateTime(year, month, day, hour)
        end
    end

    # If no match found, return missing
    return missing
end
