require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    subject(:user) { build(:user) }

    describe "GET #new" do
        it "renders the new template" do
            get :new, params: {}
            expect(response).to render_template(:new)
        end
    end

    describe "POST #create" do
     context "with valid params" do
        it "logs in the user and redirects to the user show page" do
            post :create, params: { user: {
                                            username: "Augustus",
                                            password: "Password"
            } }

            augustus = User.find_by(username: "Augustus")
            expect(response).to redirect_to(user_url(augustus))
            expect(session[:session_token]).to eq(augustus.session_token)
            expect(assigns(:current_user)).to eq(augustus)
        end
     end

     context "with invalid params" do
        it "validates the username and password" do
            post :create, params: { user: {
                                            username: "Augustus"
            } }

            expect(response).to render_template(:new)
            expect(flash[:errors]).to be_present
        end
     end
    end

    describe "GET #show" do  
        context "when logged in" do
            before do
                post :create, params: { user: {
                                                username: "Augustus",
                                                password: "Password"
                } }    
            end
            it "renders the show template" do
                augustus = User.find_by(username: "Augustus")
                get :show, params: { id: augustus.id }

                expect(response).to render_template(:show)
            end
        end

        context "when not logged in" do
            before { user.save! }
            it "redirects to the login page" do
                get :show, params: { id: user.id }

                expect(response).to redirect_to(new_session_url)
            end
        end
    end
end
