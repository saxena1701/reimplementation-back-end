class Api::V1::AssignmentsController < ApplicationController

  # GET /api/v1/assignments
  def index
    assignments = Assignment.all
    render json: assignments
  end

  # GET /api/v1/assignments/:id
  def show
    assignment = Assignment.find(params[:id])
    render json: assignment
  end

  # POST /api/v1/assignments
  def create
    assignment = Assignment.new(assignment_params)
    if assignment.save
      render json: assignment, status: :created
    else
      render json: assignment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/assignments/:id
  def update
    assignment = Assignment.find(params[:id])
    if assignment.update(assignment_params)
      render json: assignment, status: :ok
    else
      render json: assignment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/assignments/:id
  def destroy
    assignment = Assignment.find_by(id: params[:id])
    if assignment
      if assignment.destroy
        render json: { message: "Assignment deleted successfully!" }, status: :ok
      else
        render json: { error: "Failed to delete assignment", details: assignment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Assignment not found" }, status: :not_found
    end
  end
  
  #add participant to assignment
  # input: assignment id
  # output: status code and json of assignment
  def add_participant
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      new_participant = assignment.add_participant(params[:user_id])
      if new_participant.save
        render json: new_participant, status: :ok
      else
        render json: new_participant.errors, status: :unprocessable_entity
      end
    end
  end

  #remove participant from assignment
  # input: user id and assignment id
  # output: status code and json of assignment
  def remove_participant
    user = User.find_by(id: params[:user_id])
    assignment = Assignment.find_by(id: params[:assignment_id])
    if user && assignment
      assignment.remove_participant(user.id)
      if assignment.save
        render json: { message: "Participant removed successfully!" }, status: :ok
      else
        render json: assignment.errors, status: :unprocessable_entity
      end
    else
      not_found_message = user ? "Assignment not found" : "User not found"
      render json: { error: not_found_message }, status: :not_found
    end
  end


  # make course_id of assignment null
  # the method is not working as of now because rails is not allowing the course id to be null
  # input: assignment id
  # output: status code and json of assignment
  def remove_assignment_from_course
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      assignment = assignment.remove_assignment_from_course
      if assignment.valid?
        if assignment.save
          render json: assignment , status: :ok
        else
          render json: assignment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  #update course id of an assignment/ assign the assign to some together course
  # input: assignment id and course id
  # output: status code and json of assignment
  def assign_courses_to_assignment
    assignment = Assignment.find_by(id: params[:assignment_id])
    course = Course.find(params[:course_id])
    if assignment && course
      assignment = assignment.assign_courses_to_assignment(course.id)
      if assignment.save
        render json: assignment, status: :ok
      else
        render json: assignment.errors, status: :unprocessable_entity
      end
    else
      not_found_message = course ? "Assignment not found" : "Course not found"
      render json: { error: not_found_message }, status: :not_found
    end
  end

  #copy existing assignment
  # input: assignment id
  # output: status code and json of assignment
  def copy_assignment
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      new_assignment = assignment.copy_assignment
      if new_assignment.save
        render json: new_assignment, status: :ok
      else
        render json :new_assignment.errors, status: :unprocessable_entity
      end
    end
  end

  # check if assignment has badge
  # input: assignment id
  # output: boolean value of has_badge field in assignment table
  # true is assignment has badge
  def has_badge
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.has_badge?, status: :ok
    end
  end

  # check if assignment has pair programming enabled
  # input: assignment id
  # output: boolean value of enable_pair_programming field in assignment table
  # true if pair programming is enabled
  def pair_programming_enabled
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.pair_programming_enabled?, status: :ok
    end
  end

  # check if assignment has topics
  # input: assignment id
  # output: boolean value of has_topics field in assignment table 
  # has_topics is set to true if there is SignUpTopic corresponding to the input assignment id 
  def has_topics
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.topics?, status: :ok
    end
  end

  # check if assignment is a team assignment 
  # input: assignment id
  # output: boolean value of max_team_size field in assignment table
  # true if assignment's max team size is greater than 1
  def team_assignment
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.team_assignment?, status: :ok
    end
  end

  # check if assignment has valid number of reviews
  # input: assignment id
  # output: boolean value which is true if number of allowed reviews are 
  # greater than required reviews for a valid review type
  def valid_num_review
    assignment = Assignment.find_by(id: params[:assignment_id])
    review_type = params[:review_type]
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.valid_num_review(review_type), status: :ok
    end
  end

  # check if assignment is calibrated 
  # input: assignment id
  # output: boolean value of is_calibrated field in assignment table
  # true if assignment is calibrated
  def is_calibrated
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.is_calibrated? , status: :ok
    end
  end

  # check if assignment has teams
  # input: assignment id
  # output: boolean value of has_teams field in assignment table
  # true if there exists a team corresponding to the input assignment id
  def has_teams
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.teams?, status: :ok
    end
  end

  # check if assignment is staggered and has no assigned topic for current user
  # input: assignment id
  # output: boolean value 
  # true if staggered_deadline field of assignment table is set to true and 
  # if it has no topics associated with the current user
  def staggered_and_no_topic
    assignment = Assignment.find_by(id: params[:assignment_id])
    topic_id = SignedUpTeam
                 .joins(team: :teams_users)
                 .where(teams_users: { user_id: 1, team_id: Team.where(assignment_id: params[:assignment_id]).pluck(:id) })
                 .pluck(:sign_up_topic_id).first
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      render json: assignment.staggered_and_no_topic?(topic_id), status: :ok
    end
  end

  # create notes for assignment 
  # input: assignment id
  # output: returns the created node
  def create_node
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      node = assignment.create_node
      render json: node, status: :ok
    end
  end

  # check if assignment has varying rubric across rounds
  # input: assignment id
  # output: boolean value indicating if rubric varies or not
  # set to true if rubrics vary across rounds in assignment else false
  def varying_rubrics_by_round?
    assignment = Assignment.find_by(id: params[:assignment_id])
    if assignment.nil?
      render json: { error: "Assignment not found" }, status: :not_found
    else
      if AssignmentQuestionnaire.exists?(assignment_id: assignment.id)
        render json: assignment.varying_rubrics_by_round?, status: :ok
      else
        render json: { error: "No questionnaire/rubric exists for this assignment." }, status: :not_found
      end
    end
  end
  
  private
  # Only allow a list of trusted parameters through.
  def assignment_params
    params.require(:assignment).permit(:title, :description)
  end
end