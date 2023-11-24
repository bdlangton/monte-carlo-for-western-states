# Monte Carlo simulation for the Western States 100

See my [Hardrock simulation
here](https://github.com/bdlangton/monte-carlo-for-hardrock).

Run simulations to calculate your odds of getting into the lottery. This is the
same method used by Western States
[themselves](https://www.wser.org/2022/12/02/2023-lottery-statistics/) but with
this you can run the odds before Western States officially publishes the
results.

Note that there could be differences between these results and what Western
States publishes. It depends on how many simulation runs you do, but also it
depends on if the total number of selections changes and whether the preliminary
ticket numbers end up changing.

This does not factor in your odds of getting onto the waitlist, just your odds
of getting selected into the original list of starters. Western States typically
selects 50 people to the waitlist, so add 50 to the `@total_picks` value to
account for the waitlist as part of the probability.

## Running simulations

You can run simulations by invoking `main.rb` and it'll prompt you for how many
simulations to run. Then it will output the average number of people selected
per category as well as the odds for each category.

```
ruby main.rb
```

You could also start up `irb` and run it that way:

```
load 'monte_carlo.rb'
mc = MonteCarlo.new(<num-of-simulations>)
mc.run_simulations
mc.calculate_odds
```

## Entrants

Entrant counts are hardcoded in `monte_carlo.rb` so make sure those are updated
before running simulations. Previous year values are on [tagged
commits](https://github.com/bdlangton/monte-carlo-for-western-states/tags).
