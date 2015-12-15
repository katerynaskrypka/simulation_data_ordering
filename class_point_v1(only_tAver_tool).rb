class Point
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

def readData 
  unsorted = "all_data_tool.txt" 
  index = 0
  arrayOfData = Array.new()
  File.readlines(unsorted).each_with_index do |line, i| 
    words = line.split(",") 
    p1 = Point.new(index, words[0], words[1], words[2])
    arrayOfData.push(p1)
    index += 1
  end
  return arrayOfData
end

class ComputeData 
  attr_accessor :limit_1, :limit_2, :index_deleted
  def initialize()
    @limit_1 = 3.5
    @limit_2 = 7.5
    @index_deleted = Array.new()
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
  
  def pointsInInterval(data)
    newData = Array.new()
    index = 0
    for i in (0...data.length)
      if data[i].x >= limit_1 && data[i].x <= limit_2
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
    distance = 0.0
    arrayDistValue = []
    arraySingleTmean = []
    arraySingleTmean.push(0)
    for i in (0...arrayOrdered.length - 1)
      singleTmean = computeSingleTemp(arrayOrdered[i].t, arrayOrdered[i + 1].t)
      arraySingleTmean.push(singleTmean)
      singleDistance = computeSingleDistance(arrayOrdered[i], arrayOrdered[i + 1])
      distance += singleDistance
      multi_T_dist = singleTmean * singleDistance + multi_T_dist
    end
    tAverage = (multi_T_dist / distance).round(3)
    multi_tAverage_Length = (tAverage * distance).round(3)
    return tAverage, arraySingleTmean, distance.round(3), multi_tAverage_Length
  end
  
  def computeSingleTemp(firstPointT, secondPointT)
    return (firstPointT + secondPointT) / 2
  end
  
  def computeSingleDistance(firstPoint, secondPoint)
    return distance = Math::sqrt((secondPoint.x - firstPoint.x)**2 + (secondPoint.y - firstPoint.y)**2)
  end
  
  def printOrderedData(arrayOrderedWithDistances, arrayOfMeanTemp) 
    puts "x_coord\ty_coord\tt_value\tT_mean"
    for i in (0...arrayOrderedWithDistances.length)
      puts "#{arrayOrderedWithDistances[i].x}\t#{arrayOrderedWithDistances[i].y}\t#{arrayOrderedWithDistances[i].t}\t#{arrayOfMeanTemp[i].round(2)}"
    end
  end
  
  def writeFile(arrayOrderedWithDistances, arrayOfMeanTemp)
    File.open("output_only_tool.txt", 'w+') do |file|
      for i in (0...arrayOrderedWithDistances.length)
        stringa = arrayOrderedWithDistances[i].x.to_s + "\t".to_s + arrayOrderedWithDistances[i].y.to_s + "\n".to_s 
       file.write(stringa)
      end
    end
  end
  
  
end

def main
  arrayOfOrderedPoints = Array.new()
  data = readData
  computedData = ComputeData.new()
  newData1 = computedData.removePointsWithZeroY(data)
  newData2 = computedData.pointsInInterval(newData1)
  min_id = computedData.findFirstPointIndex(newData2)
  arrayOfOrderedPoints.push(newData2[min_id])
  arrayOrderedWithDistances = computedData.sorteData(arrayOfOrderedPoints, newData2)
  tAverage, arraySingleTmean, distance, multi_tAverage_Length = computedData.computeTemperature(arrayOrderedWithDistances)
  
  
  computedData.printOrderedData(arrayOrderedWithDistances,arraySingleTmean)
  
  puts "\nT_Average #{tAverage}, C \nT_average * Length = #{tAverage} * #{distance} = #{multi_tAverage_Length}"
  
  computedData.writeFile(arrayOrderedWithDistances,arraySingleTmean)
  
end
main




