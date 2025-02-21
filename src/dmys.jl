"""
$docstring_dmy
"""
function dmy(dates_mdy)
    date_string = dates_mdy
     format = ""
     if !ismissing(date_string)
        if occursin(r"^\d{2}[-]\d{2}[-]\d{4}$", date_string)
            format = "dd-mm-yyyy"
        elseif occursin(r"^\d{2}[\/]\d{2}[\/]\d{4}$", date_string)
            format = "dd/mm/yyyy"        
         elseif any(occursin(month, uppercase(date_string)) for month in full_month)
             format = "dd U yyyy"
         elseif any(occursin(month, uppercase(date_string)) for month in abbrev_months)
             format = "dd u yyyy"
         end
     end
     try
        if lang == "english"
              return Date.(dates_mdy, format)
        else 
            return Date.(dates_mdy, format, locale = lang)
        end
     catch
         return dmy2.(dates_mdy)
     end
 end

function dmy2(date_string::Union{AbstractString, Missing})
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
$docstring_dmy_hms
"""
function dmy_hms(dates_mdy)
    date_string = dates_mdy
    format = ""
    if !ismissing(date_string)
        if occursin(r"^\d{1,2}\s[a-z]{2,4}\s\d{4}\s\d{2}:\d{2}:\d{2}\s[a-z]{1,2}$", date_string)
            format = "dd u yyyy HH:MM:SS p"
        elseif occursin(r"[AaPp][Mm]$", date_string)
            if occursin("-", date_string)
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]$", date_string)
                    format = "dd-mm-yyyy HH:MM:SS p"
                else
                    format = "dd-mm-yyyy HH:MM:SSp"
                end
            else
                if occursin(r"\d{2}:\d{2}:\d{2} [AaPp][Mm]$", date_string)
                    format = "dd/mm/yyyy HH:MM:SS p"
                else
                    format = "dd/mm/yyyy HH:MM:SSp"
                end
            end
        else
            if occursin("-", date_string)
                format = "dd-mm-yyyy HH:MM:SS"
            else
                format = "dd/mm/yyyy HH:MM:SS"
            end
        end        
    end
    if lang == "english"
        try
            return DateTime.(dates_mdy, format)
        catch
            return dmy_hms2.(dates_mdy)
        end
    else
        try
            return DateTime.(dates_mdy, format, locale = lang)
        catch
            return dmy_hms2.(dates_mdy)
        end
    end
end

function dmy_hms2(datetime_string::Union{AbstractString, Missing})
    if ismissing(datetime_string)
        return missing
    else
        datetime_string = uppercase(datetime_string)
        datetime_string = replace_month_with_number(datetime_string)
    end

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



