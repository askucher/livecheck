func = (item)->
  item + 1

  
func 1 # sucess

func {} # fail

# проверять нужно даже если функция не вызывается
parent-func = ->
  func {} #fail 
  
some-var = 1
  
func some-var #success

some-var2 = {}

func some-var2 #fail

parent-func-2 = (some-var)->
  func some-var

parent-func-2 1 #success

parent-func-2 {} #success
  
