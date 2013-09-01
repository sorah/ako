require 'spec_helper'

describe PaymentsController, clean_db: true do
  let(:valid_attributes) do
    {
      "amount" => "100"
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PaymentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let!(:payment) { create(:payment) }

  describe "GET index" do
    it "assigns all payments as @payments" do
      payment # to create
      get :index, {}, valid_session
      assigns(:payments).should eq([payment])
    end

    it "sorts payments to the later paid first" do
      base = Time.now

      payment.destroy!
      first = create(:payment, paid_at: base + 30)
      last = create(:payment, paid_at: base - 30)
      middle = create(:payment, paid_at: base)

      get :index, {}, valid_session
      expect(assigns(:payments)).to eq([first, middle, last])
    end
  end

  describe "GET show" do
    it "assigns the requested payment as @payment" do
      get :show, {:id => payment.to_param}, valid_session
      assigns(:payment).should eq(payment)
    end
  end

  describe "GET new" do
    it "assigns a new payment as @payment" do
      get :new, {}, valid_session
      assigns(:payment).should be_a_new(Payment)
    end
  end

  describe "GET edit" do
    it "assigns the requested payment as @payment" do
      get :edit, {:id => payment.to_param}, valid_session
      assigns(:payment).should eq(payment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Payment" do
        expect {
          post :create, {:payment => valid_attributes}, valid_session
        }.to change(Payment, :count).by(1)
      end

      it "assigns a newly created payment as @payment" do
        post :create, {:payment => valid_attributes}, valid_session
        assigns(:payment).should be_a(Payment)
        assigns(:payment).should be_persisted
      end

      it "redirects to the created payment" do
        post :create, {:payment => valid_attributes}, valid_session
        response.should redirect_to(Payment.last)
      end
    end

    describe "with invalid params" do
      before do
        Payment.any_instance.stub(:save).and_return(false)
      end

      it "assigns a newly created but unsaved payment as @payment" do
        post :create, {payment: {"amount" => "-1"}}, valid_session
        assigns(:payment).should be_a_new(Payment)
      end

      it "re-renders the 'new' template" do
        post :create, {payment: {"amount" => "-1"}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested payment" do
        # Assuming there are no other payments in the database, this
        # specifies that the Payment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Payment.any_instance.should_receive(:update).with(valid_attributes)
        put :update, {:id => payment.to_param, :payment => valid_attributes}, valid_session
      end

      it "assigns the requested payment as @payment" do
        put :update, {:id => payment.to_param, :payment => valid_attributes}, valid_session
        assigns(:payment).should eq(payment)
      end

      it "redirects to the payment" do
        put :update, {:id => payment.to_param, :payment => valid_attributes}, valid_session
        response.should redirect_to(payment)
      end
    end

    describe "with invalid params" do
      it "assigns the payment as @payment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Payment.any_instance.stub(:save).and_return(false)
        put :update, {:id => payment.to_param, payment: {"amount" => "-1"}}, valid_session
        assigns(:payment).should eq(payment)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Payment.any_instance.stub(:save).and_return(false)
        put :update, {:id => payment.to_param, payment: {"amount" => "-1"}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested payment" do
      expect {
        delete :destroy, {:id => payment.to_param}, valid_session
      }.to change(Payment, :count).by(-1)
    end

    it "redirects to the payments list" do
      delete :destroy, {:id => payment.to_param}, valid_session
      response.should redirect_to(payments_url)
    end
  end

end
