class ProjectIdeasController < ApplicationController

  get '/project_ideas' do
    @project_entry = ProjectEntry.all
    erb :'project_ideas/index'
  end

  # get journal_entries/new to render a form to create new entry
  get '/project_ideas/new' do
    redirect_if_not_logged_in
    erb :'/project_ideas/new'
  end

  # post journal_entries to create a new journal entry
  post '/project_ideas' do
    redirect_if_not_logged_in
    # I want to create a new journal entry and save it to the DB
    # I also only want to create a journal entry if a user is logged in
    # I only want to save the entry if it has some content
    if params[:content] != ""
      # create a new entry
      @project_entry = ProjectEntry.create(content: params[:content], user_id: current_user.id, title: params[:title], mood: params[:mood])
      flash[:message] = "Project entry successfully created." if @project_entry.id
      redirect "/project_ideas/#{@project_entry.id}"
    else
      flash[:errors] = "Something went wrong - you must provide content for your entry."
      redirect '/project_ideas/new'
    end
  end

  # show route for a journal entry
  get '/project_ideas/:id' do
    set_project_idea_entry
    erb :'/project_ideas/show'
  end


  # *** MAJOR PROBLEMS!!! ***
  # 1. RIGHT NOW, ANYONE CAN EDIT ANYONE ELSE'S JOURNAL ENTRIES!!!!
  # 2. ALSO, I CAN EDIT A JOURNAL ENTRY TO BE BLANK!!!!!

  # This route should send us to journal_entries/edit.erb, which will
  # render an edit form
  get '/project_ideas/:id/edit' do
    redirect_if_not_logged_in
    set_project_entry
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
    set_project_entry
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
    set_project_entry
    if authorized_to_edit?(@project_entry)
      @project_entry.destroy
      flash[:message] = "Successfully deleted that Project."
      redirect '/project_ideas'
    else
      redirect '/project_ideas'
    end
  end
  # index route for all journal entries

  private

  def set_project_entry
    @project_entry = ProjectEntry.find(params[:id])
  end
end
