require 'spec_helper'

describe ExpensesController, clean_db: true do
  let(:valid_attributes) do
    {
      "amount" => "100"
    }
  end

  let(:valid_session) { {} }
  let!(:expense) { create(:expense) }

  describe "GET index" do
    it "assigns all expenses as @expenses" do
      get :index, {}, valid_session
      assigns(:expenses).should eq([expense])
    end

    it "sorts expenses to the later paid first" do
      base = Time.now

      expense.destroy!
      first = create(:expense, paid_at: base + 30)
      last = create(:expense, paid_at: base - 30)
      middle = create(:expense, paid_at: base)

      get :index, {}, valid_session
      expect(assigns(:expenses)).to eq([first, middle, last])
    end
  end

  describe "GET show" do
    it "assigns the requested expense as @expense" do
      get :show, {:id => expense.to_param}, valid_session
      assigns(:expense).should eq(expense)
    end
  end

  describe "GET new" do
    it "assigns a new expense as @expense" do
      get :new, {}, valid_session
      assigns(:expense).should be_a_new(Expense)
    end
  end

  describe "GET edit" do
    it "assigns the requested expense as @expense" do
      get :edit, {:id => expense.to_param}, valid_session
      assigns(:expense).should eq(expense)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Expense" do
        expect {
          post :create, {:expense => valid_attributes}, valid_session
        }.to change(Expense, :count).by(1)
      end

      it "assigns a newly created expense as @expense" do
        post :create, {:expense => valid_attributes}, valid_session
        assigns(:expense).should be_a(Expense)
        assigns(:expense).should be_persisted
      end

      it "redirects to the created expense" do
        post :create, {:expense => valid_attributes}, valid_session
        response.should redirect_to(Expense.last)
      end
    end

    describe "with invalid params" do
      before do
        Expense.any_instance.stub(:save).and_return(false)
      end

      it "assigns a newly created but unsaved expense as @expense" do
        post :create, {expense: {"amount" => "-1"}}, valid_session
        assigns(:expense).should be_a_new(Expense)
      end

      it "re-renders the 'new' template" do
        post :create, {expense: {"amount" => "-1"}}, valid_session
        response.should render_template("new")
      end
    end

    context "with both place_id and place_name" do
      let(:place) { create(:place) }

      it "accepts place_id" do
        post :create, {expense: valid_attributes.merge(place_id: place.id, place_name: 'foo bar')}, valid_session

        expect(Expense.last.place_id).to eq place.id
      end
    end

    context "when XHR" do
      before do
        request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
        request.env['HTTP_ACCEPT'] = 'text/html'
      end

      context "with valid attributes" do
        it "renders card" do
          post :create, {:expense => valid_attributes}, valid_session

          expect(response.code).to eq '200'
          expect(response.content_type).to eq 'application/json'

          expect(response).to render_template(
            '_card',
            locals: { expense: Expense.last },
            layout: false
          )

          json = JSON.parse(response.body)
          expect(json['html']).to be_a_kind_of(String)
          expect(json['success']).to be_true
        end
      end

      context "with invalid attributes" do
        it "renders card" do
          post :create, {:expense => {comment: 'only'}}, valid_session

          expect(response.code).to eq '200'
          expect(response.content_type).to eq 'application/json'

          expect(response).to render_template('_form', layout: false)
          expect(assigns(:expense)).to be_a(Expense)

          json = JSON.parse(response.body)
          expect(json['html']).to be_a_kind_of(String)
          expect(json['success']).to be_false
        end
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested expense" do
        Expense.any_instance.should_receive(:update).with(valid_attributes)
        put :update, {:id => expense.to_param, :expense => valid_attributes}, valid_session
      end

      it "assigns the requested expense as @expense" do
        put :update, {:id => expense.to_param, :expense => valid_attributes}, valid_session
        assigns(:expense).should eq(expense)
      end

      it "redirects to the expense" do
        put :update, {:id => expense.to_param, :expense => valid_attributes}, valid_session
        response.should redirect_to(expense)
      end
    end

    describe "with invalid params" do
      it "assigns the expense as @expense" do
        # Trigger the behavior that occurs when invalid params are submitted
        Expense.any_instance.stub(:save).and_return(false)
        put :update, {:id => expense.to_param, expense: {"amount" => "-1"}}, valid_session
        assigns(:expense).should eq(expense)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Expense.any_instance.stub(:save).and_return(false)
        put :update, {:id => expense.to_param, expense: {"amount" => "-1"}}, valid_session
        response.should render_template("edit")
      end
    end

    context "with both place_id and place_name" do
      let(:place) { create(:place) }

      it "accepts place_id" do
        put :update, {id: expense.id, expense: {place_id: place.id, place_name: 'foo bar'}}, valid_session

        expect(expense.reload.place_id).to eq place.id
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested expense" do
      expect {
        delete :destroy, {:id => expense.to_param}, valid_session
      }.to change(Expense, :count).by(-1)
    end

    it "redirects to the expenses list" do
      delete :destroy, {:id => expense.to_param}, valid_session
      response.should redirect_to(expenses_url)
    end
  end

  describe "#candidates_for_bill" do
    before do
      request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
    end

    let(:bill) { create(:bill) }

    context "when request is not via XHR" do
      before do
        request.env.delete 'HTTP_X_REQUESTED_WITH'
      end

      it "rejects" do
        post :candidates_for_bill, {}, valid_session
        expect(response.code).to eq '400'
      end
    end

    context "with bill_id" do
      context "when bill exists" do
        before do
          create(:expense, amount: 100, paid_at: bill.billed_at)
        end

        it "assigns bill.expense_candidates" do
          post :candidates_for_bill, {bill_id: bill.id}, valid_session
          expect(assigns(:expenses)).to eq bill.expense_candidates
        end
      end

      context "when bill not exists" do
        it "returns 404" do
          id = bill.id
          bill.destroy!

          expect {
            post :candidates_for_bill, {bill_id: id}, valid_session
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    it "renders without layout"

    context "with bill" do
      it "creates temporalily bill"
    end
  end
end
