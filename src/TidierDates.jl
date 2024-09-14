module TidierDates

using Dates, Reexport, TimeZones

@reexport using Dates

include("datedocstrings.jl")

export mdy, mdy_hms, dmy, dmy_hms, ymd, ymd_hms, ymd_h, ymd_hm, 
hms, difftime, floor_date, round_date, now, today, am, pm, leap_year, 
days_in_month, dmy_h, dmy_hm, mdy_h, mdy_hm, hm

#### Create dictionaries to map full and abbreviated month names to numbers
full_month_to_num = Dict{String, Int}(
    "JANUARY" => 1, "FEBUARY" => 2, "MARCH" => 3, "APRIL" => 4,
    "MAY" => 5, "JUNE" => 6, "JULY" => 7, "AUGUST" => 8,
    "SEPTEMBER" => 9, "OCTOBER" => 10, "NOVEMBER" => 11, "DECEMBER" => 12, 
    #spanish
    "ENERO" => 1, "FEBRERO" => 2, "MARZO" => 3, "ABRIL" => 4,
    "MAYO" => 5, "JUNIO" => 6, "JULIO" => 7, "AGOSTO" => 8,
    "SEPTIEMBRE" => 9, "OCTUBRE" => 10, "NOVIEMBRE" => 11, "DICIEMBRE" => 12,
    #french
    "JANVIER" => 1, "FÉVRIER" => 2, "MARS" => 3, "AVRIL" => 4,
    "MAI" => 5, "JUIN" => 6, "JUILLET" => 7, "AOÛT" => 8,
    "SEPTEMBRE" => 9, "OCTOBRE" => 10, "NOVEMBRE" => 11, "DÉCEMBRE" => 12
)

abbreviated_month_to_num = Dict{String, Int}(
    "JAN" => 1, "FEB" => 2, "MAR" => 3, "APR" => 4,
    "MAY" => 5, "JUN" => 6, "JUL" => 7, "AUG" => 8,
    "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12,
    #spanish
    "ENE" => 1, "FEB" => 2, "MAR" => 3, "ABR" => 4,
    "MAY" => 5, "JUN" => 6, "JUL" => 7, "AGO" => 8,
    "SEP" => 9, "OCT" => 10, "NOV" => 11, "DIC" => 12,
    #french
    "JAN" => 1, "FÉV" => 2, "MAR" => 3, "AVR" => 4,
    "MAI" => 5, "JUI" => 6, "JUIL" => 7, "AOÛ" => 8,
    "SEP" => 9, "OCT" => 10, "NOV" => 11, "DÉC" => 12

)

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
            return round(dt, Year)
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
                throw(ArgumentError("Unit must be one of 'year', 'month', 'day', 'hour', 'minute', 'second'."))
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
