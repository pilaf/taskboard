class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.all()
    @members = Member.all()

    if(params[:project])
	@project = Project.find(params[:project])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new
          
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    if(params[:dynamic])
      @team.save
      render :inline => "<script>location.reload(true);</script>"
    else
      respond_to do |format|
        if @team.save
	  flash[:notice] = 'Team was successfully created.'
	  format.html { redirect_to(@team) }
	  format.xml  { render :xml => @team, :status => :created, :location => @team }
        else
	  format.html { render :action => "new" }
          format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])

    if(params[:dynamic])
      @team.update_attributes(params[:team])
      render :inline => "<script>location.reload(true);</script>"
    else
      respond_to do |format|
        if @team.update_attributes(params[:team])
          flash[:notice] = 'Team was successfully updated.'
          format.html { redirect_to(@team) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end

  def manage_members
    @team = Team.find(params[:id])
  end

  def add_member_to_team
    @team = Team.find(params[:id])
    @members = Member.find(:all).collect { |project| [project.name, project.id] }
  end

  def add_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    if !@team.members.exists?(@member)
      @team.members << @member
      @team.save
    end
    render :update do |page|
      page.replace_html "team-members-list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
    end
  end

  def remove_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    if @team.members.exists?(@member)
      @team.members.delete(@member)
      @team.save
    end
    render :update do |page|
      page.replace_html "team-members-list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
    end
  end
  
  def show_form
    if(params[:team])
	@team = Team.find(params[:team])
    else
	@team = Team.new
    end
    @project = Project.find(params[:project]) if (params[:project])

    render :update do |page|
	if @project       
		page.replace_html "dummy-for-actions", 
			:partial => 'form', 
			:locals => { 
				:team => @team, 
				:project =>  @project 
			}
	else
		page.replace_html "dummy-for-actions", 
			:partial => 'form', 
				:locals => { :team => @team }
	end		
    end
  end


end