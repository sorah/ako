require 'spec_helper'

describe AccountsController do
  let(:valid_attributes) { { "name" => "MyString" } }
  let(:valid_session) { {} }

  describe "GET index" do
    let(:account) { Account.create! valid_attributes }

    it "assigns all accounts as @accounts" do
      get :index, {}, valid_session
      assigns(:accounts).should eq([account])
    end
  end

  describe "GET show" do
    let(:account) { Account.create! valid_attributes }

    it "assigns the requested account as @account" do
      get :show, {:id => account.to_param}, valid_session
      assigns(:account).should eq(account)
    end
  end

  describe "GET new" do

    it "assigns a new account as @account" do
      get :new, {}, valid_session
      assigns(:account).should be_a_new(Account)
    end
  end

  describe "GET edit" do
    let(:account) { Account.create! valid_attributes }

    it "assigns the requested account as @account" do
      get :edit, {:id => account.to_param}, valid_session
      assigns(:account).should eq(account)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Account" do
        expect {
          post :create, {:account => valid_attributes}, valid_session
        }.to change(Account, :count).by(1)
      end

      it "assigns a newly created account as @account" do
        post :create, {:account => valid_attributes}, valid_session
        assigns(:account).should be_a(Account)
        assigns(:account).should be_persisted
      end

      it "redirects to the created account" do
        post :create, {:account => valid_attributes}, valid_session
        response.should redirect_to(Account.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved account as @account" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        post :create, {:account => { "name" => "invalid value" }}, valid_session
        assigns(:account).should be_a_new(Account)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        post :create, {:account => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:account) { Account.create! valid_attributes }

    describe "with valid params" do
      it "updates the requested account" do
        Account.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => account.to_param, :account => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested account as @account" do
        put :update, {:id => account.to_param, :account => valid_attributes}, valid_session
        assigns(:account).should eq(account)
      end

      it "redirects to the account" do
        put :update, {:id => account.to_param, :account => valid_attributes}, valid_session
        response.should redirect_to(account)
      end
    end

    describe "with invalid params" do
      it "assigns the account as @account" do
        Account.any_instance.stub(:save).and_return(false)
        put :update, {:id => account.to_param, :account => { "name" => "invalid value" }}, valid_session
        assigns(:account).should eq(account)
      end

      it "re-renders the 'edit' template" do
        Account.any_instance.stub(:save).and_return(false)
        put :update, {:id => account.to_param, :account => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:account) { Account.create! valid_attributes }

    it "destroys the requested account" do
      expect {
        delete :destroy, {:id => account.to_param}, valid_session
      }.to change(Account, :count).by(-1)
    end

    it "redirects to the accounts list" do
      delete :destroy, {:id => account.to_param}, valid_session
      response.should redirect_to(accounts_url)
    end
  end
end
