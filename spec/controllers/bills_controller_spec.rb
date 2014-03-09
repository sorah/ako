require 'spec_helper'

describe BillsController do
  let(:valid_attributes) { { "amount" => "1" } }
  let(:valid_session) { {} }

  describe "GET index" do
    let(:bill) { Bill.create! valid_attributes }

    it "assigns all bills as @bills" do
      get :index, {}, valid_session
      assigns(:bills).should eq([bill])
    end
  end

  describe "GET show" do
    let(:bill) { Bill.create! valid_attributes }

    it "assigns the requested bill as @bill" do
      get :show, {:id => bill.to_param}, valid_session
      assigns(:bill).should eq(bill)
    end
  end

  describe "GET new" do
    it "assigns a new bill as @bill" do
      get :new, {}, valid_session
      assigns(:bill).should be_a_new(Bill)
    end
  end

  describe "GET edit" do
    let(:bill) { Bill.create! valid_attributes }

    it "assigns the requested bill as @bill" do
      get :edit, {:id => bill.to_param}, valid_session
      assigns(:bill).should eq(bill)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bill" do
        expect {
          post :create, {:bill => valid_attributes}, valid_session
        }.to change(Bill, :count).by(1)
      end

      it "assigns a newly created bill as @bill" do
        post :create, {:bill => valid_attributes}, valid_session
        assigns(:bill).should be_a(Bill)
        assigns(:bill).should be_persisted
      end

      it "redirects to the created bill" do
        post :create, {:bill => valid_attributes}, valid_session
        response.should redirect_to(Bill.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bill as @bill" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bill.any_instance.stub(:save).and_return(false)
        post :create, {:bill => { "amount" => "invalid value" }}, valid_session
        assigns(:bill).should be_a_new(Bill)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bill.any_instance.stub(:save).and_return(false)
        post :create, {:bill => { "amount" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end

    context "with meta" do
      it "creates a new Bill with given JSON" do
        post :create, {bill: {amount: 100, meta: {test: 'hello'}.to_json}}, valid_session

        expect(Bill.last.meta['test']).to eq 'hello'
      end
    end
  end

  describe "PUT update" do
    let!(:bill) { Bill.create! valid_attributes }

    describe "with valid params" do
      it "updates the requested bill" do
        expect {
          put :update, {:id => bill.to_param, :bill => { "amount" => "10" }}, valid_session
        }.to change {
          bill.reload.amount
        }.from(1).to(10)
      end

      it "assigns the requested bill as @bill" do
        put :update, {:id => bill.to_param, :bill => valid_attributes}, valid_session
        assigns(:bill).should eq(bill)
      end

      it "redirects to the bill" do
        put :update, {:id => bill.to_param, :bill => valid_attributes}, valid_session
        response.should redirect_to(bill)
      end
    end

    describe "with invalid params" do
      it "assigns the bill as @bill" do
        Bill.any_instance.stub(:save).and_return(false)
        put :update, {:id => bill.to_param, :bill => { "amount" => "invalid value" }}, valid_session
        assigns(:bill).should eq(bill)
      end

      it "re-renders the 'edit' template" do
        Bill.any_instance.stub(:save).and_return(false)
        put :update, {:id => bill.to_param, :bill => { "amount" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end

    context "with meta" do
      it "creates a new Bill with given JSON" do
        put :update, {id: bill.to_param, bill: {meta: {test: 'hello'}.to_json}}, valid_session

        expect(bill.reload.meta['test']).to eq 'hello'
      end

      context "without meta" do
        before do
          bill.meta['hello'] = 'hola'
          bill.save!
        end

        it "lets meta as is" do
        put :update, {id: bill.to_param, bill: {amount: 10}}, valid_session
          expect(bill.reload.meta['hello']).to eq 'hola'
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bill" do
      bill = Bill.create! valid_attributes
      expect {
        delete :destroy, {:id => bill.to_param}, valid_session
      }.to change(Bill, :count).by(-1)
    end

    it "redirects to the bills list" do
      bill = Bill.create! valid_attributes
      delete :destroy, {:id => bill.to_param}, valid_session
      response.should redirect_to(bills_url)
    end
  end
end
