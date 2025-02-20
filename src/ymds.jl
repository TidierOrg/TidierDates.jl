"""
$docstring_ymd
"""
function ymd(dates_mdy)
    date_string = dates_mdy
    format = ""
    if !ismissing(date_string)
        if occursin(r"^\d{4}-\d{2}-\d{2}$", date_string)
            format = "yyyy-mm-dd"
        elseif occursin(r"^\d{8}$", date_string)  
            format = "yyyymmdd"
        elseif any(occursin(month, uppercase(date_string)) for month in full_month)
            format = "yyyy U dd"
        elseif any(occursin(month, uppercase(date_string)) for month in abbrev_months)
            format = "yyyy u dd"
        else
            format = "yyyy/mm/dd"
        end
    end
    if lang == "english"
        try
            return Date.(dates_mdy, format)
        catch
            return ymd2.(dates_mdy)
        end
    else
        try
            return Date.(dates_mdy, format, locale = lang)
        catch
            return ymd2.(dates_mdy)
        end
    end
end

function ymd2(date_string::Union{AbstractString, Missing})

    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF|THE" => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end

    # Try "yyyymmdd" or "yymmdd" format
    m = match(r"^(\d{2,4})(\d{1,2})(\d{1,2})$", date_string)
    if m !== nothing
        year_str, month_str, day_str = m.captures
        year = parse(Int, year_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    # Try "yyyy/mm/dd", "yyyy-mm-dd", "yy/mm/dd", or "yy-mm-dd" formats
    m = match(r"^(\d{2,4})[/-](\d{1,2})[/-](\d{1,2})$", date_string)
    if m !== nothing
        year_str, month_str, day_str = m.captures
        year = parse(Int, year_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    # Try "Year Month Day" format (month can be a number or word)
    m = match(r"^(\d{2,4})\s+(\w+)\s+(\d{1,2})(st|nd|rd|th)?$", date_string)
    if m !== nothing
        year_str, month_str, day_str, _ = m.captures
        year = parse(Int, year_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        month = tryparse(Int, month_str)
        if month === nothing
            month = parse(Int, replace_month_with_number(month_str))
        end
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    # Try "yyyy mm dd" or "yy mm dd" format
    m = match(r"^(\d{2,4})\s+(\d{1,2})\s+(\d{1,2})$", date_string)
    if m !== nothing
        year_str, month_str, day_str = m.captures
        year = parse(Int, year_str)
        if length(year_str) == 2
            if year > 30
                year += 1900
            else
            year += 2000
            end
        end
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        return Date(year, month, day)
    end

    return missing
end


"""
$docstring_ymd_hms
"""
function ymd_hms(dates_mdy)
    date_string = dates_mdy
    format = ""
    if !ismissing(date_string)
        if endswith(date_string, r"[AaPp][Mm]")
            if occursin("-", date_string)
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]", date_string)
                    format = "yyyy-mm-dd HH:MM:SS p"
                else
                    format = "yyyy-mm-dd HH:MM:SSp"
                end
            else
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]", date_string)
                    format = "yyyy/mm/dd HH:MM:SS p"
                else
                    format = "yyyy/mm/dd HH:MM:SSp"
                end
            end
        else
            if occursin("-", date_string)
                format = "yyyy-mm-dd HH:MM:SS"
            else
                format = "yyyy/mm/dd HH:MM:SS"
            end
        end
    end
    if lang == "english"
        try
            return DateTime.(dates_mdy, format)
        catch
            return ymd_hms2.(dates_mdy)
        end
    else
        try
            return DateTime.(dates_mdy, format, locale = lang)
        catch
            return ymd_hms2.(dates_mdy)
        end
    end
end

function ymd_hms2(datetime_string::Union{AbstractString, Missing})
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

        minute = parse(Int, minute_str)
        second = parse(Int, second_str)
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
            hour += 12
        end
        if hour == 24
            return DateTime(year, month, day, 0, minute, second) + Day(1)
        else
         return DateTime(year, month, day, hour, minute, second)
        end
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
        minute = parse(Int, minute_str)
        if minute == 60
            @warn "Minute is 60, returning missing"
            return missing
        end
        # Handle AM/PM format
        if hour <= 12 && occursin(r"(?<![A-Za-z])[Pp](?:[Mm])?(?![A-Za-z])", datetime_string)
            hour += 12
        end
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
        if hour == 24
            return DateTime(year, month, day, 0) + Day(1)
        else
          return DateTime(year, month, day, hour)
        end
    end

    # If no match found, return missing
    return missing
end
