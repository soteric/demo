class HomeController < ApplicationController
include Versionone

  def index
  end

  def backlog
    sprint = params[:sprint]
    print "sprint = ", sprint, "\n"
    @release = Release.find_by_name("b1508")
    @title = @release.name + " Talent V1 Backlog Status"
  	@projects = Project.where(:release_id => @release.id)
  	@categories = []
  	@not_started, @dev_in_progress, @qa_in_progress, @completed = [], [], [], []
    
    @projects.each do |p|
      @categories << p.team.name.upcase
      
      xmldoc = get_backlog_report_by_query("/vone/rest-1.v1/Data/Story?Sel=SecurityScope.Name,SecurityScope,IsClosed,Status.Name,Timebox.Name&Where=SecurityScope=\"Scope:" + p.scope_id.to_s + "\"")
  		tmp_not_started, tmp_dev, tmp_qa, tmp_completed = calculate_data_by_xml(xmldoc, sprint)
      print tmp_not_started, tmp_dev, tmp_qa, tmp_completed

      @not_started << tmp_not_started
      @dev_in_progress << tmp_dev
      @qa_in_progress << tmp_qa
      @completed << tmp_completed
    end
  end
end

