def pathexpr:
	map(
		if type == "number" then
			"[\(tostring)]"
		else
			"."+.
		end
	) | join("")
;

def pathexpr2:
  reduce .[] as $k ("";
    . + ($k | if type == "number" then  "[\(.)]"
              elif test("[^a-zA-Z0-9_]") then "[\"\(.)\"]"
              else "." + $k
              end))
    | if startswith(".") then . else "." + . end ;

