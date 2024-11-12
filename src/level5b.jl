function plot_level5b()
    pop30 = [9999, 1, 0, 0] # Initial condition 
    tspan_intervention = (0.0, 180.0) # Time span 
    params_intervention = (8.0, 0.036, 0.1429, 0.2, 0.0714, 0.0333, 0.3, 0.424) # Parameters
    # Solve the ODE
    prob_intervention = ODEProblem(intervention, pop30, tspan_intervention, params_intervention)
    sol_intervention = solve(prob_intervention)
    plot(sol_intervention.t, sol_intervention[2,:], label="Infections", xlabel="Days", ylabel="Population", color=:blue)
    plot!(sol_intervention.t, sol_intervention[3,:], label="Severe Cases", color=:red)
    plot!(sol_intervention.t, sol_intervention[4,:], label="Recovered", color=:green)
end