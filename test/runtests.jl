using Project
using Test

@testset "Project.jl" begin
    # Write your tests here.
    # Test plot_level2
    try
        Project.plot_level2()
    catch e
        @test false  # Indicate the test has failed
        println("plot_level2 failed: ", e)
    end

    # Test plot_level3
    try
        Project.plot_level3()
    catch e
        @test false
        println("plot_level3 failed: ", e)
    end

    # Test plot_level4
    try
        Project.plot_level4()
    catch e
        @test false
        println("plot_level4 failed: ", e)
    end

    # Test plot_level5
    try
        Project.plot_level5()
    catch e
        @test false
        println("plot_level5 failed: ", e)
    end

    # Test plot_level5a
    try
        Project.plot_level5a()
    catch e
        @test false
        println("plot_level5a failed: ", e)
    end

    # Test plot_level5b
    try
        Project.plot_level5b()
    catch e
        @test false
        println("plot_level5b failed: ", e)
    end
end
