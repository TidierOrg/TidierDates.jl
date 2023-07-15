using TidierDates
using Test

@testset "TidierDates.jl" begin
    println(mdy("12/03/2020"))  # Output: 2020-12-03
    println(mdy("12-03-2020"))  # Output: 2020-12-03
    println(mdy(missing))  # Output: missing
end
