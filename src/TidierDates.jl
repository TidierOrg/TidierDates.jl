module TidierDates

using Dates, Reexport, TimeZones
#Unicode

@reexport using Dates

include("datedocstrings.jl")
include("month_dicts.jl")
export mdy, mdy_hms, dmy, dmy_hms, ymd, ymd_hms, ymd_h, ymd_hm, 
hms, difftime, floor_date, round_date, now, today, am, pm, leap_year, 
days_in_month, dmy_h, dmy_hm, mdy_h, mdy_hm, hm


function replace_month_with_number(datetime_string::Union{String, SubString{String}})

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

include("ymds.jl")
include("dmys.jl")
include("mdys.jl")



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
function floor_date(dt::Union{DateTime, Date, Time, Missing}, unit::String)
    if ismissing(dt)
        return missing
    end

    if unit == "year"
        return floor(dt, Year)
    elseif unit == "quarter"
        return floor(dt, Quarter)
    elseif unit == "month"
        return floor(dt, Month)
    elseif unit == "week"
        if dayofweek(dt) != 7
            start_of_week = floor(dt, Week)
            start_of_week -= Day(1)
            return start_of_week
        else
            return dt
        end
    elseif unit == "day"
        return floor(dt, Day)
    elseif unit == "hour"
        return floor(dt, Hour)
    elseif unit == "minute"
        return floor(dt, Minute)
    else
        throw(ArgumentError("Unit must be one of 'year', 'quarter', 'month', 'week', 'day', 'hour', or 'minute'."))
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
            return round(dt, Year)
        elseif unit == "quarter"
            return round(dt, Quarter)
        elseif unit == "month"
            return round(dt, Month)
        elseif unit == "day"
            return round(dt, Day)
        elseif dt isa DateTime
            if unit == "hour"
                return round(dt, Hour)
            elseif unit == "minute"
                return round(dt, Minute)
            elseif unit == "second"
                return round(dt, Second)
            else
                throw(ArgumentError("Unit must be one of 'year', 'quarter', 'month', 'day', 'hour', 'minute', 'second'."))
            end
        else
            throw(ArgumentError("Unit must be one of 'year', 'month', 'day'."))
        end
    elseif dt isa Time
        if unit == "hour"
            return round(dt, Hour)
        elseif unit == "minute"
            return round(dt, Minute)
        elseif unit == "second"
            return round(dt, Second)
        else
            throw(ArgumentError("Unit must be one of 'hour', 'minute', 'second'."))
        end
    else
        throw(ArgumentError("dt must be a DateTime, Date or Time object."))
    end
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


"""
$docstring_hm
"""
function hm(time_string::Union{AbstractString, Missing})
    if ismissing(time_string)
        return missing
    end
    try
        return Time(time_string, "HH:MM")
    catch
       return missing
    end
end

end
