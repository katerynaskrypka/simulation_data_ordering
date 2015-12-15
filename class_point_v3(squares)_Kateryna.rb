class PointChip
  attr_accessor :node_index, :x, :y, :t
  def initialize(node_index, x, y, t)
    @node_index = node_index.to_f
    @x          = x.to_f
    @y          = y.to_f
    @t          = t.to_f

  end # def initialize
  
  def to_s; "Point: #{@node_index} #{@x} #{@y} #{@t}"; end
end #class

class Distance
  def initialize(p1,p2)
    
  end
end

def readData(type)
  if type == "tool" 
    unsorted = "all_data_tool.txt" 
  else
    unsorted = "all_data_chip.txt" 
  end 
  index = 0
  arrayOfData = Array.new()
  File.readlines(unsorted).each_with_index do |line, i| 
    words = line.split(",") 
    p1 = PointChip.new(index, words[0], words[1], words[2])
    arrayOfData.push(p1)
    index += 1
  end
  return arrayOfData
end

class ComputeData 
  attr_accessor :limit_1, :limit_2, :index_deleted
  def initialize()
    @index_deleted = Array.new()
  end
   
  def pointsInInterval(data, limit_1, limit_2)
    @limit_1 = limit_1
    @limit_2 = limit_2
    newData = Array.new()
    index = 0
    for i in (0...data.length)
      if data[i].x >= limit_1 && data[i].x <= limit_2
		#newPoint = PointChip.new(data[i].node_index, data[i].x, data[i].y, data[i].t)
		#newPoint.node_index = index
        data[i].node_index = index 
        newData.push(data[i])
        index += 1
      end
    end 
    return newData
  end
  
  def findFirstPointIndex(data)
    min_x = 100000000000
    min_id = -1
    for index in (0...data.length) 
      if data[index].x < min_x 
        min_id = data[index].node_index
        min_x = data[index].x
      end
    end
    return min_id
  end
  
  
  def sorteData(arrayOrdered, data)
    counter = 0
    firstPoint = arrayOrdered[0]
    data.delete_at(firstPoint.node_index)
    while data.length > 1
      arrayDistance = computeAllDistances(firstPoint, data)
      indexMin = findMinDistanceAndReturnIndex(arrayDistance)
      arrayOrdered.push(data[indexMin])
      firstPoint = data[indexMin]
      data.delete_at(indexMin)
      counter += 1
    end
    
    return arrayOrdered
  end
  
  
  
  def computeAllDistances(firstPoint, data)
    arrayDistance = Array.new()
    for i in (0...data.length)
      distance, index = computeDistance(firstPoint, data[i])
      distanceIndex = [distance, index]
      arrayDistance.push(distanceIndex)
    end 
    return arrayDistance
  end
  
  def computeDistance(firstPoint, secondPoint)
    distance = Math::sqrt((secondPoint.x - firstPoint.x)**2 + (secondPoint.y - firstPoint.y)**2)
    return distance, secondPoint.node_index
  end
  
  def findMinDistanceAndReturnIndex(distanceIndex)
    min_dist = 100000000000
    min_index = -1
    for i in (0...distanceIndex.length)
      if distanceIndex[i][0] < min_dist 
        min_dist = distanceIndex[i][0]
        min_index = i
      end
    end
    return min_index
  end

  def computeTemperature(arrayOrdered)
    multi_T_dist = 0.0
    distance_chip = 0.0
    arrayDistValue = []
    arraySingleTmean = []
    arraySingleTmean.push(0)
    for i in (0...arrayOrdered.length - 1)
      singleTmean = computeSingleTemp(arrayOrdered[i].t, arrayOrdered[i + 1].t)
      arraySingleTmean.push(singleTmean)
      singleDistance = computeSingleDistance(arrayOrdered[i], arrayOrdered[i + 1]) 
      distance_chip += singleDistance
      multi_T_dist = singleTmean * singleDistance + multi_T_dist
    end
    tAverage_chip = (multi_T_dist / distance_chip).round(3)
    return tAverage_chip, arraySingleTmean, distance_chip.round(3)
  end
  
  def computeSingleTemp(firstPointT, secondPointT)
    return (firstPointT + secondPointT) / 2
  end
  
  def computeSingleDistance(firstPoint, secondPoint)
    distance_chip = Math::sqrt((secondPoint.x - firstPoint.x)**2 + (secondPoint.y - firstPoint.y)**2)
    return distance_chip
  end
  
  def printOrderedData(arrayOrderedWithDistances, arrayOfMeanTemp) 
    #puts "x_coord\ty_coord\tt_value\tT_mean"
    for i in (0...arrayOrderedWithDistances.length)
      # puts "#{arrayOrderedWithDistances[i].x}\t#{arrayOrderedWithDistances[i].y}\t#{arrayOrderedWithDistances[i].t}\t#{arrayOfMeanTemp[i].round(2)}"
    end
  end
  
  def writeFile(arrayOrderedWithDistances, arrayOfMeanTemp)
    File.open("output_chip_old.txt", 'w+') do |file|
      for i in (0...arrayOrderedWithDistances.length)
        stringa = arrayOrderedWithDistances[i].x.to_s + "\t".to_s + arrayOrderedWithDistances[i].y.to_s + "\n".to_s 
       file.write(stringa)
      end
    end
  end
    
end

class ComputeAllData 
  attr_accessor :limit_start, :limit_stop,:startChip, :stopChip,:startTool, :stopTool, :arrayOfOrderedPoints, :squareDim, :step
  def initialize()
    @step = 0.2
    @squareDim = 1
    dataChip = readData("chip")
    dataTool = readData("tool")
    newDataChip = removePointsWithZeroY(dataChip)
    findLimit(newDataChip,dataTool)
    startScroll(newDataChip, dataTool)
  end
  
  def startScroll(newDataChip, newDataTool)
    index = 0
    actualStartLimit = @limit_start 
    actualStopLimit = @limit_start + @squareDim
    while actualStopLimit < @limit_stop
      puts "=================== "
      puts "Square limit -> start: #{actualStartLimit.round(3)}  stop: #{actualStopLimit.round(3)}"

      chip_t = 0
      chip_d = 0
      
      tool_t = 0
      tool_d = 0
	   
	  chip_t, chip_d = singleChip(newDataChip, actualStartLimit, actualStopLimit, index) 
    
	  if actualStartLimit < startTool && startTool < actualStopLimit
		 tool_t, tool_d = singleTool(newDataTool, startTool, actualStopLimit, index)   
	  end
	  if actualStartLimit > startTool && actualStopLimit < startTool 
		 tool_t, tool_d = singleTool(newDataTool, actualStartLimit, actualStopLimit, index)   
	  end
	  if actualStartLimit < stopTool && stopTool < actualStopLimit
		 tool_t, tool_d = singleTool(newDataTool, actualStartLimit, stopTool, index)   
	  end
    
      if tool_t != 0 && chip_t != 0 && tool_d != 0 && chip_d != 0
        tool_chip_t = ( chip_t * chip_d + tool_t * tool_d) / (chip_d + tool_d)
        puts "\nTOOL/CHIP"
        puts "T_Average_tool_chip = (#{chip_t} * #{chip_d} + #{tool_t} * #{tool_d}) / (#{chip_d} + #{tool_d})"
        puts "T_Average_tool_chip = #{tool_chip_t.round(2)}, C"
        puts "=================== "
      end
     #

      actualStartLimit += step 
      actualStopLimit += step
      index += 1

      puts " "
    end
  end
  
  def singleChip(newData1, actualStartLimit, actualStopLimit, index)  #newData1 =  CHIP
    computedData = ComputeData.new()
	@arrayOfOrderedPoints = Array.new()
    newData2 = computedData.pointsInInterval(newData1, actualStartLimit, actualStopLimit)
    min_id = computedData.findFirstPointIndex(newData2)
    arrayOfOrderedPoints.push(newData2[min_id])
    arrayOrderedWithDistances = computedData.sorteData(arrayOfOrderedPoints, newData2)
    tAverage_chip, arraySingleTmean, distance_chip = computedData.computeTemperature(arrayOrderedWithDistances)
    computedData.printOrderedData(arrayOrderedWithDistances,arraySingleTmean)
    puts "\nCHIP -> Square idx: #{index}"
    puts "T_Average_chip = #{tAverage_chip}, C \ndistance_chip = #{distance_chip}, mm"
    computedData.writeFile(arrayOrderedWithDistances,arraySingleTmean)
    return tAverage_chip,distance_chip
  end
  
  def singleTool(newData1, actualStartLimit, actualStopLimit, index) #newData1 =  TOOL
    computedData = ComputeData.new()
	@arrayOfOrderedPoints = Array.new()
    newData2 = computedData.pointsInInterval(newData1, actualStartLimit, actualStopLimit)
    min_id = computedData.findFirstPointIndex(newData2)
    arrayOfOrderedPoints.push(newData2[min_id])
    arrayOrderedWithDistances = computedData.sorteData(arrayOfOrderedPoints, newData2)
    tAverage_tool, arraySingleTmean, distance_tool = computedData.computeTemperature(arrayOrderedWithDistances)
    computedData.printOrderedData(arrayOrderedWithDistances,arraySingleTmean)
    puts "\nTOOL -> Square idx: #{index}"
    puts "T_Average_tool = #{tAverage_tool}, C \ndistance_tool = #{distance_tool}, mm"
    computedData.writeFile(arrayOrderedWithDistances,arraySingleTmean)
    return tAverage_tool, distance_tool
  end
  
  def findLimit(newDataChip, newDataTool)
    arrayXChip = Array.new()
    for i in 0...newDataChip.length
      arrayXChip.push(newDataChip[i].x)
    end
    arrayXTool = Array.new()
    for i in 0...newDataTool.length
      arrayXTool.push(newDataTool[i].x)
    end
    if arrayXChip.min <= arrayXTool.min
      @limit_start =  arrayXChip.min
    else
      @limit_start =  arrayXTool.min      
    end
    if arrayXChip.max >= arrayXTool.max
      @limit_stop =  arrayXChip.max
    else
      @limit_stop =  arrayXTool.max      
    end
    @startTool = arrayXTool.min
    @stopTool = arrayXTool.max
    @startChip = arrayXChip.min
    @stopChip = arrayXChip.max
  end
  
  def removePointsWithZeroY(data)
    y_limit = 4.9
    newData = Array.new()
    for i in 0...data.length
      if data[i].y > y_limit 
        newData.push(data[i])
      end
   end
   return newData
  end
    
end


#def main
  computedAllData = ComputeAllData.new()
  puts "limits\t|T_aver_chip\t|dist_chip\t|T_aver_tool\t|dist_tool\t|T_aver_tool_chip"
  
  #puts "limits\t|#{chip_t}\t|#{chip_d}"#"\t|#{tool_chip_t.round(2)}"

  #puts "limits\t|#{tAverage_chip}\t|#{distance_chip}\t|#{tAverage_tool}\t|#{distance_tool}\t|#{tool_chip_t.round(2)}"
  
  
  #end
#main
