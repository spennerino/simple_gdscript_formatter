const SYMBOLS = [
	r"\*\*=",
	r"\*\*",
	"<<=",
	">>=",
	"<<",
	">>",
	"==",
	"!=",
	">=",
	"<=",
	"&&",
	r"\|\|",
	r"\+=",
	"-=",
	r"\*=",
	"/=",
	"%=",
	"&=",
	r"\^=",
	r"\|=",
	"~=",
	":=",
	"->",
	r"&",
	r"\|",
	r"\^",
	"-",
	r"\+",
	"/",
	r"\*",
	">",
	"<",
	"-",
	"%",
	"=",
	":",
	",",
];
const KEYWORDS = [
	"and",
	"is",
	"or",
	"not",
]


static func apply(code: String) -> String:
	var indent_regex = RegEx.create_from_string(r"(\n\t*) {4}")
	var new_code = indent_regex.sub(code, "$1\t", true)
	while(code != new_code):
		code = new_code
		new_code = indent_regex.sub(code, "$1\t", true)

	var symbols_regex = "(" + ")|(".join(SYMBOLS) + ")"
	var symbols_operator_regex = RegEx.create_from_string(" *?(" + symbols_regex + ") *")
	code = symbols_operator_regex.sub(code, " $1 ", true)

	# ": =" => ":="
	code = RegEx.create_from_string(r": *=").sub(code, ":=", true)

	# "a (" => "a("
	code = RegEx.create_from_string(r"(?<=[\w\)\]]) *([\(:,])(?!=)").sub(code, "$1", true)

	# "( a" => "(a"
	code = RegEx.create_from_string(r"([\(\{}]) *").sub(code, "$1", true)

	# "a )" => "a)"
	code = RegEx.create_from_string(r" *([\)\}])").sub(code, "$1", true)

	var keywoisrd_regex = r"|".join(KEYWORDS)
	var keyword_operator_regex = RegEx.create_from_string(r"(?<=[ \)\]])(" + keywoisrd_regex + r")(?=[ \(\[])")
	code = keyword_operator_regex.sub(code, " $1 ", true)

	# tab "a 	=" => "a ="
	code = RegEx.create_from_string(r"(\S)\t+").sub(code, "$1 ", true)

	#trim
	code = RegEx.create_from_string("[ \t]*\n").sub(code, "\n", true)

	# "    " => " "
	code = RegEx.create_from_string(" +").sub(code, " ", true)

	# "= - a" => "= -a"
	code = RegEx.create_from_string(r"((" + symbols_regex + ") ?)- ").sub(code, "$1-", true)

	code = _handle_indent(code, 1, "[", "]")
	code = _handle_indent(code, 1, "{", "}")
	code = _handle_indent(code, 2, "(", ")")
	return code


static func _handle_indent(code: String, indent_level: int, left: String, right: String) -> String:
	var i = 1
	var parts := find_outer_parentheses(code, i, left, right)

	while parts.size() > 0:
		for part in parts:
			var escaped := regex_escape(part)
			var reg := RegEx.create_from_string("(?<=^|\n)(.*?" + escaped + ")")
			var found := reg.search(code)
			if found:
				var block := found.get_string()
				var lines := block.split("\n")
				if lines.size() > 1:
					var base_indent := get_indent_level(lines[0])
					var formatted := format_block(lines, base_indent, indent_level, right)
					code = reg.sub(code, formatted)
		i += 1
		parts = find_outer_parentheses(code, i, left, right)
	return code


static func format_block(lines: Array[String], base_indent: int, indent_level: int, right: String) -> String:
	var result := []
	indent_level += base_indent
	var block_indent_stack := []

	for i in range(lines.size()):
		var line_indent = get_indent_level(lines[i])

		while block_indent_stack.size() > 0 and line_indent <= block_indent_stack[ - 1]:
			block_indent_stack.pop_back()

		var line := lines[i].lstrip("\t")

		if i == 0:
			result.append(lines[i])
		elif i == lines.size() - 1 and line.begins_with(right):
			result.append("\t".repeat(base_indent) + line)
		else:
			result.append("\t".repeat(indent_level + block_indent_stack.size()) + line)

		if line.begins_with("if") or line.begins_with("match"):
			block_indent_stack.append(line_indent)

	return "\n".join(result)


static func get_indent_level(line: String) -> int:
	var regex := RegEx.new()
	return line.length() - line.lstrip("\t").length()


static func regex_escape(text: String) -> String:
	var specials = "\\.+*?[^]$(){}=!<>|:-#\r\n\t\f"
	var result := []
	for c in text:
		if specials.find(c) != -1:
			result.append("\\")
		result.append(c)
	return "".join(result)


static func find_outer_parentheses(text: String, target_level: int, left: String, right: String) -> Array:
	var result := []
	var depth := 0
	var start := -1

	for i in range(text.length()):
		var c := text[i]
		if c == left:
			depth += 1
			if depth == target_level:
				start = i
		elif c == right:
			if depth == target_level and start != -1:
				result.append(text.substr(start, i - start + 1))
			depth -= 1
	return result
