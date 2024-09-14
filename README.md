# TidierDates.jl
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/TidierOrg/TidierDates.jl/blob/main/LICENSE)
[![Docs: Latest](https://img.shields.io/badge/Docs-Latest-blue.svg)](https://tidierorg.github.io/TidierDates.jl/dev)
[![Build Status](https://github.com/TidierOrg/TidierStrings.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/TidierOrg/TidierDates.jl/actions/workflows/CI.yml?query=branch%3Amain)
<img src="/docs/src/assets/TidierDates_logo.png" align="right" style="padding-left:10px;" width="150"/>

## What is TidierDates.jl

`TidierDates.jl` is a 100% Julia implementation of the R lubridate package. 

`TidierDates.jl` has one main goal: to implement lubridate's straightforward syntax and of ease of use while working with dates for Julia users. While this package was developed to work seamlessly with `Tidier.jl` functions and macros, it can also work as a independently as a standalone package. This package is powered by Dates.jl.


## Installation

For the development version:

```julia
using Pkg
Pkg.add(url = "https://github.com/TidierOrg/TidierDates.jl.git")
```

## What functions does TidierDates.jl support?

- `ymd()`, `ymd_hms()`, `ymd_h()`, `ymd_hm()`
- `dmy()`, `dmy_hms()`, `dmy_h()`, `dmy_hm()`
- `mdy()`, `mdy_hms()`, `mdy_h()`, `mdy_hm()`
- `floor_date()`
- `round_date()`
- `timediff()`
- `now()`, `today()`
- `am()`, `pm()`
- `leap_year()`
- `days_in_month()`

## Examples

#### `mdy()`, `dmy()`, `ymd()`

These functions parse dates represented as strings into a DateTime format in Julia. The input should be a string month-day-year, day-month-year, or year-month-day format respectively. They are relatively robust in their ability to take non-uniform strings of dates. English, Spanish, Portuguese, and French months and abbreviations are supported.

```julia
using TidierData
using TidierDates

df = DataFrame(date = ["today is the 4th July, 2000", 
                        "ayer fue 13th Oct 2001", 
                        "3 of Mar, 2002 was a fun day", 
                        "23rd Apr 2003", 
                        "23/7/2043", 
                        "03/02/1932", 
                        "23-08-1932", 
                        "4th of July, 2005", 
                        "08092019" , 
                        missing])

@chain df begin
    @mutate(date = dmy(date))
end
```

```
10×1 DataFrame
 Row │ date       
     │ Date?      
─────┼────────────
   1 │ 2000-07-04
   2 │ 2001-10-13
   3 │ 2002-03-03
   4 │ 2003-04-23
   5 │ 2043-07-23
   6 │ 1932-03-02
   7 │ 1932-08-23
   8 │ 2005-07-04
   9 │ 2019-09-08
  10 │ missing 
```

#### `mdy_hms()`, `dmy_hms()`, `ymd_hms()`
Similar to the previous group, these functions parse date-time strings in month-day-year, day-month-year, or year-month-day format respectively. The input should include both date and time information.

#### `round_date()`, `floor_date()`
`floor_date()`: This function rounds a date down to the nearest specified unit (e.g., hour, minute, day, month, year). It takes two arguments - a Date or DateTime object and a string indicating the unit of time to which the date should be floored.
`round_date()`: This function rounds a date to the nearest specified unit (e.g., hour, minute, month, year). Like 

```julia
df2 = DataFrame(date = ["20190330120141", "2008-04-05 16-23-07", "2010.06.07 19:45:00", 
                        "2011-2-8 14-3-7", "2012-3, 9 09:2, 37", "201305-15 0302-09",
                        "2013 arbitrary 2 non-decimal 7 chars 13 in between 2 !!! 7", 
                        "OR collapsed formats: 20140618 181608 (as long as prefixed with zeros)",
                         missing ]) 

@chain df2 begin
    @mutate(date = ymd_hms(date))
    @mutate(floor_byhr = floor_date(date, "week"))
    @mutate(round_bymin = round_date(date, "minute"))
    @mutate(rounded_bymo = round_date(date, "month"))
end
```

```
9×4 DataFrame
 Row │ date                 floor_byhr           round_bymin          rounded_bymo        
     │ DateTime?            DateTime?            DateTime?            DateTime?           
─────┼────────────────────────────────────────────────────────────────────────────────────
   1 │ 2019-03-30T12:01:41  2019-03-24T00:00:00  2019-03-30T12:02:00  2019-04-01T00:00:00
   2 │ 2008-04-05T16:23:07  2008-03-30T00:00:00  2008-04-05T16:23:00  2008-04-01T00:00:00
   3 │ 2010-06-07T19:45:00  2010-06-06T00:00:00  2010-06-07T19:45:00  2010-06-01T00:00:00
   4 │ 2011-02-08T14:03:07  2011-02-06T00:00:00  2011-02-08T14:03:00  2011-02-01T00:00:00
   5 │ 2012-03-09T09:02:37  2012-03-04T00:00:00  2012-03-09T09:03:00  2012-03-01T00:00:00
   6 │ 2013-05-15T03:02:09  2013-05-12T00:00:00  2013-05-15T03:02:00  2013-05-01T00:00:00
   7 │ 2013-02-12T07:13:02  2013-02-10T00:00:00  2013-02-12T07:13:00  2013-02-01T00:00:00
   8 │ 2014-06-18T18:16:08  2014-06-15T00:00:00  2014-06-18T18:16:00  2014-07-01T00:00:00
   9 │ missing              missing              missing              missing                  
```

#### `difftime()`
This function computes the difference between two DateTime or Date objects. It returns the result in the unit specified by the second argument, which can be "seconds", "minutes", "hours", "days", or "weeks". It returns this value as a float.

```julia
times = DataFrame(
    start_time = [
        "06-27-2023 15:20:00",
        "06-26-2023 12:45:15",
        "06-26-2023 16:30:30",
        "06-25-2023 10:11:35",
        "06-24-2023 09:00:24",
        "06-26-2023 09:30:00",
        "06-25-2023 11:00:15",
        "06-24-2023 01:34:45",
        "06-26-2023 14:20:00",
        "06-25-2023 10:45:30"
    ],
    end_time = [
        "06-27-2023 14:53:53",
        "06-25-2023 10:50:30",
        "06-28-2023 16:32:30",
        "06-24-2023 10:20:30",
        "06-24-2023 10:05:00",
         missing,
        "10-25-2023 11:55:13",
        "06-24-2023 11:35:45",
        "07-26-2023 15:15:45",
        "06-24-2023 12:50:15"
    ]
)
```

```
10×2 DataFrame
 Row │ start_time           end_time            
     │ String               String?             
─────┼──────────────────────────────────────────
   1 │ 06-27-2023 15:20:00  06-27-2023 14:53:53
   2 │ 06-26-2023 12:45:15  06-25-2023 10:50:30
   3 │ 06-26-2023 16:30:30  06-28-2023 16:32:30
   4 │ 06-25-2023 10:11:35  06-24-2023 10:20:30
   5 │ 06-24-2023 09:00:24  06-24-2023 10:05:00
   6 │ 06-26-2023 09:30:00  missing             
   7 │ 06-25-2023 11:00:15  10-25-2023 11:55:13
   8 │ 06-24-2023 01:34:45  06-24-2023 11:35:45
   9 │ 06-26-2023 14:20:00  07-26-2023 15:15:45
  10 │ 06-25-2023 10:45:30  06-24-2023 12:50:15
```

#### after a string is converted into a datetime format, Date.jl functions such as hour(), year(), etc can be applied in Tidier chains as well.

```julia
@chain times begin
    @mutate(start_time = mdy_hms(start_time))
    @mutate(end_time = mdy_hms(end_time))
    @mutate(timedifmins = difftime(end_time, start_time, "minutes"))
    @mutate(timedifmins = difftime(end_time, start_time, "hours"))
    @mutate(year= year(start_time))
    @mutate(second = second(start_time))
end
```

```
10×5 DataFrame
 Row │ start_time           end_time             timedifmins     year   second 
     │ DateTime             DateTime?            Float64?        Int64  Int64  
─────┼─────────────────────────────────────────────────────────────────────────
   1 │ 2023-06-27T15:20:00  2023-06-27T14:53:53       -0.435278   2023       0
   2 │ 2023-06-26T12:45:15  2023-06-25T10:50:30      -25.9125     2023      15
   3 │ 2023-06-26T16:30:30  2023-06-28T16:32:30       48.0333     2023      30
   4 │ 2023-06-25T10:11:35  2023-06-24T10:20:30      -23.8514     2023      35
   5 │ 2023-06-24T09:00:24  2023-06-24T10:05:00        1.07667    2023      24
   6 │ 2023-06-26T09:30:00  missing              missing          2023       0
   7 │ 2023-06-25T11:00:15  2023-10-25T11:55:13     2928.92       2023      15
   8 │ 2023-06-24T01:34:45  2023-06-24T11:35:45       10.0167     2023      45
   9 │ 2023-06-26T14:20:00  2023-07-26T15:15:45      720.929      2023       0
  10 │ 2023-06-25T10:45:30  2023-06-24T12:50:15      -21.9208     2023      30
  ```

#### `hms()` 
This function parses time strings (e.g., "12:34:56") into a Time format in Julia. It takes a string or an array of strings with the time information and doesn't require additional arguments.

```julia
df3 = DataFrame(
    Time = [
        "09:00:24",
        "10:11:35",
        "01:34:45",
        "12:45:15",
        "09:30:00",
        "10:45:30",
        "11:00:15",
        "14:20:00",
        "15:10:45",
        missing
    ]
)

@chain df3 begin
    @mutate(Time = hms(Time))
end
```

```
10×1 DataFrame
 Row │ Time     
     │ Time?    
─────┼──────────
   1 │ 09:00:24
   2 │ 10:11:35
   3 │ 01:34:45
   4 │ 12:45:15
   5 │ 09:30:00
   6 │ 10:45:30
   7 │ 11:00:15
   8 │ 14:20:00
   9 │ 15:10:45
  10 │ missing  
```
 