# ============================================================
# construct_elev_geodata.R
# Project : BEP — Bilingual Education Policy, Philippines
# Purpose : Extract municipality-level mean elevation from
#           SRTM 30-arc-second data via geodata package
#           (CGIAR-CSI / UC Davis server)
#
# Author  : Takiko Igarashi
# Created : June 2026
#
# Output  : terrain_ruggedness.csv
#   - adm3_psgc : PSA municipality PSGC code (merge key for Stata)
#   - adm3_en   : Municipality name (for verification)
#   - elev_mean : Mean elevation within municipality (metres)
#   - elev_sd   : SD of elevation within municipality (metres)
#
# Data source:
#   SRTM 30-arc-second (~1km resolution) elevation data for the
#   Philippines, accessed via geodata::elevation_30s().
#   Primary source: NASA Shuttle Radar Topography Mission (SRTM),
#   distributed via UC Davis geodata server.
#   Citation: NASA JPL (2013). NASA Shuttle Radar Topography Mission
#   Global 1 arc second. NASA EOSDIS Land Processes DAAC.
#   https://doi.org/10.5067/MEaSUREs/SRTM/SRTMGL1.003
#
# R packages required:
#   install.packages(c("sf", "terra", "exactextractr", "geodata"))
#
# Pipeline:
#   STEP 1 : Load PSA municipality shapefile
#   STEP 2 : Download SRTM elevation via geodata
#   STEP 3 : Extract mean and SD per municipality
#   STEP 4 : Export CSV for Stata merge
#
# Next step in Stata:
#   See construct_elev_control.do (embedded in master do-file §17b)
#   for merge into main analysis dataset via prv_birth x mun_birth.
# ============================================================

library(sf)
library(terra)
library(exactextractr)
library(geodata)

# ------------------------------------------------------------
# STEP 1: Load PSA municipality shapefile
# Set repo_root to the folder where you have cloned/downloaded this
# repository, then adjust paths below if your folder names differ.
# ------------------------------------------------------------

repo_root      <- "."
shapefile_path <- file.path(repo_root, "PH_BEP/LDI/PH_Adm3_MuniCities/PH_Adm3_MuniCities.shp.shp")
output_path    <- file.path(repo_root, "PH_BEP/LDI/terrain_ruggedness.csv")

cat("Loading shapefile...\n")
muni       <- st_read(shapefile_path, quiet = TRUE)
muni_wgs84 <- st_transform(muni, crs = 4326)
cat("Shapefile loaded:", nrow(muni_wgs84), "municipalities\n")

# ------------------------------------------------------------
# STEP 2: Download SRTM elevation data via geodata
# elevation_30s: ~1km (30 arc-second) resolution for Philippines
# Downloaded from UC Davis geodata server (CGIAR-CSI)
# ------------------------------------------------------------

cat("\nDownloading SRTM elevation data via geodata...\n")
elev <- geodata::elevation_30s(country = "PHL", path = tempdir())
cat("Elevation raster loaded.\n")

# ------------------------------------------------------------
# STEP 3: Extract mean and SD of elevation per municipality
# exactextractr is faster than terra::extract for polygons
# ------------------------------------------------------------

cat("\nExtracting elevation statistics per municipality...\n")
elev_stats <- exact_extract(elev, muni_wgs84,
                             fun      = c("mean", "stdev"),
                             progress = TRUE)

# ------------------------------------------------------------
# STEP 4: Assemble and export
# ------------------------------------------------------------

cat("\nAssembling output...\n")
result <- data.frame(
  adm3_psgc = muni_wgs84$adm3_psgc,
  adm3_en   = muni_wgs84$adm3_en,
  elev_mean = elev_stats$mean,
  elev_sd   = elev_stats$stdev
)

cat("\nSummary of mean elevation (elev_mean, metres):\n")
print(summary(result$elev_mean))

cat("\nSummary of elevation SD (elev_sd, metres):\n")
print(summary(result$elev_sd))

write.csv(result, output_path, row.names = FALSE)
cat("\nDone. Output saved to:", output_path, "\n")
cat("Rows:", nrow(result), "\n")
cat("\nNext: run construct_elev_control.do in Stata\n")
