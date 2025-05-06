static func apply(code: String) -> String:
	var trim_double_newlines := RegEx.create_from_string("\n{2,}")
	code = trim_double_newlines.sub(code, "\n\n", true)

	code = _ensure_blank_lines_before_declarations(code)

	var trim_triple_newlines := RegEx.create_from_string("\n{3,}")
	code = trim_triple_newlines.sub(code, "\n\n\n", true)
	if code.length() > 0 and not code.ends_with("\n\n"):
		code += "\n"
	return code


static func _ensure_blank_lines_before_declarations(code: String) -> String:
	var declaration_regex := RegEx.create_from_string(r"(func|class) .*")
	var comment_or_warning_regex := RegEx.create_from_string(r"^\s*(__COMMENT__|@warning)")

	var lines := code.split('\n')
	var result_lines: Array[String] = []
	for line: String in lines:
		if declaration_regex.search(line):
			if result_lines.size() > 0:
				var i := result_lines.size() - 1
				while comment_or_warning_regex.search(result_lines[i]):
					i -= 1
				result_lines.insert(i + 1, "")
				result_lines.insert(i + 1, "")
		result_lines.append(line)

	return "\n".join(result_lines).strip_edges(true, false)
