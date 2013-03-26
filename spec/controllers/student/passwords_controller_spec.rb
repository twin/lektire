require "spec_helper"

describe Student::PasswordsController do
  before(:all) { @student = create(:student) }

  before do
    controller.send(:log_in!, @student)
  end

  describe "#edit" do
    it "renders :edit" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    context "when valid" do
      before do
        Password.any_instance.stub(:valid?).and_return(true)
        Student.any_instance.stub(:update_attributes)
      end

      it "updates the password" do
        Student.any_instance.unstub(:update_attributes)
        expect {
          put :update, password: {new: "secret"}
        }.to change{@student.reload.password_digest}
      end

      it "redirects to profile" do
        put :update
        expect(response).to redirect_to(profile_path)
      end

      it "sets a flash message" do
        put :update
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when invalid" do
      before do
        Password.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @password and its attributes" do
        put :update, password: {old: "secret"}
        expect(assigns(:password)).not_to be_nil
        expect(assigns(:password).old).to eq "secret"
      end

      it "renders :edit" do
        put :update
        expect(response).to render_template(:edit)
      end
    end
  end

  after(:all) { @student.destroy }
end
