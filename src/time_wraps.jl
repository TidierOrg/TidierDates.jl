function hour(time)
    return ismissing(time) ? missing : Dates.hour(time)
end

function minute(time)
    return ismissing(time) ? missing : Dates.minute(time)
end

function second(time)
    return ismissing(time) ? missing : Dates.second(time)
end

function day(time)
    return ismissing(time) ? missing : Dates.day(time)
end

function month(time)
    return ismissing(time) ? missing : Dates.month(time)
end

function year(time)
    return ismissing(time) ? missing : Dates.year(time)
end