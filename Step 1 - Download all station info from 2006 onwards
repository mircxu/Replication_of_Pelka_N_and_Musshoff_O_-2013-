library(rdwd)
library(xlsx)

# Load metaIndex data
data("metaIndex")

# Filter stations with historical monthly climate data
historical_stations <- metaIndex[with(metaIndex, res == "monthly" & var == "kl" & per == "historical"),]

# Check if each station has data from 2006 onwards and hasfile is TRUE
covered_years <- sapply(seq_len(nrow(historical_stations)), function(i) {
  start_year <- as.numeric(substr(historical_stations$von_datum[i], 1, 4))
  end_year <- as.numeric(substr(historical_stations$bis_datum[i], 1, 4))
  has_file <- historical_stations$hasfile[i]
  return(start_year <= 2006 && end_year >= 2006 && has_file)
})

# Filter stations that have data from 2006 onwards and hasfile is TRUE
historical_stations <- historical_stations[covered_years, ]

# Calculate the number of days for each station's data availability
historical_stations$ndays <- as.numeric(historical_stations$bis_datum - historical_stations$von_datum)

# Sort stations based on the number of available days of data
historical_stations <- berryFunctions::sortDF(historical_stations, ndays)

# Convert date columns to character to avoid huxtable error
historical_stations$von_datum <- as.character(historical_stations$von_datum)
historical_stations$bis_datum <- as.character(historical_stations$bis_datum)

# Print the sorted list of stations
print(historical_stations)

# Save the filtered data as an Excel file
write.xlsx(historical_stations, "Historical_Stations_2006_Onwards.xlsx", row.names = FALSE)
