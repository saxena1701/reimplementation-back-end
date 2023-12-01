require "swagger_helper"

RSpec.describe "api/v1/assignments_controller", type: :request do
  path "/api/v1/assignments/{assignment_id}/add_participant" do
    post "Add Participant to Assignment" do
      tags "Assignments"
      consumes "application/json"
      produces "application/json"
      parameter name: :assignment_id, in: :path, type: :integer, required: true
      parameter name: :user_id, in: :query, type: :integer, required: true

      response "200", "participant added successfully" do
        let(:assignment_id) { Assignment.first.id }
        let(:user_id) { User.first.id }
        run_test!
      end

      response "404", "assignment not found" do
        let(:assignment_id) { 999 } # Non-existent assignment ID
        let(:user_id) { User.first.id }
        run_test!
      end

      response "422", "unprocessable entity" do
        let(:assignment_id) { Assignment.first.id }
        let(:user_id) { nil } # Invalid user_id
        run_test!
      end
    end
  end
end
