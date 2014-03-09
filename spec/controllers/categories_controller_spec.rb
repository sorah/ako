require 'spec_helper'

describe CategoriesController do
  let(:valid_attributes) { { "name" => "MyString" } }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all categories as @categories" do
      category = create(:category)
      get :index, {}, valid_session
      assigns(:categories).should eq([category])
    end

    it "considers order attribute" do
      category_b = create(:category, order: 1)
      category_c = create(:category, order: 2)
      category_a = create(:category, order: 0)

      categories = [category_a, category_b, category_c]

      get :index, {}, valid_session
      assigns(:categories).should eq(categories)
    end
  end

  describe "GET show" do
    let(:category) { Category.create! valid_attributes }

    it "assigns the requested category as @category" do
      get :show, {:id => category.to_param}, valid_session
      assigns(:category).should eq(category)
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new, {}, valid_session
      assigns(:category).should be_a_new(Category)
    end
  end

  describe "GET edit" do
    let(:category) { Category.create! valid_attributes }

    it "assigns the requested category as @category" do
      get :edit, {:id => category.to_param}, valid_session
      assigns(:category).should eq(category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, {:category => valid_attributes}, valid_session
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, {:category => valid_attributes}, valid_session
        assigns(:category).should be_a(Category)
        assigns(:category).should be_persisted
      end

      it "redirects to the created category" do
        post :create, {:category => valid_attributes}, valid_session
        response.should redirect_to(Category.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        post :create, {:category => { "name" => "invalid value" }}, valid_session
        assigns(:category).should be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        post :create, {:category => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:category) { Category.create! valid_attributes }

    describe "with valid params" do
      it "updates the requested category" do
        Category.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => category.to_param, :category => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested category as @category" do
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        assigns(:category).should eq(category)
      end

      it "redirects to the category" do
        put :update, {:id => category.to_param, :category => valid_attributes}, valid_session
        response.should redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        Category.any_instance.stub(:save).and_return(false)
        put :update, {:id => category.to_param, :category => { "name" => "invalid value" }}, valid_session
        assigns(:category).should eq(category)
      end

      it "re-renders the 'edit' template" do
        Category.any_instance.stub(:save).and_return(false)
        put :update, {:id => category.to_param, :category => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:category) { Category.create! valid_attributes }

    it "destroys the requested category" do
      expect {
        delete :destroy, {:id => category.to_param}, valid_session
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      delete :destroy, {:id => category.to_param}, valid_session
      response.should redirect_to(categories_url)
    end
  end

end
