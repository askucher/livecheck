require! {
    \prelude-ls : { each }
}




RunExpression = (item, table)->
    if item.operands == "Function" then
        return { type: "Data", typeof: "Function", value: item }
    return { type: "Data", typeof: "ErrorData" }




ScanExpression = (item,table)->
    if item.operands != 2 then return
    if item.body.1 != "=" then return
    table[item.body.0.name] = RunExpression item.body.2, table



ScanBlockStatement = (program)->
    if program.type != "BlockStatement" then return {}
    table = {}
    program.body |> each (it)->
        #console.log it
        if it.type == "VariableDeclaration" then it.body |> each (i)-> table[i.0] = undefined
        if it.type == "Expression" then ScanExpression it, table
    table
	
	

	
RunProgramForGetTableVars = (program)->
    if typeof! program != "Object" then return {}
    ScanBlockStatement program



module.exports = RunProgramForGetTableVars