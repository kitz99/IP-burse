module ApplicationsHelper
	def cp(path)
		"is-active" if current_page?(path)
	end
end
