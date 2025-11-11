require 'json'

class MonteCarlo
  attr_reader :entrants
  attr_reader :selected_entrants
  attr_reader :averages
  attr_reader :odds

  def initialize(year = 2025, simulations = 1000, waitlist = true)
    @year = year.to_i
    @simulations = simulations.to_i
    @waitlist = !!waitlist

    json_data = JSON.parse(File.read("years/#{@year}.json"))
    @entrants = json_data["entrants"]
    @waitlist_size = json_data["waitlist"] || 0
    @auto_waitlist = json_data["auto_waitlist"]
    @total_picks = json_data["total_picks"]
    @total_picks += @waitlist_size if @waitlist

    set_all_tickets

    # Stores sum of all selected entrants for all simulations
    @selected_entrants = new_entrants_list
  end

  def run_simulations
    num_entrants = @entrants.reduce(0) { |sum, x| sum = sum + x[1] }
    puts "\nRunning #{@simulations} simulations for #{@year} with waitlist#{@waitlist ? '' : ' not'} included"
    puts "\nEntrant Data: #{num_entrants} entrants and #{@all_tickets.size} tickets for #{@total_picks} spots"

    @simulations.times do
      tickets_left = Marshal.load(Marshal.dump(@all_tickets))
      picks_left = @total_picks

      while picks_left > 0 do
        # When we get to the waitlist, add the auto waitlist entrants starting with the entrants
        # with the most tickets
        if picks_left == @waitlist_size && @auto_waitlist > 0 && @waitlist
          auto_tickets = @entrants.keys.map(&:to_i).max
          loop do
            num_auto_tickets = tickets_left.values.count(auto_tickets)
            num_auto_entrants = [num_auto_tickets / auto_tickets, picks_left].min
            @selected_entrants[auto_tickets.to_s] += num_auto_entrants
            picks_left -= num_auto_entrants
            tickets_left.delete_if { |_, v| v == auto_tickets }
            auto_tickets /= 2
            break if auto_tickets < @auto_waitlist
          end
        end

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
