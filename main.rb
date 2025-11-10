#!/usr/bin/env ruby

require './monte_carlo.rb'

puts "Enter year (default: current year + 1)"
current_year = Time.now.year
year = gets.chomp.to_i
year = current_year + 1 if year.zero? || year > current_year
year = 2023 if year <= 2023

puts "Enter number of simulations (default: 1_000, max: 10_000)"
simulations = gets.chomp.to_i
simulations = 1000 if simulations.zero? || simulations > 10000
simulations = 1 if simulations <= 0

puts "Include waitlist in the odds? y/n"
waitlist = gets.chomp.downcase == "y"

start = Time.now.to_i
mc = MonteCarlo.new(year, simulations, waitlist)
mc.run_simulations
mc.calculate_odds
finish = Time.now.to_i

puts "\nAverage selections:"
pp mc.averages

puts "\nOdds:"
pp mc.odds

puts "\nSeconds taken: #{finish - start}"
