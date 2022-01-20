module ManuscriptsHelper
	def manuscript_family_tree manuscript
		[
			{
				name: "Manuscript " + manuscript.display_name,
				url: edit_manuscript_path(manuscript),
				children: manuscript.booklets.map{ |b| 
					{
						name: b.display_name,
						url: edit_manuscript_booklet_path(manuscript, b),
						children: b.contents.map{ |c|
							{
								name: c.display_name,
								url: edit_manuscript_booklet_content_path(manuscript, b, c)
							}
						}
					}
				}
			}
		]
	end
end
