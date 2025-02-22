﻿note
	description: "[
		Automatically generated class for EiffelStudio ES_SMALL_ICONS icons.
	]"
	generator: "Eiffel Matrix Generator"
	command_line: "[
		emcgen %EIFFEL_SRC%\Delivery\studio\bitmaps\png\small_icons.ini -f %EIFFEL_SRC%\tools\eiffel_matrix_code_generator\frames\studio_dpi.e.frame --output_file %EIFFEL_SRC%\Eiffel\interface\new_graphical\shared\es_small_icons.e
		]"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SMALL_ICONS

inherit
	ES_DPI_PIXMAPS

create
	make

feature -- Access

	width: NATURAL_8 = 12
			-- <Precursor>

	height: NATURAL_8 = 1
			-- <Precursor>

feature {NONE} -- Access

	matrix_pixel_border: NATURAL_8 = 1
			-- <Precursor>

feature -- Icons
	
	frozen bp_current_line_icon: EV_PIXMAP
			-- Access to 'current line' pixmap.
		require
			has_named_icon: has_named_icon (bp_current_line_name)
		once
			Result := named_icon (bp_current_line_name)
		ensure
			bp_current_line_icon_attached: Result /= Void
		end

	frozen bp_current_line_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'current line' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_current_line_name)
		once
			Result := named_icon_buffer (bp_current_line_name)
		ensure
			bp_current_line_icon_buffer_attached: Result /= Void
		end

	frozen bp_slot_icon: EV_PIXMAP
			-- Access to 'slot' pixmap.
		require
			has_named_icon: has_named_icon (bp_slot_name)
		once
			Result := named_icon (bp_slot_name)
		ensure
			bp_slot_icon_attached: Result /= Void
		end

	frozen bp_slot_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'slot' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_slot_name)
		once
			Result := named_icon_buffer (bp_slot_name)
		ensure
			bp_slot_icon_buffer_attached: Result /= Void
		end

	frozen bp_enabled_icon: EV_PIXMAP
			-- Access to 'enabled' pixmap.
		require
			has_named_icon: has_named_icon (bp_enabled_name)
		once
			Result := named_icon (bp_enabled_name)
		ensure
			bp_enabled_icon_attached: Result /= Void
		end

	frozen bp_enabled_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'enabled' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_enabled_name)
		once
			Result := named_icon_buffer (bp_enabled_name)
		ensure
			bp_enabled_icon_buffer_attached: Result /= Void
		end

	frozen bp_disabled_icon: EV_PIXMAP
			-- Access to 'disabled' pixmap.
		require
			has_named_icon: has_named_icon (bp_disabled_name)
		once
			Result := named_icon (bp_disabled_name)
		ensure
			bp_disabled_icon_attached: Result /= Void
		end

	frozen bp_disabled_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'disabled' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_disabled_name)
		once
			Result := named_icon_buffer (bp_disabled_name)
		ensure
			bp_disabled_icon_buffer_attached: Result /= Void
		end

	frozen bp_slot_current_line_icon: EV_PIXMAP
			-- Access to 'slot current line' pixmap.
		require
			has_named_icon: has_named_icon (bp_slot_current_line_name)
		once
			Result := named_icon (bp_slot_current_line_name)
		ensure
			bp_slot_current_line_icon_attached: Result /= Void
		end

	frozen bp_slot_current_line_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'slot current line' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_slot_current_line_name)
		once
			Result := named_icon_buffer (bp_slot_current_line_name)
		ensure
			bp_slot_current_line_icon_buffer_attached: Result /= Void
		end

	frozen bp_enabled_current_line_icon: EV_PIXMAP
			-- Access to 'enabled current line' pixmap.
		require
			has_named_icon: has_named_icon (bp_enabled_current_line_name)
		once
			Result := named_icon (bp_enabled_current_line_name)
		ensure
			bp_enabled_current_line_icon_attached: Result /= Void
		end

	frozen bp_enabled_current_line_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'enabled current line' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_enabled_current_line_name)
		once
			Result := named_icon_buffer (bp_enabled_current_line_name)
		ensure
			bp_enabled_current_line_icon_buffer_attached: Result /= Void
		end

	frozen bp_disabled_current_line_icon: EV_PIXMAP
			-- Access to 'disabled current line' pixmap.
		require
			has_named_icon: has_named_icon (bp_disabled_current_line_name)
		once
			Result := named_icon (bp_disabled_current_line_name)
		ensure
			bp_disabled_current_line_icon_attached: Result /= Void
		end

	frozen bp_disabled_current_line_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'disabled current line' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_disabled_current_line_name)
		once
			Result := named_icon_buffer (bp_disabled_current_line_name)
		ensure
			bp_disabled_current_line_icon_buffer_attached: Result /= Void
		end

	frozen bp_slot_other_frame_icon: EV_PIXMAP
			-- Access to 'slot other frame' pixmap.
		require
			has_named_icon: has_named_icon (bp_slot_other_frame_name)
		once
			Result := named_icon (bp_slot_other_frame_name)
		ensure
			bp_slot_other_frame_icon_attached: Result /= Void
		end

	frozen bp_slot_other_frame_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'slot other frame' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_slot_other_frame_name)
		once
			Result := named_icon_buffer (bp_slot_other_frame_name)
		ensure
			bp_slot_other_frame_icon_buffer_attached: Result /= Void
		end

	frozen bp_enabled_other_frame_icon: EV_PIXMAP
			-- Access to 'enabled other frame' pixmap.
		require
			has_named_icon: has_named_icon (bp_enabled_other_frame_name)
		once
			Result := named_icon (bp_enabled_other_frame_name)
		ensure
			bp_enabled_other_frame_icon_attached: Result /= Void
		end

	frozen bp_enabled_other_frame_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'enabled other frame' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_enabled_other_frame_name)
		once
			Result := named_icon_buffer (bp_enabled_other_frame_name)
		ensure
			bp_enabled_other_frame_icon_buffer_attached: Result /= Void
		end

	frozen bp_disabled_other_frame_icon: EV_PIXMAP
			-- Access to 'disabled other frame' pixmap.
		require
			has_named_icon: has_named_icon (bp_disabled_other_frame_name)
		once
			Result := named_icon (bp_disabled_other_frame_name)
		ensure
			bp_disabled_other_frame_icon_attached: Result /= Void
		end

	frozen bp_disabled_other_frame_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'disabled other frame' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_disabled_other_frame_name)
		once
			Result := named_icon_buffer (bp_disabled_other_frame_name)
		ensure
			bp_disabled_other_frame_icon_buffer_attached: Result /= Void
		end

	frozen bp_enabled_conditional_icon: EV_PIXMAP
			-- Access to 'enabled conditional' pixmap.
		require
			has_named_icon: has_named_icon (bp_enabled_conditional_name)
		once
			Result := named_icon (bp_enabled_conditional_name)
		ensure
			bp_enabled_conditional_icon_attached: Result /= Void
		end

	frozen bp_enabled_conditional_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'enabled conditional' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_enabled_conditional_name)
		once
			Result := named_icon_buffer (bp_enabled_conditional_name)
		ensure
			bp_enabled_conditional_icon_buffer_attached: Result /= Void
		end

	frozen bp_disabled_conditional_icon: EV_PIXMAP
			-- Access to 'disabled conditional' pixmap.
		require
			has_named_icon: has_named_icon (bp_disabled_conditional_name)
		once
			Result := named_icon (bp_disabled_conditional_name)
		ensure
			bp_disabled_conditional_icon_attached: Result /= Void
		end

	frozen bp_disabled_conditional_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'disabled conditional' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (bp_disabled_conditional_name)
		once
			Result := named_icon_buffer (bp_disabled_conditional_name)
		ensure
			bp_disabled_conditional_icon_buffer_attached: Result /= Void
		end

feature -- Icons: Animations
	
	-- No animation frames detected.

feature -- Constants: Icon names

	bp_current_line_name: STRING = "bp current line"
	bp_slot_name: STRING = "bp slot"
	bp_enabled_name: STRING = "bp enabled"
	bp_disabled_name: STRING = "bp disabled"
	bp_slot_current_line_name: STRING = "bp slot current line"
	bp_enabled_current_line_name: STRING = "bp enabled current line"
	bp_disabled_current_line_name: STRING = "bp disabled current line"
	bp_slot_other_frame_name: STRING = "bp slot other frame"
	bp_enabled_other_frame_name: STRING = "bp enabled other frame"
	bp_disabled_other_frame_name: STRING = "bp disabled other frame"
	bp_enabled_conditional_name: STRING = "bp enabled conditional"
	bp_disabled_conditional_name: STRING = "bp disabled conditional"

feature {NONE} -- Basic operations

	populate_coordinates_table (a_table: STRING_TABLE [TUPLE [x: NATURAL_8; y: NATURAL_8]])
			-- <Precursor>
		do
			a_table.put ([{NATURAL_8} 1, {NATURAL_8} 1], bp_current_line_name)
			a_table.put ([{NATURAL_8} 2, {NATURAL_8} 1], bp_slot_name)
			a_table.put ([{NATURAL_8} 3, {NATURAL_8} 1], bp_enabled_name)
			a_table.put ([{NATURAL_8} 4, {NATURAL_8} 1], bp_disabled_name)
			a_table.put ([{NATURAL_8} 5, {NATURAL_8} 1], bp_slot_current_line_name)
			a_table.put ([{NATURAL_8} 6, {NATURAL_8} 1], bp_enabled_current_line_name)
			a_table.put ([{NATURAL_8} 7, {NATURAL_8} 1], bp_disabled_current_line_name)
			a_table.put ([{NATURAL_8} 8, {NATURAL_8} 1], bp_slot_other_frame_name)
			a_table.put ([{NATURAL_8} 9, {NATURAL_8} 1], bp_enabled_other_frame_name)
			a_table.put ([{NATURAL_8} 10, {NATURAL_8} 1], bp_disabled_other_frame_name)
			a_table.put ([{NATURAL_8} 11, {NATURAL_8} 1], bp_enabled_conditional_name)
			a_table.put ([{NATURAL_8} 12, {NATURAL_8} 1], bp_disabled_conditional_name)
		end

;note
	copyright:	"Copyright (c) 1984-2019, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
