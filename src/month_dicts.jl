#### Create dictionaries to map full and abbreviated month names to numbers
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
