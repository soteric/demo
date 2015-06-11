require 'ntlm'
require 'net/http'
require 'rexml/document'
include REXML

module Versionone
	def get_backlog_report_by_query(query)
		xmlfile = v1_query(query)
		status_list = ['']
		xmlfile
	end

	def calculate_data_by_xml(xmldoc, sprint)
		backlogs = []
		if sprint == nil
			sprint = "Sprint 1"
		end

		root = Document.new(xmldoc).root
		root.elements.each("Asset") do |asset|
			tmp = BacklogEntity.new
			
			# extract 1st level asset
			asset.elements.each("Attribute") do |attr|
	  		attr_name, attr_text = attr.attributes['name'], attr.text
	  		if attr_name == 'IsClosed'
	  			tmp.isClosed = attr_text
	  		elsif attr_name == 'Timebox.Name'
	  			tmp.timebox = attr_text
	  		elsif attr_name == 'Status.Name'
	  			tmp.status = attr_text
	  		elsif attr_name == 'SecurityScope.Name'
	  			tmp.scopeName = attr_text
	  		end
	  	end

	  	if asset.get_elements("Relation").length == 1
				asset.elements.each("Relation") do |relation|
					relation_name = relation.attributes['name']
					relation.elements.each("Asset") do |relation_asset|
						relation_text = relation_asset.attributes['idref']
						if relation_name == 'SecurityScope'
							tmp.scopeId = relation_text
						end
					end
				end
			end
			backlogs << tmp
		end

		generate_report(backlogs, sprint)

	end

	def generate_report(backlogs, sprint)
		count_not_started, count_dev, count_qa, count_completed = 0, 0, 0, 0
		print "Inside generate_report: Sprint = ", sprint, "\n"
		status_not_started = ['None', 'No Requirements', 'Requirements Done', 'Planned']
		status_in_progress = ['In Progress', 'Awaiting Clarification', 'Awaiting Code Fix', 'Blocked', 'Reopened']
		status_in_testing = ['In Testing', 'Dev Complete']
		status_completed = ['Done']

		backlogs.each do |b|
			if b.timebox == sprint 
				if b.isClosed == 'True'
					count_completed =+ 1
				elsif status_not_started.include?(b.status) or b.status == nil
					count_not_started += 1
				elsif status_in_progress.include?(b.status)
					count_dev += 1
				elsif status_in_testing.include?(b.status)
					count_qa += 1
				elsif status_completed.include?(b.status)
					count_completed += 1
				end	
			end
		end
		
		return [count_not_started, count_dev, count_qa, count_completed]
	end

	def v1_query(query, host='versionone.successfactors.com', user='ewang', domain='ah_nt_domain', password='Welcomecw!')
		xmlfile = nil
		Net::HTTP.start('versionone.successfactors.com') do |http|
			request = Net::HTTP::Get.new(query)
			request['authorization'] = 'NTLM ' + NTLM.negotiate.to_base64
			response = http.request(request)
			# The connection must be keep-alive!
			challenge = response['www-authenticate'][/NTLM (.*)/, 1].unpack('m').first
			request['authorization'] = 'NTLM ' + NTLM.authenticate(challenge, user, domain, password).to_base64
			response = http.request(request)
			xmlfile = response.body
		end
		xmlfile
	end

  class BacklogEntity
		def initialize(isClosed="", timebox="", status="", scopeName="", scopeId="")
			@isClosed = isClosed
			@timebox = timebox
			@status = status
			@scopeName = scopeName
			@scopeId = scopeId
		end

		# Getter
		def isClosed
		  @isClosed
		end
		def timebox
		  @timebox
		end
		def status
		  @status
		end
		def scopeName
		  @scopeName
		end
		def scopeId
		  @scopeId
		end

		# Setter
		def isClosed=(value)
		  @isClosed = value
		end
		def timebox=(value)
		  @timebox = value
		end
		def status=(value)
		  @status = value
		end
		def scopeName=(value)
		  @scopeName = value
		end
		def scopeId=(value)
		  @scopeId = value
		end
	end

	class DefectEntity
		def initialize(configurationType="", scopeName="", type="", scopeId="", sla="", status="", isClosed="")
			@configurationType = configurationType
			@scopeName = scopeName
			@type = type
			@scopeId = scopeId
			@sla = sla
			@status = status
			@isClosed = isClosed
		end

		# Getter
		def configurationType
		  @configurationType
		end
		def scopeName
		  @scopeName
		end
		def type
		  @type
		end
		def scopeId
		  @scopeId
		end
		def sla
		  @sla
		end
		def status
		  @status
		end
		def isClosed
		  @isClosed
		end	

		# Setter
		def configurationType=(value)
		  @configurationType = value
		end
		def scopeName=(value)
		  @scopeName = value
		end
		def type=(value)
		  @type = value
		end
		def scopeId=(value)
		  @scopeId = value
		end
		def sla=(value)
		  @sla = value
		end
		def status=(value)
		  @status = value
		end
		def isClosed=(value)
		  @isClosed = value
		end			
	end
end