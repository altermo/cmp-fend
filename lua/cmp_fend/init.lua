local source = {}
function source.new() return setmetatable({}, { __index = source }) end
function source.get_position_encoding_kind() return 'utf-8' end
function source.get_keyword_pattern() return [[\(\d\|sqrt\|log\|cos\|sin\|pi\|acos\|asin\)\S*\( in .*\)\?]] end
function source.complete(_,request,callback)
  local pureinput=string.sub(request.context.cursor_before_line,request.offset)
  local input=pureinput
  local speciall_upper=input:match('[¹²³]')
  input=input:gsub('¹','^1')
  input=input:gsub('²','^2')
  input=input:gsub('³','^3')
  if input:match('^%d*$') then callback{isIncomplete=true} return end
  vim.system({'fend',input},{},function (info)
    if info.code~=0 then callback{isIncomplete=true} return end
    local value=info.stdout
    if speciall_upper then value=value:gsub('%^2','²'):gsub('%^3','³') end
    value=value:gsub('approx%. ','')
    callback({items={{
      word=value,
      filterText=pureinput,
      label=value
    },{
        word=pureinput..'='..value,
        filterText=pureinput,
        label=pureinput..'='..value
      }},isIncomplete=true})
  end)
end
return source
