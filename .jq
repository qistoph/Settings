def pathexpr:
	map(
		if type == "number" then
			"["+(.|tostring)+"]"
		else
			"."+.
		end
	) | join("")
;
