const CodeOrder = preload("rules/code_order.gd")
const RuleSpacing = preload("rules/spacing.gd")
const RuleBlankLines = preload("rules/blank_lines.gd")


static func _apply_rules(code: String) -> String:
	code = RuleSpacing.apply(code)
	code = CodeOrder.apply(code)
	code = RuleBlankLines.apply(code)
	return code


static func _replace(text: String, what: String, forwhat: String) -> String:
	var index := text.find(what)
	if index != -1:
		text = text.substr(0, index) + forwhat + text.substr(index + what.length())
	return text


func format_code(code: String) -> String:
	var string_regex = RegEx.create_from_string(r"\&?([\"'])(?:(?=(\\?))\2[\s\S])*?\1")
	var string_matches = string_regex.search_all(code)
	var string_map = {}

	for i in range(string_matches.size()):
		var match = string_matches[i]
		var original = match.get_string()
		var placeholder = "__STRING__%d__" % i
		string_map[placeholder] = original
		code = _replace(code, original, placeholder)

	var comment_regex = RegEx.create_from_string("#.*")
	var comment_matches = comment_regex.search_all(code)
	var comment_map = {}

	for i in range(comment_matches.size()):
		var match = comment_matches[i]
		var original = match.get_string()
		var placeholder = "__COMMENT__%d__" % i
		comment_map[placeholder] = original
		code = _replace(code, original, placeholder)

	var ref_regex = RegEx.create_from_string(r"\$.*?(?=[.$])")
	var ref_matches = ref_regex.search_all(code)
	var ref_map = {}

	for i in range(ref_matches.size()):
		var match = ref_matches[i]
		var original = match.get_string()
		var placeholder = "__REF__%d__" % i
		ref_map[placeholder] = original
		code = _replace(code, original, placeholder)
	
	code = _apply_rules(code)

	for placeholder in ref_map:
		code = code.replace(placeholder, ref_map[placeholder])
	for placeholder in comment_map:
		code = code.replace(placeholder, comment_map[placeholder])
	for placeholder in string_map:
		code = code.replace(placeholder, string_map[placeholder])

	return code
