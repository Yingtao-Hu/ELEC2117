# Define the error function including intervention parameters εi and pi
function error_function(params_input)
    β, ps, γs, α, εi, pi = params_input
    pop0 = [9976, 21, 3, 0] # Initial condition 
    data_infected = [21, 29, 25, 30, 28, 34, 28, 54, 57, 92, 73, 80, 109, 102, 128, 135, 163, 150, 211, 196, 233, 247, 283, 286, 332, 371, 390, 404, 467, 529, 598, 641, 704, 702, 788, 856, 854, 955, 995, 1065, 1106, 1159, 1217, 1269, 1298, 1328, 1339, 1383, 1431, 1422, 1414, 1485, 1464, 1480]  
    data_severe = [3, 3, 4, 7, 3, 8, 7, 5, 9, 13, 15, 3, 20, 13, 11, 20, 16, 11, 15, 18, 27, 24, 28, 36, 41, 35, 41, 55, 63, 66, 72, 80, 90, 104, 109, 115, 127, 135, 147, 162, 163, 186, 194, 200, 216, 223, 241, 249, 258, 275, 277, 299, 302, 300]
    tspan = (28.0, 36.0) # Time span 
    tspan_intervention = (0.0, 45.0) # Time span 
    
    # Solve sir_model for the first 8 days
    params_sir = (8.0, β, 0.1429, ps, γs, α)
    prob_sir = ODEProblem(sir_model, pop0, tspan, params_sir)
    sol_sir = solve(prob_sir, saveat=28:1:36)
    
    # Extract conditions at t = 36 for intervention initial conditions
    Si, Ii, Isi, Ri = sol_sir[1, end], sol_sir[2, end], sol_sir[3, end], sol_sir[4, end]
    pop30 = [Si, Ii, Isi, Ri]
    
    # Solve intervention model from day 31 to 55
    params_intervention = (8.0, β, 0.1429, ps, γs, α, εi, pi)
    prob_intervention = ODEProblem(intervention, pop30, tspan_intervention, params_intervention)
    sol_intervention = solve(prob_intervention, saveat=1:1:45)
    
    # Combine the solutions from both models
    combined_I = vcat(sol_sir[2, :], sol_intervention[2, :])
    combined_Is = vcat(sol_sir[3, :], sol_intervention[3, :])

    # Calculate error with respect to actual data
    error_infected = sum((combined_I - data_infected).^2)
    error_severe = sum((combined_Is - data_severe).^2)
    
    return error_infected + error_severe
end
function plot_level5()
    # Traverse beta values
    β_values = 0.036:0.00001:0.037  # Define the range for β values
    errors = Float64[]  # Initialize an empty array to store the errors
    for β in β_values
        params_input = [β, 0.2, 0.0714, 0.0333, 0.3, 0.424]
        push!(errors, error_function(params_input))
    end
    # Plot error vs beta
    plot(β_values, errors, xlabel="β", ylabel="Error", label="Error vs β")
end