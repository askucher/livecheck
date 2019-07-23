require!{
    \prelude-ls : { map }
}




ExpressionToText = (item)->
    if item.operands == "Return" then
        R = 
            | item.body == null => "return"
            | _ => "return " + ExpressionToText item.body
        return R
    if item.operands == "Function" then
        params = item.params.join ","
        return "function(#{params})" + BlockStatementToText item.body, 1
    if item.operands == "Object" then
        pairs = item.body |> map (it)->
            (ExpressionToText it.0) + ": " + (ExpressionToText it.1)
        pairs = pairs.join ", "
        R = 
            | pairs.length => "{ #{pairs} }"
            | _ => "{}"
        return R
    if item.operands == "Call" then 
        name = 
            | (item.name.operands == 0) && ( typeof! item.name.name == \String ) => item.name.name
            | _ => "(#{ExpressionToText item.name})"
        args = item.body |> map ExpressionToText
        args = args.join ", "
        return "#{name}(#{args})"
    if item.operands == 0 then 
      R =
        | ( typeof! item.name == \String ) => item.name
        | ( typeof! item.value == \String ) => "\"#{item.value}\""
        | ( typeof! item.value == \Number ) => item.value
        | ( typeof! item.value == \Null ) => "null"
        | _ => "undefined"
      return R
    if item.operands == 2 then return (ExpressionToText item.body.0) + " #{item.body.1} " + (ExpressionToText item.body.2)
    "(E!)"


VariableDeclarationToText = (item)->
    R = item.body |> map (it)->
        if it.1 == null then return it.0
        "#{it.0} = " + ExpressionToText it.1
    "var " + R.join ", "


	
OneToText = (item)->
    Result = "(E!)"
    if item.type == "DontSupport" then Result = "(BuildProgram:DontSupport)"
    if item.type == "VariableDeclaration" then Result = VariableDeclarationToText item
    if item.type == "Expression" then Result = ExpressionToText item
    "#{Result}"


BlockStatementToText = (program,ok)->
    text = ""
    if program.type == "BlockStatement" then
        List = program.body |> map OneToText
        separator = ";\n"
        text = (List.join separator) + separator
    if ok then
        text = "{\n#{text}}".split("\n").join("\n	")
    text




ProgtamToText = (program)->
    if typeof! program != "Object" then return "(Error:NotObject)"
    if program.type == "BlockStatement" then return BlockStatementToText program, false
    OneToText program

   
   
module.exports = ProgtamToText