require 'json'

class MonteCarlo
  attr_reader :entrants
  attr_reader :selected_entrants
  attr_reader :averages
  attr_reader :odds

  def initialize(simulations = 1000, waitlist = true)
    @simulations = simulations
    @total_picks = 270
    @total_picks += 75 if waitlist

    @entrants = JSON.parse(File.read("years/2025.json"))

    set_all_tickets

    # Stores sum of all selected entrants for all simulations
    @selected_entrants = new_entrants_list
  end

  def run_simulations
    puts "Running #{@simulations} simulations"

    @simulations.times do
      tickets_left = Marshal.load(Marshal.dump(@all_tickets))
      picks_left = @total_picks

      while picks_left > 0 do
        # Select a random ticket
        num_to_remove = tickets_left[tickets_left.keys.sample]
        @selected_entrants[num_to_remove.to_s] += 1

        # Remove appropriate tickets from pool
        removals = 0
        tickets_left.each do |ticket_no, ticket_type|
          if ticket_type == num_to_remove
            removals += 1
            tickets_left.delete(ticket_no)
            break if removals >= num_to_remove
          end
        end

        picks_left -= 1
      end
    end
  end

  def calculate_odds
    calculate_averages

    @odds = {}
    @entrants.each do |key, val|
      @odds[key] = (100 * @averages[key] / val).round(2)
    end

    @odds
  end

  private

  def calculate_averages
    @averages = new_entrants_list(true)

    @selected_entrants.each do |key, val|
      @averages[key] = val.to_f / @simulations
    end

    @averages
  end

  def set_all_tickets
    cnt = 0
    @all_tickets = {}

    # Add each individual ticket to the pool
    @entrants.each do |key, num|
      num_tickets = num * key.to_i
      num_tickets.times do
        @all_tickets.merge!({cnt => key.to_i})
        cnt += 1
      end
    end
  end

  def new_entrants_list(as_double = false)
    entrants_list = {}
    @entrants.each do |key, _|
      entrants_list[key] = as_double ? 0.0 : 0
    end
    entrants_list
  end
end
