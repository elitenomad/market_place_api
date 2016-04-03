require 'rails_helper'

describe Api::V1::UsersController do
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "Post #create" do

    context "when successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the json response just created for the user ' do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { is_expected.to respond_with 201}
    end
  end

  describe "Patch #update" do

    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        request.headers['Authorization'] =  @user.auth_token
        patch :update, { id: @user.id, user: { email: 'xyz@simple.com'} }, format: :json
      end

      it "renders the json representation for the updated user" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql "xyz@simple.com"
      end

      it { is_expected.to respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        request.headers['Authorization'] =  @user.auth_token
        patch :update, { id: @user.id,
                         user: { email: "bademail.com" } }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "Delete #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
      delete :destroy, {id: @user.id }, format: :json
    end

    it { is_expected.to respond_with 204 }
  end
end