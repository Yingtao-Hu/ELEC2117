# Define the error function
function error_function_3(params_input_3)
    β, ps, γs, α = params_input_3

    pop0 = [5999, 1, 0, 0]
    tspan = (0.0, 31.0)

    new_params = (8.0, β, 0.1429, ps, γs, α)
    prob = ODEProblem(sir_model, pop0, tspan, new_params)
    sol = solve(prob, saveat=0:1:31)  
    
    # Model outputs for infected and severe cases at the matching days
    I_model = sol[2, 16:31]
    Is_model = sol[3, 22:31]
    data_infected = [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55]  # day 16-31
    data_severe =   [0, 0, 1, 2, 5, 5, 5, 2, 9, 4]                                # day 22-31
    # Errors in infected and severe cases
    error_infected = sum((I_model - data_infected).^2)
    error_severe = sum((Is_model - data_severe).^2)
    
    return error_infected + error_severe
end

# Function to plot error vs β
function plot_level3()
    β_values = 0.03:0.0001:0.04  # Range of β values
    errors = Float64[]  # Empty array for errors
    
    for β in β_values
        params_input_3 = [β, 0.2, 0.0714, 0.0333]
        push!(errors, error_function_3(params_input_3))
    end
    
    # Plotting
    plot(β_values, errors, xlabel="β", ylabel="Error", label="Error vs β")
end
