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

## Running simulations

You can run simulations by invoking `main.rb` and it'll prompt you for how many
simulations to run and whether to include the chance of landing on the waitlist
in the odds. Western States includes the waitlist in the odds that they
calculate. Then it will output the average number of people selected per
category as well as the odds for each category.

```
ruby main.rb
```

To skip the prompts you can provide some or all of the parameters: year,
simulations, and waitlist (y/n).

```
ruby main.rb 2026 1000 y
```

You could also start up `irb` and run it that way:

```
load 'monte_carlo.rb'
mc = MonteCarlo.new(<year>, <num-of-simulations>, <include-waitlist-boolean>)
mc.run_simulations
mc.calculate_odds
```

## Entrants

Entrant counts are hardcoded in JSON files in the `years` folder, so make sure
those are updated before running simulations.
