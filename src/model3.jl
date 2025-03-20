using LinearAlgebra, Plots, CSV, DataFrames

# Load initial female population (2020 census, in millions)
age_groups = 0:5:85  # 18 age groups (0-4, 5-9, ..., 85+)
initial_pop = [
    41.8, 41.5, 54.2, 48.9, 46.8, 44.1,  # Ages 0-29
    38.2, 35.6, 33.1, 30.4, 27.8, 25.2,  # Ages 30-59
    22.5, 19.7, 16.9, 13.2, 9.8, 6.4     # Ages 60-85+
]  # Source: 2020 Census (simplified)

# Survival probabilities (5-year intervals, from UN life tables)
survival = [
    0.996, 0.995, 0.994, 0.993, 0.992,  # Ages 0-24
    0.990, 0.987, 0.983, 0.978, 0.970,  # Ages 25-49
    0.955, 0.930, 0.890, 0.825, 0.720,  # Ages 50-74
    0.550, 0.300, 0.000                 # Ages 75+
]

# Age-specific fertility rates (per 1,000 women, adjusted to TFR=1.3)
fertility_base = [0.0, 0.0, 0.05, 0.25, 0.45, 0.35, 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
fertility = fertility_base .* (1.3 / sum(fertility_base))  # Normalize to TFR=1.3

# Build Leslie Matrix (18x18)
n = length(age_groups)
leslie = zeros(n, n)

# Fill survival rates (subdiagonal)
for i in 1:n-1
    leslie[i+1, i] = survival[i]
end

# Fill fertility rates (first row)
leslie[1, :] = fertility

# Project population for 30 years (5-year intervals)
years = 30
population = zeros(n, years+1)
population[:, 1] = initial_pop

for t in 1:years
    population[:, t+1] = leslie * population[:, t]
end

# Convert to total population (millions)
total_pop = sum(population, dims=1)'

# Plot results
plt = plot(layout=(2,1), size=(800, 600), legend=:topleft)

# Age structure
heatmap!(plt[1], 0:5:5*years, age_groups, population,
         title="China's Population Pyramid Projection (2020–2050)",
         xlabel="Year", ylabel="Age Group",
         color=:viridis, cbar=:right)

# Total population
plot!(plt[2], 2020:5:2020+5*years, total_pop,
      label="Total Female Population",
      color=:red, lw=2, markershape=:circle,
      title="Total Population Projection",
      xlabel="Year", ylabel="Population (Millions)")

display(plt)

# Print key metrics
println("Projected Total Female Population (2050): ", round(total_pop[end], digits=2), " million")
println("Long-term growth rate (λ): ", round(eigvals(leslie)[end], digits=4))