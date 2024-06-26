require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/productions", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Production. As you add validations to Production, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    xit "renders a successful response" do
      Production.create! valid_attributes
      get productions_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    xit "renders a successful response" do
      production = Production.create! valid_attributes
      get production_url(production)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    xit "renders a successful response" do
      get new_production_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    xit "renders a successful response" do
      production = Production.create! valid_attributes
      get edit_production_url(production)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      xit "creates a new Production" do
        expect {
          post productions_url, params: { production: valid_attributes }
        }.to change(Production, :count).by(1)
      end

      xit "redirects to the created production" do
        post productions_url, params: { production: valid_attributes }
        expect(response).to redirect_to(production_url(Production.last))
      end
    end

    context "with invalid parameters" do
      xit "does not create a new Production" do
        expect {
          post productions_url, params: { production: invalid_attributes }
        }.to change(Production, :count).by(0)
      end

    
      xit "renders a response with 422 status (i.e. to display the 'new' template)" do
        post productions_url, params: { production: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      xit "updates the requested production" do
        production = Production.create! valid_attributes
        patch production_url(production), params: { production: new_attributes }
        production.reload
        skip("Add assertions for updated state")
      end

      xit "redirects to the production" do
        production = Production.create! valid_attributes
        patch production_url(production), params: { production: new_attributes }
        production.reload
        expect(response).to redirect_to(production_url(production))
      end
    end

    context "with invalid parameters" do
    
      xit "renders a response with 422 status (i.e. to display the 'edit' template)" do
        production = Production.create! valid_attributes
        patch production_url(production), params: { production: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    xit "destroys the requested production" do
      production = Production.create! valid_attributes
      expect {
        delete production_url(production)
      }.to change(Production, :count).by(-1)
    end

    xit "redirects to the productions list" do
      production = Production.create! valid_attributes
      delete production_url(production)
      expect(response).to redirect_to(productions_url)
    end
  end
end
