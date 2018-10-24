# PFT-specific parameters
pft <- c(2, 2, 1)
lai <- c(0.5, 1, 1.5)
wai <- c(0.01, 0.01, 0.01)
cai <- rep(1, length(lai))
orient_factor <- c(0.5, 0.5)
clumping_factor <- c(0.8, 0.8)

leaf_spec <- list(
  PEcAnRTM::prospect(c(1.4, 30, 0.01, 0.01), 4),
  PEcAnRTM::prospect(c(1.3, 40, 0.01, 0.01), 4)
)

leaf_reflect <-Reduce(
  cbind,
  Map(function(x) x[, "reflectance"], leaf_spec)
)
leaf_trans <- Reduce(
  cbind,
  Map(function(x) x[, "transmittance"], leaf_spec)
)

matplot(leaf_reflect, type = "l")

# Load existing soil and wood reflectance spectra
# Note that I have to add one more value to end so vectors line up
iota_g <- scan(system.file("extdata/soil_reflect_par.dat", package = "PEcAnRTM"))
iota_g <- c(iota_g, tail(iota_g, 1))
wood_reflect <- scan(system.file("extdata/wood_reflect_par.dat", package = "PEcAnRTM"))
wood_reflect <- c(wood_reflect, tail(wood_reflect, 1))
wood_reflect <- matrix(wood_reflect, 2101, max(pft))
wood_trans <- matrix(0, 2101, max(pft))

# For now, assume constant solar spectrum
# Adjust with data later
down_sky <- rep(0.1 / 2101, 2101)
down0_sky <- rep(0.9 / 2101, 2101)
czen <- 0.451

if (FALSE) {

  source("twostream.R")
  result <- sw_two_stream(
    czen,
    iota_g,
    pft,
    lai, wai, cai,
    orient_factor, clumping_factor,
    leaf_reflect, leaf_trans,
    wood_reflect, wood_trans,
    down_sky, down0_sky
  )

}

## # Read PAR data from CRUNCEP
## dl <- PEcAn.data.atmosphere::download.CRUNCEP(
##   outfolder = "cruncep_download",
##   start_date = "2004-07-01",
##   end_date = "2004-08-01",
##   site_id = NA,
##   lon.in = 84.6738,
##   lat.in = 45.5594,
##   overwrite = FALSE,
##   method = "ncss"
## )
## nc <- ncdf4::nc_open(dl$file)
## SW <- max(ncdf4::ncvar_get(nc, "surface_downwelling_shortwave_flux_in_air"))
## ncdf4::nc_close(nc)

# Borrow logic from met2model.ED2
## cosz <- 0.451
## SW <- 668.3394
## frac <- SW / (1366 * cosz)
## SWd <- SW * (1 - frac)                  # Diffuse portion
## nir_beam <- (SW - SWd) * 0.57
## nir_diff <- SWd * 0.48
## vis_beam <- (SW - SWd) * 0.43
## vis_diff <- SWd * 0.52
