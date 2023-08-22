using TidierData
using TidierDates

# ## `mdy()`, `dmy()`, `ymd()`
# These functions parse dates represented as strings into a DateTime format in Julia. The input should be a string month-day-year, day-month-year, or year-month-day format respectively. They are relatively robust in their ability to take non-uniform strings of dates with year in yyyy format

df = DataFrame(date = ["today is the 4th July, 2000", 
                        "ayer fue 13th Oct 2001", 
                        "3 of Mar, 2002 was a fun day", 
                        "23rd Apr 2003", 
                        "7/23/2043", 
                        "03/2/1932", 
                        "08-23-1932", 
                        "4th of July, 2005", 
                        "08092019" , 
                        missing])

@chain df begin
    @mutate(date = dmy(date))
end

# ## `mdy_hms()`, `dmy_hms()`, `ymd_hms()`
# Similar to the previous group, these functions parse date-time strings in month-day-year, day-month-year, or year-month-day format respectively. The input should include both date and time information.

# ##  `round_date()`, `floor_date()`
#`floor_date()`: This function rounds a date down to the nearest specified unit (e.g., hour, minute, day, month, year). It takes two arguments - a Date or DateTime object and a string indicating the unit of time to which the date should be floored.
#`round_date()`: This function rounds a date to the nearest specified unit (e.g., hour, minute, month, year). Like 


df2 = DataFrame(date = ["20190330120141", "2008-04-05 16-23-07", "2010.06.07 19:45:00", 
                        "2011-2-8 14-3-7", "2012-3, 9 09:2, 37", "201305-15 0302-09",
                        "2013 arbitrary 2 non-decimal 7 chars 13 in between 2 !!! 7", 
                        "OR collapsed formats: 20140618 181608 (as long as prefixed with zeros)",
                         missing ]) 

@chain df2 begin
    @mutate(date = ymd_hms(date))
    @mutate(floor_byhr = floor_date(date, "hour"))
    @mutate(round_bymin = round_date(date, "minute"))
    @mutate(rounded_bymo = round_date(date, "month"))
end

# ## `difftime()`
# This function computes the difference between two DateTime or Date objects. It returns the result in the unit specified by the second argument, which can be "seconds", "minutes", "hours", "days", or "weeks". It returns this value as a float.

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

# After a string is converted into a datetime format, Date.jl functions such as hour(), year(), etc can be applied in Tidier chains as well.

@chain times begin
    @mutate(start_time = mdy_hms(start_time))
    @mutate(end_time = mdy_hms(end_time))
    @mutate(timedifmins = difftime(end_time, start_time, "minutes"))
    @mutate(timedifmins = difftime(end_time, start_time, "hours"))
    @mutate(year= year(start_time))
    @mutate(second = second(start_time))
end

# ## `hms()` 
# This function parses time strings (e.g., "12:34:56") into a Time format in Julia. It takes a string or an array of strings with the time information and doesn't require additional arguments.

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
    @filter(!ismissing(Time))
    @mutate(hour = hour(Time))
end