      
        
      initial_data        = []   # non-ordered data with all X, Y, T
      #data_canc_y         = []   # non-ordered Y-data with cancelled Y (if y < y_limit)
      y_limit             = 4.9
      data_with_y_limit   = []   # non-ordered data with X, Y_limit, T        
      initial_data_float  = []
 
 
 
      # # # # # # # # # # # # # # # # # # # # # # # # #
      # # # # # #      W O R K P I E C E    # # # # # #
      # # # # # # # # # # # # # # # # # # # # # # # # #
      
      
      
      unsorted = "all_data.txt" 

      
      puts "\nCONVERTING THE DATA TO THE ARRAYS OF STRINGS ['', '', '']\n\n"
      File.readlines(unsorted).each_with_index do |line, i| 
        # puts "linea : #{line.to_s.inspect}"
        # puts "#{line}".class# => String
        
        words = line.split(",") 
        
        # puts words.inspect #=> ["5.16375", "4.99757", "138.276"]
       
        initial_data << words
        
      end
      
      
      
      
      # # #   CONVERTING 'INITIAL_DATA' (ARRAY OF ARRAY OF STRINGS) TO 'INITIAL_DATA_FLOAT' (ARRAY OF ARRAYS OF NUMBERS)    
     
      initial_data_float = initial_data.dup
        
      initial_data_float.map!{ |line| line.map{ |array| array.to_f} }
        # changes all values of X, Y, T in non-ordered 'initial_data' array from lines to float_numbers
        #  TO VERIFY if data format has been changed:
                 # puts initial_data_float.inspect
   
    
      # # #   REMOVING OF Y < Y_limit FROM THE DATA ARRAYS
       data_with_y_limit = initial_data_float.delete_if{|element| element[1] < y_limit}
      
        # puts data_with_y_limit.inspect
        # puts data_with_y_limit.length
   
   
      
                     # # #  IF NEEDED TO EXTRACT VALUES OF X, Y, T SEPARATELY
                     #  puts "\nACCESS TO THE VALUES (ORIGINAL DATA)\n\n"
                     #  for i in 0..(initial_data.length - 1) do     
                     #    
                     #             #   E X A M P L E 
                     #             #   array = [['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i']]
                     #             #   new_array = array.map {|el| el[2]}
                     #             #   => ["c", "f", "i"]
                     #    
                     #      x  = initial_data.map{ |column| column [0]} # x è un array di stringhe(valori) [" ", " ", " ", " "]
                     #      y  = initial_data.map{ |column| column [1]} # y è un array di stringhe(valori) [" ", " ", " ", " "] 
                     #      t  = initial_data.map{ |column| column [2]} # t è un array di stringhe(valori) [" ", " ", " ", " "] 
                     #
                     #             #  puts "data X \n#{x.inspect}\n"
                     #             #  puts "data Y \n#{y.inspect}\n"
                     #             #  puts "data T \n#{t.inspect}\n" 
                     #  end
     
     
     
      # # #   ORDERING BY X DATA 
      puts "\nORDERED DATA (ARRAY OF ARRAYS OF STRINGS): \n\n"
      
      ordered = data_with_y_limit.sort{ |line_1,line_2| line_1[0] <=> line_2[0] }
      
      # puts ordered.inspect
    


                     #   # # #    U N C O M M E N T if wanted to see the table of ALL ORDERED VALUES
                     #     puts "\nACCESS TO THE VALUES (ORDERED DATA) \n\n"
                     #     for i in 0..(ordered.length-1) do
                     #         x = ordered[i][0]
                     #         y = ordered[i][1]
                     #         t = ordered[i][2]
                     #          puts "#{x.to_f}\t\t#{y.to_f}\t\t#{t.to_f}"
                     #     end
                                     
      
      
      # # #   SAVING ORDERED DATA TO THE NEW FILE
      # kateryna@MacBook-Pro:simulation_data_order:> ruby sorting_data.rb > out.txt
      
      File.open("ordered_data.txt", 'w+') do |file|
         file.write(ordered.inspect)
      end
    
    
      # # # CHOOSING THE INTERVALS OF X FOR WORKPIECE
     
      puts "DATA IN CHOSEN INTERVAL\n "
     
      wp_points = ordered[0..400] # number of points describing workpiece
     
      limit_1       = 3.54
      limit_2       = 3.65
      
      x_array       = [] # array of floats to get access to the previuos/next values to calculate sum
      y_array       = [] # array of floats to get access to the previuos/next values to calculate sum
      t_array       = [] # array of floats to get access to the previuos/next values to calculate sum
     
      x_dist_sqrt   = [] # array of floats with all square distancies between x(n) - x(n-1)
      y_dist_sqrt   = [] # array of floats with all square distancies between y(n) - y(n-1)
      distance      = [] # array of all hypotenuses
      data_x_y_dist = []
      ordered_dist  = []
     
     
      t_mean        = []
      
      
      for i in 0...(ordered.length) do   
           x = ordered[i][0]
           y = ordered[i][1]
           t = ordered[i][2]
           
           # puts x.inspect
           
           if x >= limit_1 && x <= limit_2 
              # puts "#{x} #{y} #{t}"     # | + | + | + |
             
              # saving values of x, y, t as arrays x[], y[], t[] to get access to the previuos/next values to calculate sum
              x_array << x
              y_array << y
              t_array << t
         
            end #if
         
      end #for
      
               puts x_array.length   # - float
              # puts y_array.inspect  # - float
              # puts t_array.inspect  # - float
        
        
        
      # # #   CALCULATE HYPOTENUSE
    
            # # #   X_DISTANCE_BETWEEN_X(n)_X(n-1)
            x_array.each_cons(2) do |x_prev_element, x_next_element|   
              
                 x_distance_sqrt = ( x_next_element - x_prev_element )**2   
                 x_dist_sqrt << x_distance_sqrt.round(5)   
 
            end 
            puts "\nX_dist \n#{x_dist_sqrt.inspect}"       
            
            
            
            # # #   Y_DISTANCE_BETWEEN_Y(n)_Y(n-1)
            y_array.each_cons(2) do |y_prev_element, y_next_element|
              
                 y_distance_sqrt = ( y_next_element - y_prev_element)**2     
                 y_dist_sqrt << y_distance_sqrt.round(3)  
            end 
             puts "\nY_dist \n#{y_dist_sqrt.inspect}"  
           
            
            
            # # #   HYPOTENUSE            
            
            # calculate the distance between all X_sqrt and Y_sqrt
            # distance = Math::sqrt ( X_sqrt + Y_sqrt ) 

            distance = x_dist_sqrt.zip(y_dist_sqrt).map { |x, y| Math::sqrt(x + y).round(4) }
   
            puts "\nDistance \n#{distance.inspect}"
            
            
            # ordinate the data of distancies from min to max

            distance.sort!{ |value_1, value_2| value_1 <=> value_2 }
             puts "\nSorted distance  \n#{distance.sort.inspect}"



            puts "\nORDERED DATA ACCORDING TO HYPOTENUSE: \n\n"
            
            # create the array 'data_with_dist' to save all arrays of [x_]
            data_x_y_dist = [x_dist_sqrt, y_dist_sqrt, distance].transpose
            
            puts "\nData_x_y_dist \n#{data_x_y_dist.inspect}"
            
            final_data = []
      
           
           
           
            puts " "
            
          
            #puts ordered[1..ordered.length].inspect
            
           
            
            puts " "
            
            puts ordered.inspect
  
            final_data = [data_x_y_dist].tranpose
           
           
           
          
  #   
  #       # CALCULATING TEMPERATURE DIFFERENCE
  #       puts " "
  #       t_array.each_cons(2) do |t_prev_element, t_next_element|   
  #          # puts "#{t_prev_element} is followed by #{t_next_element}"
  #           t_difference = ( t_next_element + t_prev_element ) / 2   
  #           # puts "t_difference #{t_difference.round(5)}"
  #          
  #           t_mean << t_difference.round(3)
  #          
  #       end #each.cons
  #       
  #       
  #       
  #                  # # #   U N C O M M E N T if wanted to see the arrays of values of x_dist and t_mean
  #                 
  #                  # puts "\nx_distance, mm: \n#{x_dist}\n"
  #                  # puts "\nT_mean, C: \n#{t_mean},\nn_values_of_T_mean = #{t_mean.length}\n\n"
  #       
  #       
  #       
  #       # SUM OF DISTANCE AND TEMPERATURE
  #   
  #       # example
  #       #  a   = [123,321,12389]
  #       #  sum = 0
  #       #  a.each{ |a| sum += a}
  #       #  puts sum => 12833
  #       
  #       
  #       #  sum of all x-distancies 
  #       x_dist_sum = 0  
  #       x_dist.each{ |x_dist| x_dist_sum += x_dist }
  #       puts "x_dist_sum, mm #{x_dist_sum.round(3)}"
  #       
  #       
  #       #  sum of all temperatures
  #       t_mean_sum = 0  
  #       t_mean.each{ |t_mean| t_mean_sum += t_mean }
  #       puts "t_mean_sum, C #{t_mean_sum.round(3)}"    
  #       
  #       
  #       
  #       # AVERAGE TEMPERATURE
  #        
  #       # V 1:
  #       temp_average = (t_mean_sum * x_dist_sum) / t_mean.length
  #       puts "temp_average, C = #{t_mean_sum.round(3)} / #{t_mean.length} * #{x_dist_sum.round(3)} = #{temp_average.round(3)} "     
  #         
  #         
  #        # V 2:
  #        # integral: f(x)dx ot Tsum(x)dx, where interval lies between x0 = limit_1 and xn = limit_2
  #        
  #             # x0 = limit_1
  #             # xn = limit_2
  #             # temp_0 = (t_mean_sum.round(3) / t_mean.length) * x0
  #             # temp_n = (t_mean_sum.round(3) / t_mean.length) * xn
  #             # temp_average = temp_n.round(3) - temp_0.round(3)
  #             # 
  #             # puts "temp_n, C #{temp_n.round(3)}; \ntemp_0, C #{temp_0.round(3)}"
  #             # puts "temp_average = temp_n - temp_0 = #{temp_average.round(3)}"
  #                 
  #      
  #      
  #      
  #      
  #        # # # # # # # # # # # # # # # # # # # # # # # # #
  #        # # # # # # # # #      T O O L    # # # # # # # #
  #        # # # # # # # # # # # # # # # # # # # # # # # # #
  #      
