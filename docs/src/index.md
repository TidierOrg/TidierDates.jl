<img src="assets/TidierDates_logo.png" align="left" style="padding-right:10px"; width="150">

## TidierDates.jl

TidierDates.jl is a package dedicated to handling dates and times. It focuses on functionality within the `lubridate` R package. This package was designed to work with `TidierData.jl` but can also work independently.

This package re-exports `Dates.jl`.

In addition, this package includes:

- `ymd()`, `ymd_hms()`
- `dmy()`, `dmy_hms()`
- `mdy()`, `mdy_hms()`
- `floor_date()`
- `round_date()`
- `timediff()`
- `now()`, `today()`
- `am()`, `pm()`
- `leap_year()`
- `days_in_month()`
