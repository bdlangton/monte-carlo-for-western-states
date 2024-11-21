#!/usr/bin/env ruby

require './monte_carlo.rb'

puts "Enter number of simulations"
simulations = gets.chomp.to_i
simulations = 1 if simulations <= 0
simulations = 10000 if simulations > 10000

puts "Include waitlist in the odds? y/n"
waitlist = gets.chomp.downcase == "y"

start = Time.now.to_i
mc = MonteCarlo.new(simulations, waitlist)
mc.run_simulations
mc.calculate_odds
finish = Time.now.to_i

puts "Seconds taken: #{finish - start}"
puts "Average selections: #{mc.averages}"
puts "Odds: #{mc.odds}"
