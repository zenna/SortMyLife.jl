module SortMyLife

export sortmylife

using Cassette
Cassette.@context SortCtx

struct Task
  x::String
end
Base.show(io::IO, t::Task) = print(io, t.x)

function Base.isless(x::Task, y::Task)
  println("Which should you do first?")
  println("a) $(x.x)")
  println("b) $(y.x)")
  @label readinput
  line = readline(stdin)
  if line == "a"
    false
  elseif line == "b"
    true
  else
    println("Did not receive a or b, try again")
    @goto readinput
  end
end

function Cassette.overdub(ctx::SortCtx, ::typeof(Base.isless), x, y)
  ctx.metadata[] += 1
  x < y
end

function sortmylife(tasks::Vector{Task})
  count1 = Ref(0)
  ctx = SortCtx(metadata = count1)
  res = Cassette.overdub(ctx, sort, unique(tasks))
  println("I sorted your life out and it only took $(ctx.metadata.x) comparisons!")
  res
end

"""
papertasks = ["Add section on control flow",
	        		"Add inverse graphics plots",
              "Add code examples",
              "Discuss scaling in section 3",
              "Relook at glucose example",
              "add Kernel comparison plot",
              "Add approximate bayesian computation benchmarks",
              "Add theorem about composing primitives",
              "Revise Draft",
              "Add a third example.. Program learning, Physics?"]

Usage: sortmylife(papertasks)
"""
sortmylife(tasks::AbstractVector) = sortmylife(Task.(tasks))

"""
tasks = \"\"\"
. Send Mum a birthday present
. Email people from hacker news
. Put tomorrow variational talk into calednar
. Setup Papaxray
. Pay Ilans thing
. Pay Taras thing
. Email people from hacker news
. Email back people who emailed me from hacker news
. Investigate Incorporate Basis.
. Think about what kind of structure I want Basis to have
. Plan San Francisco trip
. Try to formalize causal entailment / causal sufficiency
. Add HP definition of explanation to overleaf paper
. Read situation calculus paper
. Make a larger plan for submission
. Try to develop a prototype
. Fix one Omega issue
. Explore Omega redesign.
. Read GAIKAS spectactular Empire
\"\"\"

sortmylife(tasks)
"""
sortmylife(::String; delim = "\n") = strip.(split(tasks, delim))

function readtasks()
  tasks = Task[]
  while true
    println("Please add a task to add or press enter to be done.")
    line = readline(stdin)
    if line == ""
      break
    else
      println("Adding task: $line")
      push!(tasks, Task(line))
    end
  end
  tasks
end

sortmylife() = sortmylife(readtasks())

end
