#!/usr/bin/env ruby

require './monte_carlo.rb'

if ARGV.length >= 1
  year = ARGV[0].to_i
else
  puts "Enter year (default: current year + 1)"
  year = $stdin.gets.chomp.to_i
end

current_year = Time.now.year
year = current_year + 1 if year.zero? || year > current_year
year = 2023 if year <= 2023

if ARGV.length >= 2
  simulations = ARGV[1].to_i
else
  puts "Enter number of simulations (default: 1_000, max: 10_000)"
  simulations = $stdin.gets.chomp.to_i
end

simulations = 1000 if simulations.zero? || simulations > 10000
simulations = 1 if simulations <= 0

if ARGV.length >= 3
  waitlist = ARGV[2].downcase == "y"
else
  puts "Include waitlist in the odds? y/n"
  waitlist = $stdin.gets.chomp.downcase == "y"
end

start = Time.now.to_i

begin
  mc = MonteCarlo.new(year, simulations, waitlist)
rescue StandardError => e
  puts e.message
  return
end

mc.run_simulations
mc.calculate_odds
finish = Time.now.to_i

puts "\nAverage selections:"
pp mc.averages

puts "\nOdds:"
pp mc.odds

puts "\nSeconds taken: #{finish - start}"
