      
        
      initial_data        = []   # non-ordered data with all X, Y, T
      #data_canc_y         = []   # non-ordered Y-data with cancelled Y (if y < y_limit)
      y_limit             = 5.0
      data_with_y_limit   = []   # non-ordered data with X, Y_limit, T        
      initial_data_float  = []
     
      limit_1       = 4.0
      limit_2       = 4.7
 
 
 
      # # # # # # # # # # # # # # # # # # # # # # # # #
      # # # # # #      W O R K P I E C E    # # # # # #
      # # # # # # # # # # # # # # # # # # # # # # # # #
      
      
      
      unsorted = "points.txt" 

      
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
   
   
      # # #   REMOVING ARRAYS FROM 'initial_data_float' WHERE Y < Y_limit
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
      
      non_ordered = data_with_y_limit#.sort{ |line_1,line_2| line_1[0] <=> line_2[0] }
      
      # puts data_with_y_limit.inspect
    


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
      
      File.open("non_ordered_data.txt", 'w+') do |file|
         file.write(non_ordered.inspect)
      end
    
    
      # # # CHOOSING THE INTERVALS OF X FOR WORKPIECE
     
      puts "DATA IN CHOSEN INTERVAL\n "
     
      wp_points = non_ordered[0..400] # number of points describing workpiece

      
      x = []
      y = []
      t = []
      
      x_array       = [] # array of floats to get access to the previuos/next values to calculate sum
      y_array       = [] # array of floats to get access to the previuos/next values to calculate sum
      t_array       = [] # array of floats to get access to the previuos/next values to calculate sum
     
      x_dist   = [] # array of floats with all square distancies between x(n) - x(n-1)
      y_dist   = [] # array of floats with all square distancies between y(n) - y(n-1)
      distance      = [] # array of all hypotenuses
      data_x_y_dist = []
      ordered_dist  = []
      
      final_data_sort_d = []
     
     
      t_mean        = []
      
      
      for i in 0...(non_ordered.length) do   
           x << non_ordered[i][0]
           y << non_ordered[i][1]
           t << non_ordered[i][2]
      end 
      
      puts "x\t#{x.length} #{x.inspect} x[i] is #{x[i].class} in x which is #{x.class}"
      puts "y\t#{y.length} #{y}"
      
        
    
     
      # # #   CALCULATE HYPOTENUSE
      
      all_points = x.length
      
      for i in 0...all_points do
        
        d_min = 1
       
        while i <= all_points do
          
          x.each_with_index do
            
            x.delete_at(i) if i == 1

            # # #   X_DISTANCE_BETWEEN_X(n)_X(n-1)
            x.each_cons(2) do |x_prev_element, x_next_element|   
              
                 x_distance_sqrt = ( x_next_element - x_prev_element )**2   
                 x_dist << x_distance_sqrt.round(5)   
 
            end #e.each_cons
 #puts "\nX_dist \n#{x_dist.length} #{x_dist.inspect}\n"  
            
            
            # # #   Y_DISTANCE_BETWEEN_Y(n)_Y(n-1)
            y.each_cons(2) do |y_prev_element, y_next_element|
         
                 y_distance_sqrt = ( y_next_element - y_prev_element)**2     
                 y_dist << y_distance_sqrt.round(3)  
            end 
            # puts "\nY_dist \n#{y_dist.inspect}" 
# puts "\nY_dist\n#{y_dist.length} #{y_dist}"
            
            
            
            # # #   HYPOTENUSE            
            
            # calculate the distance between all X_sqrt and Y_sqrt
            # distance = Math::sqrt ( X_sqrt + Y_sqrt ) 
            distance = x_dist.zip(y_dist).map { |x, y| Math::sqrt(x + y).round(4) }

      
            
         #   # # #   Y_DISTANCE_BETWEEN_Y(n)_Y(n-1)
         #   y.each_cons(2) do |y_prev_element, y_next_element|
         #     
         #        y_distance_sqrt = ( y_next_element - y_prev_element)**2     
         #        y_dist << y_distance_sqrt.round(3)  
         #   end 
         #   puts "\nY_dist \n#{y_dist.inspect}"  
         #  
            
            
            # # #   HYPOTENUSE            
            
            # calculate the distance between all X_sqrt and Y_sqrt
            # distance = Math::sqrt ( X_sqrt + Y_sqrt ) 
            
            #while i = ordered.length do
            
           # puts x_dist.zip(y_dist).inspect
           
           #     distance = x_dist.zip(y_dist).map { |x, y| Math::sqrt(x + y).round(4) }

            #end
            
            # puts "\nDistance \n#{distance.length} #{distance.inspect}"
            
            
            
            
          end #x.each   

        end #while i
               
      end #x in   

  
      puts "\nX_dist \n#{x_dist.length} #{x_dist.inspect}\n"  
  
     puts "\nY_dist\n#{y_dist.length} #{y_dist}"
    puts "\nDistance #{distance}" 

      
      puts "\nulala"
      puts x_dist.min
      
       data_x_y_dist = [x_dist, y_dist, distance].transpose
      
      
#
#
#
#            puts "\nORDERED DATA ACCORDING TO HYPOTENUSE: \n\n"
#            
#            # create the array 'data_with_dist' to save all arrays of distncies between x,y and hypotenuse values
#            data_x_y_dist = [x_dist, y_dist, distance].transpose
#            
# # puts "\nData_x_y_dist_1 \n#{data_x_y_dist.inspect}"
#            
#           
#            
#            # # #   FINAL DATA = merging of:
#            #       1)ordened_data without the first element (because it is assumed as 0) and 
#            #       2)data with all distancies between x,y, and hypotenuse.
#    
#            a = ordered[1..ordered.length]
#          
#            b = data_x_y_dist.map{ |element| element}
#            
#            
#            # data as a string
#            final_data_string = a.zip(b).map{ |ab| ab.join (" ")}.join("\n")
#            # puts "\nfinal_data_string \n#{final_data_string.inspect}"
#           
#           
#            # converting string_data to array_data of strings 
#            # final_data_array is ["4.32986 5.33471 298.748 0.0 0.00031 0.024 0.1559", "4.34515 5.28462 310.526 0.0 0.00023 0.003 0.0568", "4.54831 5.26964 329.022 0.0 0.04127 0.0 0.2032"]
#            final_data_array = final_data_string.split("\n") 
#           
## puts "\nfinal_data_array \n#{final_data_array.inspect}"
#           
#           
#            # converting strings of array 'final_data_array' to [["4.32986", "5.33471", "298.748", "0.0", "0.00031", "0.024", "0.1559"], ["4.34515", "5.28462", "310.526", "0.0", "0.00023", "0.003", "0.0568"], ["4.54831", "5.26964", "329.022", "0.0", "0.04127", "0.0", "0.2032"]]
#            final_data = []
#            for i in 0..(final_data_array.length - 1) do
#             
#                 element = final_data_array[i].split(" ")
#             
#                 final_data << element
#             
#            end   
#              
## puts "\nfinal_data \n#{final_data.inspect}"
#            
#            
#            # sorting of array 'data_x_y_dist' (with x_sqrt, y_sqrt, distance) according to distance
#           
#           final_data_sort_d = final_data.sort!{ |value_1, value_2| value_1[0] <=> value_2[0]}
#            
#          
#           # to print all values in chisen interval in nice way:
#           # # #    LIMITS
#           
#           for i in 0..(final_data_sort_d.length - 1) do
#             if  final_data_sort_d[i][0].to_f >= limit_1 &&  final_data_sort_d[i][0].to_f <= limit_2    
#              
#              x_values_lim = final_data_sort_d[i][0].to_f
#              y_values_lim = final_data_sort_d[i][1].to_f
#              t_values_lim = final_data_sort_d[i][2].to_f  
#              d_values_lim = final_data_sort_d[i][4].to_f  
#              
#              puts "#{x_values_lim}\t#{y_values_lim}\t#{t_values_lim}\t#{d_values_lim}"
#   
#             end #if
#           end #for
#           
#           
#
#
## puts "\n x.inspect #{x.inspect}"
## puts "\n y.inspect #{y.inspect}"
## puts "\n t.inspect #{t.inspect}"
#           
#
#
#           
#       #    x_values = final_data_sort_d.map{ |column| column[0].to_f }
#       #    
#       #    y_values = final_data_sort_d.map{ |column| column[1].to_f }
#       #    
#       #    d_values = final_data_sort_d.map{ |column| column[4].to_f }
#       #    
#       #    
#          #puts "x_values#{x_values}\ny_values#{y_values}\nd_values#{d_values}"
#           
#           
#           
#           
#         #  puts "\nfinal_data_sort_d \nX #{final_data_sort_d.shift.zip(*final_data_sort_d).first}"
#           
#          
#            
#
#
#
#  #   
#  #       # CALCULATING TEMPERATURE DIFFERENCE
#  #       puts " "
#  #       t_array.each_cons(2) do |t_prev_element, t_next_element|   
#  #          # puts "#{t_prev_element} is followed by #{t_next_element}"
#  #           t_difference = ( t_next_element + t_prev_element ) / 2   
#  #           # puts "t_difference #{t_difference.round(5)}"
#  #          
#  #           t_mean << t_difference.round(3)
#  #          
#  #       end #each.cons
#  #       
#  #       
#  #       
#  #                  # # #   U N C O M M E N T if wanted to see the arrays of values of x_dist and t_mean
#  #                 
#  #                  # puts "\nx_distance, mm: \n#{x_dist}\n"
#  #                  # puts "\nT_mean, C: \n#{t_mean},\nn_values_of_T_mean = #{t_mean.length}\n\n"
#  #       
#  #       
#  #       
#  #       # SUM OF DISTANCE AND TEMPERATURE
#  #   
#  #       # example
#  #       #  a   = [123,321,12389]
#  #       #  sum = 0
#  #       #  a.each{ |a| sum += a}
#  #       #  puts sum => 12833
#  #       
#  #       
#  #       #  sum of all x-distancies 
#  #       x_dist_sum = 0  
#  #       x_dist.each{ |x_dist| x_dist_sum += x_dist }
#  #       puts "x_dist_sum, mm #{x_dist_sum.round(3)}"
#  #       
#  #       
#  #       #  sum of all temperatures
#  #       t_mean_sum = 0  
#  #       t_mean.each{ |t_mean| t_mean_sum += t_mean }
#  #       puts "t_mean_sum, C #{t_mean_sum.round(3)}"    
#  #       
#  #       
#  #       
#  #       # AVERAGE TEMPERATURE
#  #        
#  #       # V 1:
#  #       temp_average = (t_mean_sum * x_dist_sum) / t_mean.length
#  #       puts "temp_average, C = #{t_mean_sum.round(3)} / #{t_mean.length} * #{x_dist_sum.round(3)} = #{temp_average.round(3)} "     
#  #         
#  #         
#  #        # V 2:
#  #        # integral: f(x)dx ot Tsum(x)dx, where interval lies between x0 = limit_1 and xn = limit_2
#  #        
#  #             # x0 = limit_1
#  #             # xn = limit_2
#  #             # temp_0 = (t_mean_sum.round(3) / t_mean.length) * x0
#  #             # temp_n = (t_mean_sum.round(3) / t_mean.length) * xn
#  #             # temp_average = temp_n.round(3) - temp_0.round(3)
#  #             # 
#  #             # puts "temp_n, C #{temp_n.round(3)}; \ntemp_0, C #{temp_0.round(3)}"
#  #             # puts "temp_average = temp_n - temp_0 = #{temp_average.round(3)}"
#  #                 
#  #      
#  #      
#  #      
#  #      
#  #        # # # # # # # # # # # # # # # # # # # # # # # # #
#  #        # # # # # # # # #      T O O L    # # # # # # # #
#  #        # # # # # # # # # # # # # # # # # # # # # # # # #
#  #      
#