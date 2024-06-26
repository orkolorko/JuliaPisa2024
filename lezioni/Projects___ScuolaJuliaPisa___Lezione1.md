## Why Julia?
	- Terse sintax
	- Easy to write, similar to mathematics
	- Syntactic sugar
	- Less boilerplate
- ## Installing Julia
	- Installation instruction can be found at [https://julialang.org/downloads/] (windows and linux)
		- This will install the [Juliaup](https://github.com/JuliaLang/juliaup) installation manager, which will automatically install julia and help keep it up to date. The command `juliaup` is also installed. To install different julia versions see `juliaup --help`.
	- on Ubuntu, I installed Julia through snap
		- `snap install julia`, this also keeps my installation up to date; when on a system with snap, I prefer to use the snap installer, but it is a matter of taste...
	- Please remark that the fact that `julia` automatically updates sometimes can be somewhat problematic, more on this later
- ## The julia REPL and initial setup
	- The basic way of interfacing with Julia is the REPL, the **Read-Eval-Print Loop**
	- At a first glance, it looks like a fancy calculator
	- Before going further, I would like to install and setup the system in a way that I found comfortable, and may work for you too
	- write `julia` on the command line, I will teach you two ways of installing packages
		- the first one opens the shell package manager, press `]`
		- the prompt color changes to blue
		- type `add OhMyREPL`, which is a package that colors the output of the REPL so it is easier to read it; remark that the REPL and the shells in julia support `TAB`-autocomplete
		- to get back from the pkg prompt to the REPL, just press `backspace`
		- another way to install packages is by using the `Pkg` package, that allows us to install packages, change environments and so on from inside Julia
		- in the REPL, the one with the `julia >` prompt, write `import Pkg`
		- this means that we are bringing the `Pkg` name in scope inside the REPL (but not its subnames)
		- Now, we can call `Pkg.add("BenchmarkTools")`; this installs a package to do Benchmarks
		- Since we only imported the `Pkg` name in scope, we need to specify the function using the dot notation
		- I use this form when I want to avoid polluting my namespaces (it is not really important in julia, since it is strongly typed, but it is a good practice)
		- Instead of `import` we could have used `using Pkg` that imports the name `Pkg` and all the names exported by `Pkg`
		- We install one last package `Pkg.add("Revise")`, this package allows julia to recompile functions on the fly when we change them in a loaded package
	- Now, for me it is a good practice to start these packages as julia starts, therefore, we make a file
		- `nano ~/.julia/config` on linux
		- on windows we should do the same in `C:\Users\USERNAME\.julia\config\startup.jl` with text editor
		- add `using Revise, OhMyREPL, BenchmarkTools` and save the file `CTRL-O + CTRL-X`
		- Documentation on the startup file https://docs.julialang.org/en/v1/manual/command-line-interface/#Startup-file
- ## Installare VSCode
	- Probably VSCode is the best thing that microsoft has done in many years (maybe forever)
		- https://code.visualstudio.com/
	- On Ubuntu
		- `snap install code`
		- On windows, we just go to the page above and download it
	- Install the Julia extension, that is going to take care of the interface between VSCode and Julia
- ## First steps in VSCode/Julia
	- We make a directory, I called it `~/Coding/Pisa2024`
	- Good practice: when we work on a new project, whether its coding a package or experiments, it is good to make a new environment, so you avoid loading unnecessary packages for your actual work (loading unnecessary packages)
	- Open VSCode, open folder, go to the folder you created
	- Press `F1` and start the Julia REPL
	- To create a new environment in the directory
	- `import Pkg; Pkg.activate("./")`
	- in the REPL we install the `Plots` package, by using `Pkg.add("Plots")`
	- Now we also change the environment for VSCode, by clicking on Julia env in the bottom state menu and choosing our working directory; this is to make VSCode aware of the packages we installed in the environment
	- Remark that using environments comes with zero cost: julia only downloads and compile one copy of the package that is then made available to the environments
- ## First use of Julia
	- In the REPL now we can use Julia to make some simple computations
	- We can use Julia as a simple calculator
		- ```julia
		  julia> 1.0 + 1.0
		  2.0
		  ```
	- It is worth starting to think about types
		- ```julia
		  julia> typeof(1.0)
		  Float64
		  ```
		- ```julia
		  julia> typeof(1)
		  Int64
		  ```
		- ```julia
		  julia>  typeof(1.0+0.3*im)
		  ComplexF64 (alias for Complex{Float64})
		  ```
		-
	- As you can see julia implicitly identifies the types of the objects: julia is a typed language and under the hood it uses types to identify and dispatch the right function
	- What is the difference between Julia and Python?
		- **Just in time** compilation
		- We define a function
			- ```julia
			  T(x) = 4*x*(1-x)
			  T (generic function with 1 method)
			  ```
		- What is going to happen when we run this function?
			- ```julia
			  julia> T(0)
			  0
			  julia> @code_warntype T(0)
			  MethodInstance for T(::Int64)
			    from T(x) @ Main REPL[8]:1
			  Arguments
			    #self#::Core.Const(T)
			    x::Int64
			  Body::Int64
			  1 ─ %1 = (1 - x)::Int64
			  │   %2 = (4 * x * %1)::Int64
			  └──      return %2
			  ```
		- When we ran this function julia identified that the input was an integer, checked if it had available all the functions needed to compile this function with an integer input and compiled a version of this function and stored it in memory (recently, it also stores them on disc, to avoide recompilation); this means that the **the first time** we ran a function julia is going to incur in overhead, but the **second time** it is going to have access to a compiled and often optimized version of the function which is going to be really fast
		- Functions that start with an `@` are called **macros** and are functions that act on julia source code before compilations. The macro `@code_warntype`is used to analyze the julia code and identify eventual type instabilities
		- The macro `@time` computes the runtime of a function
		- In the REPL, we can access the help prompt by pressing `?`
		- We ran the example in the help
- ## Declaring more complex functions in julia
- We open a file and add the following code
- ```julia
  function orbit(T, x0::Float64, N)
     orb = zeros(Float64, N)
     x = x0
     for i in 1:N
        orb[i] = x
        x = T(x)
     end
     return orb
  end
  ```
- We would like to be able not to worry about the input type, but types are something we can work with in Julia, to do so we use the `typeof` function
	- ```julia
	  function orbit(T, x0, N)
	     orb = zeros(typeof(x0), N)
	     x = x0
	     for i in 1:N
	        orb[i] = x
	        x = T(x)
	     end
	     return orb
	  end
	  ```
- This is similar to what is achieved in C++ by using templates, but it is simpler to use
- ## Summary of the lecture
	- We installed Julia and VScode
	- We installed some basic packages
	- We used the REPL and discussed on types
	- we implemented a somewhat more complicated function
	- plotted an histogram
	- made a small discussion on generic code
	-
-
	-
	-