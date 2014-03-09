require 'spec_helper'

describe PlacesController do
  let(:valid_attributes) { { "name" => "MyString" } }
  let(:valid_session) { {} }

  describe "GET index" do
    let!(:place) { Place.create! valid_attributes }

    it "assigns all places as @places" do
      get :index, {}, valid_session
      assigns(:places).should eq([place])
    end
  end

  describe "GET show" do
    let(:place) { Place.create! valid_attributes }

    it "assigns the requested place as @place" do
      get :show, {:id => place.to_param}, valid_session
      assigns(:place).should eq(place)
    end
  end

  describe "GET new" do
    it "assigns a new place as @place" do
      get :new, {}, valid_session
      assigns(:place).should be_a_new(Place)
    end
  end

  describe "GET edit" do
    let(:place) { Place.create! valid_attributes }

    it "assigns the requested place as @place" do
      get :edit, {:id => place.to_param}, valid_session
      assigns(:place).should eq(place)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Place" do
        expect {
          post :create, {:place => valid_attributes}, valid_session
        }.to change(Place, :count).by(1)
      end

      it "assigns a newly created place as @place" do
        post :create, {:place => valid_attributes}, valid_session
        assigns(:place).should be_a(Place)
        assigns(:place).should be_persisted
      end

      it "redirects to the created place" do
        post :create, {:place => valid_attributes}, valid_session
        response.should redirect_to(Place.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved place as @place" do
        # Trigger the behavior that occurs when invalid params are submitted
        Place.any_instance.stub(:save).and_return(false)
        post :create, {:place => { "name" => "invalid value" }}, valid_session
        assigns(:place).should be_a_new(Place)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Place.any_instance.stub(:save).and_return(false)
        post :create, {:place => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:place) { Place.create! valid_attributes }

    describe "with valid params" do
      it "updates the requested place" do
        Place.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => place.to_param, :place => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested place as @place" do
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        assigns(:place).should eq(place)
      end

      it "redirects to the place" do
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        response.should redirect_to(place)
      end
    end

    describe "with invalid params" do
      it "assigns the place as @place" do
        Place.any_instance.stub(:save).and_return(false)
        put :update, {:id => place.to_param, :place => { "name" => "invalid value" }}, valid_session
        assigns(:place).should eq(place)
      end

      it "re-renders the 'edit' template" do
        Place.any_instance.stub(:save).and_return(false)
        put :update, {:id => place.to_param, :place => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:place) { Place.create! valid_attributes }

    it "destroys the requested place" do
      expect {
        delete :destroy, {:id => place.to_param}, valid_session
      }.to change(Place, :count).by(-1)
    end

    it "redirects to the places list" do
      delete :destroy, {:id => place.to_param}, valid_session
      response.should redirect_to(places_url)
    end
  end

  describe "GET candidates_for_expense" do
    it "renders candidates for expense" do
      a = create(:place, name: 'aab')
      b = create(:place, name: 'abb')
      c = create(:place, name: 'abc')

      post :candidates_for_expense, {name: 'ab'}, valid_session

      expect(assigns(:places)).to eq [b,c]
      expect(response).to render_template("candidates_for_expense")
    end
  end
end
