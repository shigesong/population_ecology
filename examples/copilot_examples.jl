# Copilot Agent Examples for Population Ecology

# This file demonstrates practical examples of using GitHub Copilot agents
# with the population ecology models in this repository.

# =============================================================================
# Example 1: Enhancing model_1.4.jl with Copilot
# =============================================================================

# Original model_1.4.jl implements simple exponential growth
# Let's use Copilot to add logistic growth capabilities

using Plots

# Original parameters
no = 100
r = 1.05
t = 0:1:30

# Copilot prompt: "Add logistic growth with carrying capacity"
# Expected Copilot suggestion:
function logistic_growth(n0, r, K, time_steps)
    nt = zeros(length(time_steps))
    nt[1] = n0
    
    for i in 2:length(time_steps)
        nt[i] = nt[i-1] + r * nt[i-1] * (1 - nt[i-1]/K)
    end
    
    return nt
end

# Copilot prompt: "Compare exponential and logistic growth on same plot"
# Expected visualization code:
K = 500  # carrying capacity
exponential = (r .^ t) .* no
logistic = logistic_growth(no, 0.1, K, t)

plot(t, exponential, label="Exponential Growth", color=:blue, linewidth=2)
plot!(t, logistic, label="Logistic Growth (K=$K)", color=:red, linewidth=2)
xlabel!("Time")
ylabel!("Population")
title!("Population Growth Models Comparison")

# =============================================================================
# Example 2: Enhancing model2.jl with Copilot
# =============================================================================

# Copilot prompt: "Add habitat heterogeneity to the invasion model"
function invasion_with_heterogeneity(hablen, runlen, estab, no, d, r)
    # Copilot suggests adding habitat quality variation
    habitat_quality = 0.5 .+ 0.5 .* sin.(LinRange(0, 2π, hablen))
    
    hab = zeros(hablen)
    new_hab = hab
    hab[1] = no
    edge = [1]
    
    for t in 1:runlen
        for h in 1:hablen
            # Modified growth rate based on habitat quality
            effective_r = r * habitat_quality[h]
            hab[h] = effective_r * hab[h]
        end
        
        # Diffusion with boundary conditions
        new_hab[1] = ((1 - d) + d / 2) * hab[1] + (d / 2) * hab[2]
        for h in 2:(hablen - 1)
            new_hab[h] = (d / 2) * hab[h - 1] + (1 - d) * hab[h] + (d / 2) * hab[h + 1]
        end
        new_hab[hablen] = ((1 - d) + d / 2) * hab[hablen] + (d / 2) * hab[hablen - 1]
        
        hab = new_hab
        edge = vcat(edge, findfirst(x -> x >= estab, hab))
    end
    
    return edge, habitat_quality
end

# Copilot prompt: "Create visualization showing habitat quality and invasion"
function plot_invasion_dynamics()
    hablen = 100
    runlen = 50
    estab = 10
    no = 50
    d = 0.2
    r = 4
    
    edge, quality = invasion_with_heterogeneity(hablen, runlen, estab, no, d, r)
    
    # Create subplot layout
    p1 = plot(quality, label="Habitat Quality", color=:green, linewidth=2)
    title!("Habitat Quality Across Space")
    xlabel!("Position")
    ylabel!("Quality")
    
    p2 = plot(edge, label="Invasion Edge", color=:red, linewidth=2)
    title!("Invasion Edge Over Time")
    xlabel!("Time")
    ylabel!("Edge Position")
    
    plot(p1, p2, layout=(2,1), size=(800, 600))
end

# =============================================================================
# Example 3: Enhancing model3.jl with Copilot
# =============================================================================

using LinearAlgebra, Statistics

# Copilot prompt: "Add uncertainty analysis to Leslie matrix projections"
function leslie_with_uncertainty(initial_pop, leslie_matrix, years, n_simulations=1000)
    n_ages = length(initial_pop)
    results = zeros(n_simulations, years+1)
    
    for sim in 1:n_simulations
        # Add parameter uncertainty using normal distribution
        perturbed_matrix = leslie_matrix .* (1 .+ 0.1 .* randn(size(leslie_matrix)))
        
        # Ensure survival probabilities stay in [0,1]
        for i in 1:n_ages-1
            perturbed_matrix[i+1, i] = max(0, min(1, perturbed_matrix[i+1, i]))
        end
        
        # Ensure fertility rates stay non-negative
        perturbed_matrix[1, :] = max.(0, perturbed_matrix[1, :])
        
        # Project population
        population = zeros(n_ages, years+1)
        population[:, 1] = initial_pop
        
        for t in 1:years
            population[:, t+1] = perturbed_matrix * population[:, t]
        end
        
        results[sim, :] = sum(population, dims=1)
    end
    
    return results
end

# Copilot prompt: "Create confidence interval plots for population projections"
function plot_uncertainty_bands()
    # Use parameters from model3.jl
    age_groups = 0:5:85
    initial_pop = [41.8, 41.5, 54.2, 48.9, 46.8, 44.1, 38.2, 35.6, 33.1, 30.4, 27.8, 25.2, 22.5, 19.7, 16.9, 13.2, 9.8, 6.4]
    
    # Simplified Leslie matrix (you would use the full one from model3.jl)
    n = length(age_groups)
    leslie = zeros(n, n)
    survival = [0.996, 0.995, 0.994, 0.993, 0.992, 0.990, 0.987, 0.983, 0.978, 0.970, 0.955, 0.930, 0.890, 0.825, 0.720, 0.550, 0.300]
    fertility = [0.0, 0.0, 0.05, 0.25, 0.45, 0.35, 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    for i in 1:n-1
        leslie[i+1, i] = survival[i]
    end
    leslie[1, :] = fertility
    
    years = 30
    uncertainty_results = leslie_with_uncertainty(initial_pop, leslie, years, 500)
    
    # Calculate confidence intervals
    mean_proj = mean(uncertainty_results, dims=1)[1, :]
    lower_ci = [quantile(uncertainty_results[:, i], 0.025) for i in 1:years+1]
    upper_ci = [quantile(uncertainty_results[:, i], 0.975) for i in 1:years+1]
    
    # Plot with uncertainty bands
    time_points = 2020:5:2020+5*years
    plot(time_points, mean_proj, label="Mean Projection", color=:blue, linewidth=3)
    plot!(time_points, lower_ci, fillrange=upper_ci, alpha=0.3, color=:blue, label="95% CI")
    plot!(time_points, upper_ci, color=:blue, linestyle=:dash, alpha=0.7, label="")
    
    title!("Population Projection with Uncertainty")
    xlabel!("Year")
    ylabel!("Population (Millions)")
end

# =============================================================================
# Example 4: Advanced Copilot Workflows
# =============================================================================

# Copilot prompt: "Create a function to perform global sensitivity analysis"
function global_sensitivity_analysis(model_function, parameter_ranges, n_samples=1000)
    # Copilot should suggest Sobol sequence sampling
    n_params = length(parameter_ranges)
    
    # Generate parameter samples using Latin Hypercube Sampling
    samples = zeros(n_samples, n_params)
    for i in 1:n_params
        range = parameter_ranges[i]
        samples[:, i] = range[1] .+ (range[2] - range[1]) .* rand(n_samples)
    end
    
    # Evaluate model for each parameter set
    results = zeros(n_samples)
    for i in 1:n_samples
        results[i] = model_function(samples[i, :])
    end
    
    # Calculate sensitivity indices (simplified version)
    sensitivity_indices = zeros(n_params)
    for i in 1:n_params
        # Correlation-based sensitivity measure
        sensitivity_indices[i] = abs(cor(samples[:, i], results))
    end
    
    return sensitivity_indices, samples, results
end

# Copilot prompt: "Create model comparison framework using information criteria"
function compare_models(data, models, model_names)
    n_models = length(models)
    aic_values = zeros(n_models)
    bic_values = zeros(n_models)
    
    for i in 1:n_models
        # Fit model and calculate likelihood
        fitted_params = fit_model(models[i], data)
        log_likelihood = calculate_likelihood(models[i], fitted_params, data)
        n_params = length(fitted_params)
        n_data = length(data)
        
        # Calculate information criteria
        aic_values[i] = 2 * n_params - 2 * log_likelihood
        bic_values[i] = log(n_data) * n_params - 2 * log_likelihood
    end
    
    # Create comparison table
    comparison_df = DataFrame(
        Model = model_names,
        AIC = aic_values,
        BIC = bic_values,
        Delta_AIC = aic_values .- minimum(aic_values),
        AIC_Weight = exp.(-0.5 .* (aic_values .- minimum(aic_values))) ./ sum(exp.(-0.5 .* (aic_values .- minimum(aic_values))))
    )
    
    return comparison_df
end

# =============================================================================
# Usage Examples and Tips
# =============================================================================

# Tips for effective Copilot usage:

# 1. Use descriptive comments
# "Create a stochastic population model with environmental noise"
# "Implement age-structured population with density dependence"

# 2. Be specific about biological processes
# "Add Type II functional response for predator-prey interaction"
# "Include reproductive senescence in fertility schedule"

# 3. Request validation and testing
# "Generate unit tests for population model functions"
# "Create property-based tests for conservation laws"

# 4. Ask for optimization
# "Optimize this loop for large population arrays"
# "Vectorize these operations for better performance"

# 5. Request documentation
# "Write comprehensive docstrings for this function"
# "Explain the biological meaning of these parameters"

println("GitHub Copilot Agent Examples loaded successfully!")
println("Try running the example functions to see Copilot-enhanced models in action.")
println("Remember: Always validate Copilot suggestions for biological realism and mathematical correctness.")