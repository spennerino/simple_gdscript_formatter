@tool


extends   Node






@warning_ignore("assert_always_false")
class class_a:
	pass
# All symbols in comment for testing purposes
# ** << >> == != >= <= && || += -= *= /= %= **= &= ^= |= ~= <<= >>= := -> & | ^ - + / * > < - %
func func_a(     param1:int, param2    :float=    1.0)  :
	var a=  10
	var b =5
	var result=0

	var c = [1 ,2    ,3]
	if c[0] != c[3]           and a> - 1:
		a = (a+b)/   (b-a)
		a = (a+b) /(b-   a      )
		a     =  -				90

	# Arithmetic operations
	result=a  +b
	result =a- b
	result= a*b
	result = a /b
	result=a% b
	result=a** b

	# Bitwise operations
	result=a&b
	result =a| b
	result= a^b
	result=~a
	result= a<<b
	result= a>> b

	# Comparison operations
	var eq=a== b
	var neq=a !=b
	var gt = a> b
	var lt= a< b
	var gte=a>=b
	var lte = a<= b

	# Logical operations
	var and_op=a>0&&b> 0
	var or_op =a>0 ||b<0

	# Assignment operations
	a+=b
	a -=b
	a*= b
	a/=b
	a%=b
	a**=b
	a&=b
	a|= b
	a^=b
	a<<=b
	a>>=b

	# Struct-like syntax (pseudo-usage, for symbol testing)
	var dict := {   "key" : "value"  }

	# := assignment
	var x  :=42

	# Function declaration with arrow return type
	var callback :=   func  ()-> void:
		print("Callback")

	# Class usage
	var obj=class_a.new  (  )
# Arrow-returned function
func get_value()  ->  int:
	return 123
#this is signal
enum afewfe{AAA,
							BBB,CCC}
func aacc(a:int,
b:int):
	var categorized_blocks := {
			 "tool": [], # @tool, @icon, @static_unload
			 "class_name": [], # class_name
			 "extends": [], # extends
			}
	if(
			1 > 0
			and 0 == 9
			and(66 > 0
					and 1 != 0
			)
	):
		pass

	
signal ss
func _init() -> void:
	pass
#this is export
@export var ee:=1
static func t()->void:
	pass
