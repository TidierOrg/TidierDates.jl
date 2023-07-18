
const docstring_mdy = 
"""
mdy(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "mmddyyyy", "month day, year", "m/d/y", or "m-d-y") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

# Arguments
date_string::Union{AbstractString, Missing}: The date string to be converted to a Date object.

# Examples
```jldoctest
julia> using Dates

julia> mdy("12032020")
2020-12-03

julia> mdy("December 3, 2020")
2020-12-03

julia> mdy("12/03/2020")
2020-12-03


julia> mdy("12-03-2020")
2020-12-03

julia> mdy(missing)
missing
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
julia> using Dates

julia> dmy("03122020")
2020-12-03

julia> dmy("3 December, 2020")
2020-12-03

julia> dmy("3/12/2020")
2020-03-12

julia> dmy("3-12-2020")
2020-03-12

julia> dmy("3rd of December, 2020")
2020-12-03

julia> dmy(missing)
missing
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
julia> using Dates

julia> ymd("20201203")
2020-12-03

julia> ymd("2020/12/03")
2020-12-03

julia> ymd("2020-12-03")
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
julia> using Dates


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
`unit`: A string specifying the units to use for rounding down. The units can be one of the following: "year", "month", "day", "hour", "minute".

# Returns
The DateTime object rounded down to the nearest specified unit. If the input is missing, the function returns a missing value.

# Examples
```jldoctest
julia> using Dates

julia> dt = DateTime(2023, 6, 15, 9, 45)
2023-06-15T09:45:00

julia> floor_date(dt, "hour")
2023-06-15T09:00:00

julia> floor_date(dt, "day")
2023-06-15T00:00:00

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
`unit`: A string specifying the units to use for rounding. The units can be one of the following: "year", "month", "day", "hour", "minute".

# Returns
The DateTime, Date, or Time object rounded to the nearest specified unit. If the input is missing, the function returns a missing value.

# Examples
```jldoctest
julia> using Dates


julia> dt = DateTime(2023, 6, 15, 9, 45)
2023-06-15T09:45:00

julia> round_date(dt, "hour")
2023-06-15T10:00:00

julia> round_date(dt, "day")
2023-06-15

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
julia> using Dates

julia> ymd_hms("2023-06-15 09:30:00")
2023-06-15T09:30:00

julia> ymd_hms("2023/06/15 09:30:00")
2023-06-15T09:30:00

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
julia> using Dates

julia> mdy_hms("06/15/2023 08:30:15")
2023-06-15T08:30:15

julia> mdy_hms("06.15.2023.08.30.15")
2023-06-15T08:30:15

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
datetime_string: A string (can contain missing values in a DataFrame).

# Returns
A DateTime object converted from the string. If the input is missing or the string format is incorrect, the function returns a missing value.

# Examples
```jldoctest
julia> using Dates

julia> dmy_hms("15-06-2023 09:30:00")
2023-06-15T09:30:00

julia> dmy_hms("15/06/2023 09:30:00")
2023-06-15T09:30:00

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
julia> using Dates

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

