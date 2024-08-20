module TidierDates

using Dates, Reexport, TimeZones

@reexport using Dates

include("datedocstrings.jl")

export mdy, mdy_hms, dmy, dmy_hms, ymd, ymd_hms, hms, difftime, floor_date, round_date, now, today, am, pm, leap_year, days_in_month
### Functions below include:

#### Create dictionaries to map full and abbreviated month names to numbers
full_month_to_num = Dict{String, Int}(
    "JANUARY" => 1, "FEBUARY" => 2, "MARCH" => 3, "APRIL" => 4,
    "MAY" => 5, "JUNE" => 6, "JULY" => 7, "AUGUST" => 8,
    "SEPTEMBER" => 9, "OCTOBER" => 10, "NOVEMBER" => 11, "DECEMBER" => 12
)

abbreviated_month_to_num = Dict{String, Int}(
    "JAN" => 1, "FEB" => 2, "MAR" => 3, "APR" => 4,
    "MAY" => 5, "JUN" => 6, "JUL" => 7, "AUG" => 8,
    "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12
)

function month_to_num(month_str::AbstractString)
    return get(full_month_to_num, month_str, get(abbreviated_month_to_num, month_str, nothing))
end

function replace_month_with_number(datetime_string::String)
    # Replace full month names
    for (month, num) in full_month_to_num
        datetime_string = replace(datetime_string, month => string(num))
    end

    # Replace abbreviated month names
    for (month, num) in abbreviated_month_to_num
        datetime_string = replace(datetime_string, month => string(num))
    end

    return datetime_string
end


"""
$docstring_mdy
"""
function mdy(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF " => ""))
        date_string = replace(date_string, r"\s+" => Base.s" ")
    end
        # Add new regex match for "mmddyyyy" format
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
        month =  parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    # Add new regex match for "m/d/y" and "m-d-y" formats
    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        month_str, day_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    return nothing
end

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
    # Add  regex match for "ddmmyyyy" format
    m = match(r"(\d{1,2})(\d{1,2})(\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\w+)\s*(\d{1,2})(st|nd|rd|th)?,?\s*(\d{4})", date_string)
    if m !== nothing
        try
            return Date(date_string, DateFormat("d m y"))
        catch
            day_str, _, _, month_str, year_str = m.captures
            month_str = parse(Int, month_str)

            day = parse(Int, day_str)
            year = parse(Int, year_str)
            return Date(year, month, day)
        end
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})(ST|nd|rd|th)?\s*(of)?\s*(\w+),?\s*(\d{4})", date_string)
    if m !== nothing
        day_str, _, _, month_str, year_str = m.captures
    
        month = parse(Int, month_str)
        if month === nothing
            return nothing
        end
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    return nothing
end


"""
$docstring_ymd
"""
function ymd(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
    else
        date_string = uppercase(date_string)
        date_string = replace_month_with_number(date_string)
        date_string = strip(replace(date_string, r"ST|ND|RD|TH|,|OF" => ""))
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
$docstring_hms
"""
function hms(time_string::Union{String, Missing})
    if ismissing(time_string)
        return missing
    end

    # Check if the input string matches the expected format
    if !occursin(r"^\d{2}:\d{2}:\d{2}$", time_string)
        error("Input string '$time_string' is not in the expected format (HH:MM:SS)")
    end

    try
        # Attempt to convert the string to a Time object
        return Time(time_string, "H:M:S")
    catch
        # If conversion fails, throw an error
        error("Failed to convert string '$time_string' to a Time object")
    end
end



"""
$docstring_floor_date
"""
function floor_date(dt::Union{DateTime, Missing}, unit::String)
    if ismissing(dt)
        return missing
    end

    if unit == "year"
        return DateTime(year(dt))
    elseif unit == "month"
        return DateTime(year(dt), month(dt))
    elseif unit == "week"
        start_of_week = firstdayofweek(dt) - Day(1)
        return DateTime(year(start_of_week), month(start_of_week), day(start_of_week))
    elseif unit == "day"
        return DateTime(year(dt), month(dt), day(dt))
    elseif unit == "hour"
        return DateTime(year(dt), month(dt), day(dt), hour(dt))
    elseif unit == "minute"
        return DateTime(year(dt), month(dt), day(dt), hour(dt), minute(dt))
    else
        throw(ArgumentError("Unit must be one of 'year', 'month', 'week', 'day', 'hour', or 'minute'."))
    end
end



"""
$docstring_round_date
"""
function round_date(dt::Union{DateTime, Date, Time, Missing}, unit::String)
    if ismissing(dt)
        return missing
    end

    if dt isa DateTime || dt isa Date
        if unit == "year"
            return month(dt) > 6 || (month(dt) == 6 && day(dt) > 15) ? Date(year(dt) + 1) : Date(year(dt))
        elseif unit == "month"
            return day(dt) > 15 ? Date(year(dt), month(dt) % 12 + 1) : Date(year(dt), month(dt))
        elseif unit == "day"
            return Date(year(dt), month(dt), day(dt))
        elseif dt isa DateTime
            if unit == "hour"
                return minute(dt) >= 30 ? DateTime(year(dt), month(dt), day(dt), hour(dt) % 24 + 1) : DateTime(year(dt), month(dt), day(dt), hour(dt))
            elseif unit == "minute"
                return second(dt) >= 30 ? DateTime(year(dt), month(dt), day(dt), hour(dt), minute(dt) % 60 + 1) : DateTime(year(dt), month(dt), day(dt), hour(dt), minute(dt))
            else
                throw(ArgumentError("Unit must be one of 'year', 'month', 'day', 'hour', 'minute'."))
            end
        else
            throw(ArgumentError("Unit must be one of 'year', 'month', 'day'."))
        end
    elseif dt isa Time
        if unit == "hour"
            return minute(dt) >= 30 ? Time(hour(dt) % 24 + 1) : Time(hour(dt))
        elseif unit == "minute"
            return second(dt) >= 30 ? Time(hour(dt), minute(dt) % 60 + 1) : Time(hour(dt), minute(dt))
        else
            throw(ArgumentError("Unit must be one of 'hour', 'minute'."))
        end
    else
        throw(ArgumentError("dt must be a DateTime, Date or Time object."))
    end
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
$docstring_mdy_hms
"""
function mdy_hms(datetime_string::Union{AbstractString, Missing})

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
$docstring_difftime
"""
function difftime(time1::Union{DateTime, Missing}, time2::Union{DateTime, Missing}, units::AbstractString)
       # If input is missing, return missing
    if ismissing(time1) | ismissing(time2)
        return missing
    end

    # Calculate the difference
    diff = time1 - time2

    # Convert the difference to the specified units
    result = nothing
    if units == "seconds"
        result = diff / Second(1)
    elseif units == "minutes"
        result = diff / Minute(1)
    elseif units == "hours"
        result = diff / Hour(1)
    elseif units == "days"
        result = diff / Day(1)
    elseif units == "weeks"
        result = diff / Week(1)
    end

    return result
end

"""
$docstring_now
"""
function now(tzone::AbstractString="")::ZonedDateTime
    if tzone == ""
        return ZonedDateTime(now())
    else
        tz::TimeZone = timezone(tzone)
        return ZonedDateTime(now(tz), tz)
    end
end

"""
$docstring_today
"""
function today(tzone::AbstractString="")::ZonedDateTime
    if tzone == ""
        return Date(now())
    else
        tz::TimeZone = timezone(tzone)
        return Date(ZonedDateTime(now(tz), tz))
    end
end

"""
$docstring_am
"""
function am(dt::DateTime)::Bool
    if ismissing(dt)
        return missing
    end

    return hour(dt) < 12
end

"""
$docstring_pm
"""
function pm(dt::DateTime)::Bool
    if ismissing(dt)
        return missing
    end

    return hour(dt) >= 12
end

"""
$docstring_leap_year
"""
function leap_year(date::Int)::Bool
    if ismissing(date)
        return missing
    end

    return isleapyear(date)
end

function leap_year(date::Date)::Bool
    if ismissing(date)
        return missing
    end

    return isleapyear(year(date))
end

"""
$docstring_days_in_month
"""
function days_in_month(dt::TimeType)::Int
    if ismissing(dt)
        return missing
    end

    return daysinmonth(dt)
end

end
