# Define the error function including intervention parameters εi and pi
function error_function_4(params_input_4)
    # Data
    data_infected = [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55, 155, 53, 67, 98, 130, 189, 92, 192, 145, 128, 68, 74, 126, 265, 154, 207, 299, 273, 190, 152, 276, 408, 267, 462, 352]  
    data_severe = [0, 0, 1, 2, 5, 5, 5, 2, 9, 4, 22, 0, 15, 48, 38, 57, 9, 18, 20, 0, 41, 15, 35, 36, 27, 38, 24, 40, 34, 57, 18, 29, 63, 66, 119] 
    β, ps, γs, α, εi, pi = params_input_4
    pop0 = [5999, 1, 0, 0]
    tspan = (0.0, 31.0)
    tspan_intervention = (0.0, 50.0)
    # Solve sir_model for the first 30 days
    params_sir = (8.0, β, 0.1429, ps, γs, α)
    prob_sir = ODEProblem(sir_model, pop0, tspan, params_sir)
    sol_sir = solve(prob_sir, saveat=0:1:31)
    
    # Extract conditions at t = 30 for intervention initial conditions
    Si, Ii, Isi, Ri = sol_sir[1, end], sol_sir[2, end], sol_sir[3, end], sol_sir[4, end]
    pop30 = [Si, Ii, Isi, Ri]
    
    # Solve intervention model from day 31 to 55
    params_intervention = (8.0, β, 0.1429, ps, γs, α, εi, pi)
    prob_intervention = ODEProblem(intervention, pop30, tspan_intervention, params_intervention)
    sol_intervention = solve(prob_intervention, saveat=1:1:25)
    
    # Combine the solutions from both models
    combined_I = vcat(sol_sir[2, 16:31], sol_intervention[2, :])
    combined_Is = vcat(sol_sir[3, 22:31], sol_intervention[3, :])

    # Calculate error with respect to actual data
    error_infected = sum((combined_I - data_infected).^2)
    error_severe = sum((combined_Is - data_severe).^2)
    
    return error_infected + error_severe
end

function plot_level4e()
    # Traverse pi values
    pi_values = 0.423:0.000001:0.425  # Define the range for pi values
    errors = Float64[]  # Initialize an empty array to store the errors
    for pi in pi_values
        params_input_4 = [0.034, 0.2, 0.0714, 0.0333, 0.3, pi]
        push!(errors, error_function_4(params_input_4))
    end
    # Plot error vs pi
    plot(pi_values, errors, xlabel="ϕi", ylabel="Error", label="Error vs ϕi")
end