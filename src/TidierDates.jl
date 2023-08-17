module TidierDates
using Dates, Reexport

@reexport using Dates

include("datedocstrings.jl")


export mdy, mdy_hms, dmy, dmy_hms, ymd, ymd_hms, hms, difftime, floor_date, round_date
### Functions below include:
    ### mdy()
    ### mdy_hms()  
    ### dmy()
    ### dmy_hms()
    ### ymd()
    ### ymd_hms() 
    ### hms() 
    ### difftime() (returns answer in seconds, minutes, hours or days)
    ### floor_date() (only supports hour, minute, day, month, year).
    ### round_date() (only supports hour, minute, day (not really viable until YMDHMS exists), month, year).


#### Create dictionaries to map full and abbreviated month names to numbers
full_month_to_num = Dict{String, Int}(
    "January" => 1, "February" => 2, "March" => 3, "April" => 4,
    "May" => 5, "June" => 6, "July" => 7, "August" => 8,
    "September" => 9, "October" => 10, "November" => 11, "December" => 12
)

abbreviated_month_to_num = Dict{String, Int}(
    "Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4,
    "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8,
    "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12
)

function month_to_num(month_str::AbstractString)
    return get(full_month_to_num, month_str, get(abbreviated_month_to_num, month_str, nothing))
end


"""
$docstring_mdy
"""

function mdy(date_string::Union{AbstractString, Missing})
    if ismissing(date_string)
        return missing
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
        month_str = lowercase(month_str)
        month_str = string(uppercase(month_str[1]), month_str[2:end])
        month = month_to_num(month_str)
        if month === nothing
            return nothing
        end
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
        month_str, day_str, _, year_str = m.captures
        month_str = lowercase(month_str)
        month_str = string(uppercase(month_str[1]), month_str[2:end])
        month = month_to_num(month_str)
        if month === nothing
            return nothing
        end
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})[/-](\d{1,2})[/-](\d{4})", date_string)
    if m !== nothing
        day_str, month_str, year_str = m.captures
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        year = parse(Int, year_str)
        return Date(year, month, day)
    end

    m = match(r"(\d{1,2})(st|nd|rd|th)?\s*(of)?\s*(\w+),?\s*(\d{4})", date_string)
    if m !== nothing
        day_str, _, _, month_str, year_str = m.captures
        month_str = lowercase(month_str)
        month_str = string(uppercase(month_str[1]), month_str[2:end])
        month = month_to_num(month_str)
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
        month_str = lowercase(month_str)
        month_str = string(uppercase(month_str[1]), month_str[2:end])
        month = month_to_num(month_str)
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
    elseif unit == "day"
        return DateTime(year(dt), month(dt), day(dt))
    elseif unit == "hour"
        return DateTime(year(dt), month(dt), day(dt), hour(dt))
    elseif unit == "minute"
        return DateTime(year(dt), month(dt), day(dt), hour(dt), minute(dt))
    else
        throw(ArgumentError("Unit must be one of 'year', 'month', 'day', 'hour', or 'minute'."))
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
          # If input is missing, return missing
    if ismissing(time1) | ismissing(time2)
        return missing
    end
   
    # Extract day, month, year, hour, minute, and second using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)

    if m !== nothing
        day_str, month_str, year_str, hour_str, minute_str, second_str = m.captures
        day = parse(Int, day_str)
        month = parse(Int, month_str)
        year = parse(Int, year_str)
        hour = parse(Int, hour_str)
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
    # If input is missing, return missing
    if ismissing(datetime_string)
        return missing
    end

    # Extract year, month, day, hour, minute, and second using a flexible regular expression
    m = match(r"(\d{1,2}).*?(\d{1,2}).*?(\d{4}).*?(\d{1,2}).*?(\d{1,2}).*?(\d{1,2})", datetime_string)
    
    if m !== nothing
        month_str, day_str, year_str, hour_str, minute_str, second_str = m.captures
        year = parse(Int, year_str)
        month = parse(Int, month_str)
        day = parse(Int, day_str)
        hour = parse(Int, hour_str)
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

end 
