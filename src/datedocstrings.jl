const docstring_mdy = 
"""
mdy(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "mmddyyyy", "month day, year", "m/d/y", or "m-d-y") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

Arguments
date_string::Union{AbstractString, Missing}: The date string to be converted to a Date object.

Examples

println(mdy("12032020"))  # Output: 2020-12-03
println(mdy("December 3, 2020"))  # Output: 2020-12-03
println(mdy("12/03/2020"))  # Output: 2020-12-03
println(mdy("12-03-2020"))  # Output: 2020-12-03
println(mdy(missing))  # Output: missing

Returns
Date or nothing: The function returns a Date object for valid inputs. For unsupported formats or missing values, it returns nothing or missing respectively.
Errors
Does not throw any errors but returns nothing for unsupported formats.
"""

const docstring_dmy = 
"""
dmy(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "ddmmyyyy", "day month, year", "d/m/y", "d-m-y" or "day of month, year") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

Arguments
date_string::Union{AbstractString, Missing}: The date string to be converted to a Date object.
Examples

println(dmy("03122020"))  # Output: 2020-12-03
println(dmy("3 December, 2020"))  # Output: 2020-12-03
println(dmy("3/12/2020"))  # Output: 2020-12-03
println(dmy("3-12-2020"))  # Output: 2020-12-03
println(dmy("3rd of December, 2020"))  # Output: 2020-12-03
println(dmy(missing))  # Output: missing

Returns
Date or nothing: The function returns a Date object for valid inputs. For unsupported formats or missing values, it returns nothing or missing respectively.
Errors
Does not throw any errors but returns nothing for unsupported formats.
"""

const docstring_ymd = 
"""
ymd(date_string::Union{AbstractString, Missing})

Converts a date string in various formats (like "yyyymmdd", "yyyy/mm/dd", "yyyy-mm-dd", or "year month day") to a Julia Date object. The function is able to handle missing values and returns missing for missing inputs.

Arguments
date_string::Union{AbstractString, Missing}: The date string to be converted to a Date object.

Examples

println(ymd("20201203"))  # Output: 2020-12-03
println(ymd("2020/12/03"))  # Output: 2020-12-03
println(ymd("2020-12-03"))  # Output: 2020-12-03
println(ymd("2020 December 3rd"))  # Output: 2020-12-03
println(ymd(missing))  # Output: missing

Returns
Date or nothing: The function returns a Date object for valid inputs. For unsupported formats or missing values, it returns nothing or missing respectively.
Errors
Does not throw any errors but returns nothing for unsupported formats.
"""

const docstring_hms = 
"""
hms(time_string::Union{String, Missing})

Converts a time string in the format "HH:MM:SS" to a Time object. If the input string does not match this format or cannot be converted, an error is thrown.

Arguments
time_string: A string or missing value representing a time. The string should be in the format "HH:MM:SS".
Returns
A Time object representing the input time string.
Examples

julia> hms("12:34:56")
12:34:56

julia> hms("25:00:00")
ERROR: Input string '25:00:00' is not in the expected format (HH:MM:SS)

julia> hms(missing)
missing
"""

const docstring_mdy_hms = 
"""
mdy_hms(datetime_string::Union{AbstractString, Missing})

Parses a datetime string that is expected to contain month, day, year, hour, minute, and second values.

Arguments
datetime_string: A string containing a datetime representation (can contain missing values in a DataFrame).
Returns
A DateTime object constructed from the parsed month, day, year, hour, minute, and second values from the input string, if all can be parsed successfully. Returns a missing value if the input is missing or if the datetime information cannot be parsed from the string.
Examples

julia> mdy_hms("06/15/2023 08:30:15")
2023-06-15T08:30:15

julia> mdy_hms("06.15.2023.08.30.15")
2023-06-15T08:30:15

julia> mdy_hms("06152023083015")
2023-06-15T08:30:15

julia> mdy_hms(missing)
missing
"""

const docstring_difftime = 
"""
difftime(time1::Union{DateTime, Missing}, time2::Union{DateTime, Missing}, units::AbstractString)

Calculate the difference between two times in the specified units.

Arguments
time1: A DateTime object (can contain missing values in a DataFrame).
time2: A DateTime object (can contain missing values in a DataFrame).
units: A string specifying the units to use when calculating the difference between the two times. The units can be one of the following: "seconds", "minutes", "hours", "days", "weeks".
Returns
The difference between the two times in the specified units. If either of the inputs is missing, the function returns a missing value.
Examples
jldoctest

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
"""
