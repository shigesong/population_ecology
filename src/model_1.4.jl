# Discrete time population growth model

using Plots

# Define parameters
no = 100
r = 1.05
t = 0:1:30

nt = (r .^ t) .* no

# Plot the results
plot(t, nt, label="Population", color=:blue)
xlabel!("Time")
ylabel!("Population")
title!("Population Growth Over Time")