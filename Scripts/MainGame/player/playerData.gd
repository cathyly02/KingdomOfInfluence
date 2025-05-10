extends Node


# default skin
var selectedSkin = 0
var username = ""
var firstSlider = 0.0
var secondSlider = 0.0
var thirdSlider = 0.0
var fourthSlider = 0.0

# save skin and name
func save_customization(skin, name, firstSlideVal, secondSlideVal, thirdSlideVal, fourthSlideVal):
	# set the skin input value in data
	selectedSkin = skin
	# Set scroll
	firstSlider = firstSlideVal
	secondSlider = secondSlideVal
	thirdSlider = thirdSlideVal
	fourthSlider = fourthSlideVal
	# user inputed name
	if (name != ""):
		# input is set to username
		username = name
	# user did not put anything
	else:
		#user set to bob
		username = "Bob"

	
	
# get data
func get_customization():
	print(selectedSkin)
	print(username)
	print(firstSlider)
	print(secondSlider)
	print(thirdSlider)
	print(fourthSlider)
	return {"skin": selectedSkin,
			"name": username,
			"first_slider": firstSlider,
			"second_slider": secondSlider,
			"third_slider": thirdSlider, 
			"fourth_slider": fourthSlider}	
	
