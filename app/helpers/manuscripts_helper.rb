module ManuscriptsHelper
	def manuscript_family_tree manuscript
		[
			{
				name: manuscript.display_name,
				url: edit_manuscript_path(manuscript),
				children: manuscript.booklets.map{ |b| 
					{
						name: b.display_name,
						url: edit_manuscript_booklet_path(manuscript, b),
						children: b.contents.with_text.map{ |c| {
							name: c.short_name,
							url: edit_manuscript_booklet_content_text_path(manuscript, b, c, c.text)
						} }
					}
				} + manuscript.contents.with_text.map{ |c| {
					name: c.short_name,
					url: edit_manuscript_content_text_path(manuscript, c, c.text)
				} }
			}
		]
	end

	private

	def contents c
		{
			name: c.short_name,
			url: edit_manuscript_booklet_content_path(manuscript, b, c)
		}
	end
end
