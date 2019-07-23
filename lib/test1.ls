require! {
    \prelude-ls : { filter, each, map }
    \colors
    "./ProgtamToText.ls": \ProgtamToText
}



RunExpression = (item,table)->
    if item == null then return { type: "Data", typeof: "Null", value: null }
    if item.operands == "Return" then return RunExpression item.body, table
    if item.operands == "Object" then
        Obj = {}
        return { type: "Data", typeof: "Object", value: Obj }
    if item.operands == 0 then
        R =
         | ( typeof! item.name == \String ) => table[item.name]
         | ( typeof! item.value == \String ) => { type: "Data", typeof: "String", value: item.value }
         | ( typeof! item.value == \Number ) => { type: "Data", typeof: "Number", value: item.value }
         | ( typeof! item.value == \Null ) => { type: "Data", typeof: "Null", value: null }
         | _ => { type: "Data", typeof: "Undefined", value: undefined }
        return R
    if item.operands == 2 then
        A = RunExpression item.body.0, table
        B = RunExpression item.body.2, table
        if item.body.1 in [ "+" ] then 
            if A.typeof != B.typeof then return throw "#{A.typeof} + #{B.typeof}"
        if item.body.1 in [ "+" ] then return { type: "Data", typeof: A.typeof, value: (A.value + B.value) }
    console.log item



	
ZapuskFunction = (program,table)->
    #console.log table
    #console.log ProgtamToText program.body.body.0
    try
       data = RunExpression program.body.body.0, table
    catch err
       return (ProgtamToText program.body.body.0) + " : #{err}"
    data


	
test = (program,table)->

    CallTest = (item)!->
        #console.log ProgtamToText item
        name = 
            | (item.name.operands == 0) && ( typeof! item.name.name == \String ) => item.name.name
            | _ => "(NeedFunction)"
        F = table[name]
        subTable = {}
        args = item.body |> map (it)-> RunExpression it, table
        pos = 0;
        F.value.params |> each (it)-> subTable[it]:=args[pos++]
        Result = ZapuskFunction F.value, subTable
        ok = (typeof! Result == "Object")
        text = (ProgtamToText item)
        if ok then 
            console.log text.yellow + " : " + ("success".green)
        else
            console.log text.yellow + " : " + (Result.red)
        
		
    program.body |> filter (it)-> (it.operands == "Call")
                 |> each CallTest


module.exports = test
