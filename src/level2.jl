# Define the SIR model.
function sir_model(dpop, pop, params, t)
    S, I, Is, R = pop
    c, β, γ, ps, γs, α = params
    N = S + I + Is + R  # Total population size
    dpop[1] = -c * β * I / N * S + α * R  # dS/dt
    dpop[2] = c * β * I / N * S - γ * I  # dI/dt
    dpop[3] = ps * γ * I - γs * Is       # dIs/dt
    dpop[4] = (1-ps) * γ * I + γs * Is - α * R  # dR/dt
end
function plot_level2()
    # Initial conditions and parameters
    pop0 = [5999, 1, 0, 0] # Initial population [S, I, Is, R]
    tspan = (0.0, 31.0)    # Time span
    params = (8.0, 0.034, 0.1429, 0.2, 0.0714, 0.0333)  # Parameters

    # Solve the ODE
    prob_sir = ODEProblem(sir_model, pop0, tspan, params)
    sol_sir = solve(prob_sir)

    # Data for plotting
    data_infected = [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55]  # day 16-31
    data_severe =   [0, 0, 1, 2, 5, 5, 5, 2, 9, 4]                                # day 22-31

    # Extract model values for dI/dt and dIs/dt
    model_infected = [sol_sir(t)[2] for t in sol_sir.t]
    model_severe = [sol_sir(t)[3] for t in sol_sir.t]
    # Plotting
    plot(sol_sir.t, model_infected, label="Model - Infections", lw=2, title="β = $(params[2])")
    plot!(sol_sir.t, model_severe, label="Model - Severe Cases", lw=2)
    scatter!(16:31, data_infected, label="Data - Infected Cases", color=:blue, markersize=3)
    scatter!(22:31, data_severe, label="Data - Severe Cases", color=:red, markersize=3)
    xlabel!("Days")
    ylabel!("Number of Cases")
end