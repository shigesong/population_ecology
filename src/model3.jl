# Leslie Matrix Population Projection in Julia

# Define the Leslie matrix
L = [
    0.0  1.2  1.1  0.8  0.0;
    0.5  0.0  0.0  0.0  0.0;
    0.0  0.6  0.0  0.0  0.0;
    0.0  0.0  0.7  0.0  0.0;
    0.0  0.0  0.0  0.9  0.0
]

# Initial population vector (age classes)
P0 = [100; 50; 30; 20; 10]

# Number of time periods to project
num_periods = 10

# Initialize a matrix to store population projections
population_projections = Matrix{Float64}(undef, length(P0), num_periods+1)
population_projections[:, 1] = P0

# Project population over the specified number of periods
for t in 1:num_periods
    population_projections[:, t+1] = L * population_projections[:, t]
end

# Print population projections
for t in 0:num_periods
    println("Population at time period $t: ", population_projections[:, t+1])
end

# Plotting the results (optional)
using Plots
plot(0:num_periods, population_projections', xlabel="Time Period", ylabel="Population", label=["Age 1" "Age 2" "Age 3" "Age 4" "Age 5"], lw=2)
title!("Population Projection Using Leslie Matrix")