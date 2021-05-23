class EmployeesController < ApplicationController
  def create
    @employee = Employee.new(employee_params)
    respond_to do |format|
      format.html { redirect_to info_path, notice: 'Funcionário adicionado' } if @employee.save
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :job)
  end
end
