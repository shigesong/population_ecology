# GitHub Copilot Agents Guide for Population Ecology

This guide provides detailed examples and workflows for using GitHub Copilot agents effectively with the population ecology models in this repository.

## Quick Start Examples

### Working with model_1.4.jl (Basic Population Growth)

The current model implements simple exponential growth. Here are practical Copilot prompts to enhance it:

```julia
# Prompt: "Add logistic growth with carrying capacity to this model"
# Expected Copilot suggestion will modify the growth equation

# Prompt: "Include environmental stochasticity"
# Copilot should suggest adding random noise terms

# Prompt: "Create a function to find equilibrium population"
# This will generate analytical solutions
```

**Try this workflow:**
1. Open `src/model_1.4.jl`
2. Add comment: `# Convert to logistic growth model with carrying capacity K=500`
3. Let Copilot suggest the new equation: `nt = nt .* r .* (1 .- nt./K)`
4. Add comment: `# Plot both exponential and logistic growth for comparison`
5. Copilot will suggest plotting code

### Working with model2.jl (Invasion Model)

This spatial model can be enhanced with Copilot's help:

```julia
# Prompt: "Add heterogeneous habitat quality"
# Copilot will suggest modifying the habitat array

# Prompt: "Include Allee effects in population growth"
# This adds minimum viable population dynamics

# Prompt: "Optimize the spatial loop for performance"
# Copilot can suggest vectorized operations
```

**Example enhancement workflow:**
1. Comment: `# Add habitat quality matrix where quality varies spatially`
2. Let Copilot suggest: `habitat_quality = rand(0.5:0.1:1.5, hablen)`
3. Comment: `# Modify growth rate based on habitat quality`
4. Copilot should integrate quality into the growth equation

### Working with model3.jl (Leslie Matrix)

Demographic models benefit from Copilot's statistical knowledge:

```julia
# Prompt: "Add confidence intervals for population projections"
# Copilot will suggest Monte Carlo or bootstrap methods

# Prompt: "Include immigration/emigration flows"
# This adds migration terms to the matrix

# Prompt: "Calculate net reproduction rate and generation time"
# Copilot knows these demographic metrics
```

## Advanced Copilot Workflows

### 1. Model Validation and Testing

Generate comprehensive tests using natural language prompts:

```julia
# In any model file, try these prompts:

# "Create unit tests that verify population never goes negative"
function test_positive_population()
    # Copilot will generate test cases
end

# "Generate property-based tests for conservation laws"
# Copilot understands mathematical properties

# "Create benchmark tests comparing analytical vs numerical solutions"
# For models with known solutions
```

### 2. Parameter Sensitivity Analysis

```julia
# "Create a function to perform sensitivity analysis on all parameters"
# Copilot will suggest parameter sweeps and visualization

# "Generate Latin hypercube sampling for parameter space exploration"
# Advanced statistical sampling methods

# "Implement global sensitivity analysis using Sobol indices"
# Copilot knows variance-based methods
```

### 3. Model Comparison and Selection

```julia
# "Compare this model with alternative formulations using AIC"
# Model selection criteria

# "Create cross-validation framework for predictive accuracy"
# Machine learning approaches to model validation

# "Generate ensemble predictions from multiple model variants"
# Combining different approaches
```

## Domain-Specific Prompting Tips

### Biological Terminology

Use specific ecological terms for better suggestions:

```julia
# Good prompts:
# "Implement density-dependent mortality"
# "Add age-structured population dynamics"
# "Model metapopulation with source-sink dynamics"
# "Include environmental stochasticity in vital rates"

# Less effective prompts:
# "Make population change randomly"
# "Add some complexity"
# "Make it more realistic"
```

### Mathematical Concepts

Be specific about mathematical approaches:

```julia
# Effective prompts:
# "Solve this system using Runge-Kutta 4th order"
# "Implement Gillespie algorithm for stochastic simulation"
# "Add diffusion term using finite differences"
# "Calculate stability using Jacobian eigenvalues"
```

### Visualization Requests

Copilot excels at generating plots when given specific requirements:

```julia
# "Create phase plane plot for predator-prey dynamics"
# "Generate heatmap of population density over space and time"
# "Plot population pyramid animation over projection period"
# "Create violin plots showing parameter uncertainty"
```

## Troubleshooting Copilot Issues

### Common Problems and Solutions

1. **Copilot suggests Python/R syntax in Julia files**
   - Solution: Add explicit Julia syntax hints in comments
   - Example: `# In Julia, use broadcasting with .* operator`

2. **Biologically unrealistic suggestions**
   - Solution: Be specific about biological constraints
   - Example: `# Ensure survival probability is between 0 and 1`

3. **Performance issues with large arrays**
   - Solution: Request vectorized operations explicitly
   - Example: `# Use vectorized operations for better performance`

4. **Mathematical errors in equations**
   - Solution: Provide references or specify equation forms
   - Example: `# Use discrete logistic equation: N(t+1) = N(t) * r * (1 - N(t)/K)`

### Improving Copilot Accuracy

1. **Provide context in comments**:
   ```julia
   # This is a Leslie matrix for age-structured population
   # Rows represent age classes, columns represent time steps
   # First row contains fertility rates, subdiagonal has survival rates
   ```

2. **Use descriptive variable names**:
   ```julia
   # Good: survival_probability, fertility_rate, carrying_capacity
   # Avoid: s, f, K (unless defined clearly)
   ```

3. **Include units and ranges**:
   ```julia
   # Population size in individuals (range: 0 to 10000)
   # Growth rate per year (typical range: 0.8 to 1.2)
   # Diffusion coefficient in km²/year
   ```

## Integration with Research Workflow

### Literature to Code

Convert research papers into implementation:

```julia
# "Implement the model from Johnson et al. (2023) equation 4"
# "Convert this differential equation system to discrete time"
# "Add the stochastic terms described in the methods section"
```

### Data Analysis Pipeline

Generate analysis workflows:

```julia
# "Create data preprocessing pipeline for population time series"
# "Implement maximum likelihood parameter estimation"
# "Generate bootstrap confidence intervals for model parameters"
```

### Reproducible Research

Create documentation and reproducibility tools:

```julia
# "Generate markdown report with model results and plots"
# "Create parameter configuration file for reproducible runs"
# "Add logging and version control for simulation runs"
```

## Best Practices Summary

1. **Start Simple**: Begin with basic requests and build complexity
2. **Be Specific**: Use domain terminology and precise requirements
3. **Validate Results**: Always check biological realism and mathematical correctness
4. **Iterate**: Refine prompts based on initial suggestions
5. **Document**: Use Copilot to generate documentation as you code
6. **Test**: Generate tests alongside implementation code

## Example Session Transcript

Here's what a typical Copilot-assisted session might look like:

```julia
# User types: "# Create predator-prey model with Type II functional response"
# Copilot suggests:
function predator_prey(u, p, t)
    prey, predator = u
    a, b, c, d, K = p
    
    dprey_dt = a * prey * (1 - prey/K) - (b * prey * predator) / (1 + b * prey)
    dpredator_dt = c * (b * prey * predator) / (1 + b * prey) - d * predator
    
    return [dprey_dt, dpredator_dt]
end

# User types: "# Add stochastic noise to both equations"
# Copilot suggests adding noise terms and proper stochastic differential equation structure

# User types: "# Create bifurcation analysis varying parameter a"
# Copilot suggests parameter sweep and stability analysis code
```

This workflow demonstrates how Copilot can accelerate model development while maintaining scientific rigor through iterative refinement and validation.