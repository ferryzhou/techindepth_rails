class MagzinesController < ApplicationController
  # GET /magzines
  # GET /magzines.json
  def index
    @magzines = Magzine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magzines }
    end
  end

  # GET /magzines/1
  # GET /magzines/1.json
  def show
    @magzine = Magzine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magzine }
    end
  end

  # GET /magzines/new
  # GET /magzines/new.json
  def new
    @magzine = Magzine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magzine }
    end
  end

  # GET /magzines/1/edit
  def edit
    @magzine = Magzine.find(params[:id])
  end

  # POST /magzines
  # POST /magzines.json
  def create
    @magzine = Magzine.new(params[:magzine])

    respond_to do |format|
      if @magzine.save
        format.html { redirect_to @magzine, notice: 'Magzine was successfully created.' }
        format.json { render json: @magzine, status: :created, location: @magzine }
      else
        format.html { render action: "new" }
        format.json { render json: @magzine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magzines/1
  # PUT /magzines/1.json
  def update
    @magzine = Magzine.find(params[:id])

    respond_to do |format|
      if @magzine.update_attributes(params[:magzine])
        format.html { redirect_to @magzine, notice: 'Magzine was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @magzine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magzines/1
  # DELETE /magzines/1.json
  def destroy
    @magzine = Magzine.find(params[:id])
    @magzine.destroy

    respond_to do |format|
      format.html { redirect_to magzines_url }
      format.json { head :ok }
    end
  end
end
