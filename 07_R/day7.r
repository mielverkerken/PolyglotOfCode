args <- commandArgs(trailingOnly=TRUE)
data <- scan(args[1], sep = ",")
median <- median(data)
mean <- mean(data)
fuel <- sum(abs(data - median))

fuelFunction <- function(mean, positions) {
  delta <- abs(positions - mean)
  sum(delta * (delta + 1) / 2)
}

fuelCeiling <- fuelFunction(ceiling(mean), data)
fuelFloor <- fuelFunction(floor(mean), data)

print(sprintf("median: %d  fuel: %d", median, fuel))
print(sprintf("mean: %f ceiling: %d floor: %d fuel: %d", 
    mean, fuelCeiling, fuelFloor, min(fuelCeiling, fuelFloor)))