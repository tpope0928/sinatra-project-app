class ProjectIdeasController < ApplicationController

  get '/project_ideas' do
    @project_ideas = ProjectIdea.all
    erb :'project_ideas/index'
  end

  get '/project_ideas/new' do
    redirect_if_not_logged_in
    erb :'/project_ideas/new'
  end

  post '/project_ideas' do
    redirect_if_not_logged_in
    if params[:content] != ""
      # create a new entry
      @project_entry = ProjectIdea.create(content: params[:content], user_id: current_user.id, title: params[:title], mood: params[:mood])
      flash[:message] = "Project Idea successfully created." if @project_entry.id
      redirect "/project_ideas/#{@project_entry.id}"
    else
      flash[:errors] = "Something went wrong - you must provide content for your idea."
      redirect '/project_ideas/new'
    end
  end

  # show route for a journal entry
  get '/project_ideas/:id' do
    set_project_idea
    erb :'/project_ideas/show'
  end

  get '/journal_entries/:id/edit' do
    redirect_if_not_logged_in
    set_project_idea
    if authorized_to_edit?(@project_entry)
      erb :'/project_ideas/edit'
    else
      redirect "users/#{current_user.id}"
    end
  end

  # This action's job is to ...???
  patch '/project_ideas/:id' do
    redirect_if_not_logged_in
    # 1. find the journal entry
    set_project_idea
    if @project_entry.user == current_user && params[:content] != ""
    # 2. modify (update) the journal entry
      @project_entry.update(content: params[:content])
      # 3. redirect to show page
      redirect "/project_ideas/#{@project_entry.id}"
    else
      redirect "users/#{current_user.id}"
    end
  end

  delete '/project_ideas/:id' do
    set_project_idea
    if authorized_to_edit?(@project_entry)
      @project_entry.destroy
      flash[:message] = "Successfully deleted that idea."
      redirect '/project_ideas'
    else
      redirect '/project_ideas'
    end
  end
  # index route for all journal entries

  private

  def set_project_idea
    @project_entry = ProjectIdea.find(params[:id])
  end
end
