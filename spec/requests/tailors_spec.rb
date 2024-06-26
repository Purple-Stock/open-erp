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

RSpec.describe "/tailors", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Tailor. As you add validations to Tailor, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    xit "renders a successful response" do
      Tailor.create! valid_attributes
      get tailors_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    xit "renders a successful response" do
      tailor = Tailor.create! valid_attributes
      get tailor_url(tailor)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    xit "renders a successful response" do
      get new_tailor_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    xit "renders a successful response" do
      tailor = Tailor.create! valid_attributes
      get edit_tailor_url(tailor)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      xit "creates a new Tailor" do
        expect {
          post tailors_url, params: { tailor: valid_attributes }
        }.to change(Tailor, :count).by(1)
      end

      xit "redirects to the created tailor" do
        post tailors_url, params: { tailor: valid_attributes }
        expect(response).to redirect_to(tailor_url(Tailor.last))
      end
    end

    context "with invalid parameters" do
      xit "does not create a new Tailor" do
        expect {
          post tailors_url, params: { tailor: invalid_attributes }
        }.to change(Tailor, :count).by(0)
      end

    
      xit "renders a response with 422 status (i.e. to display the 'new' template)" do
        post tailors_url, params: { tailor: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      xit "updates the requested tailor" do
        tailor = Tailor.create! valid_attributes
        patch tailor_url(tailor), params: { tailor: new_attributes }
        tailor.reload
        skip("Add assertions for updated state")
      end

      xit "redirects to the tailor" do
        tailor = Tailor.create! valid_attributes
        patch tailor_url(tailor), params: { tailor: new_attributes }
        tailor.reload
        expect(response).to redirect_to(tailor_url(tailor))
      end
    end

    context "with invalid parameters" do
    
      xit "renders a response with 422 status (i.e. to display the 'edit' template)" do
        tailor = Tailor.create! valid_attributes
        patch tailor_url(tailor), params: { tailor: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    xit "destroys the requested tailor" do
      tailor = Tailor.create! valid_attributes
      expect {
        delete tailor_url(tailor)
      }.to change(Tailor, :count).by(-1)
    end

    xit "redirects to the tailors list" do
      tailor = Tailor.create! valid_attributes
      delete tailor_url(tailor)
      expect(response).to redirect_to(tailors_url)
    end
  end
end
