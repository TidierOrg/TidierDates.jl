# Define your language-specific arrays (these can be defined elsewhere)
english_months = [
    "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", 
    "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
]
english_months_abbr = [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", 
    "AUG", "SEP", "OCT", "NOV", "DEC"
]

spanish_months = [
    "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO",
    "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"
]
spanish_months_abbr = [
    "ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL",
    "AGO", "SEP", "OCT", "NOV", "DIC"
]
days_of_week_spanish = ["LUNES", "MARTES", "MIÉRCOLES", "JUEVES", "VIERNES", "SÁBADO", "DOMINGO"]

french_months = [
    "JANVIER", "FEVRIER", "FÉVRIER", "MARS", "AVRIL", "MAI", "JUIN", 
    "JUILLET", "AOÛT", "AOUT", "SEPTEMBRE", "OCTOBRE", "NOVEMBRE", 
    "DÉCEMBRE", "DECEMBRE"
]
french_months_abbr = [
    "JAN", "FÉV", "MAR", "AVR", "MAI", "JUI", "JUIL",
    "AOÛ", "AOU", "SEP", "OCT", "NOV", "DÉC"
]
days_of_week_french = ["LUNDI", "MARDI", "MERCREDI", "JEUDI", "VENDREDI", "SAMEDI", "DIMANCHE"]

portuguese_months = [
    "JANEIRO", "FEVEREIRO", "MARÇO", "ABRIL", "MAIO", "JUNHO", "JULHO",
    "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO"
]
portuguese_months_abbr = [
    "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL",
    "AGO", "SET", "OUT", "NOV", "DEZ"
]
days_of_week_portuguese = [
    "SEGUNDA-FEIRA", "TERÇA-FEIRA", "QUARTA-FEIRA", 
    "QUINTA-FEIRA", "SEXTA-FEIRA", "SÁBADO", "DOMINGO"
]
english_days_of_week = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
langa = []
# Set up globals (initially default to English)
global full_monthg = english_months
global abbrev_monthsg = english_months_abbr
global days_of_weekg = english_days_of_week
global lang = "english"

function set_lang(lang_str::AbstractString)
    global full_month, abbrev_months, days_of_week, lang
    lang_lower = lowercase(lang_str)
    if lang_lower == "english"
         full_month   = english_months
         abbrev_months = english_months_abbr
         days_of_week =  english_days_of_week
         Dates.LOCALES["english"] = Dates.DateLocale(english_months, english_months, english_months_abbr, [""])
         lang = lang_lower
    elseif lang_lower == "spanish"
         full_month   = spanish_months
         abbrev_months = spanish_months_abbr
         days_of_week = days_of_week_spanish
         Dates.LOCALES["spanish"] = Dates.DateLocale(spanish_months, spanish_months, spanish_months_abbr, [""])
         lang = lang_lower
    elseif lang_lower == "french"
         full_month   = french_months
         abbrev_months = french_months_abbr
         days_of_week = days_of_week_french
         Dates.LOCALES["french"] = Dates.DateLocale(french_months, french_months, french_months_abbr, [""])
         lang = lang_lower
    elseif lang_lower == "portuguese"
         full_month   = portuguese_months
         abbrev_months = portuguese_months_abbr
         days_of_week = days_of_week_portuguese
         Dates.LOCALES["portuguese"] = Dates.DateLocale(portuguese_months, portuguese_months, portuguese_months_abbr, [""])
         lang = lang_lower
    else
         error("Language '$lang_str' not supported")
    end
    return nothing
end

function set_lang(language, full_months_arr::AbstractVector{<:AbstractString}, 
                  abbrev_months_arr::AbstractVector{<:AbstractString}, 
                  days_arr::AbstractVector{<:AbstractString})
    global full_month, abbrev_months, days_of_week, lang
    Dates.LOCALES[language] = Dates.DateLocale(full_months_arr, abbrev_months_arr, days_arr, [""])
    full_month   = full_months_arr
    abbrev_months = abbrev_months_arr
    days_of_week = days_arr
    lang = language
    return nothing
end
export set_lang


#### For fall back functions
full_month_to_num = Dict{String, Int}(
    "JANUARY" => 1, "FEBUARY" => 2, "MARCH" => 3, "APRIL" => 4,
    "MAY" => 5, "JUNE" => 6, "JULY" => 7, "AUGUST" => 8,
    "SEPTEMBER" => 9, "OCTOBER" => 10, "NOVEMBER" => 11, "DECEMBER" => 12, 
    #spanish
    "ENERO" => 1, "FEBRERO" => 2, "MARZO" => 3, "ABRIL" => 4,
    "MAYO" => 5, "JUNIO" => 6, "JULIO" => 7, "AGOSTO" => 8,
    "SEPTIEMBRE" => 9, "OCTUBRE" => 10, "NOVIEMBRE" => 11, "DICIEMBRE" => 12,
    #french
    "JANVIER" => 1, "FEVRIER" => 2, "FÉVRIER" => 2, "MARS" => 3, "AVRIL" => 4,
    "MAI" => 5, "JUIN" => 6, "JUILLET" => 7, "AOÛT" => 8, "AOUT" => 8,
    "SEPTEMBRE" => 9, "OCTOBRE" => 10, "NOVEMBRE" => 11, "DÉCEMBRE" => 12, "DECEMBRE" => 12,
    #portugues
    "JANEIRO" => 1, "FEVEREIRO" => 2, "MARÇO" => 3, "ABRIL" => 4,
    "MAIO" => 5, "JUNHO" => 6, "JULHO" => 7, "AGOSTO" => 8,
    "SETEMBRO" => 9, "OUTUBRO" => 10, "NOVEMBRO" => 11, "DEZEMBRO" => 12

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
    "MAI" => 5, "JUI" => 6, "JUIL" => 7, "AOÛ" => 8, "AOU" => 8,
    "SEP" => 9, "OCT" => 10, "NOV" => 11, "DÉC" => 12,
    #portugues
)

# All full month names across languages
full_month = [
    "JANUARY", "FEBUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", 
    "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER",
    "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO",
    "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE",
    "JANVIER", "FEVRIER", "FÉVRIER", "MARS", "AVRIL", "MAI", "JUIN", 
    "JUILLET", "AOÛT", "AOUT", "SEPTEMBRE", "OCTOBRE", "NOVEMBRE", 
    "DÉCEMBRE", "DECEMBRE",
    "JANEIRO", "FEVEREIRO", "MARÇO", "ABRIL", "MAIO", "JUNHO", "JULHO",
    "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO"
]

# All abbreviated month names across languages
abbrev_months = [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", 
    "AUG", "SEP", "OCT", "NOV", "DEC",
    "ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL",
    "AGO", "SEP", "OCT", "NOV", "DIC",
    "JAN", "FÉV", "MAR", "AVR", "MAI", "JUI", "JUIL",
    "AOÛ", "AOU", "SEP", "OCT", "NOV", "DÉC",
    "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL",
    "AGO", "SET", "OUT", "NOV", "DEZ"
]

