function invasion(hablen, runlen, estab, no, d, r)
    hab = zeros(hablen)
    new_hab = hab
    hab[1] = no
    edge = [1]
    for t in 1:runlen
        for h in 1:hablen
            hab[h] = r * hab[h]
        end
        new_hab[1] = ((1 - d) + d / 2) * hab[1] + (d / 2) * hab[2]
        for h in 2:(hablen - 1)
            new_hab[h] = (d / 2) * hab[h - 1] + (1 - d) * hab[h] + (d / 2) * hab[h + 1]
        end
        new_hab[hablen] = ((1 - d) + d / 2) * hab[hablen] + (d / 2) * hab[hablen - 1]
        hab = new_hab
        edge = vcat(edge, findfirst(x -> x >= estab, hab))
    end
    return edge
end

# Parameters
hablen = 100
runlen = 50
estab = 10
no = 50
d = 0.2 # Given value for d
r = 4 # Given value for r

# Running the invasion function
edge = invasion(hablen, runlen, estab, no, d, r)

# Plotting
using Plots
plot(edge, label="Invasion Edge", color=:green)
title!("Invasion Edge Over Time")
xlabel!("Time")
ylabel!("Edge Position")