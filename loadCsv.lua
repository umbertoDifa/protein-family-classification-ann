--from http://nocurve.com/simple-csv-read-and-write-using-lua/

---------------------------------------------------------------------
local function split(str, sep)
    sep = sep or ','
    fields={}
    local matchfunc = string.gmatch(str, "([^"..sep.."]+)")
    if not matchfunc then return {str} end
    for str in matchfunc do
        table.insert(fields, str)
    end
    return fields
end

---------------------------------------------------------------------
function read(path, sep, tonum)
    tonum = tonum or true
    sep = sep or ','
    local csvFile = {}
    local file = assert(io.open(path, "r"))
    for line in file:lines() do
        fields = split(line, sep)
        if tonum then -- convert numeric fields to numbers
            for i=1,#fields do
                fields[i] = tonumber(fields[i]) or fields[i]
            end
        end
        table.insert(csvFile, fields)
    end
    file:close()
    return csvFile
end

---------------------------------------------------------------------
function write(path, data, sep)
    sep = sep or ','
    local file = assert(io.open(path, "w"))
    for i=1,#data do
        for j=1,#data[i] do
            if j>1 then file:write(sep) end
            file:write(data[i][j])
        end
        file:write('\n')
    end
    file:close()
end

---------------------------------------------------------------------
local classes = {1,2,3,4} -- indices in torch/lua start at 1, not at zero

--read labels
trainingLabelsTable=read('./../pythonScripts/trainingLabels.csv')
--transform to tensor
trainingLabels= torch.Tensor(trainingLabelsTable)


trainingDataTable=read('./../pythonScripts/trainingData.csv')
trainingData= torch.Tensor(trainingDataTable)

--reshape training data into a list of 3D tensors
trainingList={}
for i=1,trainingData:size(1) do
   table.insert(trainingList,torch.reshape(trainingData[i],1,23,23))
end

return trainingList,
      trainingLabels,
      classes
