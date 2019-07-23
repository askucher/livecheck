require!{
    \prelude-ls : { map }
}


BuildBlockStatement = (item)->
    if item.type == "BlockStatement" then item = item.body
    body = item |> map BuildOne
    { type:"BlockStatement", inAST:item, body:body }



BuildExpression = (item)->
    if item == null then return null
    if item.type in [ "NumericLiteral", "StringLiteral" ] then return { type: "Expression", operands: 0, inAST: item, value: item.value }
    if item.type in [ "Identifier" ] then return { type: "Expression", operands: 0, inAST: item, name: item.name }
    if item.type in [ "AssignmentExpression", "BinaryExpression" ] then 
        return { type: "Expression", operands: 2, inAST: item, body: [ (BuildExpression item.left), item.operator, (BuildExpression item.right)] }
    if item.type in [ "CallExpression" ] then 
        args = item.arguments |> map BuildExpression
        return { type: "Expression", operands: "Call", inAST: item, name: (BuildExpression item.callee), body: args }
    if item.type in [ "ObjectExpression" ] then 
        obj = item.properties |> map (it)->
            [ (BuildExpression it.key), (BuildExpression it.value) ]
        return { type: "Expression", operands: "Object", inAST: item, body: obj }
    if item.type in [ "FunctionExpression" ] then 
        params = item.params |> map (it)-> it.name
        return { type: "Expression", operands: "Function", inAST: item, body: (BuildBlockStatement item.body), params: params }
    { type: "Expression", inAST: item, body: [] }

	
BuildDeclarations = (item)->
    item |> map (it)->
        [it.id.name, BuildExpression it.init]

BuildOne = (item)->
    if item.type == "VariableDeclaration" then 
        return { type: "VariableDeclaration", inAST: item, body: BuildDeclarations item.declarations }
    if item.type == "ExpressionStatement" then 
        return BuildExpression item.expression
    if item.type in [ "ReturnStatement" ] then
        return { type: "Expression", operands: "Return", inAST: item, body: BuildExpression item.argument }
    { type: "DontSupport", inAST: item }



BuildProgram = (BODY)->
    BuildBlockStatement BODY

	
module.exports = BuildProgram