note
	description: "Summary description for {ES_CLOUD_LICENSES_ADMIN_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CLOUD_LICENSES_ADMIN_HANDLER

inherit
	ES_CLOUD_ADMIN_HANDLER
		rename
			make as make_admin_handler
		end

	WSF_URI_TEMPLATE_HANDLER

create
	make

feature {NONE} -- Creation

	make (a_es_cloud_api: ES_CLOUD_API; a_admin_module: ES_CLOUD_MODULE_ADMINISTRATION)
		do
			admin_module := a_admin_module
			make_admin_handler (a_es_cloud_api)
		end

feature -- Access

	admin_module: ES_CLOUD_MODULE_ADMINISTRATION

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
		do
			if attached {WSF_STRING} req.path_parameter ("license") as p_license then
				handle_license (p_license.value, req, res)
			elseif req.is_post_request_method then
				handle_licenses_group_action (req, res)
			else
				handle_licenses_list (req, res)
			end
		end

	handle_license (a_lic_id: READABLE_STRING_GENERAL; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			lic: ES_CLOUD_LICENSE
			l_email_lic: detachable ES_CLOUD_EMAIL_LICENSE
			s: STRING
			r: like new_generic_response
			f: CMS_FORM
			fset: WSF_FORM_FIELD_SET
			l_user: detachable ES_CLOUD_USER
		do
			if api.has_permission ("admin es licenses") then
				lic := es_cloud_api.license_by_key (a_lic_id)
				if lic = Void and a_lic_id.is_integer_64 then
					lic := es_cloud_api.license (a_lic_id.to_integer_64)
				end
				if lic = Void then
					send_not_found (req, res)
				else
					l_user := es_cloud_api.user_for_license (lic)

					r := new_generic_response (req, res)
					create s.make_empty

						-- Edit form
					create f.make (r.absolute_url (req.percent_encoded_path_info, Void), "edit-license")
					f.set_method_post
					if l_user = Void then
						l_email_lic := es_cloud_api.email_license (lic)
					end
					if l_email_lic /= Void then
						admin_module.add_assign_email_license_form_part_to (l_email_lic, f, es_cloud_api)
					end

					create fset.make
					fset.set_legend ("Edit license " + html_encoded (lic.key))
					f.extend (fset)
					admin_module.add_license_form_part_to (lic, fset, es_cloud_api)
					if req.is_post_request_method then
						f.validation_actions.extend (agent admin_module.license_form_validation_action (?, l_user, lic, es_cloud_api))
						f.process (r)
						if attached es_cloud_api.license_by_key (lic.key) as l_updated_lic then
							lic := l_updated_lic
						end
						es_cloud_api.append_license_to_html (lic, l_user, Void, s)

							-- Update form with fresh data.
						create f.make (r.absolute_url (req.percent_encoded_path_info, Void), "edit-license")
						f.set_method_post
						if l_email_lic /= Void then
							admin_module.add_assign_email_license_form_part_to (l_email_lic, f, es_cloud_api)
						end

						create fset.make
						f.extend (fset)
						admin_module.add_license_form_part_to (lic, fset, es_cloud_api)

						f.append_to_html (r.wsf_theme, s)
					else
						es_cloud_api.append_license_to_html (lic, l_user, Void, s)
						f.append_to_html (r.wsf_theme, s)
					end

					r.set_main_content (s)
					r.execute
				end
			end
		end

	handle_licenses_list (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: like new_generic_response
			lic: detachable ES_CLOUD_LICENSE
			s: STRING
			l_user: ES_CLOUD_USER
			l_plan_filter: detachable READABLE_STRING_GENERAL
			l_expiring_before_n_days_filter: INTEGER
			l_org: ES_CLOUD_ORGANIZATION
			l_email: READABLE_STRING_8
--			orgs: detachable LIST [ES_CLOUD_ORGANIZATION]
			lst: LIST [TUPLE [license: ES_CLOUD_LICENSE; user: detachable ES_CLOUD_USER; email: detachable READABLE_STRING_8; org: detachable ES_CLOUD_ORGANIZATION]]
		do
			if api.has_permission ("admin es licenses") then
				if attached {WSF_STRING} req.query_parameter ("plan") as p_plan then
					l_plan_filter := p_plan.value
				end
				if attached {WSF_STRING} req.query_parameter ("expiring_before_n_days") as p_expiring_before_n_days then
					l_expiring_before_n_days_filter := p_expiring_before_n_days.value.to_integer_32
					if l_expiring_before_n_days_filter <= 0 then
						l_expiring_before_n_days_filter := 0
					end
				end
				r := new_generic_response (req, res)
				add_primary_tabs (r)

				if l_plan_filter /= Void then
					create s.make_from_string ("<h1>Licenses for plan %"" + html_encoded (l_plan_filter) + "%"</h1>")
				else
					create s.make_from_string ("<h1>Licenses</h1>")
					s.append ("See <a href=%"" + api.administration_path ("/cloud/plans/") + " %">available plans</a>")
				end
				if l_expiring_before_n_days_filter > 0 or l_plan_filter /= Void  then
					s.append (" | <a href=%"" + req.script_url (req.percent_encoded_path_info) + "%">All the licenses</a>")
				elseif l_expiring_before_n_days_filter = 0 then
					s.append (" | <a href=%"" + req.script_url (req.percent_encoded_path_info) + "?expiring_before_n_days=7%">Licenses expiring before 7 days</a>")
				end
				if l_expiring_before_n_days_filter > 0 then
					s.append ("<br/>Currently listing licenses expiring before " + l_expiring_before_n_days_filter.out + " days.")
				end

				s.append ("<form action=%"" + req.percent_encoded_path_info + "%" method=%"post%" >")
				s.append ("<table class=%"with_border%" style=%"border: solid 1px black%"><tr><th>Entity</th><th>Owner</th><th>Plan</th><th>Conditions</th><th>Until</th><th>Last</th><th>organization(s)</th>")
				s.append ("</tr>")
				if l_plan_filter /= Void and then attached es_cloud_api.plan_by_name (l_plan_filter) as pl then
					lst := es_cloud_api.licenses_for_plan (pl)
				else
					lst := es_cloud_api.licenses
				end
				if l_expiring_before_n_days_filter > 0 then
					from
						lst.start
					until
						lst.after
					loop
						lic := lst.item.license
						if lic.is_expired or lic.days_remaining <= l_expiring_before_n_days_filter then
							--Keep
							lst.forth
						else
							lst.remove
						end
					end
				end
				across
					lst as ic
				loop
					lic := ic.item.license
					l_user := ic.item.user
					l_email := ic.item.email
					l_org :=  ic.item.org
					if lic /= Void then
						s.append ("<tr><td>")
						s.append ("<input type=%"checkbox%" name=%"licenses[" + url_encoded (lic.key) + "]%"/> ")
						s.append ("<a href=%"")
						s.append (api.location_url (r.location + url_encoded (lic.key), Void))
						s.append ("%">")
						s.append (html_encoded (lic.key))
						s.append ("</a>")
						s.append ("<!-- " + lic.id.out + " -->")
						s.append ("</td>")
						if l_user /= Void then
							s.append ("<td class=%"user%">")

							s.append ("<a href=%"")
							s.append (api.administration_path ("cloud/installations/?user=" + l_user.id.out))
							s.append ("%">")
							s.append (html_encoded (api.real_user_display_name (l_user)))
							s.append ("</a>")
						elseif l_org /= Void then
							s.append ("<td class=%"organization%">")
							s.append ("[ORG] <a href=%"")
							s.append (api.administration_path ("cloud/organizations/" + l_org.id.out + "/"))
							s.append ("%">")
							s.append (html_encoded (l_org.title_or_name))
							s.append ("</a>")
						elseif l_email /= Void then
							s.append ("<td class=%"email%">")
							s.append (l_email)
						else
							s.append ("<td>")
						end
						s.append ("</td>")

						if attached lic.plan as l_plan then
							s.append ("<td>") -- Plan
							s.append (html_encoded (l_plan.title_or_name))
							s.append ("</td>")

							s.append ("<td>") -- Conditions
							if attached lic.platforms_as_csv_string as l_platforms then
								s.append (" platforms:" + html_encoded (l_platforms))
							end
							if attached lic.version as l_version then
								s.append (" version:" + html_encoded (l_version))
							end
							s.append ("</td>")
							if lic.is_active then
								if attached lic.expiration_date as dt then
									if lic.days_remaining < 10 then
										s.append ("<td class=%"warning%">") -- Until
									else
										s.append ("<td>") -- Until
									end
									s.append (html_encoded (date_time_to_string (dt)))
									s.append (" ( " + lic.days_remaining.out + " days remaining )")
								else
									s.append ("<td>") -- Until
									s.append ("<strong>ACTIVE</strong>")
									s.append (" (since ")
									s.append (html_encoded (date_time_to_string (lic.creation_date)))
									s.append (")")
								end
							elseif lic.is_suspended then
								s.append ("<td class=%"suspended%">")
								s.append ("<strong>SUSPENDED</strong>")
							else

								s.append ("<td class=%"expired%">") -- Until

								s.append ("<strong>EXPIRED</strong>")
								if attached lic.expiration_date as dt then
									s.append (" (since ")
									s.append (html_encoded (date_time_to_string (dt)))
									s.append (")")
								end
							end
							s.append ("</td>")
							s.append ("<td>") -- Last
							if
								attached {ES_CLOUD_SESSION} es_cloud_api.last_license_session (lic) as l_last and then
								attached l_last.last_date as dt
							then
								s.append ("<time class=%"timeago%" datetime=%"" + date_time_to_timestamp_string (dt) + "%">")
								s.append (html_encoded (date_time_to_string (dt)))
								s.append ("</time>")
							end
							s.append ("<a href=%"")
							s.append (api.location_url ("activities/" + url_encoded (lic.key), Void))
							s.append ("%">...</a>")
							s.append ("</td>")
						else
							s.append ("<td></td>") -- Plan
							s.append ("<td></td>") -- Conditions
							s.append ("<td></td>") -- Until
							s.append ("<td></td>") -- Last
						end
--						if l_user /= Void and orgs /= Void then
--							s.append ("<td>")
--							across
--								orgs as o_ic
--							loop
--								s.append ("<a href=%"")
--								s.append (api.administration_path ("cloud/organizations/" + o_ic.item.id.out + "/"))
--								s.append ("%">")
--								s.append (html_encoded (o_ic.item.name))
--								s.append ("</a> ")
--							end
--							s.append ("</td>")
--						else

						if l_org /= Void then
							s.append ("<td class=%"organization%">")
							s.append ("<a href=%"")
							s.append (api.administration_path ("cloud/organizations/" + l_org.id.out + "/"))
							s.append ("%">")
							s.append (html_encoded (l_org.title_or_name))
							s.append ("</a>")
							s.append ("</td>")
						else
							s.append ("<td></td>") -- Organization
						end

						s.append ("</tr>")
					end
				end
				s.append ("</table>%N")

				s.append ("<input type=%"submit%" name=%"group_action%" value=%"Group-Action%" /></form>")

				s.append ("<br/>%N")

				s.append ("<table class=%"with_border%" style=%"border: solid 1px black%"><tr><th>organizations</th><th>Plan</th><th>Until</th>")
	--			s.append ("<th>Action</th>")
				s.append ("</tr>")
				across
					es_cloud_api.organizations as ic
				loop
--					sub := es_cloud_api.organization_subscription (ic.item)
--					if
--						l_plan_filter = Void
--						or else (sub /= Void and then l_plan_filter.is_case_insensitive_equal (sub.plan.name))
--					then
--						s.append ("<tr><td><a href=%"")
--						s.append (api.administration_path ("cloud/organizations/" + ic.item.id.out + "/"))
--						s.append ("%">")
--						s.append (html_encoded (ic.item.name))
--						s.append ("</a></td>")

--						if sub /= Void then
--							s.append ("<td>")
--							s.append (html_encoded (sub.plan.title_or_name))
--							s.append ("</td>")
--							s.append ("<td>")
--							if sub.is_active then
--								if attached sub.expiration_date as dt then
--									s.append (html_encoded (date_time_to_string (dt)))
--									s.append (" ( " + sub.days_remaining.out + " days remaining )")
--								else
--									s.append ("<strong>ACTIVE</strong>")
--									s.append (" (since ")
--									s.append (html_encoded (date_time_to_string (sub.creation_date)))
--									s.append (")")
--								end
--							else
--								s.append ("<strong>EXPIRED</strong>")
--								if attached sub.expiration_date as dt then
--									s.append (" (since ")
--									s.append (html_encoded (date_time_to_string (dt)))
--									s.append (")")
--								end
--							end
--							s.append ("</td>")
--		--					s.append ("<td>")
--		--					s.append ("Cancel | Upgrade")
--		--					s.append ("</td>")
--						else
--							s.append ("<td>")
--							s.append ("</td>")
--							s.append ("<td>")
--							s.append ("</td>")
--		--					s.append ("<td>")
--		--					s.append ("Upgrade")
--		--					s.append ("</td>")
--						end

--						s.append ("</tr>")
--					end
				end
				s.append ("</table>%N")


				r.set_main_content (s)
				r.execute
			else
				send_access_denied (req, res)
			end
		end

	handle_licenses_group_action (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: like new_generic_response
			l_licenses: STRING_TABLE [ES_CLOUD_LICENSE]
			lic: ES_CLOUD_LICENSE
			s,t: STRING
			s_nb: READABLE_STRING_32
			nb_months, nb_days: INTEGER
			f: CMS_FORM
			h: WSF_FORM_HIDDEN_INPUT
			tf: WSF_FORM_TEXT_INPUT
			l_submit: WSF_FORM_SUBMIT_INPUT
			l_choices: WSF_FORM_SELECT
			l_ch: WSF_FORM_SELECT_OPTION
			fset: WSF_FORM_FIELD_SET
			l_trial_plan: detachable ES_CLOUD_PLAN
		do
			if api.has_permission ("admin es licenses") then
				if
					attached {WSF_STRING} req.form_parameter ("group_action") as p_action and then
					attached {WSF_TABLE} req.form_parameter ("licenses") as p_lics
				then
					create l_licenses.make (p_lics.count)
					across
						p_lics as ic
					loop
						lic := es_cloud_api.license_by_key (ic.key)
						if lic /= Void then
							l_licenses [ic.key] := lic
						end
					end

					r := new_generic_response (req, res)
					if
						p_action.same_string ("Extend") and then
						attached {WSF_STRING} req.form_parameter ("duration-in-month") as p_duration_in_months
					then
						s_nb := p_duration_in_months.value
						if s_nb.is_integer then
							nb_months := s_nb.to_integer --months
						elseif s_nb.is_real then
							nb_days := (31 * s_nb.to_real).truncated_to_integer --days
						end
						across
							l_licenses as ic
						loop
							lic := ic.item
							es_cloud_api.extend_license_with_duration (lic, 0, nb_months, nb_days)
							es_cloud_api.save_license (lic)
							r.add_notice_message ("License " + html_encoded (ic.key) + ": expires in " + lic.days_remaining.out + " days")
						end
					elseif
						p_action.same_string ("Change Plan") and then
						attached {WSF_STRING} req.form_parameter ("new_plan") as p_new_plan_name
					then
						if attached es_cloud_api.plan_by_name (p_new_plan_name.string_representation) as pl then
							across
								l_licenses as ic
							loop
								lic := ic.item
								if not lic.plan.same_plan (pl) then
									lic.set_plan (pl)
									es_cloud_api.save_license (lic)
									r.add_notice_message ("License " + html_encoded (lic.key) + " udpated to plan %"" + html_encoded (pl.title_or_name)+ "%"")
								end
							end
						else
							r.add_error_message ("Could not find plan %"" + html_encoded (p_new_plan_name.string_representation) + "%".")
						end
					end

					create s.make_from_string ("<h1>Action: " + html_encoded (p_action.string_representation) + "</h1>%N")
					s.append ("<div><a href=%"" + req.percent_encoded_path_info + "%">Return to licenses list</a></div>%N")

					create f.make (req.percent_encoded_path_info, Void)
					f.set_method_post
					across
						l_licenses as ic
					loop
						lic := ic.item
						f.extend_html_text ("<li>")
						create h.make_with_text ("licenses[" + url_encoded (lic.key) + "]", "on")
						f.extend (h)
						create t.make_empty
						if attached es_cloud_api.user_for_license (lic) as l_user then
							es_cloud_api.append_one_line_license_view_to_html (lic, l_user, admin_module.module, t)
						else
							t.append (html_encoded (ic.key))
						end
						f.extend_html_text (t)
						f.extend_html_text ("</li>")
					end
					create fset.make
					fset.set_legend ("Extending license duration")
					f.extend (fset)
					create tf.make ("duration-in-month")
					tf.set_label ("Extend license duration")
					tf.set_description ("Add N months to license duration ...")
					fset.extend (tf)
					create l_submit.make_with_text ("group_action", "Extend")
					fset.extend (l_submit)

					create fset.make
					fset.set_legend ("Change license plan")
					f.extend (fset)
					create l_choices.make ("new_plan")
					l_trial_plan := es_cloud_api.trial_plan
					across
						es_cloud_api.plans as ic
					loop
						create l_ch.make (ic.item.name, ic.item.title_or_name)
						if l_trial_plan /= Void and then l_trial_plan.same_plan (ic.item) then
							l_ch.set_is_selected (True)
						end
						l_choices.add_option (l_ch)
					end
					fset.extend (l_choices)

					create l_submit.make_with_text ("group_action", "Change Plan")
					fset.extend (l_submit)

					f.append_to_html (r.wsf_theme, s)
					r.set_main_content (s)
					r.execute
				else
					send_bad_request (req, res)
				end
			else
				send_access_denied (req, res)
			end
		end

end
