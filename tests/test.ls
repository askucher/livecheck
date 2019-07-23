func = (item)->
  item + 1

  
func 1 # sucess

func {} # fail

parent-func = ->
  func {} #fail 
  
some-var = 1
  
func some-var #success

some-var2 = {}

func some-var2 #fail

