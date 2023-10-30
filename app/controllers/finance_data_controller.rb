class FinanceDataController < ApplicationController
  before_action :set_finance_data, only: [:show, :edit, :update, :destroy]

  def index
    @finance_data = FinanceDatum.all
  end
  
  def show
  end
  
  def new
    @finance_data = FinanceDatum.new
  end
  
  def create
    @finance_data = FinanceDatum.new(finance_data_params)
    if @finance_data.save
      redirect_to @finance_data, notice: 'Finance Data was successfully created.'
    else
      render :new
    end
  end
  
  def edit; end
  
  def update
    if @finance_data.update(finance_data_params)
      redirect_to @finance_data, notice: 'Finance Data was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @finance_data.destroy
    redirect_to finance_data_url, notice: 'Finance Data was successfully destroyed.'
  end

  def upload; end

  def import
    if params[:file].present?
      # Process the file and save data
      process_and_save_file(params[:file])
      redirect_to finance_data_path, notice: 'Finance Data was successfully uploaded.'
    else
      redirect_to finance_data_path, alert: 'No file selected.'
    end
  end

  private

  def process_and_save_file(file)
    # Function to convert date from Portuguese to English format
    def convert_date(date_str)
      portuguese_to_english_months = {
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
      
      portuguese_to_english_months.each do |pt_month, en_month|
        if date_str.include?(pt_month)
          return Date.strptime(date_str.gsub(pt_month, en_month), '%d %B %Y')
        end
      end
      nil
    end
    
    # Load the Excel file from the uploaded file
    xlsx = Roo::Spreadsheet.open(file)
  
    # Get the first sheet
    sheet = xlsx.sheet(0)
  
    # Process the data
    results = {}
  
    # Skip the first two rows (headers) and iterate through each row
    sheet.each_row_streaming(offset: 2) do |row|
      date_str = row[6].to_s  # Adjust the index based on your Excel file structure
  
      # Check if the cell value is numeric before converting to float
      value_str = row[18].to_s.gsub('BRL ', '')  # Remove the currency symbol
      next unless value_str.match?(/\A-?\d+(\.\d+)?\z/)  # Skip the row if the value is not numeric
  
      value = value_str.to_f
  
      # Convert the date from Portuguese to English format
      date = convert_date(date_str)
  
      # Skip the row if the date conversion fails
      next if date.nil?
  
      # Initialize the results for this date if it doesn't exist
      results[date] ||= { 'Renda' => 0, 'Despesa' => 0, 'Montante Fixo' => 0 }
  
      if value.positive?
        results[date]['Renda'] += value
      else
        results[date]['Despesa'] += value
      end
      results[date]['Montante Fixo'] += value
    end
    #byebug
    # Save the results into the database
    results.each do |date, data|
      FinanceDatum.create(date: date, income: data['Renda'], expense: data['Despesa'], fixed_amount: data['Montante Fixo'])
    end
  end
  
  def set_finance_data
    @finance_data = FinanceDatum.find(params[:id])
  end
  
  def finance_data_params
    params.require(:finance_data).permit(data: {})
  end

end
