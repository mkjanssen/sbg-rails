class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:show, :edit, :update, :destroy, :print, :solutions]
  before_action :set_course

  # GET /assessments
  # GET /assessments.json
  def index
    @assessments = Assessment
      .where(course:@course)
  end

  # GET /assessments/1
  # GET /assessments/1.json
  def show
  end

  # GET /assessments/1/print.tex
  def print
    @exercise_versions = ExerciseVersion
      .includes(:exercise, :students, covered_standard: :standard)
      .where(covered_standards: {assessment: @assessment})
    @students = Student.where(course:@course)
  end

  # GET /assessments/1/print/solutions.tex
  def solutions
  end

  # GET /assessments/new
  def new
    if (assessments = Assessment.where(course: @course)).length > 0
      last_tex_header = assessments.last.tex_header
    else
      last_tex_header = ''
    end
    @assessment = Assessment.new(
      course: @course,
      tex_header: last_tex_header
    )
  end

  # # GET /assessments/1/edit
  def edit
    render status: :not_implemented, text: "Not implemented"
  end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = Assessment.new(assessment_params)

    respond_to do |format|
      if @assessment.save
        format.html { redirect_to [@course, @assessment], notice: 'Assessment was successfully created.' }
        format.json { render :show, status: :created, location: @assessment }
      else
        format.html { render :new }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assessments/1
  # PATCH/PUT /assessments/1.json
  def update
    respond_to do |format|
      if @assessment.update(assessment_params)
        format.html { redirect_to [@course, @assessment], notice: 'Attempt was successfully updated.' }
        format.json { render :show, status: :ok, location: @assessment }
      else
        format.html { render :edit }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to course_assessments_url(@course), notice: 'Attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment
      @assessment = Assessment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_params
      params.require(:assessment).permit(:name, :tex_header, standard_ids: []).merge(course:@course)
    end
end
