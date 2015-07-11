class SubphezesController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show, :latest]
  before_action :set_subphez, only: [:edit, :update, :destroy]

  # GET /subphezs
  # GET /subphezs.json
  def index
    @subphezes = Subphez.all
  end

  # GET /subphezs/1
  # GET /subphezs/1.json
  def show
    @subphez = Subphez.by_path(params[:path])
    if @subphez.nil?
      redirect_to :back, alert: 'Could not find subphez.'
    end
    @posts = @subphez.posts.by_hot_score.paginate(:page => params[:page])
  end

  def latest
    @subphez = Subphez.by_path(params[:path])
    if @subphez.nil?
      redirect_to :back, alert: 'Could not find subphez.'
    end
    @posts = @subphez.posts.latest.paginate(:page => params[:page])
  end

  # GET /subphezs/new
  def new
    @subphez = Subphez.new
  end

  # GET /subphezs/1/edit
  def edit
  end

  # POST /subphezs
  # POST /subphezs.json
  def create
    @subphez = Subphez.new(subphez_params)
    @subphez.user_id = current_user.id
    respond_to do |format|
      if @subphez.save
        format.html { redirect_to view_subphez_path(:path => @subphez.path), notice: 'Subphez was successfully created.' }
        format.json { render :show, status: :created, location: @subphez }
      else
        format.html { render :new }
        format.json { render json: @subphez.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subphezs/1
  # PATCH/PUT /subphezs/1.json
  def update
    respond_to do |format|
      if @subphez.update(subphez_params)
        format.html { redirect_to view_subphez_path(:path => @subphez.path), notice: 'Subphez was successfully updated.' }
        format.json { render :show, status: :ok, location: @subphez }
      else
        format.html { render :edit }
        format.json { render json: @subphez.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subphezs/1
  # DELETE /subphezs/1.json
  # def destroy
  #   @subphez.destroy
  #   respond_to do |format|
  #     format.html { redirect_to subphezs_url, notice: 'Subphez was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subphez
      @subphez = Subphez.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subphez_params
      params.require(:subphez).permit(:path, :title, :sidebar)
    end
end
