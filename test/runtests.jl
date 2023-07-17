module TestTidierDates

using TidierDates
using Test
using Documenter

DocMeta.setdocmeta!(TidierDates, :DocTestSetup, :(using TidierDates); recursive=true)

doctest(TidierDates)

end