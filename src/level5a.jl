function sir_model_reverse(dpop, pop, params, t)
    S, I, Is, R = pop
    c, β, γ, ps, γs, α= params
    N = S + I + Is + R # Overall population size
    dpop[1] =  c * β * I / N * S - α * R # dS/dt
    dpop[2] = -c * β * I / N * S + γ * I  # dI/dt
    dpop[3] = -ps * γ * I + γs * Is # dIs/dt
    dpop[4] = -(1-ps) * γ * I - γs * Is + α * R # dR/dt
end
function plot_level5a()
    pop0 = [9976, 21, 3, 0] # Initial condition 
    tspan = (0.0, 21.0) # Time span 
    params = (8.0, 0.036, 0.1429, 0.2, 0.0714, 0.0333) # Parameters
    # Solve the ODE
    prob_sir = ODEProblem(sir_model_reverse, pop0, tspan, params)
    sol_sir = solve(prob_sir)

    plot(sol_sir.t, sol_sir[2,:], label="Infections", xlabel="Days ago", ylabel="Population", color=:blue, title="backtrace")
    plot!(sol_sir.t, sol_sir[3,:], label="Severe Cases", color=:red)
    # To see the actual values use the following code
    #Ii, Isi = sol_sir[2, end], sol_sir[3, end]
    #println("$Ii, $Isi")
end