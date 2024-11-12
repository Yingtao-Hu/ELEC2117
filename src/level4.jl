function intervention(dpop, pop, params, t)
    S, I, Is, R = pop
    c, β, γ, ps, γs, α, εi, pi = params
    N = S + I + Is + R
    dpop[1] = -c * (1 - εi * pi) * β * I / N * S + α * R
    dpop[2] = c * (1 - εi * pi) * β * I / N * S - γ * I
    dpop[3] = ps * γ * I - γs * Is
    dpop[4] = (1 - ps) * γ * I + γs * Is - α * R
end

function plot_level4()
    # SIR model parameters and initial condition
    pop0 = [5999, 1, 0, 0]
    tspan = (0.0, 31.0)
    params = (8.0, 0.034, 0.1429, 0.2, 0.0714, 0.0333)
    tspan_intervention = (0.0, 50.0)
    params_intervention = (8.0, 0.034, 0.1429, 0.2, 0.0714, 0.0333, 0.3, 0.424)

    # Solve initial SIR model
    prob_sir = ODEProblem(sir_model, pop0, tspan, params)
    sol_sir = solve(prob_sir)

    # Extract initial condition at t=30 for intervention model
    Si, Ii, Isi, Ri = sol_sir[1, end], sol_sir[2, end], sol_sir[3, end], sol_sir[4, end]
    pop30 = [Si, Ii, Isi, Ri]

    # Solve intervention model
    prob_intervention = ODEProblem(intervention, pop30, tspan_intervention, params_intervention)
    sol_intervention = solve(prob_intervention)

    # Combine data for plotting
    combined_t = vcat(sol_sir.t, sol_intervention.t .+ sol_sir.t[end])
    combined_I = vcat(sol_sir[2, :], sol_intervention[2, :])
    combined_Is = vcat(sol_sir[3, :], sol_intervention[3, :])

    # Data points
    data_infected = [11, 7, 20, 3, 29, 14, 11, 12, 16, 10, 58, 34, 26, 29, 51, 55, 155, 53, 67, 98, 130, 189, 92, 192, 145, 128, 68, 74, 126, 265, 154, 207, 299, 273, 190, 152, 276, 408, 267, 462, 352, 385, 221, 420, 544, 329, 440, 427, 369, 606, 416, 546, 475, 617, 593, 352, 337, 473, 673, 653, 523, 602, 551, 686, 556, 600]
    data_severe = [0, 0, 1, 2, 5, 5, 5, 2, 9, 4, 22, 0, 15, 48, 38, 57, 9, 18, 20, 0, 41, 15, 35, 36, 27, 38, 24, 40, 34, 57, 18, 29, 63, 66, 119, 76, 95, 28, 109, 136, 119, 104, 121, 93, 147, 129, 130, 161, 133, 136, 138, 139, 181, 181, 218, 183, 167, 164, 219, 220]

    # Plot
    plot(combined_t, combined_I, label="Model - Infections", xlabel="Days", ylabel="Population", color=:blue, title="φi = $(params_intervention[8])")
    plot!(combined_t, combined_Is, label="Model - Severe Cases", color=:red)
    scatter!(16:81, data_infected, label="Data - Infected Cases", color=:blue, markersize=2)
    scatter!(22:81, data_severe, label="Data - Severe Cases", color=:red, markersize=2)
end