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
	code = RegEx.create_from_string(r"(\t*.*?)\t*").sub(code, "$1", true)

	#trim
	code = RegEx.create_from_string("[ \t]*\n").sub(code, "\n", true)

	# "    " => " "
	code = RegEx.create_from_string(" +").sub(code, " ", true)

	# "= - a" => "= -a"
	code = RegEx.create_from_string(r"((" + symbols_regex + ") ?)- ").sub(code, "$1-", true)
	return code
