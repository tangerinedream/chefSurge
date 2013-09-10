name "webserver"
description "Web Server"
run_list "role[base]", "recipe[apache]"
default_attributes({
	"apache" => {
		"sites" => {
			"admin" => {
				"port" => 82
			},
# This Role overrides / takes precedence over Recipe Attribute for bears
			"bears" => {
				"port" => 8081
			}
		}
	}
})
