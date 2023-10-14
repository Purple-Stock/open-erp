# app/helpers/shein_orders_helper.rb

module SheinOrdersHelper
  def time_remaining(shein_order)
    collection_deadline = DateTime.parse(shein_order.data['Limite de tempo para coletar']) rescue nil
    
    if collection_deadline
      time_remaining = collection_deadline - DateTime.now
      days_remaining = time_remaining.to_i
      hours_remaining = (time_remaining % 1 * 24).to_i
      minutes_remaining = (time_remaining * 24 % 1 * 60).to_i

      # Add a negative sign if the time remaining is negative
      sign = time_remaining.negative? ? "-" : ""
      
      "#{sign}#{days_remaining.abs}d #{hours_remaining.abs}h #{minutes_remaining.abs}m"
    else
      "Invalid Date"
    end
  end

  def order_status(shein_order)
    collection_deadline = DateTime.parse(shein_order.data['Limite de tempo para coletar']) rescue nil
    
    if collection_deadline
      time_remaining = collection_deadline - DateTime.now
      time_remaining.negative? ? "Atrasado" : "Em dia"
    else
      "Invalid Date"
    end
  end
end
