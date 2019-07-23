require! {
    \fs
    \babylon
    \colors
    \livescript
    "./lib/BuildProgram.ls": \BuildProgram
    "./lib/ProgtamToText.ls": \ProgtamToText
    "./lib/RunProgramForGetTableVars.ls": \RunProgramForGetTableVars
    "./lib/test1.ls": \test1
}





#--------------------------------------------------------------------------------------------------
analizeFile = (filename)!->
    if !fs.existsSync filename then 
        console.log "File #{filename} not found!".red
        return
    code = fs.readFileSync(filename,"utf8")
    analizeCode code, filename

	
getBodyOfLS = (code)->
   #console.log code
   try
    code = livescript.compile(code,{ bare:true, header:false })
    #console.log code
    AST = babylon.parse(code, {
      # parse in strict mode and allow module declarations 
      sourceType: "module",
      plugins: [
        # enable jsx and flow syntax 
      ]
      });
   catch err
    console.log err
    process.exit(1);
   AST.program.body



   
	

analizeCode = (code, filename)!->
    BODY = getBodyOfLS code
    #console.log JSON.stringify BODY, null, 2
    program = BuildProgram BODY
    #console.log ProgtamToText program
    table = RunProgramForGetTableVars program
    test1 program, table

	
	

#--------------------------------------------------------------------------------------------------
analizeFile "tests/test.ls"


