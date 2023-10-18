# app/helpers/shein_orders_helper.rb

module SheinOrdersHelper
  def time_remaining(shein_order)
    collection_deadline = parse_portuguese_date(shein_order.data['Limite de tempo para coletar'])
    
    if collection_deadline
      # Adjust the time zone difference to +3 hours (180 minutes)
      time_difference = collection_deadline.to_i - Time.zone.now.to_datetime.to_i + (3 * 60 * 60)

      # Calculate days, hours, and minutes
      days_remaining = time_difference / (24 * 60 * 60)
      hours_remaining = (time_difference % (24 * 60 * 60)) / (60 * 60)
      minutes_remaining = (time_difference % (60 * 60)) / 60

      # Add a negative sign if the time remaining is negative
      sign = time_difference.negative? ? "-" : ""

      # Format the result
      formatted_result = "#{sign}#{days_remaining.abs}d #{hours_remaining.abs}h #{minutes_remaining.abs}m"
    else
      "Invalid Date"
    end
  end

  def order_status(shein_order)
    collection_deadline = parse_portuguese_date(shein_order.data['Limite de tempo para coletar'])
    
    if collection_deadline
      time_remaining = collection_deadline - Time.zone.now.to_datetime
      time_remaining.negative? ? "Atrasado" : "Em dia"
    else
      "Invalid Date"
    end
  end

  private

  def parse_portuguese_date(portuguese_date_string)
    # Define a hash to map Portuguese month names to English
    month_translation = {
      'janeiro' => 'January',
      'fevereiro' => 'February',
      'março' => 'March',
      'abril' => 'April',
      'maio' => 'May',
      'junho' => 'June',
      'julho' => 'July',
      'agosto' => 'August',
      'setembro' => 'September',
      'outubro' => 'October',
      'novembro' => 'November',
      'dezembro' => 'December'
    }

    # Split the input Portuguese date string into day, month, year, and time parts
    parts = portuguese_date_string.split

    # Translate the Portuguese month name to English
    english_month = month_translation[parts[1]]

    # Create a new date string with the English month name
    english_date_string = "#{parts[0]} #{english_month} #{parts[2]} #{parts[3]}"

    # Parse the English date string into a DateTime object
    DateTime.parse(english_date_string)
  rescue
    nil
  end
end
