require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    subject(:user){ build(:user) }
    
    describe "GET #new" do
        it "renders the new template" do
            get :new, params: {}
            expect(response).to render_template(:new)
        end
    end

    describe "POST #create" do
        before { user.save! }
        context "with valid params" do
            it "logs in the user and redirects to the user show page" do
                post :create, params: { user: {
                                                username: "Caligula",
                                                password: "Password"
                } }

                expect(session[:session_token]).to eq(user.session_token)
                expect(response).to redirect_to(user_url(user))
            end
        end

        context "with invalid params" do
            it "validates the params" do
                post :create, params: { user: {
                                                username: "NotCaligula",
                                                password: "NotPassword"
                } }

                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end
        end
    end
end
