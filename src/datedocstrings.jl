const docstring_mdy =
"""
    mdy(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "mmddyyyy", "month day, year", "m/d/y", or "m-d-y") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

# Arguments
`date_string`::Union{AbstractString, Missing}: The date string to be converted to a Date object.

# Examples
```jldoctest
julia> mdy("12032020")
2020-12-03

julia> mdy("December 3, 2020")
2020-12-03

julia> mdy("12/03/2020")
2020-12-03

julia> mdy("12-03-2020")
2020-12-03

julia> mdy("1 24 2023")
2023-01-24

julia> mdy("01 24 2023")
2023-01-24

julia> mdy(missing)
missing

julia> mdy("FÉVRIER 20 2020") # French
2020-02-20
```
"""

const docstring_dmy =
"""
    dmy(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "ddmmyyyy", "day month, year", "d/m/y", "d-m-y" or "day of month, year") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

# Arguments
`date_string`::Union{AbstractString, Missing}: The date string to be converted to a Date object.

# Examples
```jldoctest
julia> dmy("03122020")
2020-12-03

julia> dmy("3 December, 2020")
2020-12-03

julia> dmy("23/12/2020")
2020-12-23

julia> dmy("3-12-2020")
2020-12-03

julia> dmy("3rd of December, 2020")
2020-12-03

julia> dmy("3rd of December, 2020")
2020-12-03

julia> dmy(missing)
missing

julia> dmy("20 DICIEMBRE 2020") # Spanish
2020-12-20

julia> dmy("21 MARÇO 2014") # Portuguese 
2014-03-21

```
"""

const docstring_ymd =
"""
    ymd(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "yyyymmdd", "yyyy/mm/dd", "yyyy-mm-dd", or "year month day") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

# Arguments
date_string::Union{AbstractString, Missing}: The date string to be converted to a Date object.

# Examples
```jldoctest
julia> ymd("20201203")
2020-12-03

julia> ymd("2020/12/03")
2020-12-03

julia> ymd("2020-12-03")
2020-12-03

julia> ymd("2020 12 03")
2020-12-03

julia> ymd("2020 December 3rd")
2020-12-03

julia> ymd(missing)
missing
```
"""


const docstring_hms =
"""
    hms(time_string::Union{String, Missing})

Converts a time string in the format "HH:MM:SS" to a Time object. If the input string does not match this format or cannot be converted, an error is thrown.

# Arguments
`time_string`: A string or missing value representing a time. The string should be in the format "HH:MM:SS".
Returns A Time object representing the input time string.

# Examples
```jldoctest
julia> hms("12:34:56")
12:34:56

julia> hms(missing)
missing
```
"""

const docstring_floor_date =
"""
    floor_date(dt::Union{DateTime, Missing}, unit::String)

Round down a DateTime object to the nearest specified unit.

# Arguments
`dt`: A DateTime object (can contain missing values in a DataFrame).
`unit`: A string specifying the units to use for rounding down. The units can be one of the following: "year", "quarter", "month", "week", "day", "hour", "minute".

# Returns
The DateTime object rounded down to the nearest specified unit. If the input is missing, the function returns a missing value.

When using the "week" unit, Sunday is considered the first day of the week, and if the date is already a Sunday, it is returned as is.

# Examples
```jldoctest
julia> dt = DateTime(2023, 6, 15, 9, 45)
2023-06-15T09:45:00

julia> floor_date(dt, "hour")
2023-06-15T09:00:00

julia> floor_date(dt, "day")
2023-06-15T00:00:00

julia> floor_date(dt, "week")
2023-06-11T00:00:00

julia> floor_date(dt, "quarter")
2023-04-01T00:00:00

julia> floor_date(missing, "day")
missing
```
"""

const docstring_round_date =
"""
    round_date(dt::Union{DateTime, Date, Time, Missing}, unit::String)

Round a DateTime, Date, or Time object to the nearest specified unit.

# Arguments
`dt`: A DateTime, Date, or Time object (can contain missing values in a DataFrame).
`unit`: A string specifying the units to use for rounding. The units can be one of the following: "year", "quarter", "month", "day", "hour", "minute", "second".

# Returns
The DateTime, Date, or Time object rounded to the nearest specified unit. If the input is missing, the function returns a missing value.

# Examples
```jldoctest
julia> dt = DateTime(2023, 6, 15, 9, 45)
2023-06-15T09:45:00

julia> round_date(dt, "hour")
2023-06-15T10:00:00

julia> round_date(dt, "day")
2023-06-15T00:00:00

julia> round_date(dt, "quarter")
2023-07-01T00:00:00

julia> round_date(missing, "day")
missing
```
"""

const docstring_ymd_hms =
"""
    ymd_hms(datetime_string::Union{AbstractString, Missing})

Convert a string with "Year-Month-Day Hour:Minute:Second" format to a DateTime object.

# Arguments
`datetime_string`: A string (can contain missing values in a DataFrame).

# Returns
A DateTime object converted from the string. If the input is missing or the string format is incorrect, the function returns a missing value.

# Examples

```jldoctest
julia> ymd_hms("2023-06-15 09:30:00")
2023-06-15T09:30:00

julia> ymd_hms("2023/06/15 09:30:00")
2023-06-15T09:30:00

julia> ymd_hms("2023/06/15 09:30:00pm")
2023-06-15T21:30:00

julia> ymd_hms("2023 June 15 09:30:00am")
2023-06-15T09:30:00 

julia> ymd_hms("2023 June 15 09:30:00 P")
2023-06-15T21:30:00

julia> ymd_hms(missing)
missing
```
"""

const docstring_mdy_hms =
"""
    mdy_hms(datetime_string::Union{AbstractString, Missing})

Parses a datetime string that is expected to contain month, day, year, hour, minute, and second values.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed month, day, year, hour, minute, and second values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> mdy_hms("06/15/2023 08:30:15")
2023-06-15T08:30:15

julia> mdy_hms("06.15.2023.08.30.15")
2023-06-15T08:30:15

julia> mdy_hms("06.15.2023.08.30.15 pm")
2023-06-15T20:30:15

julia> mdy_hms("06152023083015")
2023-06-15T08:30:15

julia> mdy_hms(missing)
missing
```
"""

const docstring_dmy_hms =
"""
    dmy_hms(datetime_string::Union{AbstractString, Missing})

Convert a string with "Day-Month-Year Hour:Minute:Second" format to a DateTime object.

# Arguments
`datetime_string`: A string (can contain missing values in a DataFrame).

# Returns
A DateTime object converted from the string. If the input is missing or the string format is incorrect, the function returns a missing value.

# Examples
```jldoctest
julia> dmy_hms("15-06-2023 09:30:00")
2023-06-15T09:30:00

julia> dmy_hms("15/06/2023 09:30:00pm")
2023-06-15T21:30:00

julia> dmy_hms("15 jan 2023 09:30:00 p")
2023-01-15T21:30:00

julia> dmy_hms(missing)
missing
```
"""

const docstring_difftime =
"""
difftime(time1::Union{DateTime, Missing}, time2::Union{DateTime, Missing}, units::AbstractString)

Calculate the difference between two times in the specified units.

# Arguments
`time1`: A DateTime object (can contain missing values in a DataFrame).
`time2`: A DateTime object (can contain missing values in a DataFrame).
`units`: A string specifying the units to use when calculating the difference between the two times. The units can be one of the following: "seconds", "minutes", "hours", "days", "weeks".

# Returns
The difference between the two times in the specified units. If either of the inputs is missing, the function returns a missing value.

# Examples
```jldoctest
julia> time1 = DateTime(2023, 6, 15, 9, 30, 0)
2023-06-15T09:30:00

julia> time2 = DateTime(2023, 6, 15, 8, 30, 0)
2023-06-15T08:30:00

julia> difftime(time1, time2, "hours")
1.0

julia> difftime(time1, time2, "minutes")
60.0

julia> difftime(time1, missing, "hours")
missing
```
"""

const docstring_now =
"""
    now(tzone::AbstractString="")::ZonedDateTime

Get the current date and time in the specified time zone.

# Arguments
`tzone`: A string specifying the time zone to use. If not provided, the default time zone is used.

# Returns
A ZonedDateTime object representing the current date and time in the specified time zone.

"""

const docstring_today =
"""
    today(tzone::AbstractString="")::ZonedDateTime

Get the current date in the specified time zone.

# Arguments
`tzone`: A string specifying the time zone to use. If not provided, the default time zone is used.

# Returns
A ZonedDateTime object representing the current date in the specified time zone.

"""

const docstring_am =
"""
    am(dt::DateTime)::Bool

Checks if the time is in the morning.

# Arguments
`dt`: A DateTime object

# Returns
A boolean indicating whether the time is in the morning.

# Examples
```jldoctest
julia> am(DateTime(2023, 6, 15, 9, 30, 0))
true

julia> am(DateTime(2023, 6, 15, 8, 30, 0))
true
```
"""

const docstring_pm =
"""
    pm(dt::DateTime)::Bool

Checks if the time is in the afternoon.

# Arguments
`dt`: A DateTime object

# Returns
A boolean indicating whether the time is in the afternoon.

# Examples
```jldoctest
julia> pm(DateTime(2023, 6, 15, 9, 30, 0))
false

julia> pm(DateTime(2023, 6, 15, 8, 30, 0))
false
```
"""

const docstring_leap_year =
"""
    leap_year(date::Date)::Bool
    leap_year(date::Int)::Bool

Checks if the year is a leap year.

# Arguments
`date`: A Date object or an integer representing the year.

# Returns
A boolean indicating whether the year is a leap year.

# Examples
```jldoctest
julia> leap_year(Date(2023, 6, 15))
false

julia> leap_year(2020)
true
```
"""

const docstring_days_in_month =
"""
    days_in_month(date::Date)::Int

Returns the number of days in the month.

# Arguments
`date`: A Date object

# Returns
An integer representing the number of days in the month.

# Examples
```jldoctest
julia> days_in_month(Date(2023, 6, 15))
30

julia> days_in_month(Date(2020, 2, 29))
29

julia> days_in_month(Date(2019, 2, 28))
28

julia> days_in_month(Date(2016, 2, 3))
29
```
"""


const docstring_ymd_h =
"""
    ymd_h(datetime_string::Union{AbstractString, Missing})::DateTime

Converts a date and time string in the format "YYYY-MM-DD HH" to a DateTime object. 

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed year, month, day, and hour values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> ymd_h("2023-06-15 09hr")
2023-06-15T09:00:00

julia> ymd_h("2023-06-15 09hr p")
2023-06-15T21:00:00

julia> ymd_h(missing)
missing
```
"""

const docstring_ymd_hm =
"""
    ymd_hm(datetime_string::Union{AbstractString, Missing})::DateTime

Converts a date and time string in the format "YYYY-MM-DD HH:MM" to a DateTime object.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed year, month, day, hour, and minute values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> ymd_hm("2023-06-15 09:30")
2023-06-15T09:30:00

julia> ymd_hm("2023-06-15 09:30p")
2023-06-15T21:30:00

julia> ymd_hm(missing)
missing
```
""" 

const docstring_dmy_h =
"""
    dmy_h(datetime_string::Union{AbstractString, Missing})::DateTime

Converts a date and time string in the format "DD-MM-YYYY HH" to a DateTime object.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed day, month, year, and hour values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.  

# Examples
```jldoctest
julia> dmy_h("01/01/2020 4PM")
2020-01-01T16:00:00

julia> dmy_h("01-01-2020 16hrs")
2020-01-01T16:00:00

julia> dmy_h(missing)
missing
```
""" 

const docstring_dmy_hm =
"""
    dmy_hm(datetime_string::Union{AbstractString, Missing})::DateTime

Converts a date and time string in the format "DD-MM-YYYY HH:MM" to a DateTime object.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed day, month, year, hour, and minute values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> dmy_hm("01/01/2020 4:30PM")
2020-01-01T16:30:00

julia> dmy_hm("01/01/2020 4:30 a")
2020-01-01T04:30:00

julia> dmy_hm(missing)
missing
```
""" 

const docstring_mdy_h =
"""
    mdy_h(datetime_string::Union{AbstractString, Missing})::DateTime    

Converts a date and time string in the format "MM-DD-YYYY HH" to a DateTime object.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed month, day, year, and hour values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> mdy_h("06-15-2023 09hr")
2023-06-15T09:00:00

julia> mdy_h("06-15-2023 09hr pM")
2023-06-15T21:00:00

julia> mdy_h("jan 3 2023 09hr p")
2023-01-03T21:00:00

julia> mdy_h(missing)
missing
```
"""

const docstring_mdy_hm =
"""
    mdy_hm(datetime_string::Union{AbstractString, Missing})::DateTime

Converts a date and time string in the format "MM-DD-YYYY HH:MM" to a DateTime object.

# Arguments
`datetime_string`: A string containing a datetime representation (can contain missing values in a DataFrame).

# Returns
A DateTime object constructed from the parsed month, day, year, and hour values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.

# Examples
```jldoctest
julia> mdy_hm("06-15-2023 09:03 P")
2023-06-15T21:03:00

julia> mdy_hm("june 15 2023 09:03 p")
2023-06-15T21:03:00

julia> mdy_hm("06-15-2023 09:03 ")
2023-06-15T09:03:00

julia> mdy_hm("june 15 2023 09:03 p")
2023-06-15T21:03:00

julia> mdy_hm(missing)
missing
```
"""

const docstring_hm =
"""
    hm(time_string::Union{AbstractString, Missing})::Time

Converts a time string in the format "HH:MM" to a Time object.

# Arguments
`time_string`: A string containing a time representation. 

# Returns
A Time object constructed from the parsed hour and minute values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the time information cannot be parsed from the string.

# Examples
```jldoctest
julia> hm("09:30")
09:30:00

julia> hm("12:60")
missing
```
"""
